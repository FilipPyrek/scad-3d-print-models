$fn = 100;
epsilon = 1;

bedWidth = 50;
bedHeight = 30*0.3;
bedDepth = 150*0.3;

wallThickness = 1;

difference() {

    resize([
        bedWidth,
        bedDepth,
        bedHeight * 2,
    ])
    rotate([
        0,
        90,
        0
    ])
    cylinder();

    translate([
        wallThickness,
        0,
        wallThickness
    ])
    resize([
        bedWidth - wallThickness * 2,
        bedDepth - wallThickness * 2,
        bedHeight * 2 - wallThickness * 2,
    ])
    rotate([
        0,
        90,
        0
    ])
    cylinder();

    translate([
        -epsilon,
        -epsilon - bedDepth / 2,
        0
    ])
    cube([
        bedWidth + epsilon * 2,
        bedDepth + epsilon * 2,
        bedHeight
    ]);
}