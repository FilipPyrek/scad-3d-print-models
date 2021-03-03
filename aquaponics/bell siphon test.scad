$fn = 100;
epsilon = 1;

innerD = 10;
outerD = 20;
drainHeight = 20;
intakeHeight = 5;
innerHeight = 20;
outerHeight = 25;
wallTickness = 2;


translate([
    0,
    0,
    wallTickness
])
union() {
    difference() {
        cylinder(h=outerHeight, d=innerD + wallTickness * 2);

        translate([
            0,
            0,
            -epsilon
        ])
        cylinder(h=outerHeight + epsilon * 2, d=innerD);

        translate([
            -innerD / 2 - wallTickness,
            -innerD / 4,
            innerHeight
        ])
        cube([
            innerD + wallTickness * 2,
            innerD / 2,
            outerHeight - innerHeight + epsilon
        ]);
    }

    translate([
        0,
        0,
        -drainHeight - wallTickness
    ])
    difference() {
        cylinder(h=drainHeight, d=innerD + wallTickness * 2);

        translate([
            0,
            0,
            -epsilon
        ])
        cylinder(h=drainHeight + epsilon * 2, d=innerD);
    }

    difference() {
        cylinder(h=outerHeight, d=outerD + wallTickness * 2);

        translate([
            0,
            0,
            -epsilon
        ])
        cylinder(h=outerHeight + epsilon * 2, d=outerD);

        translate([
            -outerD / 4,
            -outerD / 2 - wallTickness,
            -epsilon
        ])
        cube([
            outerD / 2,
            outerD + wallTickness * 2,
            intakeHeight + epsilon
        ]);
    }

    translate([
        0,
        0,
        outerHeight
    ])
    cylinder(h=wallTickness, d=outerD + wallTickness * 2);
}

difference() {
    translate([
        -outerD,
        -outerD,
        0
    ])
    difference() {
        cube([
            outerD * 2,
            outerD * 2,
            outerHeight * 1.5
        ]);

        translate([
            wallTickness,
            wallTickness,
            wallTickness
        ])
        cube([
            outerD * 2 - wallTickness * 2,
            outerD * 2 - wallTickness * 2,
            outerHeight * 1.5 -  - wallTickness
        ]);
        
        
    }
    
    translate([
        0,
        0,
        -epsilon
    ])
    cylinder(d=innerD, h=wallTickness + epsilon * 2);
}