## __Overview__
--------

Custom ImageJ macros, for the quantification of both anterior and posterior neural folds (NFs) in mice.

# Asymmetry_Macros
Disclaimer: These macros are to be used on confocal images, lower resolution could affect read-outs
## Anterior neural fold quantification:
These macros must be used after the anterior NFs have been vertically orientated
- Find Area
    - Finds the total area of a selected embryo
- Find Maxima
    - Used for counting mitotic cells - fluoresce with proliferative antibody before analysis
    - Applys a median filter and finds maxima, to count pHH3 
- Six selections - for both pHH3 and total cell count
    - Make sure not to look at pHH3 layer prior to making selections
    - apply six selections using the macro, then follow instructions
- Area difference
    - selects both NFs individually and measures their areas
- Cfl1 quant
    - select an area that fits within both left-right NF
    - follow macros instructions

## Posterior neural fold quantification
These macros must be used after the posterior NFs have been vertically orientated and surface sliced.

- Deletion quantification
    - Used to measure Vangl2 deletion
    - follow instructions in the macro

- Deviation map
    - Used to measure and visualise the percentage difference between overlapping and divergent volumes
    - Three different methods depending on the images you have.

- Distance map
    - Finds the voxel distances between left and right NFs
    - Two different methods for different image types.

- PNP select and quantification
    - 1-100 selection maker, makes 1% selections across the PNP and measures pixel intensity
    - Macro for outline, scans across the image until it hits a pixel, producing an outline
    - Overall intensity uses the above macro and measures intensity