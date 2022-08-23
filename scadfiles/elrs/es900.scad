use <../shapes.scad>

include <../globals.scad>

board_width = 12.2 + tolerance;
board_height = 4;

wall_thickness = 0.7;

screw_hole_diameter = 2.5;
screw_mount_diameter = screw_hole_diameter


module es900_mount() {
    total_width = board_width + (wall_thickness * 2);
    total_height = board_height + wall_thickness;

    difference() {
        union() {
        }
    
        translate([0, 0, -epsilon])
        xy_cube(board_width, board_width, board_height + epsilon);
    }
}

es900_mount();