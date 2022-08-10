use <micro_pan.scad>

color("green")
translate([0, 0, 9.3])
servo_shaft_and_gear();

color("red")
translate([0, 20, 0])
harness();

color("yellow")
translate([20, 0, 0])
rotate([0, 0, 90])
nano_camera_mount_and_gear();

