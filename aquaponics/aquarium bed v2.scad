$fn = 100;
epsilon = 1;

printerMaxPartSize = 170;

bedWidth = 500;
bedDepth = 150;
bedHeight = 45;
bedWallThickness = 2;

intakeInnerD = 6;
intakeOuterD = 8;
intakeHeight = 10;

intakeWallSpacing = 2;
intakeWallWidth = intakeOuterD * 2;
intakeWallThickness = 2;

drainInnerD = 6;
drainOuterD = 8;
drainAngle = 45;
drainHeight = 15;
drainWallSpacing = 10;

filterXCount = 5;
filterYCount = 8;
filterTickness = filterXCount > filterYCount
        ? (bedDepth - bedWallThickness * 2) / (filterXCount * 2)
        : (bedHeight - bedWallThickness) / (filterYCount * 2);

bedMainPartWidth = bedWidth + intakeHeight - drainOuterD - drainWallSpacing * 2 - bedWallThickness - drainWallSpacing;
flangeCount = ceil(bedMainPartWidth / printerMaxPartSize);
flangeSize = bedHeight * 0.5;
flangeThickness = 4;

module bed() {
    difference() {
        cube([
            bedWidth,
            bedDepth,
            bedHeight
        ]);

        translate([
            bedWallThickness,
            bedWallThickness,
            bedWallThickness
        ])
        cube([
            bedWidth - bedWallThickness * 2,
            bedDepth - bedWallThickness * 2,
            bedHeight - bedWallThickness + epsilon
        ]);

        // intake
        translate([
            -epsilon,
            bedDepth / 2,
            bedHeight - intakeOuterD/2 - intakeWallThickness
        ])
        rotate([
            0,
            90,
            0
        ])
        cylinder(d=intakeInnerD, h = bedWallThickness + epsilon * 2);

        ///drain
        translate([
            bedWidth - bedWallThickness - drainOuterD / 2 - drainWallSpacing,
            bedWallThickness + (bedDepth - 2 * bedWallThickness) / 4,
            bedWallThickness
        ])
        rotate([
            -drainAngle,
            0,
            0
        ])
        translate([
            0,
            0,
            -drainHeight
        ])
        cylinder(d=drainInnerD, h=drainHeight * 2);
    }

}

module intake() {
     translate([
        -intakeHeight,
        bedDepth / 2,
        bedHeight - intakeOuterD/2 - intakeWallThickness
    ])
    rotate([
        0,
        90,
        0
    ])
    difference() {
        cylinder(d=intakeOuterD, h=intakeHeight);

        translate([
            0,
            0,
            -epsilon
        ])
        cylinder(d=intakeInnerD, h=intakeHeight + 2 * epsilon);
    }

    translate([
        bedWallThickness + intakeWallSpacing,
        bedDepth / 2 - intakeWallWidth / 2,
        bedWallThickness
    ])
    cube([
        intakeWallThickness,
        intakeWallWidth,
        bedHeight - bedWallThickness - intakeWallThickness
    ]);

    translate([
        bedWallThickness,
        bedDepth / 2 - intakeWallWidth / 2,
        bedHeight - intakeWallThickness
    ])
    cube([
        intakeWallThickness + intakeWallSpacing,
        intakeWallWidth,
        intakeWallThickness
    ]);

    translate([
        bedWallThickness,
        bedDepth / 2 - intakeWallWidth / 2,
        (bedHeight - bedWallThickness - intakeWallThickness) / 2 + bedWallThickness
    ])
    cube([
        intakeWallSpacing,
        intakeWallThickness,
        (bedHeight - bedWallThickness - intakeWallThickness) / 2
    ]);

    translate([
        bedWallThickness,
        bedDepth / 2 + intakeWallWidth / 2 - intakeWallThickness,
        (bedHeight - bedWallThickness - intakeWallThickness) / 2 + bedWallThickness
    ])
    cube([
        intakeWallSpacing,
        intakeWallThickness,
        (bedHeight - bedWallThickness - intakeWallThickness) / 2
    ]);
}


module flange() {
    if (flangeCount > 1) {

        for(side = ["near", "far"]) {
            for(i = [1:flangeCount - 1]) {
                translate([
                    bedMainPartWidth / flangeCount * i - (flangeThickness / 2 * (side == "far" ? -1 : 1)) - intakeHeight,
                    (side == "far" ? bedDepth - bedWallThickness: bedWallThickness),
                    bedWallThickness
                ])
                rotate([
                    90,
                    0,
                    90 * (side == "far" ? -1 : 1)
                ])
                linear_extrude(height=flangeThickness)
                {
                    polygon(
                        points=[[0,0],[flangeSize,0],[0,flangeSize]],
                        paths=[[0,1,2]]
                    );
                }
            }
        }
    }

    if (bedWidth + intakeHeight > printerMaxPartSize) {
        for(side = ["near", "far"]) {
            translate([
                bedMainPartWidth - (flangeThickness / 2 * (side == "far" ? -1 : 1)) - intakeHeight - flangeThickness / 2,
                (side == "far" ? bedDepth - bedWallThickness: bedWallThickness),
                bedWallThickness
            ])
            rotate([
                90,
                0,
                90 * (side == "far" ? -1 : 1)
            ])
            linear_extrude(height=flangeThickness)
            {
                polygon(
                    points=[[0,0],[flangeSize,0],[0,flangeSize]],
                    paths=[[0,1,2]]
                );
            }
        }
    }
}

module drain() {
    translate([
        bedWidth - bedWallThickness - drainOuterD / 2 - drainWallSpacing,
        0,
        bedWallThickness
    ])
    union() {
        difference() {
            translate([
                0,
                (bedDepth - 2 * bedWallThickness) / 4 * 3 + bedWallThickness,
                0
            ])
            rotate([
                drainAngle,
                0,
                0
            ])
            difference() {
                cylinder(d=drainOuterD, h=drainHeight);

                translate([
                    0,
                    0,
                    -epsilon
                ])
                cylinder(d=drainInnerD, h=drainHeight + epsilon * 2);
            }

            translate([
                - drainWallSpacing / 2,
                (bedDepth - 2 * bedWallThickness) / 4 * 3 + bedWallThickness - max(drainHeight, drainOuterD) /2,
                -max(drainHeight, drainOuterD)
            ])
            cube([
                max(drainHeight, drainOuterD),
                max(drainHeight, drainOuterD),
                max(drainHeight, drainOuterD)
            ]);
        }

        difference() {
            translate([
                0,
                bedWallThickness + (bedDepth - 2 * bedWallThickness) / 4,
                0
            ])
            rotate([
                -drainAngle,
                0,
                0
            ])
            translate([
                0,
                0,
                -drainHeight
            ])
            difference() {
                cylinder(d=drainOuterD, h=drainHeight * 2);

                translate([
                    0,
                    0,
                    -epsilon
                ])
                cylinder(d=drainInnerD, h=drainHeight * 2 + epsilon * 2);
            }
        }
    }
}

module filter() {
    for(i = [1:filterYCount]) {
        step = (bedHeight - bedWallThickness) / (filterYCount * 2) * i;

        translate([
            bedWidth - bedWallThickness - drainOuterD - drainWallSpacing * 2 - bedWallThickness,
            bedWallThickness,
            bedWallThickness + step + filterTickness * (i - 1)
        ])
        cube([
            bedWallThickness,
            bedDepth - bedWallThickness * 2,
            filterTickness
        ]);
    }

    for(i = [1:filterXCount]) {
        step = (bedDepth - bedWallThickness * 2) / filterXCount  * i;

        translate([
            bedWidth - bedWallThickness - drainOuterD - drainWallSpacing * 2 - bedWallThickness,
            bedWallThickness + step - filterTickness / 2 - (bedDepth - bedWallThickness * 2) / filterXCount / 2,
            bedWallThickness 
        ])
        cube([
            bedWallThickness,
            filterTickness,
            bedHeight - bedWallThickness
        ]);
    }
}

bed();
intake();
flange();
drain();
filter();
