/* [Render] */
$fn = 20;
epsilon = 1;

/* [Bed] */
bedWidth = 500;
bedDepth = 120;
bedHeight = 40;
bedWallThickness = 2;

bedInnerWidth = bedWidth - bedWallThickness * 2;
bedInnerDepth = bedDepth - bedWallThickness * 2;
bedInnerHeight = bedHeight - bedWallThickness;

/* [Water Intake] */
intakeXWallSpacing = 10;
intakeTopD = 8;
intakeTopHeight = 10;
intakeTopThickness = 1;

intakeBottomD = 20;
intakeBottomHeight = 1;

intakeSupportHeight = 2;
intakeSupportWidth = 1;
intakeSupportCount = 10; 

/* [Drain] */

drainWallSpacing = 5;
drainTopD = 8;
drainTopHeight = 10;
drainTopThickness = 1;

drainBottomD = 20;
drainBottomHeight = 1;

drainSupportHeight = 2;
drainSupportWidth = 1;
drainSupportCount = 10; 

drainIntakeDistance = 60;

drainFilterWallThickness = 2;
drainFilterWidth = drainBottomD/2 + drainTopD/2 + drainIntakeDistance + drainWallSpacing * 2 + drainFilterWallThickness;
drainFilterDepth = drainBottomD + drainWallSpacing * 2 + drainFilterWallThickness;
drainFilterHeight = bedInnerHeight;
drainFilterHoleSize = 2;


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
            bedInnerHeight + epsilon
        ]);

        // Siphon drain hole
        for(drainIndex = ["drain1","drain2"]) 
        translate([
            bedWidth - drainTopD/2 - bedWallThickness - drainWallSpacing,
            drainIndex == "drain1"
                ? drainBottomD/2 + bedWallThickness + drainWallSpacing
                : bedDepth - drainBottomD/2 - bedWallThickness - drainWallSpacing,
            -epsilon
        ])
        cylinder(d=drainTopD - drainTopThickness * 2, h = bedWallThickness + epsilon * 2);
    }

    // Siphon intake
    for(drainIndex = ["drain1","drain2"])
    translate([
        bedWidth - drainTopD/2 - bedWallThickness - drainWallSpacing - drainIntakeDistance,
        drainIndex == "drain1"
            ? drainBottomD/2 + bedWallThickness + drainWallSpacing
            : bedDepth - drainBottomD/2 - bedWallThickness - drainWallSpacing,
        bedWallThickness
    ])
    union() {
        difference() {
            union() {
                for(index = [1:intakeSupportCount]) {
                    rotate(360/intakeSupportCount * index)
                    translate([
                        -intakeSupportWidth/2,
                        -intakeBottomD / 2,
                        0
                    ])
                    cube([
                        intakeSupportWidth,
                        intakeBottomD,
                        intakeSupportHeight
                    ]);
                }
                translate([
                    0,
                    0,
                    intakeSupportHeight 
                ])
                cylinder(d = intakeBottomD, h = intakeBottomHeight);
            }

            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeSupportHeight + intakeBottomHeight);
        }

        translate([
            0,
            0,
            intakeSupportHeight + intakeBottomHeight
        ])
        difference() {
            cylinder(d=intakeTopD, h = intakeTopHeight);
            translate([
                0,
                0,
                -epsilon
            ])
            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeTopHeight + epsilon * 2);
        }
    }

    // Siphon drain tube
    for(drainIndex = ["drain1","drain2"])
    translate([
        bedWidth - drainTopD/2 - bedWallThickness - drainWallSpacing,
        drainIndex == "drain1"
            ? drainBottomD/2 + bedWallThickness + drainWallSpacing
            : bedDepth - drainBottomD/2 - bedWallThickness - drainWallSpacing,
        bedWallThickness
    ])
    difference() {
        cylinder(d=drainTopD, h = drainTopHeight);
        translate([
            0,
            0,
            -epsilon
        ])
        cylinder(d=drainTopD - drainTopThickness * 2, h = drainTopHeight + epsilon * 2);
    }

    // Siphon filter
    for(drainIndex = ["drain1","drain2"])
    translate([
        bedInnerWidth + bedWallThickness - drainFilterWidth,
        drainIndex == "drain1"
            ? bedWallThickness
            : bedWallThickness + bedInnerDepth - drainFilterDepth,
        bedWallThickness
    ])
    difference() {
        cube([
            drainFilterWidth,
            drainFilterDepth,
            drainFilterHeight
        ]);

        translate([
            drainFilterWallThickness,
            drainIndex == "drain1"
                ? 0
                : drainFilterWallThickness,
            0
        ])
        cube([
            drainFilterWidth - drainFilterWallThickness,
            drainFilterDepth - drainFilterWallThickness,
            drainFilterHeight + epsilon
        ]);

        zNumberOfHoles = floor((drainFilterHeight - drainFilterWallThickness * 2 )/(drainFilterHoleSize * 2));
        xNumberOfHoles = floor((drainFilterWidth - drainFilterWallThickness * 2 )/(drainFilterHoleSize * 2));
        yNumberOfHoles = floor((drainFilterDepth - drainFilterWallThickness * 2 )/(drainFilterHoleSize * 2));

        // X axis holes
        for (zIndex = [0:zNumberOfHoles]) {
            for(xIndex = [0:xNumberOfHoles]) {
                translate([
                    drainFilterWallThickness + drainFilterHoleSize * xIndex * 2,
                    -epsilon,
                    drainFilterHoleSize * zIndex * 2,
                ])
                cube([
                    drainFilterHoleSize,
                    drainFilterDepth + epsilon * 2,
                    drainFilterHoleSize
                ]);
            }
        }

        // Y axis holes
        for (zIndex = [0:zNumberOfHoles]) {
            for(yIndex = [0:yNumberOfHoles]) {
                translate([
                    -epsilon,
                    drainFilterWallThickness + drainFilterHoleSize * yIndex * 2,
                    drainFilterHoleSize * zIndex * 2,
                ])
                cube([
                    drainFilterWidth + epsilon * 2,
                    drainFilterHoleSize,
                    drainFilterHoleSize
                ]);
            }
        }
    }

    // Water Intake
    translate([
        intakeXWallSpacing + intakeBottomD/2 + bedWallThickness,
        bedWallThickness + bedInnerDepth /2,
        bedWallThickness
    ])
    union() {
        difference() {
            union() {
                // Intake supports
                for(index = [1:intakeSupportCount]) {
                    rotate(360/intakeSupportCount * index)
                    translate([
                        -intakeSupportWidth/2,
                        -intakeBottomD / 2,
                        0
                    ])
                    cube([
                        intakeSupportWidth,
                        intakeBottomD,
                        intakeSupportHeight
                    ]);
                }

                // Intake bottom cover
                translate([
                    0,
                    0,
                    intakeSupportHeight 
                ])
                cylinder(d = intakeBottomD, h = intakeBottomHeight);
            }

            // Intake tube hole
            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeSupportHeight + intakeBottomHeight);
        }

        // Intake tube
        translate([
            0,
            0,
            intakeSupportHeight + intakeBottomHeight
        ])
        difference() {
            cylinder(d=intakeTopD, h = intakeTopHeight);
            translate([
                0,
                0,
                -epsilon
            ])
            cylinder(d=intakeTopD - intakeTopThickness * 2, h = intakeTopHeight + epsilon * 2);
        }
    }
}
