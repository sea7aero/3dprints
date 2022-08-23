// Creates a mounting box for the antenna of the M9N-5883 GPS + Compass module.
// https://www.mateksys.com/?portfolio=m9n-5883
include <../globals.scad>

board_width = 32.10;
board_height = 1.7;
board_radius = 2;

hole_distance_to_edge = 2.8;
hole_offset = (board_width / 2) - hole_distance_to_edge;
hole_diameter = 2.0;

antenna_width = 26.0;
antenna_radius = 2.9;
antenna_height = 4.2;

connector_width = 10.8;
connector_height = 4.8;

wall_thickness = 0.7;

module foreach_corner(offset) {
    for(x = [-1, 1]) {
        for(y = [-1, 1]) {
            translate([offset * x, offset * y, 0])
            children();
        }
    }
}

// Creates a square with rounded corners, centered
module rounded_square(width, radius, height) {
    linear_extrude(height)
    hull() {
        foreach_corner((width / 2) - radius) {
            circle(radius);
        }
    }
}

module m9n_5883_cover() {
    total_width = board_width + (wall_thickness * 2);
    total_height = wall_thickness + antenna_height;
    
    difference() {
        rounded_square(total_width, board_radius, total_height);
        
        // Cavity for antenna
        translate([0, 0, wall_thickness])
        rounded_square(antenna_width + tolerance, antenna_radius, antenna_height + epsilon);
        
        translate([0, 0, wall_thickness])        
        foreach_corner(hole_offset) {
            cylinder(antenna_height + epsilon, r = hole_diameter / 2);
        }
    }
}

module m9n_5883_mount() {
    floor_height = wall_thickness * 2;
    total_width = board_width + (wall_thickness * 2);
    total_height = floor_height + connector_height + board_height;
    
    difference() {
        union() {
            difference() {
                rounded_square(total_width, board_radius, total_height);
                
                // Cavity for the board
                translate([0, 0, floor_height])
                rounded_square(board_width, board_radius, connector_height + board_height + epsilon);
                
                // Cavities for the 2 connectors
                for(x = [0, 1]) {
                    mirror([x, 0, 0])
                    translate([-total_width/2 - epsilon, -connector_width / 2, floor_height])
                    cube([connector_width + epsilon, connector_width, total_height + epsilon]);
                }
            }
            
            // Mounting standoffs
            foreach_corner(board_width / 2 - hole_distance_to_edge) {
                cylinder(h = wall_thickness + connector_height, r = hole_distance_to_edge + wall_thickness);
            }
        }
        
        // Mounting holes
        translate([0, 0, -epsilon])
        foreach_corner(board_width/ 2 - hole_distance_to_edge) {
            cylinder(h = total_height + (2*epsilon), r = (hole_diameter + 0.5) / 2);
        }
    }
}


m9n_5883_cover();
translate([board_width + 10, 0, 0])
m9n_5883_mount();