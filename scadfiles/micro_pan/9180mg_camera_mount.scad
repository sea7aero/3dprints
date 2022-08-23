use <micro_pan.scad>
// The servo to use, select one from servo_data.csv
servo_data = search_servos("9180MG");

camera_mount_with_gear(servo_data);