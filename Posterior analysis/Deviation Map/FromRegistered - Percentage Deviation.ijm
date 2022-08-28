//selects a slice where the image should be visible
//asks for you to apply a threshold to the images and removes the outliers
setBatchMode("show");
setSlice(nSlices/4);
run("Threshold...");
waitForUser("Apply threshold to image", "Do not caculate threshold for each image, select Huang with Dark Background");
setBatchMode("hide");
run("Remove Outliers...", "radius=10 threshold=50 which=Bright stack");
run("Remove Outliers...", "radius=10 threshold=50 which=Dark stack");
setBatchMode("hide");
Path = "C:/Users/henry/OneDrive - University College London/Project Work/Image Analysis/Images/Cell shaver/deviation_map_python/"
og_name = getTitle();
OG_file_name = Path+og_name;


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
YHeight = getHeight();
for (XCoord = 0; XCoord<getWidth(); 1) {
	makeRectangle(XCoord, 0, SubS, YHeight);
	roiManager("add");
	XCoord += SubS;
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
run("Tile");

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



roiManager("reset");
selectWindow("Result");
run("Select None");
saveAs("Tiff", OG_file_name);
close("*");



