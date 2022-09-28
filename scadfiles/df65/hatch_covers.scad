// Hatch covers for the DragonForce 65 Model Sailboat
// These are designed to be printed with a flexible filament, and be water-resistant
// when press-fit.

use <../shapes.scad>

include <../globals.scad>

module hatch_cover(
    width,
    length,
    corner_radius,
    cover_thickness = 1.6,
    cover_overlap = 4.0,
    plug_depth = 2.4,
    plug_lip = 0.75
) {
    // Cover
    linear_extrude(cover_thickness)
    rounded_square(
        width + (cover_overlap*2),
        length + (cover_overlap*2),
        corner_radius + cover_overlap
    );
    
    translate([0, 0, cover_thickness - epsilon])
    hull() {
        linear_extrude(plug_lip)
        rounded_square(width, length, corner_radius);
        
        translate([0, 0, plug_depth])
        linear_extrude(plug_lip)
        rounded_square(
            width + (plug_lip*2),
            length + (plug_lip*2),
            corner_radius + plug_lip
        );      
    }
}

module small_hatch_cover() {    
    hatch_cover(24.4, 50.4, 12.1);
}

small_hatch_cover();