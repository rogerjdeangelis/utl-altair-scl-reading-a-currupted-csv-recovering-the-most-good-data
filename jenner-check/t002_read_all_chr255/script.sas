/* Adapted from utl-altair-scl-reading-a-currupted-csv-recovering-the-most-good-data.sas
   Step 2: read every record of the corrupted CSV into fixed $255 character columns so
   no data is lost regardless of which columns a given row's commas actually populate.
   Original:
     data workx.messy;
      infile 'd:/csv/2536_bridge_conditions.csv' delimiter=',' MISSOVER DSD lrecl=384;
      length v1-v39 $255;
      informat v1-v39 $255.;
      input v1-v39;
     run;
   Adapted here to inline DATALINES sampled verbatim from the repo's own
   2536_bridge_conditions.csv (the English header row plus three clean data rows),
   truncated to the first 10 columns (v1-v10) for a compact bundle. The v1-v39
   variable-list RANGE syntax the original uses in LENGTH/INFORMAT/INPUT does not
   currently parse on Jenner (filed as regression tests); worked around here by
   spelling out v1 v2 ... v10 explicitly, which exercises the identical
   DSD/MISSOVER/$255 read logic against the same data.
*/

data workx.messy;
  length v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 $255;
  informat v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 $255.;
  infile datalines dlm=',' dsd missover;
  input v1 v2 v3 v4 v5 v6 v7 v8 v9 v10;
  datalines;
ID,STRUCTURE,HWY NAME,LATITUDE,LONGITUDE,CATEGORY,SUBCATEGORY 1,TYPE 1,MATERIAL 1,YEAR BUILT
 1 -  43/,WEST STREET UNDERPASS,403,43.164531,-80.251582,Bridge,Beam/Girder,AASHTO Girder,Prestressed Precast Concrete,1963
 1 -  44/,NORTH PARK STEET UNDERPASS,403,43.165918,-80.263791,Bridge,Beam/Girder,AASHTO Girder,Prestressed Precast Concrete,1962
 1 -  85/,GURNEY CREEK WHITEMAN BRIDGE,24,43.137489,-80.367297,Bridge,Beam/Girder,Plate I Girder,Steel,2011
;
run;

proc contents data=workx.messy;
run;

proc print data=workx.messy;
run;
