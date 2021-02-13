$fn = 100;
epsilon = 1;

intakeInnerD = 12;
intakeOuterD = 14;
intakeHeight = 10;

transitionHeight = 10;

outputOuterD = 8;
outputInnerD = 6;
outputHeight = 10;

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
}