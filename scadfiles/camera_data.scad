CAMERA_COMMENT = 1;
CAMERA_WIDTH = 2;

CAMERAS = 
[["Nano", "Generic Nano-sized FPV camera", 14],
 ["Micro", "Generic Micro-sized FPV camera", 19],
 ["Mini", "Generic Mini-sized FPV camera", 21],
 ["Full", "Generic Full-sized FPV camera", 28]];

function search_cameras(key) = CAMERAS[search([key], CAMERAS)[0]];
