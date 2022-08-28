//run("Brightness/Contrast...");
//run("Duplicate...", "duplicate channels=2");

//run("Rotate 90 Degrees Left");
run("Set Measurements...", "area redirect=None decimal=1");
run("Enhance Contrast", "saturated=0.35");
run("Median...", "radius=7");
run("Find Maxima...")
run("Clear Results");
run("Measure");
print(nResults);
run("Clear Results");