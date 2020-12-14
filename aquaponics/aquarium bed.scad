/* [Render] */
$fn = 20;

/* [Bed] */
bedWidth = 500;
bedDepth = 120;
bedHeight = 40;
bedWallThickness = 2;

bedInnerWidth = bedWidth - bedWallThickness * 2;
bedInnerDepth = bedDepth - bedWallThickness * 2;
bedInnerHeight = bedHeight - bedWallThickness;

/* [Siphon Tube] */
siphonTubeHeight = 8;
siphonTubeWidth = siphonTubeHeight * 2;
siphonZ = bedHeight * 0.7 - siphonTubeHeight/2;

siphonFilterWallThickness = 2; 
siphonFilterWidth = siphonTubeHeight * 2;
siphonFilterDepth = siphonTubeWidth * 1.5;
siphonFilterHeight = bedInnerHeight;
siphonHoleSize = 2;

/* [Intake] */
intakeWallSpacing = 10;
intakeTopD = 8;
intakeTopHeight = 10;
intakeTopThickness = 1;

intakeBottomD = 20;
intakeBottomHeight = 1;

intakeHolderHeight = 2;
intakeHolderWidth = 1;
intakeHolderCount = 10; 

union() {
    difference() {
        // Bed
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
            bedInnerWidth,
            bedInnerDepth,
            bedInnerHeight
        ]);

        // Siphon out
        translate([
            -intakeBottomD/2 + bedWidth - intakeWallSpacing,
            bedWallThickness + bedInnerDepth / 4,
            0
        ])
        cylinder(d=intakeTopD - intakeTopThickness * 2, h = bedWallThickness);

        // Siphon tube hole
        // translate([
        //     bedWidth - bedWallThickness,
        //     bedDepth / 2,
        //     siphonZ
        // ])
        // rotate([
        //     0,
        //     90,
        //     0
        // ])
        // resize([siphonTubeHeight, siphonTubeWidth, bedWallThickness])
        // cylinder();
    }

    // // Filter
    // translate([
    //     bedWidth - siphonFilterWidth - bedWallThickness,
    //     bedDepth / 2 - siphonFilterDepth / 2,
    //     bedWallThickness
    // ])
    // difference() {
    //     cube([
    //         siphonFilterWidth,
    //         siphonFilterDepth,
    //         siphonFilterHeight
    //     ]);

    //     translate([
    //         siphonFilterWallThickness,
    //         siphonFilterWallThickness,
    //         0
    //     ])
    //     cube([
    //         siphonFilterWidth - siphonFilterWallThickness,
    //         siphonFilterDepth - siphonFilterWallThickness * 2,
    //         siphonFilterHeight
    //     ]);

    //     zNumberOfHoles = floor((siphonFilterHeight - siphonFilterWallThickness * 2 )/(siphonHoleSize * 2));
    //     xNumberOfHoles = floor((siphonFilterWidth - siphonFilterWallThickness * 2 )/(siphonHoleSize * 2));
    //     yNumberOfHoles = floor((siphonFilterDepth - siphonFilterWallThickness * 2 )/(siphonHoleSize * 2)) - 1;

    //     // X axis holes
    //     for (zIndex = [0:zNumberOfHoles]) {
    //         for(xIndex = [0:xNumberOfHoles]) {
    //             translate([
    //                 siphonFilterWallThickness + siphonHoleSize * xIndex * 2,
    //                 0,
    //                 siphonHoleSize * zIndex * 2,
    //             ])
    //             cube([
    //                 siphonHoleSize,
    //                 siphonFilterDepth,
    //                 siphonHoleSize
    //             ]);
    //         }
    //     }

    //     // Y axis holes
    //     for (zIndex = [0:zNumberOfHoles]) {
    //         for(yIndex = [0:yNumberOfHoles]) {
    //             translate([
    //                 0,
    //                 siphonFilterWallThickness + siphonHoleSize * yIndex * 2 + siphonHoleSize/2,
    //                 siphonHoleSize * zIndex * 2,
    //             ])
    //             cube([
    //                 siphonHoleSize,
    //                 siphonHoleSize,
    //                 siphonHoleSize
    //             ]);
    //         }
    //     }
    // }

    // Siphon intake
    translate([
        -intakeBottomD/2 + bedWidth - intakeWallSpacing,
        bedWallThickness + bedInnerDepth / 4 * 3,
        bedWallThickness
    ])
    union() {
        difference() {
            union() {
                for(index = [1:intakeHolderCount]) {
                    rotate(360/intakeHolderCount * index)
                    translate([
                        -intakeHolderWidth/2,
                        -intakeBottomD / 2,
                        0
                    ])
                    cube([
                        intakeHolderWidth,
                        intakeBottomD,
                        intakeHolderHeight
                    ]);
                }
                translate([
                    0,
                    0,
                    intakeHolderHeight 
                ])
                cylinder(d = intakeBottomD, h = intakeBottomHeight);
            }

            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeHolderHeight + intakeBottomHeight);
        }

        translate([
            0,
            0,
            intakeHolderHeight + intakeBottomHeight
        ])
        difference() {
            cylinder(d=intakeTopD, h = intakeTopHeight);
            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeTopHeight);
        }
    }

    // Siphon drain tube
    translate([
            -intakeBottomD/2 + bedWidth - intakeWallSpacing,
            bedWallThickness + bedInnerDepth / 4,
            bedWallThickness
        ])
        difference() {
            cylinder(d=intakeTopD, h = intakeTopHeight);
            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeTopHeight);
        }

    // Intake
    translate([
        intakeWallSpacing + intakeBottomD/2 + bedWallThickness,
        bedWallThickness + bedInnerDepth /2,
        bedWallThickness
    ])
    union() {
        difference() {
            union() {
                for(index = [1:intakeHolderCount]) {
                    rotate(360/intakeHolderCount * index)
                    translate([
                        -intakeHolderWidth/2,
                        -intakeBottomD / 2,
                        0
                    ])
                    cube([
                        intakeHolderWidth,
                        intakeBottomD,
                        intakeHolderHeight
                    ]);
                }
                translate([
                    0,
                    0,
                    intakeHolderHeight 
                ])
                cylinder(d = intakeBottomD, h = intakeBottomHeight);
            }

            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeHolderHeight + intakeBottomHeight);
        }

        translate([
            0,
            0,
            intakeHolderHeight + intakeBottomHeight
        ])
        difference() {
            cylinder(d=intakeTopD, h = intakeTopHeight);
            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeTopHeight);
        }
    }
}
