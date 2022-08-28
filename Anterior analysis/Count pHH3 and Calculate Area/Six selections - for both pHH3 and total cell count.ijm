run("Select None");
Stack.setDisplayMode("color");
setSlice(nSlices);
Dialog.create("Rotate?");
Dialog.addCheckbox("Rotate Left?", true);
Dialog.show();
rotate = Dialog.getCheckbox();

if (rotate == true) {
	run("Rotate 90 Degrees Left");
}
run("Maximize");
run("Specify...", "width=40 height=40 x=500 y=256 slice=3 scaled");
waitForUser("make 6 selections starting from the top right of the NF, 3 on each side" );
roiManager("Show All with labels");
run("Select None");
run("Duplicate...", "title=Selection duplicate");

selectWindow("Selection");
roiManager("Select", 0);
run("Duplicate...", "duplicate");
rename("Selection-1");
selectWindow("Selection");
roiManager("Select", 1);
run("Duplicate...", "duplicate");
rename("Selection-2");
selectWindow("Selection");
roiManager("Select", 2);
run("Duplicate...", "duplicate");
rename("Selection-3");
selectWindow("Selection");
roiManager("Select", 3);
run("Duplicate...", "duplicate");
rename("Selection-4");
selectWindow("Selection");
roiManager("Select", 4);
run("Duplicate...", "duplicate");
rename("Selection-5");
selectWindow("Selection");
roiManager("Select", 5);
run("Duplicate...", "duplicate");
rename("Selection-6");

selectWindow("Selection-1");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");

selectWindow("Selection-2");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


selectWindow("Selection-3");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


selectWindow("Selection-4");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


selectWindow("Selection-5");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


selectWindow("Selection-6");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


saveAs("Tiff");

waitForUser("copy values from log to excel");

run("Close All");
 
roiManager("reset");