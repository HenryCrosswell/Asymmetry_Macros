
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

//duplicate the layers and concatinate the images
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
selectWindow("RightNF");
run("Flip Vertically");
run("Concatenate...", "  title=[Cat image] open image1=LeftNF image2=RightNF");
run("Correct 3D drift");
close("Cat image");
waitForUser("Save this image as 'embryo' - registered time points");

setSlice(nSlices/4);
run("Threshold...");
waitForUser("Apply threshold to image - DO NOT CALCULATE FOR EACH IMAGE");
run("Remove Outliers...", "radius=10 threshold=50 which=Bright stack");
run("Remove Outliers...", "radius=10 threshold=50 which=Dark stack");

run("Duplicate...", "title=Left duplicate frames=1");
waitForUser("select original registered time points image");
run("Duplicate...", "title=Right duplicate frames=2");


//Find overlap and divergent volume
imageCalculator("Subtract create stack", "Left","Right");
selectWindow("Result of Left");
imageCalculator("Subtract create stack", "Right","Left");
selectWindow("Result of Right");

imageCalculator("Add create stack", "Result of Left","Result of Right");
selectWindow("Result of Result of Left");
selectWindow("Result of Right");
close();
selectWindow("Result of Left");
makeRectangle(631, 183, 16, 10);
close();
imageCalculator("AND create stack", "Right","Left");
selectWindow("Result of Right");
rename("CommonVolume");
selectWindow("Result of Result of Left");

rename("Divergent Volume");
run("Merge Channels...", "c1=[Divergent Volume] c2=CommonVolume create");