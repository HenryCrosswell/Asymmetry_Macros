
selectWindow("registered time points");
run("Duplicate...", "title=Left duplicate frames=1");
selectWindow("registered time points");
run("Duplicate...", "title=Right duplicate frames=2");


imageCalculator("Subtract create stack", "Left","Right");
selectWindow("Result of Left");
imageCalculator("Subtract create stack", "Right","Left");
selectWindow("Result of Right");
imageCalculator("Add create stack", "Result of Left","Result of Right");
selectWindow("Result of Result of Left");
selectWindow("Result of Right");
close();
selectWindow("Result of Left");
makeRectangle(631, 183, 16, 10);
close();
imageCalculator("AND create stack", "Right", "Left");
selectWindow("Result of Right");

rename("CommonVolume");
selectWindow("Result of Result of Left");
rename("Divergent Volume");
waitForUser;

run("Merge Channels...", "c1=[Divergent Volume] c2=CommonVolume create");
selectWindow("Left");
close();
selectWindow("Right");
close();