TLx = 0
TLy = 0
TRx = 10
TRy = 0
BLx = 0
BLy = 10
BRx = 10
BRy = 10
i=0


//while (TRx<=getWidth()) {
	if (BRy == getHeight()) {
			break;
	makePolygon(TLx,TLy,TRx,TRy,BRx,BRy,BLx,BLy);
	TLx+=10;
	TRx+=10;
	BRx+=10;
	BLx+=10;
	run("Measure");
	run("Select None");
	if (TRx+1 == getWidth()) {
		TRx = 0;
		TLy+=10;
		TRy+=10;
		BRy+=10;
		BLy+=10;
		BRx = 10;
		BLx = 0;
		TRx = 10;
		TLx = 0;
		}
	}
}
