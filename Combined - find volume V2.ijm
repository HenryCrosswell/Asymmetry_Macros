
//Make sure important results and ROI's are saved and cleared
//Z sum project of the shaved NE, creates seperate images to be manipulated
run("Duplicate...", "title=Original duplicate");
selectWindow("Original");
run("Duplicate...", "title=AOriginal duplicate");
run("Z Project...", "projection=[Sum Slices]");
run("Set Measurements...", "area redirect=None decimal=4");


//Selection of Zippering point, returns the value into the next section
setTool("point");
waitForUser("Point selection", "When a Zippering point is selected, Click 'OK'");
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

//In a SUM-projected image oriented ZP on left, tail on right
//This Macro tessallates polygons from the ZP down the image and adds to ROI manager.
By = 0;

setBatchMode(true);
run("Set Measurements...", "mean redirect=None decimal=1");

while(By < getHeight()) {
	By = By+1;
makePolygon(0,ZPY,getWidth(),By,getWidth(),0,0,0);
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
close("ROI Manager");
close("Threshold");
run("Clear Results");

break;
}

}

setBatchMode(false);

selectWindow("Parent");
roiManager("Add");
close();

//Exits with single polygon ROI showing best symmetry.

//Selects that ROI and applies it to stack
roiManager("Select", 0);
close();
selectWindow("AOriginal");
roiManager("Select", 0);

//creates a polygon that obtains the angle at which the image will be rotated
//so that the plane of symmetry is now horizontal
getSelectionCoordinates(xpoints, ypoints);
makeSelection("angle",newArray(xpoints[1],xpoints[0],xpoints[2]), newArray(ypoints[1],ypoints[0],ypoints[0]));
run("Measure");
Poly_angle = getResult("Angle", 0);
selectWindow("AOriginal");
close();


//converts angle into negative int. and rotates the image.
nPoly_angle = 0 - Poly_angle;
selectWindow("Original");
run("Rotate... ", "angle=nPoly_angle grid=1 interpolation=Bilinear enlarge stack");
run("Select None");
run("Clear Results");
selectWindow("Original");


//applies threshold with user adjustability
setBatchMode(false);
setSlice(nSlices/2);
run("Threshold...");
waitForUser("Apply threshold to image");
setBatchMode(true);

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

// assigning variables
TotalLeftArea = 0;
TotalRightArea = 0;

//measure the area of suquential neural folds in the left NF after 
//threshold has been applied, removing any blank splace values
//repeat for right

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
setBatchMode(false);

//sum the areas and times them by the voxel height
//print total volumes for both neural folds 
getVoxelSize(width, height, depth, unit);
print("The Left neural folds' volume is", TotalLeftArea*depth, "micrometres cubed");
print("The Right neural folds' volume is", TotalRightArea*depth, "micrometres cubed");
print("There is a difference of", abs((TotalLeftArea*height)-(TotalRightArea*height)), "micrometres cubed");

//The total volume of both L/R neural folds appear in your Log
//along with the absolute value of one minus the other.