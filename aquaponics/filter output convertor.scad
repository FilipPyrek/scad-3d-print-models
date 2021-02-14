$fn = 100;
epsilon = 1;

intakeInnerD = 12;
intakeOuterD = 14;
intakeHeight = 10;

transitionHeight = 10;

outputOuterD = 8;
outputInnerD = 6;
outputHeight = 15;

oxOuterD = 4;
oxInnerD = 3;
oxHeight = 7;

oxBreakD = outputInnerD * 0.75;
oxBreakThickness = 1;

module convertor(smallD, smallHeight, bigD, bigHeight, transitionHeight) {
    hull() {

        cylinder(h=bigHeight, d=bigD);

        translate([
            0,
            0,
            bigHeight + transitionHeight
        ])
        cylinder(h=0.001, d=smallD);
    }

    translate([
        0,
        0,
        bigHeight + transitionHeight
    ])
    cylinder(h=smallHeight, d=smallD);
}

module oxygenIntake(oxInnerD, oxOuterD, oxHeight, invert = false) { 
    rotate([
        0,
        90,
        0
    ])
    difference() {
        if (invert == false) {
            cylinder(h=oxHeight, d=oxOuterD);
        }

        
        translate([
            0,
            0,
            -epsilon
        ])
        cylinder(h=oxHeight + epsilon * 2, d=oxInnerD);
    }
}


difference() {
    convertor(
        outputOuterD,
        outputHeight,
        intakeOuterD,
        intakeHeight,
        transitionHeight
    );

    translate([
        0,
        0,
        -epsilon
    ])
    convertor(
        outputInnerD,
        outputHeight + epsilon,
        intakeInnerD,
        intakeHeight + epsilon,
        transitionHeight
    );

    translate([
        outputOuterD/2 -  (intakeOuterD - intakeInnerD),
        0,
        intakeHeight + transitionHeight + oxInnerD / 2 + oxBreakThickness
    ])
    oxygenIntake(oxInnerD, oxOuterD, oxHeight, true);
}


difference() {
    translate([
        0,
        0,
        intakeHeight + transitionHeight
    ])
    cylinder(d=outputInnerD, h=oxBreakThickness);

    translate([
        0,
        0,
        intakeHeight + transitionHeight - epsilon
    ])
    cylinder(d=oxBreakD, h=oxBreakThickness + epsilon * 2);
}

translate([
    outputOuterD/2 -  (intakeOuterD - intakeInnerD) / 2,
    0,
    intakeHeight + transitionHeight + oxInnerD / 2 + oxBreakThickness
])
oxygenIntake(oxInnerD, oxOuterD, oxHeight);