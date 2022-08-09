use <../mcad/involute_gears.scad>
use <../mcad/metric_fastners.scad>
use <../lib/servos.scad>
use <../lib/cameras.scad>

$fn=60;

servo_horn_shaft_height = 4.3;
servo_screwhead_diameter = 4.6;

gear_thickness = 5.0;
gear_axle_diameter = 3.2; // M3 Bolt

axle_nut_diameter = 8.2;  // M3 Nut

// Gear calculations https://khkgears.net/new/gear_knowledge/abcs_of_gears-b/basic_gear_terminology_calculation.html

// module = circular_pitch / pi
// reference_diameter = number_of_teeth * module
// Therefore:
// circular_pitch = diameter * pi / number_of_teeth

module double_helix_gear(
    number_of_teeth,
    total_thickness,
    bore_diameter=gear_axle_diameter
) {
    diametral_pitch = 1.0;
    diameter = number_of_teeth * diametral_pitch;
    circumference = 3.1415 * diameter;
        
    thickness = total_thickness / 2;
    
    twist = 0; // 360 / (circumference / thickness);
    
    translate([0, 0, thickness])
    union() {
        gear(
            diametral_pitch = 1,
            number_of_teeth = number_of_teeth,
            bore_diameter = bore_diameter,
            gear_thickness = thickness,
            rim_thickness  = thickness,
            hub_thickness = thickness,
            twist = twist
        );
        mirror([0, 0, 1])
        gear(
            diametral_pitch = 1,
            number_of_teeth = number_of_teeth,
            bore_diameter = bore_diameter,
            gear_thickness = thickness,
            rim_thickness  = thickness,
            hub_thickness = thickness,
            twist = twist
        );
    }
}
    

// The gear attached to the servo, it's the larger of the two gears
module drive_gear() { 
    double_helix_gear(
        number_of_teeth = 16,
        total_thickness = gear_thickness,
        bore_diameter = servo_screwhead_diameter
    );
}

module servo_shaft_and_gear() {
    mirror([0, 0, 1])
    union() {
        mg90_shaft(
            height = servo_horn_shaft_height,
            screwhead_diameter = servo_screwhead_diameter,
            shaft_diameter = 7);
        translate([0, 0, servo_horn_shaft_height])      
        drive_gear();
    }
}

// The gear we'll attach the camera to, it's smaller.
module driven_gear() {
    mirror ([0,1,0])
    double_helix_gear(
        number_of_teeth=8,
        total_thickness = gear_thickness
    );
}

// Transition between a gear and camera mount so it can be 3d printed without support.
module nano_gear_transition(diameter, height) {
    hull() {
        cylinder(h = 1, r = diameter / 2);
        translate([0, 0, height])
        nano_base_plate();
    }
}

module nano_camera_mount_and_gear() {
    gear_diameter = 10;
    transition_height = (17 - gear_diameter) / 2;
    
    driven_gear();
    
    translate([0, 0, gear_thickness])
    difference() {
        union() {
            nano_gear_transition(gear_diameter, transition_height);
        
            translate([0, 0, transition_height])
            nano_mount();
        }
        translate([0, 0, -0.1])
        cylinder(h = transition_height * 2, r = gear_axle_diameter / 2);
        
        translate([0, 0, 0.5])
        cylinder(h = transition_height * 2, r = axle_nut_diameter / 2);
    }
}

nano_camera_mount_and_gear();