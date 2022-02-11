//seperates the two registered neural folds and calculates the pixel distain from one half to the other

waitForUser("Make sure registered time point image is selected");
setBatchMode(true);

run("Duplicate...", "title=BothNF duplicate");
run("Duplicate...", "title=NF1-Edge duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF1-DM duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-Edge duplicate frames=2");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-DM duplicate frames=2");
selectWindow("NF1-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");
selectWindow("NF2-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");
selectWindow("NF1-DM");
run("Distance Map", "stack");
selectWindow("NF2-DM");
run("Distance Map", "stack");
imageCalculator("Multiply create 32-bit stack", "NF1-Edge","NF2-DM");
selectWindow("NF2-DM");
close();
imageCalculator("Multiply create 32-bit stack", "NF2-Edge","NF1-DM");
selectWindow("NF2-Edge");
close();
selectWindow("NF1-DM");
close();
imageCalculator("Add create 32-bit stack", "Result of NF2-Edge", "NF1-Edge");
setBatchMode(false);
selectWindow("Result of Result of NF2-Edge");