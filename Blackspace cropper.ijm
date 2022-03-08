
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

