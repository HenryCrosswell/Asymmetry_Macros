
run("Invert LUT");
run("Duplicate...", "title=BothNF duplicate");
run("Duplicate...", "title=NF1 duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2 duplicate frames=2");


selectWindow("BothNF");
run("Duplicate...", "title=NF1-Edge duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-Edge duplicate frames=2");

selectWindow("BothNF");
run("Duplicate...", "title=NF1-DM duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-DM duplicate frames=2");

selectWindow("NF1-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");
selectWindow("NF2-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");

selectWindow("NF1-DM");
run("Distance Transform 3D");
rename("NF1-DM");
selectWindow("NF1-DM");
close();
selectWindow("NF2-DM");
run("Distance Transform 3D");
rename("NF2-DM");
selectWindow("NF2-DM");
close();

imageCalculator("Multiply create 32-bit stack", "NF1","NF1-Edge");
run("Divide...", "value=255 stack");
rename("NF1-pxEdge");
imageCalculator("Multiply create 32-bit stack", "NF2","NF2-Edge");
run("Divide...", "value=255 stack");
rename("NF2-pxEdge");

imageCalculator("Multiply create 32-bit stack", "NF1-pxEdge","NF2-DM");
rename("NF1 edge with NF2 DM");


imageCalculator("Multiply create 32-bit stack", "NF2-pxEdge","NF1-DM");
rename("NF2 edge with NF1 DM")


//sums the two halves together

imageCalculator("Add create 32-bit stack", "NF2 edge with NF1 DM","NF1 edge with NF2 DM");
rename("Result")
selectWindow("NF1-pxEdge");
run("Multiply...", "value=255 stack");
selectWindow("NF2-pxEdge");
run("Multiply...", "value=255 stack");
setBatchMode("exit and display");


