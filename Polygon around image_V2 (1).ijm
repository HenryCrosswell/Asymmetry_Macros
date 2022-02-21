
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
roiManager("Select", 0);