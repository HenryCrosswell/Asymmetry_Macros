print(getTitle());
x = 0;
y = 0;
run("Set Measurements...", "mean redirect=None decimal=4");
roi_count = 0;
count = 0;


while (y != 1800) {
makeRectangle(x, y, 50, 180);
x += 50 ;
run("Measure");
roiManager("Add");
if (x == 500) {
	x = 0;
	y+=180;
}
count += 1;
if (roi_count == 0){
	colour = "#3cb44b";
	roi_count = 1;
	t1 = getResult("Mean");
}
else if (roi_count == 1){
	colour = "#ffe119";
	roi_count = 2;
	t2 = getResult("Mean");
}
else if (roi_count == 2){
	colour = "#f58231";
	roi_count = 3;
	t3 = getResult("Mean");
}
else if (roi_count == 3){
	colour = "#42d4f4";
	roi_count = 4;
	t4 = getResult("Mean");
}
else if (roi_count == 4){
	colour = "#bfef45";
	roi_count = 5;
	t5 = getResult("Mean");
}
else if (roi_count == 5){
	colour = "#469990";
	roi_count = 6;
	t6 = getResult("Mean");
}
else if (roi_count == 6){
	colour = "#dcbeff";
	roi_count = 7;
	t7 = getResult("Mean");
}
else if (roi_count == 7){
	colour = "#fffac8";
	roi_count = 8;
	t8 = getResult("Mean");
}
else if (roi_count == 8){
	colour = "#808000";
	roi_count = 9;
	t9 = getResult("Mean");
}
else if (roi_count == 9){
	colour = "#aaffc3";
	roi_count = 0;
	t10 = getResult("Mean");
	run("Clear Results");
	IJ.log(t1 + "\t " + t2 + "\t " + t3 + "\t " + t4 + "\t " + t5 + "\t " + t6 + "\t " + t7 + "\t " + t8 + "\t " + t9 + "\t " + t10);
}



roinumber = roiManager("count") - 1;
roiManager("select", roinumber);
roiManager("Set Color", colour);
roiManager("Set Line Width", 7);

}
run("Clear Results");
roiManager("Show All without labels");
roiManager("delete");