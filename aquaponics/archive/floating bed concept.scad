$fn = 100;
epsilon = 1;

bedWidth = 50;
bedHeight = 30*0.3;
bedDepth = 150*0.3;

bedRoundingSize = [5/3 * bedHeight, 5/3 * bedHeight, 1];

wallThickness = 1;


echo("Volume:",
    (
        (
            (PI * (bedRoundingSize[0] / 2) * (bedRoundingSize[1] / 2)) / 2
            +
            (bedDepth - bedRoundingSize[0]) * bedHeight
        )
        * bedWidth
    )
    / pow(10, 3)
);

rotate([
    90,
    0,
    90
])
difference() {
    translate([
        bedRoundingSize[0]/2,
        bedRoundingSize[1]/2,
        0
    ])
    minkowski() {
        cube([
            bedDepth - bedRoundingSize[0],
            bedHeight * 2 - bedRoundingSize[1],
            bedWidth - bedRoundingSize[2]
        ]);
        resize(bedRoundingSize)
        cylinder();
    }

    translate([
        bedRoundingSize[0]/2 + wallThickness,
        bedRoundingSize[1]/2 + wallThickness,
        wallThickness
    ])
    minkowski() {
        cube([
            bedDepth - bedRoundingSize[0] - wallThickness * 2,
            bedHeight * 2 - bedRoundingSize[1] - wallThickness * 2,
            bedWidth - bedRoundingSize[2] - wallThickness * 2
        ]);
        resize(bedRoundingSize)
        cylinder();
    }

    translate([
        -epsilon,
        bedHeight,
        -epsilon
    ])
    cube([
        bedDepth +  epsilon * 2,
        bedHeight + epsilon,
        bedWidth + epsilon * 2
    ]);
}