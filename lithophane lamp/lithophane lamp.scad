/* [Lithophane] */
lithophaneDiameter = 114;
lithophaneMaxThick = 3;
lithophaneBorderThickness = 3;

/* [Cover] */
coverHeight = 20;
coverSphereHeight = 70;
enableCableHole = true;
cableDiameter = 5;

/* [Render] */
renderQuality = 100; // [10:1:360]
$fn = renderQuality;
epsilon = 0+1;
objectsToRender = "top + bottom"; // [top + bottom, top, bottom]

function calcSphereD(lithoD, lithoMaxThick) = lithoD + lithoMaxThick * 2;

module cover(sphereHeight, coverHeight, lithoD, lithoMaxThick, lithoBorderThickness) {
	sphereD = calcSphereD(lithoD, lithoMaxThick);

	difference() {
		resize([
			sphereD,
			sphereD,
			sphereHeight
		])
		sphere(d=sphereD);
		
		translate([
			-sphereD/2,
			-sphereD/2,
			0
		])
		cube([
			sphereD,
			sphereD,
			sphereHeight
		]);

		translate([
			-sphereD/2,
			-sphereD/2,
			-sphereHeight/2 - coverHeight
		])
		cube([
			sphereD,
			sphereD,
			sphereHeight / 2
		]);
		
		translate([
			0,
			0,
			-lithophaneBorderThickness
		])
		cylinder(h=lithophaneBorderThickness + epsilon, d = lithoD);
		
	}
}

module cableHole(coverHeight, lithoD, lithoMaxThick, cableD) {
	sphereD = calcSphereD(lithoD, lithoMaxThick);

	translate([
		0,
		0,
		-coverHeight - epsilon
	])
	cylinder(h=coverHeight + epsilon * 2, d=cableD);
	
	translate([
		0,
		0,
		-coverHeight
	])
	rotate([0,90,0])
	cylinder(h=sphereD/2, d=cableD);
}

module bottomCover(sphereHeight, coverHeight, lithoD, lithoMaxThick, lithoBorderThickness, cableD) {
	difference() {
		cover(sphereHeight, coverHeight, lithoD, lithoMaxThick, lithoBorderThickness);

		if (enableCableHole == true) {
			cableHole(coverHeight, lithoD, lithoMaxThick, cableD);
		}
	}
}

module topCover(sphereHeight, coverHeight, lithoD, lithoMaxThick, lithoBorderThickness) {
	cover(sphereHeight, coverHeight, lithoD, lithoMaxThick, lithoBorderThickness);
}

module renderCovers() {
	sphereD = calcSphereD(lithophaneDiameter, lithophaneMaxThick);

	if (objectsToRender != "bottom")
	bottomCover(coverSphereHeight, coverHeight, lithophaneDiameter, lithophaneMaxThick, lithophaneBorderThickness, cableDiameter);

	if (objectsToRender != "top")
	translate([
		sphereD * 2,
		0,
		0
	])
	topCover(coverSphereHeight, coverHeight, lithophaneDiameter, lithophaneMaxThick, lithophaneBorderThickness);
}


renderCovers();