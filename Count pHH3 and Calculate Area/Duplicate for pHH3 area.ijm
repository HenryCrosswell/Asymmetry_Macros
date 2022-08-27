
run("Duplicate...", "title=q duplicate");
//run("Rotate 90 Degrees Left");
run("Select None");
setTool("polygon");
waitForUser("create a polygon around the outside of both neural folds - THEN click ok");
run("Clear Outside");
run("Next Slice [>]");
run("Clear Outside");
run("Select None");
setTool("rectangle");
waitForUser("create a rectangle that seperates one of the NF - THEN click ok");

selectWindow("q");
run("Duplicate...", "title=R1 duplicate channels=1");
selectWindow("q");
run("Duplicate...", "title=R2 duplicate channels=3");
selectWindow("q");
run("Make Inverse");
run("Duplicate...", "title=L1 duplicate channels=1");
selectWindow("q");
run("Duplicate...", "title=L2 duplicate channels=3");
selectWindow("q");
close();

wait(20);
selectWindow("R1");
waitForUser("run find maxima macro or find area - select threshold");
close()
selectWindow("R2");
waitForUser("run find maxima macro or find area");
close()
selectWindow("L1");
waitForUser("run find maxima macro or find area");
close()
selectWindow("L2");
waitForUser("run find maxima macro or find area");
close()