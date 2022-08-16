$fn = 64;

tolerance = 0.1;
epsilon = 0.01;

module foreach_corner(offset) {
    for(x = [-1, 1]) {
        for(y = [-1, 1]) {
            translate([offset * x, offset * y, 0])
            children();
        }
    }
}

// Creates a square with rounded corners, centered
module rounded_square(width, radius) {    
    hull() {
        foreach_corner((width / 2) - radius) {
            circle(radius);
        }
    }
}

// Creates a mount over the top of the antenna of the M9N-5883 GPS + Compass module.
// https://www.mateksys.com/?portfolio=m9n-5883
module m9n_5883_mount() {
    board_width = 32.10;
    board_radius = 2;
    
    hole_distance_to_edge = 2.8;
    hole_offset = (board_width / 2) - hole_distance_to_edge;
    hole_diameter = 1.0;
    
    antenna_width = 26.0;
    antenna_radius = 2.9;
    antenna_height = 4.0;
    
    wall_thickness = 0.7;
    
    total_height = antenna_height + wall_thickness;
    
    difference() {
        linear_extrude(total_height)
        rounded_square(board_width, board_radius);
        
        translate([0, 0, wall_thickness])
        linear_extrude(antenna_height + epsilon)
        rounded_square(antenna_width + tolerance, antenna_radius);
        
        translate([0, 0, wall_thickness])        
        foreach_corner(hole_offset) {
            cylinder(antenna_height + epsilon, r = hole_diameter / 2);
        }
    }
}

m9n_5883_mount();