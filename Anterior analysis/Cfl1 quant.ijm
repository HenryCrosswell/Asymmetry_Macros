while (nImages != 0){
im_name = getTitle();
run("Duplicate...", "title=q duplicate");
Stack.setChannel(2);
run("Select None");
setTool("rectangle");
waitForUser("create a rectangle that fits inside both NFs - Select the left - THEN click ok");
run("Duplicate...", "title=Left duplicate channels=1");

selectWindow("q");
waitForUser("Move to the right NF - THEN click ok");
run("Duplicate...", "title=Right duplicate channels=1");
waitForUser("prepare to copy value");
run("Set Scale...");
Dialog.create("User inputs");
Dialog.addNumber("Paste here ->", 0.0);
Dialog.show();
SubS = Dialog.getNumber();


run("Images to Stack");
run("Duplicate...", "title=[Stained images] duplicate");
selectWindow("Stack");
run("Make Montage...", "columns=2 rows=1 scale=1");
run("Set Measurements...", "area redirect=None decimal=1");
run("Duplicate...", "title=[Masked montage] duplicate");
run("Threshold...");
waitForUser("Min-error, 15% click apply");
run("Invert LUT");
run("Remove Outliers...", "radius=5 threshold=50 which=Dark");
run("Remove Outliers...", "radius=5 threshold=50 which=Bright");
run("Montage to Stack...", "columns=2 rows=1 border=0");
rename("Masked image");
run("Create Selection");
selectWindow("Stained images");
run("Restore Selection");
waitForUser("does this look representitive of the stained/deleted surface? [ctrl shft - A to remove] [ctrl shft - E to apply]");
width = getWidth();
height = getHeight();
newImage("particles", "8-bit black", width, height, 1);
run("Restore Selection");
fill();
run("Select None");
run("Threshold...");
waitForUser("Apply");
run("Set Scale...", "distance=SubS known=1 unit=micron");
run("Analyze Particles...", "size=25-Infinity show=Masks clear summarize");
selectWindow("Mask of particles");
run("Invert LUT");

run("Create Selection");
selectWindow("Stained images");
run("Restore Selection");
run("Measure");

selectWindow("Mask of particles");
run("Make Inverse");
selectWindow("Stained images");
run("Restore Selection");
run("Measure");

close("particles");
close("Mask of particles");
x = getResult("Area", 0);
x1 = getResult("Area", 1);

selectWindow("Stained images");
run("Next Slice [>]");
selectWindow("Masked image");
run("Next Slice [>]");
run("Create Selection");
selectWindow("Stained images");
run("Restore Selection");
waitForUser("does this look representitive of the stained/deleted surface? [ctrl shft - A to remove] [ctrl shft - E to apply]");

newImage("particles", "8-bit black", width, height, 1);
run("Restore Selection");
fill();
run("Select None");
run("Threshold...");
waitForUser("Apply");
run("Set Scale...", "distance=SubS known=1 unit=micron");
run("Analyze Particles...", "size=25-Infinity show=Masks clear summarize");

selectWindow("Mask of particles");
run("Invert LUT");

run("Create Selection");
selectWindow("Stained images");
run("Restore Selection");
run("Measure");

selectWindow("Mask of particles");
run("Make Inverse");
selectWindow("Stained images");
run("Restore Selection");
run("Measure");
close("particles");
close("Mask of particles");
y = getResult("Area", 0);
y1 = getResult("Area", 1);

close("Stack");
close("Montage");
close("*image*");

close("q");
close("Threshold");
run("Close");
print(im_name);


print("Left stained area:");
print(x);
print("Left deleted area:");
print(x1);
print("Right stained area:");
print(y);
print("Right deleted area:");
print(y1);
print("");

run("Clear Results");
close();

}