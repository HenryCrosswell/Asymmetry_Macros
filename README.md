# Asymmetry_Macros
Macros for ImageJ - towards the asymmetry project

To develop a heatmap of percentage deviation:
1.	Use SurfaceShaver macro to find the top 20 pixels of the NE surface - Pre done by Gabe
2. Run "Combined - Find percentage deviation"
3. Click zippering points and accept following pop-ups
4. Save when prompted
5. Binarise stack: Huang - Dark background - Do not calculate for each image
6. Run “DeviationMapFromTesslatedLinesV2”
7.	Save resulting image (values represent percentage diversion)

To count pHH3 and calculate area of NFs
1. run "Duplicate for cell count"
2. Run "find area" or " Find maxima" depending on which image is selected
3. record Data in excel

To calculate 3D Pixel difference
$$$$$$$