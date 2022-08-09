use <mcad/involute_gears.scad>
use <mcad/servos.scad>

$fn=64;

// Servo spline details: https://www.rcgroups.com/forums/showpost.php?p=13441675&postcount=2
module servo_spline(
    diameter,
    number_of_teeth,
    thickness = 3.0,
    screw_diameter = 2.0
) {
    gear(
        diametral_pitch = number_of_teeth / diameter,
        number_of_teeth = number_of_teeth,
        gear_thickness = thickness,
        hub_thickness = thickness,
        rim_thickness = thickness,
        bore_diameter = screw_diameter
    );
}

// 20 tooth splne with a 4.8mm outer diameter.
module mg90_spline() {
    servo_spline(4.8, 20, screw_diameter=2.0);
}

module mg90_shaft(
    height = 4.6,
    shaft_diameter = 6.7,
    screw_diameter = 2.6,
    screwhead_diameter = 4.6
) {
    
    difference() {
        cylinder(h=height, r=shaft_diameter / 2, center=false);
        
        translate([0, 0, height - 1.0])
        cylinder(h=1, r2=screwhead_diameter / 2, r1=screw_diameter / 2);
        
        cylinder(h=15, r=screw_diameter / 2, center=true);
        translate([0, 0, -0.01]) mg90_spline();
    }
}

module mg90(position=[0, 0, 0], rotation=[0, 0, 0]) {
    towerprosg90(position=position, rotation=rotation);
}

mg90_shaft();