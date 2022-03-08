i=0
SubS = 1;
Lx = 1;
y = 1;
Rx = getWidth();
SlideCoord = 0
run("Clear Results");
run("Set Measurements...", "mean redirect=None decimal=1");
makeRectangle(Lx, y, Rx, SubS);
run("Measure");
y += SubS;

//bypasses the top lines of black pixels
while (getResult("Mean", nResults-1) == 0) {
	run("Select None");
	y += SubS;
	makeRectangle(Lx, y, Rx, SubS);
	run("Measure");
};
run("Clear Results");
run("Select None");

//extends a rectangle until it reaches a real pixel value
//flips rectangle around and saves to ROI manager
//eventually combines all ROI's into 

while (y < getHeight()-SubS) {
	makeRectangle(Lx, y, SlideCoord+1, SubS);
	run("Measure");
	run("Select None");
	if (getResult("Mean", nResults-1) == 0) {
		run("Select None");
		SlideCoord ++;
		makeRectangle(Lx, y, SlideCoord, SubS);
		run("Clear Results");
		run("Measure");
		if (SlideCoord>Rx) {
			break;
		}
	}else {
		makeRectangle(SlideCoord+1, y, (Rx-SlideCoord-1), SubS);
		roiManager("add");
		y += SubS;
		run("Select None");
		run("Clear Results");
		run("Measure");		
		SlideCoord = 0;
};
};
roiManager("Combine");
roiManager("add");

i=roiManager("count");
roiManager("Select", i-1);
run("Clear Results");
SelectSeq = Array.getSequence(i-1);
roiManager("Select", SelectSeq);
roiManager("Delete");
roiManager("count");
roiManager("select", 0);


