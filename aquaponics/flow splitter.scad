$fn = 100;
epsilon = 1;

inputOuterD = 8;
inputInnerD = 6;
inputHeight = 10;

outputAOuterD = 8;
outputAInnerD = 3;
outputAHeight = 10;
outputAAngle = 45;

outputBOuterD = 8;
outputBInnerD = 6;
outputBHeight = 10;
outputBAngle = 45;

module outputB(inner = false, socket = false) {
    translate([
        -cos(outputBAngle) * (outputBOuterD/2),
        0,
        inputOuterD
    ])
    rotate([
        0,
        -outputBAngle,
        0
    ])
    cylinder(d=inner == true ? outputBInnerD : outputBOuterD, h = socket == true ? 1 : outputBHeight +  (inner == true ? epsilon : 0));
} 

module outputA(inner = false, socket = false) {
    translate([
        cos(outputAAngle) * (outputAOuterD/2),
        0,
        inputOuterD
    ])
    rotate([
        0,
        outputAAngle,
        0
    ])
    cylinder(d=inner == true ? outputAInnerD : outputAOuterD, h = socket == true ? 1 : outputAHeight + (inner == true ? epsilon : 0));
}

module input(inner = false, socket = false) {
    translate([
        0,
        0,
        socket == true ? 0 : -inputHeight - (inner == true ? epsilon : 0)
    ])
    cylinder(d=inner == true ? inputInnerD : inputOuterD, h = socket == true ? 1 : inputHeight + (inner == true ? epsilon * 2 : 0));
}

module body(inner = false) {
    hull() {
        input(inner, true);

        outputA(inner, true);
        outputB(inner, true);
    }
}

module branches(inner = false) {
    input(inner);
    outputA(inner);
    outputB(inner);
}


difference() {
    union() {
        body();
        branches();
    }

    body(true);
    branches(true);
}
