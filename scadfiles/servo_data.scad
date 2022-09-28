SERVO_LENGTH = 1;
SERVO_WIDTH = 2;
SERVO_HEIGHT = 3;
SERVO_TAB_LENGTH = 4;
SERVO_TAB_WIDTH = 5;
SERVO_TAB_THICKNESS = 6;
SERVO_TAB_HEIGHT = 7;
SERVO_MOUNTING_HOLE_OFFSET = 8;
SERVO_MOUNTING_HOLE_DIAMETER = 9;
SERVO_BEARING_CASE_DIAMETER = 10;
SERVO_BEARING_CASE_HEIGHT = 11;
SERVO_GEAR_CASE_DIAMETER = 12;
SERVO_SPLINE_OUTER_DIAMETER = 13;
SERVO_SPLINE_HEIGHT = 14;
SERVO_SPLINE_TEETH = 15;
SERVO_SPLINE_SCREW_DIAMETER = 16;
SERVO_WIRE_THICKNESS = 17;
SERVO_WIRE_OFFSET = 18;

SERVOS = 
[["9180MG", 23.5, 12, 21.0, 32.5, 11, 1.7, 16.5, 1.2, 2, 12, 3.8, 6.0,
  3.8, 3.2, 25, 2.0, 1.0, 0],
 ["MG90S", 22.5, 12, 22.5, 32.5, 12, 2.5, 18.0, 1.2, 2, 12, 6.0, 6.0, 4.8,
  4.1, 20, 2.5, 1.2, 4]];

function search_servos(key) = SERVOS[search([key], SERVOS)[0]];
