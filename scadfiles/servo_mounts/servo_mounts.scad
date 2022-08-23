use <../servos.scad>

$fn = 64;

// Extra added to servo dimensions to account for printer tolerances
tolerance = 0.1;

// Small fudge factor to fix z-fighting in the render
epsilon = 0.01;

module servo_mount(
    servo_length,
    servo_width,
    tab_size,
    wall_thickness = 1.2,
    foam_thickness = 5.5,
    mounting_hole_diameter = 1.5,
    mounting_hole_distance = 1.0,
    wire_width = 4.0
) {
    servo_length = servo_length + tolerance;
    servo_width = servo_width + tolerance;
    
    wall_length = servo_length + (2 * wall_thickness);
    wall_width = servo_width + (2 * wall_thickness);
    
    total_length = wall_length + (2 * tab_size);
   
    translate([-wall_length / 2, -wall_width / 2, 0])
    difference() {
        union() {
            translate([-tab_size, 0, 0])
            cube([total_length, wall_width, wall_thickness]);
            translate([0, 0, wall_thickness])
            cube([wall_length, wall_width, foam_thickness]);
        }
        
        // hole for the servo to go in
        translate([wall_thickness, wall_thickness, -1])
        cube([servo_length, servo_width, 40]);
       
        // mounting holes
        translate([-mounting_hole_distance, wall_width / 2, -1])
        cylinder(h = 40, r = mounting_hole_diameter / 2);
        translate([wall_length + mounting_hole_distance, wall_width / 2, -1])
        cylinder(h = 40, r = mounting_hole_diameter / 2);
        
        // slot for wire
        translate([-epsilon, (wall_width - wire_width) / 2, -epsilon])
        cube([wall_thickness + (2*epsilon), wire_width, foam_thickness + wall_thickness + (2 * epsilon)]);
    }
}

module demo() {
    color("red")
    mg90();
    
    translate([5.5, 0, 16])
    mirror([0, 0, 1])
    servo_mount(servo_length=22.8, servo_width=12.2, tab_size=4.7);
}

demo();