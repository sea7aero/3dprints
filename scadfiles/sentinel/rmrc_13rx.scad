// A mounting plate for the RMRC 900MHz - 1.3Ghz VRX, designed to mount to a side panel of the Sentinel AAT.
// As configured, the VRX is oriented with the antenna cable facing the rear when mounted on the left.

include <../globals.scad>
include <./sentinel.scad>
use <../shapes.scad>

plate_width = 81.6;
plate_length = 115.0;
plate_thickness = 3.4;

// Dimensions of the mounting holes in the RMRC VRX

mounting_bolt_diameter = 4;
mounting_hole_y_offsets = [15, 9.5];
mounting_hole_x_offset = 5;

module mounting_plate() {
    linear_extrude(plate_thickness)
    rounded_square(plate_width, plate_length, 5.0);
}

module vrx_mounting_holes() {
    x_offsets = [
        plate_width / 2 - mounting_hole_x_offset,
        plate_width / -2 + mounting_hole_x_offset
    ];

    y_offsets = [
        plate_length / 2 - mounting_hole_y_offsets[0],
        plate_length / -2 + mounting_hole_y_offsets[1],
    ];

    for(x = x_offsets) {
        for(y = y_offsets) {
            translate([x, y, -epsilon])
            xy_cylinder(h = plate_thickness + (2 * epsilon), d = mounting_bolt_diameter);
        }
    }
}

// Big square hole to fit the VRX wiring through
module wire_passthrough() {
    translate([0, 0, -epsilon]) {
        linear_extrude(plate_thickness + (2 * epsilon))
        rounded_square(panel_block_length, panel_block_separation, 2.0);
    }
}

difference() {
    mounting_plate();
    vrx_mounting_holes();  
    wire_passthrough();
    panel_mounting_holes(plate_thickness);  
}
