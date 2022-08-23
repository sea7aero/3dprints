use <micro_pan.scad>
// The servo to use, select one from servo_data.csv
servo_data = search_servos("9180MG");

mirror([0, 0, 1])
drive_gear(servo_data);