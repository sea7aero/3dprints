// This file produces an antenna mount that fits in the mounting holes on the tail of the
// AtomRC Killer Whale RC plane. It is designed for an HappyModel ELS900-RX antenna, but
// may fit other similar dipole antennas.

$fn = 64;

// Radius of the hole in the plywood mount.
inner_radius = 6.5 / 2;

// Radius of the hole in the foam.
outer_radius = 5;

// Depth of the hole in the foam.
hole_depth = 4.5;

// Small amount to avoid z-fighting.
epsilon = 0.01;

// The length to make the portion of the mount the antenna fits on.
mount_length = 27;

antenna_radius = 2.5;


module clip() {
    difference() {
        cylinder(h = mount_length, r = outer_radius, center = true);

        translate([-outer_radius, 0, 0])
        cube([outer_radius * 2, outer_radius * 2, mount_length + (epsilon * 2)], center = true);
        
        translate([outer_radius / 2 + 0.8, 0, 0])
        cylinder(h = mount_length + (epsilon * 2), r = antenna_radius, center = true);
    }
}

module mount() {
    difference() {
        union() {
            cylinder(h = hole_depth, r = outer_radius);
            translate([0, 0, hole_depth - epsilon])
            rotate([0, -90, 0])
            clip();
        }
        
        translate([0, 0, -epsilon])
        cylinder(h = hole_depth + outer_radius, r1 = antenna_radius + 0.1, r2 = antenna_radius + 1.0);
    }
}

mount();