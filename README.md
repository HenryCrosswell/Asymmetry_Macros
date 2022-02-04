# Asymmetry_Macros
Macros for ImageJ - towards the asymmetry project

To develop a heatmap of percentage deviation:
1.	Use SurfaceShaver macro to find the top 20 pixels of the NE surface
2.	On a sum projection of the saved slices of NE, run “Polygon around image_V2” 
3.	Save the ROI
4.	Rotate stack to correct symmetry and duplicate L and R halves relative to ZP
5.	Horizontally invert Right NF and concatenate as 4D image
6.	Correct 3D drift – Save Registered L and R
7.	Binarise stack: Huang, remove outliers with 10-pixel radius bright then dark
8.	Duplicate Left and Right folds named accordingly
9.	Run “FindOverlapAndDivergentVolume”
10.	Reslice from Right
11.	Save Divergent and Overlap
12.	Duplicate Divergent and Overlap named accordingly
13.	Run “DeviationMapFromTesslatedLinesV2”
14.	Save resulting image (values represent percentage diversion)

