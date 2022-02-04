//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Median...", "radius=7");
run("Find Maxima...")
run("Clear Results");
run("Measure");
print(nResults);
run("Clear Results");