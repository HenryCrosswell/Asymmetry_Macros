# Asymmetry_Macros
Macros for ImageJ - towards the asymmetry project

To count pHH3 and calculate area of NFs
1. open all three macros in this folder
2. run "Duplicate for cell count"
3. Run "find area" or " Find maxima" depending on which image is selected
4. For area the entirety of the embryo should be selected, for pHH3 just the NE should be selected
5. make sure the find maxima value is custom to each NF but still consistent between NF halves
6. record Data in excel

To calculate the volume of each NF 
1. run "Combined - volume V2"

To count individual selections pHH3 counts to calculate total cell counts in the future
1. Duplicate embryo, rename - q - and turn off layer with pHH3 cells
2. specify a selection box - 100x100
3. save the ROI, move the box to a different area, save the ROI once again
4. Repeat util you have 5 seperate, random ROI's
5. run - duplication for square counts
6. count individual cells with multi-point tool
7. turn on pHH3 layer and count mitosing cells
8. record data in excel

To develop a heatmap of percentage deviation:
1. Run "Combined - Find percentage deviation" on a shaved neural fold image
2. when this macro finishes, run deviation map from tesslated linesV2
2. Save resulting image (values represent percentage diversion)

To calculate difference in 3D pixel distance
1. Run - Combined Pixel Distance on a shaved neural fold image
2. ??????? extract values?
