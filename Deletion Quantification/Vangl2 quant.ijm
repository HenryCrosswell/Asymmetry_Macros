im_name = getTitle();
areadiff = 602;
run("Duplicate...", "title=q duplicate channels=1");
setTool("Polygon");
waitForUser("select PNP");
run("Clear Outside");
run("Crop");
run("Create Mask");

while (areadiff > 600) {
	
selectWindow("Mask");

setTool("Line");
waitForUser("Select midline");
setOption("ShowAngle", true);
run("Measure");
run("Select None");
run("Duplicate...", "title=qangle duplicate");
Poly_angle = getResult("Angle", 0);
//nangle = 0 - Poly_angle;
run("Rotate... ", "angle=Poly_angle grid=1 interpolation=Bilinear enlarge stack");
setTool("Rectangle");
waitForUser("select left half");
run("Clear Results");

run("Set Measurements...", "area mean redirect=None decimal=1");
run("Duplicate...", "title=left");
run("Threshold...");
waitForUser("apply");
run("Create Selection");
run("Measure");
leftarea = getResult("Area", 0);
close();

selectWindow("qangle");
run("Make Inverse");
run("Duplicate...", "title=right");
run("Threshold...");
waitForUser("apply");
run("Create Selection");
run("Measure");
rightarea = getResult("Area", 1);
close(); 

areadiff = (leftarea - rightarea);
abs(areadiff);
if (areadiff > 600){
	print(areadiff);
	print("try again");
	close();
	run("Clear Results");
};

};
selectWindow("qangle");
run("Make Inverse");
print("\\Clear");
run("Clear Results");
print(im_name);
print(leftarea);
print(rightarea);

selectWindow("q");
run("Rotate... ", "angle=Poly_angle grid=1 interpolation=Bilinear enlarge stack");
run("Enhance Contrast", "saturated=0.35");
run("Threshold...");
waitForUser("apply");
run("Remove Outliers...", "radius=5 threshold=50 which=Dark");
run("Remove Outliers...", "radius=5 threshold=50 which=Bright");
selectWindow("qangle");
selectWindow("q");
run("Restore Selection");

run("Set Measurements...", "area mean redirect=None decimal=1");
run("Duplicate...", "title=left");
run("Create Selection");
run("Measure");
leftarea = getResult("Area", 0);
close();

selectWindow("q");
run("Make Inverse");
run("Duplicate...", "title=right");
run("Create Selection");
run("Measure");
rightarea = getResult("Area", 1);
close(); 

print(leftarea);
print(rightarea);
run("Clear Results");