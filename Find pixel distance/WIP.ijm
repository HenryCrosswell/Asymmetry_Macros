
//Make sure important results and ROI's are saved and cleared

//Z sum project of the shaved NE, creates seperate images to be manipulated

setBatchMode("hide");
run("Duplicate...", "title=Original duplicate");
selectWindow("Original");
run("Duplicate...", "title=AOriginal duplicate");
run("Z Project...", "projection=[Sum Slices]");
run("Set Measurements...", "area redirect=None decimal=4");



//Selection of Zippering point, returns the value into the next section
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

//In a SUM-projected image oriented ZP on left, tail on right
//This Macro tessallates polygons from the ZP down the image and adds to ROI manager.
By = 0;

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
run("Clear Results");
SelectSeq = Array.getSequence(i+1);
roiManager("Select", SelectSeq);
roiManager("Deselect");
roiManager("Delete");
break;
}

}
selectWindow("Parent");
roiManager("Add");
close();
close("Clear*");
selectWindow("SUM_AOriginal");
close();
//Exits with single polygon ROI showing best symmetry.

//Selects that ROI and applies it to stack
selectWindow("AOriginal");
run("Select None");
roiManager("Select", 0);
close("ROI Manager");

//creates a polygon that obtains the angle at which the image will be rotated
//so that the plane of symmetry is now horizontal
getSelectionCoordinates(xpoints, ypoints);
makeSelection("angle",newArray(xpoints[1],xpoints[0],xpoints[2]), newArray(ypoints[1],ypoints[0],ypoints[0]));
run("Measure");
Poly_angle = getResult("Angle", 0);
selectWindow("AOriginal");
close();
//works

//converts angle into negative int. and rotates the image.
nPoly_angle = 0 - Poly_angle;
selectWindow("Original");
run("Select None");
run("Rotate... ", "angle=nPoly_angle grid=1 interpolation=Bilinear enlarge stack");
run("Select None");
run("Clear Results");

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
selectWindow("Cat image");
run("Correct 3D drift");
close("Cat image");

setBatchMode("show");

waitForUser("Save this image as 'embryo' - registered time points");

setSlice(nSlices/4);
run("Threshold...");
waitForUser("Apply threshold to image - DO NOT CALCULATE FOR EACH IMAGE");
setBatchMode("hide");
run("Remove Outliers...", "radius=10 threshold=50 which=Bright stack");
run("Remove Outliers...", "radius=10 threshold=50 which=Dark stack");


//seperates the two registered neural folds and calculates the pixel distain from one half to the other

run("Invert LUT");
run("Duplicate...", "title=BothNF duplicate");
run("Duplicate...", "title=NF1 duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2 duplicate frames=2");
selectWindow("BothNF");
run("Duplicate...", "title=NF1-Edge duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF1-DM duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-Edge duplicate frames=2");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-DM duplicate frames=2");
selectWindow("NF1-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");
selectWindow("NF2-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");
selectWindow("NF1-DM");
run("Distance Map", "stack");
selectWindow("NF2-DM");
run("Distance Map", "stack");
imageCalculator("Multiply create 32-bit stack", "NF1","NF1-Edge");
run("Divide...", "value=255 stack");
imageCalculator("Multiply create 32-bit stack", "NF2","NF2-Edge");
run("Divide...", "value=255 stack");

imageCalculator("Multiply create 32-bit stack", "Result of NF1","NF2-DM");
selectWindow("NF2-DM");
close();
imageCalculator("Multiply create 32-bit stack", "Result of NF2","NF1-DM");
selectWindow("NF2-Edge");
close();
selectWindow("NF1-DM");
close();
imageCalculator("Add create 32-bit stack", "Result of Result of NF2","Result of Result of NF1");

setBatchMode(false);
selectWindow("Result of Result of Result of NF2");