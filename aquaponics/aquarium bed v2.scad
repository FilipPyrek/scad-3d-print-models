$fn = 100;
epsilon = 1;

printerMaxPartSize = 170;

bedWidth = 500;
bedDepth = 150;
bedHeight = 30;
bedWallThickness = 2;

intakeInnerD = 6;
intakeOuterD = 8;
intakeHeight = 10;

intakeWallSpacing = 2;
intakeWallWidth = intakeOuterD * 2;
intakeWallThickness = 2;

drainWallThickness = bedWallThickness;
drainInsideOuterD = 21;
drainInsideInnerD = 7;
drainInsideHeight = bedHeight * 0.5;

drainOutsideOuterD = drainInsideOuterD * 1.65;
drainOutsideInnerD = drainOutsideOuterD - drainWallThickness;
drainOutsideHeight = drainInsideHeight * 1.1;

drainIntakeHeight = bedHeight * 0.05;
drainOutputHeight = bedHeight;

drainOxIntakeSize = drainOutsideHeight - drainInsideHeight;
drainOxIntakeWallSize = drainWallThickness / 2;

filterInnerD = drainOutsideOuterD * 1.3;
filterOuterD = filterInnerD  + bedWallThickness * 2;
filterCountZ = 5;
filterPillarWidth = 5;
filterPillarCount = 4;

bedMainPartWidth = bedWidth + intakeHeight;
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
            bedWidth / 2,
            bedDepth / 2,
            -epsilon
        ])
        cylinder(d=drainInsideInnerD, h=bedWallThickness + epsilon * 2);
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
}

module drain() {
    translate([
        bedWidth / 2,
        bedDepth / 2,
        0
    ])
    union() {
        translate([
            0,
            0,
            bedWallThickness
        ])
        union() {
            // inner drain
            difference() {
                cylinder(d=drainInsideOuterD, h=drainOutsideHeight);
                
                hull() {
                    translate([0,0,drainInsideHeight * 0.75])
                    cylinder(d=drainInsideInnerD, h=1);

                    translate([
                        0,
                        0,
                        drainInsideHeight
                    ])
                    cylinder(d=drainInsideOuterD - drainWallThickness, h=drainOutsideHeight - drainInsideHeight + epsilon);
                }

                translate([
                    0,
                    0,
                    -epsilon
                ])
                cylinder(d=drainInsideInnerD, h = drainInsideHeight * 0.75 + epsilon * 2);
                
                /// top intakes
                for(rotation = [0,90]){
                    rotate([
                        0,
                        0,
                        rotation
                    ])
                    translate([
                        -drainInsideOuterD / 2,
                        -drainInsideOuterD / 4,
                        drainInsideHeight
                    ])
                    cube([
                        drainInsideOuterD,
                        drainInsideOuterD / 2,
                        drainOutsideHeight - drainInsideHeight + epsilon
                    ]);
                }
            }

            // outer cylinder
            difference() {
                cylinder(d=drainOutsideOuterD, h=drainOutsideHeight);

                translate([
                    0,
                    0,
                    -epsilon
                ])
                cylinder(d=drainOutsideInnerD, h=drainOutsideHeight + epsilon * 2);
            
                // bottom intakes
                for (rotation = [22.5,67.5,112.5,157.5]) {
                    rotate([
                        0,
                        0,
                        rotation
                    ])
                    translate([
                        -drainOutsideOuterD / 4 / 2,
                        -drainOutsideOuterD / 2,
                        -epsilon
                    ])
                    cube([
                        drainOutsideOuterD / 2 / 2,
                        drainOutsideOuterD,
                        drainIntakeHeight + epsilon
                    ]);
                }

                // ox intake
                translate([
                    -drainOutsideOuterD / 4 / 2,
                    -drainOutsideOuterD / 2 - epsilon,
                    drainInsideHeight
                ])
                cube([
                    drainOutsideOuterD / 4,
                    (drainOutsideOuterD - drainOutsideInnerD) / 2 + epsilon * 2,
                    drainOxIntakeSize + epsilon
                ]);
            }

            // cover
            color("white", 0.25)
            translate([
                0,
                0,
                drainOutsideHeight
            ])
            cylinder(d=drainOutsideOuterD, h = drainWallThickness);
        
            // oxygen
            translate([
                -drainOutsideOuterD / 4 / 2,
                -drainOxIntakeSize - drainOutsideOuterD / 2 + (drainOutsideOuterD - drainOutsideInnerD) / 2,
                drainInsideHeight
            ])
            union() {
                // tube
                difference() {
                    translate([
                        -drainOxIntakeWallSize,
                        -drainOxIntakeWallSize,
                        -drainOutsideHeight + drainOxIntakeSize + drainIntakeHeight * 3
                    ])
                    cube([
                        drainOutsideOuterD / 4 + drainOxIntakeWallSize * 2,
                        drainOxIntakeSize + drainOxIntakeWallSize,
                        drainOutsideHeight - drainIntakeHeight * 3 + drainWallThickness
                    ]);

                    translate([
                        0,
                        0,
                        -drainOutsideHeight + drainOxIntakeSize + drainIntakeHeight * 3 - epsilon
                    ])
                    cube([
                        drainOutsideOuterD / 4,
                        drainOxIntakeSize + epsilon,
                        drainOutsideHeight - drainIntakeHeight * 3 + epsilon
                    ]);
                }

                // bottom holder
                difference() {
                    translate([
                        -drainOxIntakeWallSize,
                        -drainOxIntakeWallSize,
                        -drainInsideHeight
                    ])
                    cube([
                        drainOutsideOuterD / 4 + drainOxIntakeWallSize * 2,
                        drainOxIntakeWallSize,
                        drainIntakeHeight * 3
                    ]);

                    translate([
                        drainOutsideOuterD / 8 / 2,
                        -drainOxIntakeWallSize - epsilon,
                        -drainInsideHeight + drainIntakeHeight * 1.5
                    ])
                    cube([
                        drainOutsideOuterD / 8,
                        drainOxIntakeWallSize + epsilon * 2,
                        drainIntakeHeight * 1.5
                    ]);
                }
            }
        }

        // output
        translate([
            0,
            0,
            -drainOutputHeight
        ])
        difference() {
            cylinder(d=drainInsideInnerD + drainWallThickness * 2, h=drainOutputHeight);

            translate([
                0,
                0,
                -epsilon
            ])
            cylinder(d=drainInsideInnerD, h=drainOutputHeight + epsilon * 2);
        }
    }
}

module filter_circle(stepSize) {
    difference() {
        cylinder(d = filterOuterD, h = stepSize);

        translate([
            0,
            0,
            -epsilon
        ])
        cylinder(d = filterInnerD, h = stepSize + epsilon * 2);
    }
}
module filter() {
    translate([
        bedWidth / 2,
        bedDepth / 2,
        bedWallThickness
    ])
    union() {
        stepSize = (bedHeight - bedWallThickness) / (filterCountZ * 2);

        for(i = [1:filterCountZ]) {
            translate([
                0,
                0,
                stepSize * 2 * i - stepSize
            ])
            filter_circle(stepSize);
            
            for(r = [0:180 / filterPillarCount:180]) {
                intersection() {
                    translate([
                        0,
                        0,
                        stepSize * 2 * (i - 1)
                    ])
                    filter_circle(stepSize);

                    rotate([
                        0,
                        0,
                        r
                    ])
                    translate([
                        -filterOuterD / 2,
                        -filterPillarWidth / 2,
                        0
                    ])
                    cube([
                        filterOuterD,
                        filterPillarWidth,
                        bedHeight - bedWallThickness
                    ]);
                }
            }
        }

    }
}

bed();
intake();
flange();
drain();
filter();
