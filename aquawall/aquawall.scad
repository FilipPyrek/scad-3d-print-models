/* [Wall] */
wallWidth = 160;
wallHeight = 160;

/* [Wall parts] */
wallPartWidth = 160;
assert(wallPartWidth > 0 && wallPartWidth <= wallWidth);
wallPartHeight = 160;
assert(wallPartHeight > 0 && wallPartHeight <= wallHeight);
wallPartThickness = 5;
assert(wallPartThickness > 0);

/* [Plant box] */
plantBoxWidth = 40;
plantBoxHeight = 20;
plantBoxDepth = 15;
plantBoxWallThickness = 2;

/* Edges  */
edgePartSize = [
	wallWidth - floor(wallWidth/wallPartWidth) * wallPartWidth,
	wallHeight - floor(wallHeight/wallPartHeight) * wallPartHeight,
	wallPartThickness
];

/* [Hooks] */
edgeNumberOfXHooks = wallPartWidth/edgePartSize[0] > 4 ? 1 : (wallPartWidth/edgePartSize[0] > 2 ? 2 : 3);
edgeNumberOfYHooks = wallPartHeight/edgePartSize[1] > 4 ? 1 : (wallPartHeight/edgePartSize[1] > 2 ? 2 : 3);


hookWidth = 4;
assert(hookWidth > 0 && hookWidth < wallPartWidth/4 && hookWidth < wallPartHeight/4);
hookHeight = 4;
assert(hookHeight > 0);
hookThickness = 2;
assert(hookThickness < wallPartThickness);
hookFitSpacingRate = 1.25;
hookWallSpacingRate = 0.925;
assert(
	hookThickness * hookFitSpacingRate < wallPartThickness &&
	hookWidth * hookFitSpacingRate < wallPartWidth/(edgeNumberOfXHooks + 1) &&
	hookHeight * hookFitSpacingRate < wallPartHeight/(edgeNumberOfXHooks + 1)
);
wallPartNumberOfXHooks = 3;
assert(wallPartNumberOfXHooks > 0);
wallPartNumberOfYHooks = 3;
assert(wallPartNumberOfYHooks > 0);


/* [Edges] */
assert(edgePartSize[0] == 0 || (edgePartSize[0] > hookWidth && edgePartSize[0] > hookHeight));
assert(edgePartSize[1] == 0 || (edgePartSize[1] > hookWidth && edgePartSize[1] > hookHeight));

// Spacing between wall parts
wallPartSpacing = hookHeight * 2;
assert(hookHeight < wallPartSpacing);


for (yIndex = [0:floor(wallHeight/wallPartHeight) - 1]) {
	for(xIndex = [0:floor(wallWidth/wallPartWidth) - 1]) {
		translate([
			xIndex * (wallPartWidth + wallPartSpacing),
			yIndex * (wallPartHeight + wallPartSpacing),
			0
		])
		union() {
			difference() {
				// Wall part
				cube([
					wallPartWidth,
					wallPartHeight,
					wallPartThickness
				]);
				
				/* Inner Hook */
				// Hook X
				for (hookIndex = [1:wallPartNumberOfXHooks]) {
					translate([
						wallPartWidth / (wallPartNumberOfXHooks + 1) * hookIndex - (hookWidth * hookFitSpacingRate) / 2,
						wallPartHeight - hookHeight * hookWallSpacingRate,
						wallPartThickness/2 - (hookThickness*hookFitSpacingRate) / 2
					])
					scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
					union() {
						cube([
							hookWidth,
							hookHeight,
							hookThickness
						]);
						cube([
							hookWidth * 1.5,
							hookHeight/2,
							hookThickness
						]);
					}
				}
				// Hook Y
				for (hookIndex = [1:wallPartNumberOfYHooks]) {
					translate([
						hookHeight * hookWallSpacingRate,
						wallPartHeight / (wallPartNumberOfYHooks + 1) * hookIndex - (hookWidth * hookFitSpacingRate)/2,
						wallPartThickness/2 - (hookThickness * hookFitSpacingRate) / 2
					])
					scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
					rotate(90)
					union() {
						cube([
							hookWidth,
							hookHeight,
							hookThickness
						]);
						cube([
							hookWidth * 1.5,
							hookHeight/2,
							hookThickness
						]);
					}
				}
				
			}
			
			/* Outer Hook */
			// Hook X
			for (hookIndex = [1:wallPartNumberOfXHooks]) {
				translate([
					wallPartWidth / (wallPartNumberOfXHooks + 1) * hookIndex,
					-hookHeight,
					wallPartThickness/2 - hookThickness / 2
				])
				union() {
					cube([
						hookWidth/2,
						hookHeight,
						hookThickness
					]);
					cube([
						hookWidth,
						hookHeight/2,
						hookThickness
					]);
				}
			}
			// Hook Y
			for (hookIndex = [1:wallPartNumberOfYHooks]) {
				translate([
					wallPartWidth + hookHeight,
					wallPartHeight / (wallPartNumberOfYHooks + 1) * hookIndex,
					wallPartThickness/2 - hookThickness / 2
				])
				rotate(90)
				union() {
					cube([
						hookWidth/2,
						hookHeight,
						hookThickness
					]);
					cube([
						hookWidth,
						hookHeight/2,
						hookThickness
					]);
				}
			}
			
			// Plant Boxes
			yBoxesCount = floor(wallPartHeight / plantBoxHeight);
			xBoxesCount = floor(wallPartWidth / (plantBoxWidth * 2));
			for(rowBoxIndex = [0:yBoxesCount - 1]) {
				for(columnBoxIndex = [0:xBoxesCount - 1]) {
					xSpace = (wallPartWidth - plantBoxWidth * (xBoxesCount * 2)) / (xBoxesCount * 2);
					ySpace = (wallPartHeight - plantBoxHeight * yBoxesCount) / yBoxesCount;

					translate([
						(plantBoxWidth + xSpace) * columnBoxIndex * 2 + (rowBoxIndex % 2 == 0 ? plantBoxWidth + xSpace: 0) + xSpace/2 ,
						(plantBoxHeight + ySpace) * rowBoxIndex + ySpace/2,
						wallPartThickness
					])
					difference() {
//						cube([
//							plantBoxWidth,
//							plantBoxHeight,
//							plantBoxDepth
//						]);
						
						faces = [
						  [0,1,2,3],  // bottom
						  [4,5,1,0],  // front
						  [7,6,5,4],  // top
						  [5,6,2,1],  // right
						  [6,7,3,2],  // back
						  [7,4,0,3]
						 ];

						polyhedron(
							points=[
							  [0, 0, 0],
							  [plantBoxWidth, 0, 0],
							  [plantBoxWidth, plantBoxHeight, 0],
							  [0, plantBoxHeight, 0],
							  [0, 0, plantBoxDepth],
							  [plantBoxWidth, 0, plantBoxDepth],
							  [plantBoxWidth, 0, plantBoxDepth],
							  [0, 0, plantBoxDepth]
							],
							faces=faces
						);
						
						phW = plantBoxWidth - plantBoxWallThickness * 2;
						translate([
							plantBoxWallThickness,
							-plantBoxWallThickness,
							-plantBoxWallThickness
						])
						polyhedron(
							points=[
							  [0, 0, 0],
							  [phW, 0, 0],
							  [phW, plantBoxHeight, 0],
							  [0, plantBoxHeight, 0],
							  [0, 0, plantBoxDepth],
							  [phW, 0, plantBoxDepth],
							  [phW, 0, plantBoxDepth],
							  [0, 0, plantBoxDepth]
							],
							faces=faces
						);
						
//						translate([
//							plantBoxWallThickness,
//							0,
//							0
//						])
//						cube([
//							plantBoxWidth - plantBoxWallThickness * 2,
//							plantBoxHeight - plantBoxWallThickness * 2,
//							plantBoxDepth - plantBoxWallThickness
//						]);
						
						
					}
				}
			}
		}
	}
}

// Edge Parts Y
if (wallWidth % wallPartWidth != 0) {
	for (yIndex = [0:floor(wallHeight/wallPartHeight) - 1]) {
		partSize = [
			wallWidth - floor(wallWidth/wallPartWidth) * wallPartWidth,
			wallPartHeight,
			wallPartThickness
		];
		
		translate([-wallPartWidth,0,0])
		union() {
			difference() {
				translate([
					0,
					yIndex * (wallPartHeight + wallPartSpacing),
					0
				])
				cube(partSize);
				
				// Inner hook for wall parts
				for (hookIndex = [1:wallPartNumberOfYHooks]) {
					translate([
						hookHeight * hookWallSpacingRate,
						(wallPartHeight + wallPartSpacing) * yIndex + wallPartHeight / (wallPartNumberOfYHooks + 1) * hookIndex - (hookWidth * hookFitSpacingRate)/2,
						wallPartThickness/2 - (hookThickness * hookFitSpacingRate) / 2
					])
					scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
					rotate(90)
					union() {
						cube([
							hookWidth,
							hookHeight,
							hookThickness
						]);
						cube([
							hookWidth * 1.5,
							hookHeight/2,
							hookThickness
						]);
					}
				}
				
				// inner hook for edge part
				for (hookIndex = [1:edgeNumberOfXHooks]) {
					translate([
						partSize[0] / (edgeNumberOfXHooks + 1) * hookIndex - (hookWidth * hookFitSpacingRate) / 2,
						partSize[1] - hookHeight * hookWallSpacingRate,
						wallPartThickness/2 - (hookThickness*hookFitSpacingRate) / 2
					])
					scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
					union() {
						cube([
							hookWidth,
							hookHeight,
							hookThickness
						]);
						cube([
							hookWidth * 1.5,
							hookHeight/2,
							hookThickness
						]);
					}
				}
			}
			
			// Outer hook
			for (hookIndex = [1:edgeNumberOfXHooks]) {
				translate([
					partSize[0] / (edgeNumberOfXHooks + 1) * hookIndex,
					yIndex * (wallPartHeight + wallPartSpacing) + (-hookHeight),
					wallPartThickness/2 - hookThickness / 2
				])
				union() {
					cube([
						hookWidth/2,
						hookHeight,
						hookThickness
					]);
					cube([
						hookWidth,
						hookHeight/2,
						hookThickness
					]);
				}
			}
		}
	}
}

// Edge Parts X
if (wallHeight % wallPartHeight != 0) {
	for (xIndex = [0:floor(wallWidth/wallPartWidth) - 1]) {
		partSize = [
			wallPartWidth,
			wallHeight - floor(wallHeight/wallPartHeight) * wallPartHeight,
			wallPartThickness
		];
		
		translate([0,-wallPartHeight,0])
		union() {
			difference() {
				translate([
					xIndex * (wallPartWidth + wallPartSpacing),
					0,
					0
				])
				cube(partSize);

				// Inner hook X
				for (hookIndex = [1:wallPartNumberOfXHooks]) {
					translate([
						wallPartWidth / (wallPartNumberOfXHooks + 1) * hookIndex - hookWidth / 2 + xIndex * (wallPartWidth + wallPartSpacing),
						wallHeight - floor(wallHeight/wallPartHeight) * wallPartHeight - hookHeight * hookWallSpacingRate,
						wallPartThickness/2 - (hookThickness*hookFitSpacingRate) / 2
					])
					scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
					union() {
						cube([
							hookWidth,
							hookHeight,
							hookThickness
						]);
						cube([
							hookWidth * 1.5,
							hookHeight/2,
							hookThickness
						]);
					}
				}
				
				// Inner hook Y
				for (hookIndex = [1:edgeNumberOfYHooks]) {
					translate([
						(partSize[0] + wallPartSpacing) * xIndex + hookHeight * hookWallSpacingRate,
						partSize[1] / (edgeNumberOfYHooks + 1) * hookIndex - (hookWidth * hookFitSpacingRate)/2,
						wallPartThickness/2 - (hookThickness * hookFitSpacingRate) / 2
					])
					scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
					rotate(90)
					union() {
						cube([
							hookWidth,
							hookHeight,
							hookThickness
						]);
						cube([
							hookWidth * 1.5,
							hookHeight/2,
							hookThickness
						]);
					}
				}
			}
		
			// Outer hook X
			for (hookIndex = [1:edgeNumberOfYHooks]) {
				translate([
					(partSize[0] + wallPartSpacing) * xIndex + partSize[0] + hookHeight,
					partSize[1] / (edgeNumberOfYHooks + 1) * hookIndex,
					wallPartThickness/2 - hookThickness / 2
				])
				rotate(90)
				union() {
					cube([
						hookWidth/2,
						hookHeight,
						hookThickness
					]);
					cube([
						hookWidth,
						hookHeight/2,
						hookThickness
					]);
				}
			}
		}
	}
}

// Edge Part
if (wallHeight % wallPartHeight != 0 && wallWidth % wallPartWidth != 0) {
	
	translate([-wallPartWidth,-wallPartHeight,0])
	difference() {
		translate([
			0,
			0,
			0
		])
		cube(edgePartSize);

		// Inner Hook X
		if (wallWidth % wallPartWidth != 0) {
			for (hookIndex = [1:edgeNumberOfXHooks]) {
				translate([
					edgePartSize[0] / (edgeNumberOfXHooks + 1) * hookIndex - (hookWidth * hookFitSpacingRate) / 2,
					edgePartSize[1] - hookHeight * hookWallSpacingRate,
					wallPartThickness/2 - (hookThickness*hookFitSpacingRate) / 2
				])
				scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
				union() {
					cube([
						hookWidth,
						hookHeight,
						hookThickness
					]);
					cube([
						hookWidth * 1.5,
						hookHeight/2,
						hookThickness
					]);
				}
			}
		}
		// Inner Hook Y
		if (wallHeight % wallPartHeight != 0) {
			for (hookIndex = [1:edgeNumberOfYHooks]) {
				translate([
					hookHeight * hookWallSpacingRate,
					edgePartSize[1] / (edgeNumberOfYHooks + 1) * hookIndex - (hookWidth * hookFitSpacingRate) / 2,
					wallPartThickness/2 - (hookThickness*hookFitSpacingRate) / 2
				])
				scale([hookFitSpacingRate,hookFitSpacingRate,hookFitSpacingRate])
				rotate(90)
				union() {
					cube([
						hookWidth,
						hookHeight,
						hookThickness
					]);
					cube([
						hookWidth * 1.5,
						hookHeight/2,
						hookThickness
					]);
				}
			}
		}
	}
}

/*

TODO:
- okrajove dily dodelat
- sloty na rostliny

*/
