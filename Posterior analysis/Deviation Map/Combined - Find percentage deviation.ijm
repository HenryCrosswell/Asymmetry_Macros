
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

setBatchMode("exit and display");
setTool("point");
waitForUser("Point selection", "When a Zippering point is selected, Click 'OK'");
setBatchMode(true);

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
setBatchMode("exit and display");
waitForUser;
close("*");
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

//duplicate the layers at midline and concatinates the images
//corrects 3D drift and prompts you to save the resulting image

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

setBatchMode("show");
waitForUser("Save this image as 'embryo' - registered time points");
close("Cat image");
//selects a slice where the image should be visible
//asks for you to apply a threshold to the images and removes the outliers
setBatchMode("show");
setSlice(nSlices/4);
run("Threshold...");
waitForUser("Apply threshold to image", "Do not caculate threshold for each image, select Huang with Dark Background");
setBatchMode("hide");
run("Remove Outliers...", "radius=10 threshold=50 which=Bright stack");
run("Remove Outliers...", "radius=10 threshold=50 which=Dark stack");

//duplicate layers
run("Duplicate...", "title=BothNF duplicate");
run("Duplicate...", "title=Left duplicate frames=1");
selectWindow("BothNF");
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
run("Reslice [/]...", "output=0.590 start=Right");
run("Duplicate...", "title=Divergent duplicate channels=1");
selectWindow("Reslice of Composite");
run("Duplicate...", "title=Overlap duplicate channels=2");
selectWindow("Composite");
close();
selectWindow("Reslice of Composite");
close();
selectWindow("Right");
close();
selectWindow("Left");
close();
selectWindow("BothNF");
close();

//Run with two binarized windows open labelled Divergent and Overlap
setBatchMode("exit and display");
Dialog.create("User inputs");
Dialog.addSlider("Sub-sampling ratio - 1 = Accurate, 10 = fast:", 1, 10, 5);
Dialog.show();
SubS = Dialog.getNumber();
selectWindow("Overlap");
selectWindow("Divergent");
run("Set Measurements...", "mean redirect=None decimal=1");
run("Select All");
run("Duplicate...", "title=Thickness");

XCoord = 0;

for (XCoord = 0; XCoord<getWidth(); 1) {
	makeRectangle(XCoord, 0, SubS, getHeight());
	roiManager("add");
	XCoord = XCoord+SubS;
}

selectWindow("Thickness");
close();

selectWindow("Divergent");
run("Select All");
setSlice(1);
selectWindow("Overlap");
run("Select All");
setSlice(1);

//make new image with width = x, height = slices
selectWindow("Divergent");
run("Select All");
Width = getWidth();
Height = nSlices();
newImage("Result", "8-bit black", Width, Height, 1);
run("Fire");

setSlice(1);
z = 1;
for (z = 1; z<=nSlices; z++) {
	
r = roiManager("count")-1;
for (i=0; i<r; i++) {
	selectWindow("Divergent");
 	roiManager("Select", i);
	run("Measure");
	selectWindow("Overlap");
	run("Restore Selection");
	run("Measure");
DivergentArea = getResult("Mean", 0)+0.0001;
OverlapArea = getResult("Mean", 1)+0.0001;
Divergence = (DivergentArea - OverlapArea)/DivergentArea*100;
run("Clear Results");

XPos = i*SubS;
YPos = getSliceNumber();

selectWindow("Result");
makeRectangle(XPos, YPos, SubS, SubS);
run("Add...", "value=Divergence");

}
	selectWindow("Divergent");
	setSlice(getSliceNumber()+SubS);
	
	selectWindow("Overlap");
	setSlice(getSliceNumber()+SubS);

	z = getSliceNumber()+SubS;

	showProgress(-z/nSlices);
}



selectWindow("Result");



