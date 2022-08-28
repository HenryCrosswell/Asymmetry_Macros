
run("Duplicate...", "title=q duplicate");
run("Rotate 90 Degrees Left");
run("Select None");
setTool("polygon");
waitForUser("create a polygon around the outside of both neural folds - THEN click ok");
run("Clear Outside");
run("Select None");
setTool("rectangle");
waitForUser("create a rectangle that seperates one of the NF - THEN click ok");

selectWindow("q");
run("Duplicate...", "title=R1 duplicate channels=2");
selectWindow("q");
run("Make Inverse");
run("Duplicate...", "title=L1 duplicate channels=2");
selectWindow("q");
close();
wait(20);

selectWindow("R1");

run("Enhance Contrast", "saturated=0.35");

run("Threshold...");
wait(7000)
run("Invert LUT");
run("Create Selection");
wait(20);
run("Measure");
print(getResult("Area", 0));
run("Clear Results");
close();

selectWindow("L1");

run("Enhance Contrast", "saturated=0.35");
run("Threshold...");
wait(7000)
run("Invert LUT");
run("Create Selection");
wait(20);
run("Measure");
print(getResult("Area", 0));
run("Clear Results");
close();
