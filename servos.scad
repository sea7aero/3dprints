use <mcad/involute_gears.scad>

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

module mg90(position=[0, 0, 0], rotation=[0, 0, 0], screws = 0, axle_length = 0, cables=0)
{
	translate(position) rotate(rotation) {
        difference(){
            union()
            {
                translate([-5.9,-11.8/2,0]) cube([22.5,11.8,22.7]);
                translate([0,0,22.7-0.1]){
                    cylinder(d=11.8,h=4+0.1);
                    hull(){
                        translate([8.8-5/2,0,0]) cylinder(d=5,h=4+0.1);
                        cylinder(d=5,h=4+0.1);
                    }
                    translate([0,0,4]) cylinder(d=4.6,h=3.2);
                }
                translate([-4.7-5.9,-11.8/2,15.9]) cube([22.5+4.7*2, 11.8, 2.5]); 
            }
            //screw holes
            translate([-2.3-5.9,0,15.9+1.25]) cylinder(d=2,h=5, center=true);
            translate([-2.3-5.9-2,0,15.9+1.25]) cube([3,1.3,5], center=true);
            translate([2.3+22.5-5.9,0,15.9+1.25]) cylinder(d=2,h=5, center=true);
            translate([2.3+22.5-5.9+2,0,15.9+1.25]) cube([3,1.3,5], center=true);
        }
        if (axle_length > 0) {
            color("red", 0.3) translate([0,0,29.9/2]) cylinder(r=1, h=29.9+axle_length, center=true);
        }
        if (cables > 0) color("red", 0.3) translate([-12.4,-1.8,4.5]) cube([10,3.6,1.2]);
        if(screws > 0) color("red", 0.3) {
            translate([-2.3-5.9,0,15.9+1.25]) cylinder(d=2,h=10, center=true);
            translate([2.3+22.5-5.9,0,15.9+1.25]) cylinder(d=2,h=10, center=true);
        }
    }
}

mg90();