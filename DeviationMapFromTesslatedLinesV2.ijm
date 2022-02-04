//Run witht wo binarized windows open labeleld Divergent and Overlap
Dialog.create("User inputs");
Dialog.addMessage("Define your parameters here.");
#@ Integer (label="Sub-sampling ratio. 1 = Accurate, 10 = fast", min=1, max=10, value=2) SubS

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

setBatchMode(true);

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



setBatchMode(false);
selectWindow("Result");
