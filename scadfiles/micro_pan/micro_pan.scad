use <mcad/involute_gears.scad>
use <mcad/metric_fastners.scad>

use <../cameras.scad>
use <../fasteners.scad>
use <../servos.scad>
use <../shapes.scad>

include <../globals.scad>
include <../servo_data.scad>

// Thickness of the harness wall
wall_thickness = 0.8;

// The diameter of the cap bolt used as an axle on the driven gear.
axle_bolt_diameter = 3;
axle_hole_diameter = axle_bolt_diameter + (2 * tolerance);

// The length of the cap bolt used as an axle on the driven gear.
axle_bolt_length = 18;

// The thickness of a single washer
axle_washer_height = 1;

axle_nut_height = 4;

// Diameter for the axle nut, accounting for using a wrench to tighten it.
axle_nut_diameter = 8;

// Diameter of the screwhead to mount harness to servo.
mounting_screwhead_diameter = 3.7;

// Diameter of the screwhead for the servo horn.
servo_horn_screwhead_diameter = 4.6;

// How thick to make the gears.
gear_thickness = 4.0;

// Number of teeth on the drive gear.
drive_gear_teeth = 16;

// The gear ratio, driven_gear_teeth / gear_ratio needs to be an integer.
gear_ratio = 2;
driven_gear_teeth = drive_gear_teeth / gear_ratio;

// Calculates the position to put the gear axle, such that it is
// centered in the space next to the bearing case.
function axle_position(servo_data) = [
    0,
    -servo_bearing_case_size(servo_data)[1] / 2,
    0
];

function gear_separation(servo_data) = (servo_spline_position(servo_data) - axle_position(servo_data))[1];

function driven_gear_radius(servo_data) = gear_separation(servo_data) / (gear_ratio + 1);

function drive_gear_radius(servo_data) = gear_separation(servo_data) - driven_gear_radius(servo_data);

module my_gear(radius, number_of_teeth, bore_diameter=0) {
    diameter = radius * 2;
    diametral_pitch = number_of_teeth / diameter;
    
    gear(
        diametral_pitch = diametral_pitch,
        number_of_teeth = number_of_teeth,
        bore_diameter = bore_diameter,
        gear_thickness = gear_thickness,
        rim_thickness  = gear_thickness,
        hub_thickness = gear_thickness
    );
}

module drive_gear(servo_data) {
    spline_diameter = servo_data[SERVO_SPLINE_OUTER_DIAMETER];
    spline_height = servo_data[SERVO_SPLINE_HEIGHT];
    
    shaft_diameter = spline_diameter + 3;
    shaft_height = spline_height + axle_washer_height;
    
    servo_horn(
        servo_data,
        shaft_height = spline_height + axle_washer_height,
        screwhead_diameter = servo_horn_screwhead_diameter
    ) {
        my_gear(
            radius = drive_gear_radius(servo_data),
            number_of_teeth = drive_gear_teeth
        );
    }
}

// Transition between a gear and camera mount so it can be 3d printed without support.
module gear_camera_transition(radius, height) {
    hull() {
        xy_cylinder(h = 1, r=radius);
        translate([0, 0, height])
        nano_base_plate();
    }
}

module camera_mount_with_gear(servo_data) {
    gear_radius = driven_gear_radius(servo_data);
        
    // TODO: 17 is a magic number, from the width of the camera mount...
    transition_height = (17 / 2) - gear_radius; 
    
    // TODO: 1.6 is a magic number, it's the wall_thickness in cameras.scad
    total_height = gear_thickness + transition_height + 1.6;
    
    nut_cavity_height = axle_nut_height + axle_washer_height;
    
    difference() {
        union() {
            my_gear(
                radius = gear_radius,
                number_of_teeth = driven_gear_teeth
            );
            
            translate([0, 0, gear_thickness - epsilon]) {
                gear_camera_transition(gear_radius, transition_height);
        
                translate([0, 0, transition_height - epsilon])
                nano_mount();
            }
        }
        
        translate([0, 0, -epsilon])
        xy_cylinder(h=total_height, d=axle_hole_diameter);
        
        translate([0, 0, total_height - nut_cavity_height])
        xy_cylinder(h=nut_cavity_height + epsilon, d=axle_nut_diameter);
    }
}

module harness_plate(servo_data, height) {
    servo_width = servo_data[SERVO_WIDTH];
    width = servo_width + (2 * wall_thickness);
    corner_radius = width / 2;

    hull() {
        for(y = [-1, 1]) {
            translate([0, y * servo_data[SERVO_TAB_LENGTH] / 2, 0]) {
            xy_cylinder(h=height, r=corner_radius);           
            
                translate([0, y * corner_radius, 0])
                xy_cylinder(h = height, r=corner_radius/4);           
            }
        }
    }
}

module gear_harness(servo_data) {
    servo_width = servo_data[SERVO_WIDTH];
    servo_length = servo_data[SERVO_LENGTH];
    servo_height = servo_data[SERVO_HEIGHT];
    
    tab_length = servo_data[SERVO_TAB_LENGTH];
    tab_height = servo_data[SERVO_TAB_HEIGHT];
    tab_thickness = servo_data[SERVO_TAB_THICKNESS];
    
    bearing_case_height = servo_data[SERVO_BEARING_CASE_HEIGHT];
    spline_height = servo_data[SERVO_SPLINE_HEIGHT];
    
    // The height from the bottom of the tab to the top of the servo body.
    tab_to_top_height = servo_height - tab_height;
    height = tab_to_top_height + bearing_case_height + spline_height;
    echo("Harness height", height);
    
    mounting_hole_diameter = servo_data[SERVO_MOUNTING_HOLE_DIAMETER];
    bevel_height = (mounting_screwhead_diameter - mounting_hole_diameter) / 2;
    
    bearing_case_size = servo_bearing_case_size(servo_data);
    servo_shaft_diameter = servo_data[SERVO_SPLINE_OUTER_DIAMETER] + 4;
    
    difference() {
        harness_plate(servo_data, height);
            
        translate([0, 0, -epsilon])
        {
            // Cavity for the servo tab to rest in
            servo_tab(servo_data, mounting_holes=false);
            
            // Holes for mounting screws
            servo_mounting_holes(servo_data) {
                xy_cylinder(h=bevel_height, d1=mounting_hole_diameter + epsilon, r2=mounting_screwhead_diameter 
    /2);
                translate([0, 0, bevel_height - epsilon])
                xy_cylinder(h=height, d=mounting_screwhead_diameter);
            }

            // Cavity for the top of the servo body
            xy_cube(servo_width, servo_length, tab_to_top_height);
            
            translate([0, 0, tab_to_top_height - epsilon]) {
                // Cavity for the bearing case
                translate([0, (servo_length - bearing_case_size[1]) / 2, 0])
                xy_cube(bearing_case_size[0], bearing_case_size[1], bearing_case_size[2] + 1);
                    
                // Cavity for the gear shaft;
                echo([0, servo_spline_position(servo_data)[1], 0])
                translate([0, servo_spline_position(servo_data)[1], 0])
                xy_cylinder(h=spline_height + 30 + (epsilon*4), d=servo_shaft_diameter + 0.2);
            

                // Cavity for the axle bolt
                translate(axle_position(servo_data))
                xy_cap_bolt(axle_hole_diameter, axle_bolt_length);
            }
        }
    }   
}

module servo_mount(servo_data) {
    length = servo_data[SERVO_LENGTH] + (tolerance * 2);
    width = servo_data[SERVO_WIDTH] + (tolerance * 2);
    height = servo_data[SERVO_TAB_HEIGHT];

    difference() {       
        union() {
            xy_cube(width + (wall_thickness*2), length + (wall_thickness*2), height);
            translate([0, 0, height - (wall_thickness*2) - epsilon])
            harness_plate(servo_data, wall_thickness*2);
        }
        
        translate([0, 0, -epsilon])
        xy_cube(width, length, (wall_thickness*2) + height + (epsilon * 2));
        
        translate([0, 0, height - epsilon])
        servo_mounting_holes(servo_data);
    }
}

module demo(servo_name, spread_z=5) {
    data = search_servos(servo_name);
    
    spread(0, 0, spread_z) {        
        servo_mount(data);
        
        color("gray")
        servo(data);
        
        servo_tab_location(data)
        gear_harness(data);

        servo_spline_location(data)
        rotate([0, 0, 360 / (drive_gear_teeth * 2)])    
        drive_gear(data);
        
        servo_spline_location(data)
        translate([0, -gear_separation(data), data[SERVO_SPLINE_HEIGHT] + axle_washer_height])
        camera_mount_with_gear(data);
    }
}

demo("MG90S");