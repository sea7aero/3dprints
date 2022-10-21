// This is a simple plate which the Eachine (or really any small VRX) can be zip-tied to).

include <../globals.scad>
include <./sentinel.scad>
use <../shapes.scad>


plate_length = (panel_block_width * 2) + panel_block_separation;
plate_width = panel_block_length;
plate_thickness = 3.4;

module mounting_plate() {
    linear_extrude(plate_thickness)
    rounded_square(plate_width, plate_length, 1.0);
}
    

difference() {
    mounting_plate();
    panel_mounting_holes(plate_thickness);
}
