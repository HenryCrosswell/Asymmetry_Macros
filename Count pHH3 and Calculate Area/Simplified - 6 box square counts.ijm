run("Select None");
Path = "C:/Users/henry/OneDrive - University College London/Project Work/Image Analysis/Images/Cell count simulation/Completed Cell counts/"
og_name_wo_selection = getTitle();
og_name = getTitle() + " Selections";
OG_file_name = Path+og_name;
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
saveAs("Tiff", OG_file_name);
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


window_name = og_name_wo_selection + getTitle();
window_path = Path+window_name;
saveAs("Tiff", window_path);

selectWindow("Selection-2");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


window_name = og_name_wo_selection + getTitle();
window_path = Path+window_name;
saveAs("Tiff", window_path);


selectWindow("Selection-3");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");

window_name = og_name_wo_selection + getTitle();
window_path = Path+window_name;
saveAs("Tiff", window_path);


selectWindow("Selection-4");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");

window_name = og_name_wo_selection + getTitle();
window_path = Path+window_name;
saveAs("Tiff", window_path);



selectWindow("Selection-5");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


window_name = og_name_wo_selection + getTitle();
window_path = Path+window_name;
saveAs("Tiff", window_path);



selectWindow("Selection-6");
run("Maximize");
setTool("multipoint");
waitForUser("First: Click on all the cells in the selection");
run("Measure");
print(nResults);
run("Clear Results");
setSlice(1);
waitForUser("Second: Select pHH3 layer and record in Excel the amount");


window_name = og_name_wo_selection + getTitle();
window_path = Path+window_name;
saveAs("Tiff", window_path);

waitForUser("copy values from log to excel");

run("Close All");
 
roiManager("reset");