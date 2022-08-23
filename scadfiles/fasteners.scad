use <shapes.scad>

include <globals.scad>

// https://www.engineersedge.com/hardware/_metric_socket_head_cap_screws_14054.htm
module xy_cap_bolt(diameter, length) {
    head_diameter = 1.8 * diameter;
	head_height = diameter;
    
    xy_cylinder(d=head_diameter, h=head_height);
    
    translate([0,0,head_height - epsilon])
    xy_cylinder(d=diameter, h=length);
}

xy_cap_bolt(3, 18);