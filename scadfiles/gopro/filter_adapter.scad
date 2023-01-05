use <../shapes.scad>

include <../globals.scad>


thickness = 4.0;

difference() {
    linear_extrude(thickness)
    rounded_square(47.0, 47.0, 13.0);
    
    translate([0, 0, -epsilon]* 2)
    linear_extrude(thickness + epsilon*4)
    rounded_square(41.0, 41.0, 11);
}
