$fn = 64;

wall_thickness = 1.6;
mount_hole_diameter = 2;

// Creates a mounting arm. Height is the height to the mounting hole.
// height: The height to the mounting hole
// width: How far apart should the mount arms be
module mount_arm(
    height,
    width,
    hole_diameter=mount_hole_diameter) {
    
    translate([wall_thickness / -2, 0, 0])
    difference() {
        union() {
            translate([0, width / -2, 0])
            cube([wall_thickness, width, height]);
        
            translate([0, 0, height])
            rotate([0, 90, 0])
            cylinder(h = wall_thickness, r = width / 2);
        }


        translate([-0.1, 0, height])
        rotate([0, 90, 0])
        cylinder(h=wall_thickness + 0.2, r = hole_diameter / 2);
    }    
}

module base_plate(width, depth) {
    x_length = (width + (wall_thickness * 2));
    
    translate([x_length / -2, depth / -2, 0])
    cube([x_length, depth, wall_thickness]);
}

// height: The height from the base to the mounting holes
// width: Width between two mounting arms
// depth: The width of the mounting arms themselves.
module simple_mount(
    height = 9,
    width = 14,
    depth = 10
) {
    x_length = (width + (wall_thickness));
    
    translate([x_length / -2, 0, wall_thickness])
    mount_arm(height, depth);
   
    translate([x_length / 2, 0, wall_thickness])
    mount_arm(height, depth);
    
    base_plate(width, depth);
}

module camera_enclosure(
    height = 14,
    width = 14,
    depth = 14
) {
    
    difference() {
        
        cube([width + (2 * wall_thickness), height + (2 * wall_thickness), depth], center=true);
        
        translate([0, 0, wall_thickness])
        cube([width, height, depth], center=true);
     
        // Hole for wires, fits a Ph3 connector
        translate([0, 0, (depth / -2) - wall_thickness])
        cylinder(h=depth, r=3);
    }
}

module nano_base_plate() {
    base_plate(14, 10);
}

module nano_mount(height=9) {
    simple_mount(
        height = height,
        width = 14,
        depth = 10
    );
}

nano_mount();