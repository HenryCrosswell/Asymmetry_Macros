
//Make sure important results and ROI's are saved and cleared

//Produces a Z sum project- oriented ZP on left, tail on right - of the shaved NE and creates seperate images to be manipulated

setBatchMode("hide");
run("Duplicate...", "title=Original duplicate"); //Original will be the main target for manipulation
selectWindow("Original");
run("Duplicate...", "title=AOriginal duplicate"); //This image will be used for the rotation calculation
run("Z Project...", "projection=[Sum Slices]");
run("Set Measurements...", "area redirect=None decimal=4");

//Selection of Zippering point, returns the value into the next section
//Makes sure the zippering point was selected

setBatchMode("show");
setTool("point");
waitForUser("Point selection", "When a Zippering point is selected, Click 'OK'");
setBatchMode("hide");

s = selectionType();
if( s == -1 ) {
    exit("There was no selection.");
} if( s != 10 ) {
    exit("The selection wasn't a point selection.");
} else {
    getSelectionCoordinates(xPoints,yPoints);
   ZPY = yPoints[0];
}
setTool("multipoint");
run("Select None");

//This tessallates polygons from the ZP down the image and adds to ROI manager.

counts = 0;
run("Set Measurements...", "mean redirect=None decimal=1");
while(counts < getHeight()) {
	counts = counts+1;
makePolygon(0,ZPY,getWidth(),counts,getWidth(),0,0,0);
roiManager("Add");
}


//Duplicate images to clear inside and outside the polygon

run("Duplicate...", "title=Parent");
run("Duplicate...", "title=ClearIn");
selectWindow("Parent");
run("Duplicate...", "title=ClearOut");


//Check whether the area outside the polygon is larger than inside in each ROI. 
//Stop when outside is smaller

r = roiManager("count");
for (i=0; i<r; i++) {
 	showProgress(i+1, r);
 	roiManager("Select", i);

selectWindow("Parent");
run("Duplicate...", "title=ClearIn");
selectWindow("Parent");
run("Duplicate...", "title=ClearOut");
 	
selectWindow("ClearOut");
run("Clear Outside");
run("Select All");
run("Measure");


selectWindow("ClearIn");
roiManager("Select", i);
run("Clear", "slice");
run("Select All");
run("Measure");

OutArea = getResult("Mean", 0);
InArea = getResult("Mean", 1);

if(OutArea<=InArea) {
run("Clear Results");
selectWindow("ClearIn");
close();
selectWindow("ClearOut");
close();
} else {
selectWindow("ClearIn");
close();
selectWindow("ClearOut");
close();

selectWindow("Parent");
roiManager("Select", i);
run("Clear Results");
SelectSeq = Array.getSequence(i+1);
roiManager("Select", SelectSeq);
roiManager("Deselect");
roiManager("Delete");
break;
}

}

//Adds the single polygon ROI showing best symmetry to ROI manager

selectWindow("Parent");
roiManager("Add");
close();
close("Clear*");
selectWindow("SUM_AOriginal");
close();

//selects the best symmetry ROI and applies it for angle manipulation

selectWindow("AOriginal");
run("Select None");
roiManager("Select", 0);

close("ROI Manager");

//creates a polygon that obtains the angle at which the image will be rotated
//so that the plane of symmetry is now horizontal
//uses the polygon showing the best symmetry

getSelectionCoordinates(xpoints, ypoints);
makeSelection("angle",newArray(xpoints[1],xpoints[0],xpoints[2]), newArray(ypoints[1],ypoints[0],ypoints[0]));
run("Measure");
Poly_angle = getResult("Angle", 0);
selectWindow("AOriginal");
close();

//converts angle into negative int. and rotates the image.

nPoly_angle = 0 - Poly_angle;
selectWindow("Original");
run("Select None");
run("Rotate... ", "angle=nPoly_angle grid=1 interpolation=Bilinear enlarge stack");
run("Select None");
run("Clear Results");


//applies threshold with user adjustability
setBatchMode("show");
setSlice(nSlices/2);
run("Threshold...");
waitForUser("Apply threshold to image", "Do not caculate threshold for each image, select Huang with Dark Background");
setBatchMode("hide");

//Duplicate images at midline to seperate neural folds
close("ROI Manager");
selectWindow("Original");
makeRectangle(0, 0, getWidth(), (getHeight()/2));
roiManager("Add");
run("Duplicate...", "title=LeftNF duplicate");
selectWindow("Original");
run("Make Inverse");
run("Duplicate...", "title=RightNF duplicate");
close("ROI Manager");
selectWindow("Original");
close();

//Invert Lut to allow for quick selection of folds, find the maximum area of the window
//so that we do not include full-window selections
run("Set Measurements...", "area redirect=None decimal=4");
selectWindow("LeftNF");
run("Invert LUT");
makeRectangle(0, 0, getWidth(), getHeight());
run("Measure");
Max_Area = getResult("Area", 0);
run("Select None");
run("Clear Results");
run("Set Measurements...", "area redirect=None decimal=4");

//measure the area of suquential neural folds in the left NF after 
//threshold has been applied, removing any blank splace values
//repeat for right
TotalLeftArea = 0;
TotalRightArea = 0;

for (n=1; n<=nSlices;n++){
	setSlice(n);
	run("Create Selection");
	run("Measure");
	run("Select None");
	Area = getResult("Area", nResults-1);
	if(Area >= Max_Area-10){
		IJ.deleteRows(nResults-1, nResults-1);
		continue
	} else {
		TotalLeftArea += Area;
		continue
	}
}
close();
run("Clear Results");

selectWindow("RightNF");
run("Invert LUT");
run("Set Measurements...", "area redirect=None decimal=4");
for (n=1; n<=nSlices;n++){
	setSlice(n);
	run("Create Selection");
	run("Measure");
	run("Select None");
	Area = getResult("Area", nResults-1);
	if(Area >= Max_Area-10){
		IJ.deleteRows(nResults-1, nResults-1);
		continue
	} else {
		TotalRightArea += Area;
		continue
	}
}
close();
run("Clear Results");
setBatchMode("exit and display");

//sum the areas and times them by the voxel height
//print total volumes for both neural folds 
getVoxelSize(width, height, depth, unit);
print("The Left neural folds' volume is", TotalLeftArea*depth, "micrometres cubed");
print("The Right neural folds' volume is", TotalRightArea*depth, "micrometres cubed");
print("There is a difference of", abs((TotalLeftArea*height)-(TotalRightArea*height)), "micrometres cubed");

//The total volume of both L/R neural folds appear in your Log
//along with the absolute value of one minus the other.