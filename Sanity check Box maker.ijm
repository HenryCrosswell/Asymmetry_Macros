x=0;
setBatchMode("hide");
newImage("Reference-1", "16-bit black", 512, 512, 1);
run("Specify...", "width=100 height=100 x=100 y=412");
setForegroundColor(255, 255, 255);
run("Fill", "slice");
run("Select None");

while (x<250) {
	x++;
	run("Duplicate...", " ");
	selectWindow("Reference-1");
};
run("Images to Stack");
run("Duplicate...", "title=StackBS duplicate");
run("Convert to Mask", "method=Huang background=Default calculate");
newImage("Reference-2", "16-bit black", 512, 512, 1);
run("Specify...", "width=100 height=100 x=100 y=200");
setForegroundColor(70, 255, 0);
run("Fill", "slice");
run("Select None");
selectWindow("Stack");
run("Convert to Mask", "method=Huang background=Default calculate");
setBatchMode("show");
waitForUser("cancel now if you dont want two time frames");
setBatchMode("hide");
y = 0;
selectWindow("Reference-2");
while (y<250) {
	run("Duplicate...", " ");
	selectWindow("Reference-2");
	y++;
};
run("Images to Stack");
run("Duplicate...", "title=Stack-SS duplicate");
run("Convert to Mask", "method=Huang background=Default calculate");
selectWindow("Stack");
close();

run("Concatenate...", "  title=[Cat image] open image1=StackBS image2=Stack-SS");
selectWindow("Cat image");

setBatchMode("show");

