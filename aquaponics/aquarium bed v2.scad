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

drainWidth = bedDepth / 3;
drainIntakeDepth = drainWidth / 5;
drainOutputDepth = drainIntakeDepth / 2;
drainTreshold = bedHeight * 0.7;
drainWallThickness = bedWallThickness;
drainIntakeHeight = bedHeight * 0.05;
drainOutputHeight = bedHeight * 0.75;

filterXCount = 5;
filterYCount = 8;
filterTickness = filterXCount > filterYCount
        ? (bedDepth - bedWallThickness * 2) / (filterXCount * 2)
        : (bedHeight - bedWallThickness) / (filterYCount * 2);

bedMainPartWidth = bedWidth + intakeHeight - drainIntakeDepth * 2 - drainOutputDepth - bedWallThickness;
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

        // drain
        translate([
            bedWidth - bedWallThickness - epsilon,
            bedDepth / 2 - drainWidth / 2 + bedWallThickness,
            drainTreshold + bedWallThickness
        ])
        cube([
            bedWallThickness + epsilon * 2,
            drainWidth - drainWallThickness * 2,
            drainIntakeHeight
        ]);
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
        bedWidth - drainIntakeDepth - bedWallThickness,
        bedDepth / 2 - drainWidth / 2,
        0,
    ])
    union() {
        translate([
            0,
            0,
            bedWallThickness
        ])
        difference() {
            cube([
                drainIntakeDepth,
                drainWidth,
                drainTreshold + drainIntakeHeight + drainWallThickness
            ]);

            translate([
                drainWallThickness,
                drainWallThickness,
                -epsilon
            ])
            cube([
                drainIntakeDepth - drainWallThickness + epsilon,
                drainWidth - drainWallThickness * 2,
                drainTreshold  + drainIntakeHeight  + epsilon
            ]);
            
            translate([
                -epsilon,
                drainWallThickness,
                -epsilon
            ])
            cube([
                drainWallThickness + epsilon * 2,
                drainWidth - drainWallThickness * 2,
                drainIntakeHeight + epsilon
            ]);

            translate([
                -epsilon,
                drainWidth / 2 - drainIntakeHeight / 2,
                drainIntakeHeight + drainIntakeHeight / 2
            ])
            cube([
                drainWallThickness + epsilon * 2,
                drainIntakeHeight,
                drainIntakeHeight / 2
            ]);
        }

        translate([
            drainOutputDepth * 2 + bedWallThickness,
            0,
            0
        ])
        union() {
            difference() {
                cube([
                    drainOutputDepth,
                    drainWidth,
                    drainTreshold + drainIntakeHeight + drainWallThickness + bedWallThickness
                ]);

                translate([
                    -epsilon,
                    drainWallThickness,
                    -epsilon
                ])
                cube([
                    drainOutputDepth - drainWallThickness + epsilon,
                    drainWidth - drainWallThickness * 2,
                    drainTreshold  + drainIntakeHeight + bedWallThickness + epsilon
                ]);
            }

            translate([
                -drainWallThickness,
                0,
                -drainOutputHeight
            ])
            difference() {
                cube([
                    drainOutputDepth + bedWallThickness,
                    drainWidth,
                    drainOutputHeight
                ]);

                translate([
                    drainWallThickness,
                    drainWallThickness,
                    -epsilon
                ])
                cube([
                    drainOutputDepth - drainWallThickness,
                    drainWidth - drainWallThickness * 2,
                    drainOutputHeight + epsilon * 2
                ]);
            }
        }
    }
}

module filter() {
    for(i = [1:filterYCount]) {
        step = (bedHeight - bedWallThickness) / (filterYCount * 2) * i;

        translate([
            bedWidth - bedWallThickness - drainIntakeDepth * 2 - bedWallThickness,
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
            bedWidth - bedWallThickness - drainIntakeDepth * 2 - bedWallThickness,
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
