// The xy_ variants of shape modules are centered with respect to the X/Y axes and "sit" on te XY plane.

module xy_cube(width, depth, height) {
    translate([0, 0, height / 2])
    cube([width, depth, height], center=true);
}

module xy_cylinder(
    h,
    r, r1, r2,
    d, d1, d2)
{
    translate([0, 0, h / 2])
    cylinder(h=h, r=r, r1=r1, r2=r2, d=d, d1=d1, d2=d2, center=true);
}

// Spreads out its children, spacing them along the x/y/z axis by the given amount.
module spread(x, y, z) {
    for(i = [0 : $children -1 ]) {
        translate([i*x, i*y, i*z])
        children(i);
    }
}

spread(15, 0, 0) {
    xy_cube(10, 10, 10);
    xy_cylinder(10, d=10);
}