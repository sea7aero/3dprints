use <micro_pan.scad>

//color("red") mg90();
//color("red") hull() { flat_nut(3.0); }

//translate([0, 40, 0])


color("red")
translate([100, -100, 0])
import("harness_center_micro.stl");

color("green")
servo_shaft_and_gear();

color("yellow")
translate([0, 12, 3])
rotate([0, 0, 360 / 16])
driven_gear();

//translate([16, 0, 0])
//
//driven_gear();
