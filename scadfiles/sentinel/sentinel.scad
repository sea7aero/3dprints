// The designs in this folder are meant to be mounted on a side panel using the "battery panel mount" that is
// included in the official AAT STLs
// https://github.com/aat-sentinel/AAT-lite-hardware/tree/main/Extras/AAT%20battery%20panel%20mount

include <../globals.scad>
use <../shapes.scad>

// Dimensions of the blocks on a side panel of the Sentinel AAT
panel_block_width = 16;
panel_block_length = 30;
panel_block_separation = 32;

// M3 phillips flat head screw dimensions, included in the Sentinel kit.
panel_screwhead_diameter = 6;
panel_screw_diameter = 2;

module panel_mounting_holes(height) {
    // There are 3 screw holes, evenly spaced, in a single column centered on the blocks.
    x_offset = panel_block_length / 4;
    y_offset = (panel_block_separation / 2) + panel_block_width / 2;
    
    for(x = [-1, 0, 1]) {
        for(y = [-1, 1]) {
            translate([x * x_offset, y * y_offset, -epsilon])
            xy_cylinder(
                h = height + (2 * epsilon),
                d1 = panel_screw_diameter,
                d2 = panel_screwhead_diameter
            );
        }
    }
}

panel_mounting_holes(3.4);

