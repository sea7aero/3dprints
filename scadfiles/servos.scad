use <mcad/involute_gears.scad>
use <shapes.scad>

include <globals.scad>
include <servo_data.scad>


module servo_body(data) {
    length = data[SERVO_LENGTH];
    width = data[SERVO_WIDTH];
    height = data[SERVO_HEIGHT];
       
    xy_cube(width, length, height);
}

// Translates (and copies) children to the bottom of the two mounting tab holes relative to the tab location.
module servo_mounting_holes_location(data) {
    length = data[SERVO_TAB_LENGTH];
    height = data[SERVO_TAB_THICKNESS];
    
    hole_radius = data[SERVO_MOUNTING_HOLE_DIAMETER] / 2;
    hole_offset = data[SERVO_MOUNTING_HOLE_OFFSET];
    
    hole_position = (length / 2) - (hole_offset + hole_radius);
    
    for(y = [-1, 1]) {
        translate([0, y * hole_position, 0]) {
            xy_cylinder(h=height + (2 * epsilon), r=hole_radius);
            
            translate([0, 0, height - epsilon])
            children();
        }
    }
}

module servo_mounting_holes(data) {    
    translate([0, 0, -epsilon])
    servo_mounting_holes_location(data) {
        xy_cylinder(
            h=data[SERVO_TAB_THICKNESS] + (2 * epsilon),
            d=data[SERVO_MOUNTING_HOLE_DIAMETER]
        );
        children();
    }
}

// Translates the module's children to the location of the servo tab.
module servo_tab_location(data) {
    translate([0, 0, data[SERVO_TAB_HEIGHT]])
    children();
}

module servo_tab(data, mounting_holes=true) {
    length = data[SERVO_TAB_LENGTH];
    width = data[SERVO_TAB_WIDTH];
    thickness = data[SERVO_TAB_THICKNESS];
           
    difference() {
        xy_cube(width, length, thickness);
        if(mounting_holes) {
            servo_mounting_holes(data);
        }
    }
}

// Returns the x, y, z location of the center bottom of the bearing case.
function servo_bearing_case_position(data) = [
    0,
    (data[SERVO_LENGTH] - data[SERVO_BEARING_CASE_DIAMETER]) / 2,
    data[SERVO_HEIGHT] - epsilon
];

// Returns the x, y, z size of the "bearing case" which is at the top of a servo.
function servo_bearing_case_size(data) = [
    data[SERVO_BEARING_CASE_DIAMETER],
    data[SERVO_BEARING_CASE_DIAMETER] + (data[SERVO_GEAR_CASE_DIAMETER] / 2),
    data[SERVO_BEARING_CASE_HEIGHT]
];

module servo_bearing_case_location(data) {
    translate(servo_bearing_case_position(data))
    children();
}

module servo_bearing_case(data) {
    bearing_case_diameter = data[SERVO_BEARING_CASE_DIAMETER];
    bearing_case_height = data[SERVO_BEARING_CASE_HEIGHT];
    gear_case_diameter = data[SERVO_GEAR_CASE_DIAMETER];
    
    xy_cylinder(h = bearing_case_height, r = bearing_case_diameter / 2);
        
    translate([0, -bearing_case_diameter / 2, 0])
    xy_cylinder(h = bearing_case_height, r = gear_case_diameter / 2);
}


// Returns the x, y, z location of the bottom of the spline.
function servo_spline_position(data) = servo_bearing_case_position(data) + [
    0,
    0,
    data[SERVO_BEARING_CASE_HEIGHT] - epsilon
];

module servo_spline_location(data) {
    translate(servo_spline_position(data))
    children();
}

module servo_spline(data) {     
    diameter = data[SERVO_SPLINE_OUTER_DIAMETER];
    height = data[SERVO_SPLINE_HEIGHT];
    teeth = data[SERVO_SPLINE_TEETH];
    
    gear(
        diametral_pitch = teeth / diameter,
        number_of_teeth = teeth,
        gear_thickness = height,
        hub_thickness = height,
        rim_thickness = height,
        bore_diameter = 0,
        clearance = 0,
        pressure_angle=35
    );
}   

module servo(data) {
    echo("Servo Data:", data);
    
    servo_body(data);
    
    servo_tab_location(data)
    servo_tab(data);
    
    servo_bearing_case_location(data)
    servo_bearing_case(data);
    
    servo_spline_location(data)
    servo_spline(data);
}

// Creates a servo horn, with children positioned on the top.  It is designed to print upside down.
module servo_horn(
    data,
    wall_thickness=1,
    shaft_height=undef,
    screwhead_diameter=undef,
) {
    spline_diameter = data[SERVO_SPLINE_OUTER_DIAMETER];
    diameter = spline_diameter + (wall_thickness * 2);
    
    screw_diameter = data[SERVO_SPLINE_SCREW_DIAMETER];
    bore_diameter = screwhead_diameter == undef ? spline_diameter : screwhead_diameter;

    spline_height = data[SERVO_SPLINE_HEIGHT];
    height = shaft_height == undef ? spline_height + wall_thickness: shaft_height;
    
    // 45 degree transition so can print without overhangs.
    transition_height = (bore_diameter - screw_diameter) / 2;
    
    difference() {
        union() {
            xy_cylinder(h=height, d=diameter);
            translate([0, 0, height - epsilon])
            children();
        }
        
        translate([0, 0, -epsilon]) {
            xy_cylinder(h=height + (epsilon*2), d=screw_diameter);
            servo_spline(data);
            
            translate([0, 0, spline_height])
            xy_cylinder(h=transition_height, d1=screw_diameter, d2=bore_diameter);
            
            translate([0, 0, spline_height + transition_height - epsilon])
            xy_cylinder(h=4000, d=bore_diameter);
        }
    }
    
    
}

module servo_demo(servo_name) {
    data = search_servos(servo_name);
    
    servo(data);
    
    servo_spline_location(data) {
        translate([0, 0, 5])
        servo_horn(data) {
            xy_cylinder(d=15, h=1.5);
        }
    }
    
    translate([20, 0, 0])        
    rotate([0, 0, 90])
    text(data[0], halign="center");       
}

servo_demo("9180MG");    
