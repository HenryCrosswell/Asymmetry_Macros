setSlice(nSlices/4);
run("Threshold...");
waitForUser("Apply threshold to image", "Do not caculate threshold for each image, select Huang with Dark Background");
setBatchMode("hide");
run("Remove Outliers...", "radius=10 threshold=50 which=Bright stack");
run("Remove Outliers...", "radius=10 threshold=50 which=Dark stack");

Path = "C:/Users/henry/OneDrive - University College London/Project Work/Image Analysis/Images/Cell shaver/pixel_distance_python/parts/"
og_name = getTitle();
OG_file_name = Path+og_name;

run("Duplicate...", "title=BothNF duplicate");
selectWindow("BothNF");
close("\\Others");
selectWindow("BothNF");
run("Duplicate...", "title=NF1-Edge duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-Edge duplicate frames=2");

selectWindow("NF1-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");
selectWindow("NF2-Edge");
run("Find Edges", "stack");
run("Divide...", "value=255 stack");

selectWindow("BothNF");
run("Duplicate...", "title=NF1 duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2 duplicate frames=2");

imageCalculator("Multiply create 32-bit stack", "NF1","NF1-Edge");
run("Divide...", "value=255 stack");
rename("NF1-pxEdge");
selectWindow("NF1-Edge");
close();
selectWindow("NF1");
close();

imageCalculator("Multiply create 32-bit stack", "NF2","NF2-Edge");
run("Divide...", "value=255 stack");
rename("NF2-pxEdge");
selectWindow("NF2-Edge");
close();
selectWindow("NF2");
close();
setBatchMode("exit and display");
waitForUser("save calculations and bothnf")

//restart macro
setBatchMode("hide");
selectWindow("BothNF");
rename("BothNF");
run("Duplicate...", "title=NF1-DM duplicate frames=1");
selectWindow("BothNF");
run("Duplicate...", "title=NF2-DM duplicate frames=2");

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
setBatchMode("exit and display");

//third

imageCalculator("Multiply create 32-bit stack", "NF1-pxEdge","NF2-DM");
rename("NF1 edge with NF2 DM");
selectWindow("NF2-DM");
close();
selectWindow("NF1-pxEdge");
close();


imageCalculator("Multiply create 32-bit stack", "NF2-pxEdge","NF1-DM");
rename("NF2 edge with NF1 DM");
selectWindow("NF1-DM");
close();
selectWindow("NF2-pxEdge");
close();
//sums the two halves together

imageCalculator("Add create 32-bit stack", "NF2 edge with NF1 DM","NF1 edge with NF2 DM");
rename("Result");
close("\\Others");
selectWindow("Result");
run("Rotate 90 Degrees Left");
run("Z Project...", "projection=[Max Intensity]");
run("Save");
close("*");
setBatchMode(false);
print("done!");