while (nImages != 0) {

im_name  = getTitle();
run("Duplicate...", "title=Og duplicate");
run("Grays");
setTool("Angle");
waitForUser("rotate around the mid point");
run("Clear Results");
run("Measure");
Poly_angle = getResult("Angle", 0);
nPoly_angle = 0 - Poly_angle;
run("Select None");
run("Rotate... ", "angle=Poly_angle grid=1 interpolation=Bilinear enlarge stack");
run("Maximize");
run("Clear Results");
setTool("Polygon");
run("Next Slice [>]");
run("Enhance Contrast", "saturated=0.35");
waitForUser("Select PNP");
run("Set Measurements...", "area redirect=None decimal=1");
run("Measure");
resetMinAndMax();
run("Clear Outside");
run("Select None");
run("Previous Slice [<]");
run("Threshold...");
waitForUser;
run("Remove Outliers...", "radius=5 threshold=50 which=Bright stack");
run("Remove Outliers...", "radius=5 threshold=50 which=Dark stack");

setTool("Rectangle");
waitForUser("seperate halves");

run("Duplicate...", "title=left duplicate");
run("Create Selection");
run("Make Inverse");
waitForUser;
run("Measure");
close();

selectWindow("Og");
run("Make Inverse");
run("Duplicate...", "title=right duplicate");

run("Create Selection");
run("Make Inverse");
waitForUser;
run("Measure");
close();
close();
close();

total = getResult("Area", 0);
x = getResult("Area", 1);
y = getResult("Area", 2);
print(im_name);

print("Total stained area:");
print(total);
print("Left stained area:");
print(total - x);
print("Right stained area:");
print(total - y);
run("Clear Results");
}