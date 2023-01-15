include <../globals.scad>
include <./sentinel.scad>

use <../shapes.scad>

m4_diameter = 4.5;
m4_head_diameter = 7;
m4_head_depth = 4.5;

thickness = 3.4;
screw_diameter = 6.5;
radius = 5.65;

antenna_width = 151.64;
antenna_mount_height = 65.4;
antenna_ridge_height = 3;
antenna_ridge_width = 1.5;

wire_screw_cutout_radius = 21/2;

tracker_mount_width = 90.6;

mount_offset = (tracker_mount_width - antenna_mount_height) / 2;

total_thickness = thickness + m4_head_depth;

module tracker_mount_holes(diameter, height) {   
    hole_offset = tracker_mount_width / 2 - radius;
    
    // Mounting plate holes
    for(x = [-1, 1]) {
        for(y = [-1, 1]) {
            translate([x * hole_offset, y * hole_offset, 0])
            xy_cylinder(d = diameter, h = height);
        }
    }
   
}

module mount_plate() {
    linear_extrude(total_thickness)
    union() {
        rounded_square(antenna_width, antenna_mount_height, radius);        
        
        translate([0, mount_offset, 0])
        rounded_square(tracker_mount_width, tracker_mount_width, radius);
    }
}
    

module mount() {
    difference() {
        mount_plate();
        
        translate([0, 0, -10 * epsilon])
        xy_cylinder(d = screw_diameter, h = 100);
        
        translate([0, mount_offset, -10 * epsilon])
        tracker_mount_holes(m4_diameter, thickness);
        
        translate([0, mount_offset, thickness + (-20 * epsilon)])
        tracker_mount_holes(m4_head_diameter, 100);
        
        translate([0, (antenna_mount_height/2 + antenna_ridge_width/2) + epsilon, 0])
        cube([1000, antenna_ridge_width, antenna_ridge_height], center = true);
        
        translate([0, -antenna_mount_height/2 - wire_screw_cutout_radius/2, -10])
        linear_extrude(150)
        circle(r = wire_screw_cutout_radius);
    }
}

mount();