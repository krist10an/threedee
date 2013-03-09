//Parameters
glassSlotWidth = 3.3;
glassSlotHeight = 20;
glassSlotDepth = 20;
distanceBetweenSlots = glassSlotWidth*2*1.618;

glassNumSlots = 4;


baseHeight = glassSlotWidth*1.618;
baseWidthPadding = glassSlotHeight/1.618;
baseDepthPadding = glassSlotWidth*1.618;

technicalOverlap = 0.01;

//Calculated parameters
totalWidth = 	2*baseWidthPadding + 
					glassNumSlots * glassSlotWidth +
					(glassNumSlots+1)*distanceBetweenSlots;
totalDepth =	glassSlotDepth + baseDepthPadding;
totalHeight = baseHeight + glassSlotHeight;

//Sanity check
echo("Width", totalWidth);
echo("Height", totalHeight);
echo("Depth", totalDepth);

difference() {
	//Make root cube
	cube([totalWidth, totalDepth, totalHeight ]);

	//Subtract slots
	for (i = [1:glassNumSlots]) {
		assign (startx = 	baseWidthPadding + 
								distanceBetweenSlots*(i) + 
								glassSlotWidth*(i-1))
		{
			translate([startx,-technicalOverlap,baseHeight]) {
				cube(	[glassSlotWidth, 
						glassSlotDepth+technicalOverlap, 
						glassSlotHeight+technicalOverlap]);
			}
		}
	}

	//Make nice edges
	translate([	-technicalOverlap,
					-technicalOverlap,
					baseHeight])
	{
		rotate([0,0,0])
		{
			cube([	baseWidthPadding, 
						totalDepth+2*technicalOverlap, 
						glassSlotHeight+technicalOverlap]);
		}
	}

	translate([	+technicalOverlap+totalWidth-baseWidthPadding,
					-technicalOverlap,
					baseHeight])
	{
		rotate([0,0,0])
		{
			cube([	baseWidthPadding, 
						totalDepth+2*technicalOverlap, 
						glassSlotHeight+technicalOverlap]);
		}
	}

	
}


