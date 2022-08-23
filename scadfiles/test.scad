include <servo_data.scad>
use <servos.scad>

servo_data = search_servos("9180MG");
servo(servo_data);