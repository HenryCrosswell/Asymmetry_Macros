run("Duplicate...", "title=Original duplicate");
run("Z Project...", "projection=[Sum Slices]");
rename("Parent");

setTool("point");
waitForUser("Point selection", "When a Zippering point is selected, Click 'OK'");

getSelectionCoordinates(xPoints,yPoints);
ZPY = yPoints[0];


By = 0;

setBatchMode(true);
run("Set Measurements...", "mean redirect=None decimal=1");

while(By < getHeight()) {
	By = By+1;
makePolygon(0,ZPY,getWidth(),By,getWidth(),0,0,0);
roiManager("Add");

}


//Duplicate images to clear inside and outside the polygon

run("Duplicate...", "title=ClearIn");
selectWindow("Parent");
run("Duplicate...", "title=ClearOut");


//Check whether the binarised area outside the polygon is largger than inside in each ROI. 
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
roiManager("select", 0);
getSelectionCoordinates(xpoints, ypoints);
Array.print(ypoints);
run("Select None");
makeLine(0, ypoints[0], getWidth(), ypoints[1]);
run("Measure");
Poly_angle = getResult("Angle", 0);
run("Rotate... ", "angle=Poly_angle grid=1 interpolation=Bilinear enlarge stack");
roiManager("delete");
run("Clear Results");




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
close("\\Others");
setBatchMode("show");
waitForUser("Save this image as 'embryo' - registered time points");

//selects a slice where the image should be visible
//asks for you to apply a threshold to the images and removes the outliers

setSlice(nSlices/4);
run("Threshold...");
waitForUser("Apply threshold to image", "Do not caculate threshold for each image, select Huang with Dark Background");
setBatchMode("hide");
run("Remove Outliers...", "radius=10 threshold=50 which=Bright stack");
run("Remove Outliers...", "radius=10 threshold=50 which=Dark stack");


//seperates the two registered neural folds and calculates the pixel distance from one half to the other


run("Invert LUT");

run("Duplicate...", "title=BothNFBS duplicate");
run("Duplicate...", "title=NF1BS duplicate frames=1");
selectWindow("BothNFBS");
run("Duplicate...", "title=NF2BS duplicate frames=2");

//flips orientation of first NF and Z projects
selectWindow("BothNFBS");
run("Select All");	
getSelectionCoordinates(xpoints, ypoints);
Refx = xpoints[1];
Refy = ypoints[2];
run("Select None");
selectWindow("NF1BS");
run("Duplicate...", "title=NF1Alter duplicate");
run("Flip Vertically");
run("Z Project...", "projection=[Sum Slices]");
rename("NF1-ZProject");
i=0;
SubS = 1;
Lx = 0;
y = 0;
Rx = getWidth();
Commence = false;
run("Clear Results");
run("Set Measurements...", "mean redirect=None decimal=1");
makeRectangle(Lx, y, Rx, SubS);
run("Measure");

//bypasses the top lines of black pixels
while (getResult("Mean", nResults-1) == 0) {
	run("Select None");
	makeRectangle(Lx, y, Rx, SubS);
	y += SubS;
	run("Measure");
	roiManager("add");
	Commence = true;
};	

if (Commence == true) {
	run("Select None");
	i=roiManager("count");
	RoiSeq = Array.sequence(i-1);
	roiManager("Select", RoiSeq);
	roiManager("Combine");
	roiManager("add");
	i=roiManager("count");
	RoiSeq = Array.sequence(i-1);
	roiManager("Select", RoiSeq);
	roiManager("Delete");
	roiManager("Select", 0);

	run("Make Inverse");
	selectWindow("NF1Alter");
	run("Restore Selection");
	run("Crop");
	selectWindow("NF1Alter");
	run("Canvas Size...", "width=Refx height=Refy position=Top-Center zero");		
	roiManager("delete");
};

//repeat for channel2
selectWindow("NF2BS");
run("Select None");
run("Duplicate...", "title=NF2Alter duplicate");
run("Flip Vertically");
run("Z Project...", "projection=[Sum Slices]");
rename("NF2-ZProject");
i=0;
SubS = 1;
Lx = 0;
y = 0;
Rx = getWidth();
Commence = false;
run("Clear Results");
run("Set Measurements...", "mean redirect=None decimal=1");
makeRectangle(Lx, y, Rx, SubS);
run("Measure");

//bypasses the top lines of black pixels
while (getResult("Mean", nResults-1) == 0) {
	run("Select None");
	makeRectangle(Lx, y, Rx, SubS);
	y += SubS;
	run("Measure");
	roiManager("add");
	Commence = true;
};	

if (Commence == true) {
	run("Select None");
	i=roiManager("count");
	RoiSeq = Array.sequence(i-1);
	roiManager("Select", RoiSeq);
	roiManager("Combine");
	roiManager("add");
	i=roiManager("count");
	RoiSeq = Array.sequence(i-1);
	roiManager("Select", RoiSeq);
	roiManager("Delete");
	roiManager("Select", 0);

	run("Make Inverse");
	selectWindow("NF2Alter");
	run("Restore Selection");
	run("Crop");
	run("Canvas Size...", "width=Refx height=Refy position=Top-Center zero");		
	roiManager("delete");
};

run("Concatenate...", "  title=[Main] open image1=NF1Alter image2=NF2Alter");
run("Flip Vertically");
selectWindow("Main");

close("\\Others");
rename("BothNF");
run("Duplicate...", "title=NF1 duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2 duplicate frames=2");


selectWindow("BothNF");
run("Duplicate...", "title=NF1-Edge duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-Edge duplicate frames=2");

selectWindow("BothNF");
run("Duplicate...", "title=NF1-DM duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-DM duplicate frames=2");

selectWindow("NF1-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");
selectWindow("NF2-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");

selectWindow("NF1-DM");
run("Distance Transform 3D");
rename("NF1-DM");
selectWindow("NF1-DM");
close();
selectWindow("NF2-DM");
run("Distance Transform 3D");
rename("NF2-DM");
selectWindow("NF2-DM");
close();

imageCalculator("Multiply create 32-bit stack", "NF1","NF1-Edge");
run("Divide...", "value=255 stack");
rename("NF1-pxEdge");
imageCalculator("Multiply create 32-bit stack", "NF2","NF2-Edge");
run("Divide...", "value=255 stack");
rename("NF2-pxEdge");

imageCalculator("Multiply create 32-bit stack", "NF1-pxEdge","NF2-DM");
rename("NF1 edge with NF2 DM");


imageCalculator("Multiply create 32-bit stack", "NF2-pxEdge","NF1-DM");
rename("NF2 edge with NF1 DM");


//sums the two halves together

imageCalculator("Add create 32-bit stack", "NF2 edge with NF1 DM","NF1 edge with NF2 DM");
rename("Result");
selectWindow("NF1-pxEdge");
run("Multiply...", "value=255 stack");
selectWindow("NF2-pxEdge");
run("Multiply...", "value=255 stack");
setBatchMode("exit and display");
//selectWindow("Result");
//setBatchMode(false);
//run("Rotate 90 Degrees Left");
//run("Z Project...", "projection=[Max Intensity]");

