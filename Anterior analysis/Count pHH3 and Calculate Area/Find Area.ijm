waitForUser("Apply only on a phalloidin stained embryo, you have 7 seconds to threshold");
run("Enhance Contrast", "saturated=0.35");
run("Threshold...");
wait(7000)
run("Invert LUT");
run("Create Selection");
wait(20);
run("Measure");
print(getResult("Area", 0));
run("Clear Results");

