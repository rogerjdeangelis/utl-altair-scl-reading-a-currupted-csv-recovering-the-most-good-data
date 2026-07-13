/* Adapted from utl-altair-scl-reading-a-currupted-csv-recovering-the-most-good-data.sas
   Step 1: count commas in each raw physical line of the corrupted bridge-conditions CSV.
   Original: infile 'd:/csv/2536_bridge_conditions.csv' lrecl=500 missover; input;
             commas=countc(_infile_,',');
   Here the original infile path is replaced by inline DATALINES that reproduce the
   exact corruption the original script is built to detect: several of the CSV's
   quoted text fields wrap across multiple physical lines (a "LAST\nMINOR REHAB"
   header field, a "CURRENT\nBCI" header field, and a 3-line address field
   "COUNTY ROAD 21 UNDERPASS / E of Cty Rod 20 Exit 51 / Dunvegan"), so a naive
   per-physical-line comma count collapses to a handful of commas on those interior
   lines versus ~35/36 on well-formed lines -- exactly the signal the original
   script's PROC FREQ is built to surface. The bare "INPUT;" + "_INFILE_" idiom the
   original script uses to capture a whole raw record is replaced with a named
   $char500. variable (line=) capturing the same raw text, since it exercises the
   identical COUNTC() logic against the same data.
*/

data workx.commas;
  length line $500;
  input line $char500.;
  rec=_n_;
  commas=countc(line,',');
  text=line;
  if commas=0 then putlog commas= text;
  datalines;
ID,STRUCTURE,HWY NAME,LATITUDE,LONGITUDE,CATEGORY,SUBCATEGORY 1,TYPE 1,MATERIAL 1,YEAR BUILT,LAST MAJOR REHAB ,"LAST
MINOR REHAB",# OF SPANS,SPAN DETAILS,DECK LENGTH,WIDTH TOTAL,REGION,County,OPERATION STATUS,OWNER,LAST INSPECTION DATE,"CURRENT
BCI",2013,2012,2011,2010,2009,2008,2007,2006,2005,2004,2003,2002,2001,2000
 1 -  43/,WEST STREET UNDERPASS,403,43.164531,-80.251582,Bridge,Beam/Girder,AASHTO Girder,Prestressed Precast Concrete,1963,2014,2007,4,Total=60.4  (1)=12.2;(2)=18;(3)=18;(4)=12.2;,61,18.4,West,BRANT,Open to traffic,Provincial,04/13/2012,71.5,,71.5,,68.1,,69,,69.4,,69.4,,70.3,73.3,
 1 - 141/1,"HWY. #2 OVERPASS, EBL",403,43.170285,-80.299808,Bridge,Beam/Girder,Plate I Girder,Steel,1965,2013,,4,Total=92  (1)=20;(2)=28;(3)=24;(4)=20;,93.4,15.5,West,BRANT,Open to traffic,Provincial,05/02/2012,69.9,,69.9,,69.2,,69.8,,70,,70,,68,72.4,
Exit 51",417,45.343231,-74.899606,Bridge,Slab,Circular Voided Slab,Post-Tensioned Cast-In-Place Concrete,1973,2012,,2,Total=80  (1)=40;(2)=40;,80.5,10.4,Eastern,STORMONT DUNDAS GLENGARRY,Open to traffic,Provincial,12/19/2012,60.6,,60.6,,60.6,,62.5,,67.6,,63,,62.2,,88.3
31 - 291/,COUNTY ROAD 21 UNDERPASS
E of Cty Rod 20 Exit 51
Dunvegan,417,45.379044,-74.832442,Bridge,Slab,Circular Voided Slab,Post-Tensioned Cast-In-Place Concrete,1973,,,2,Total=74  (1)=37;(2)=37;,76.2,10.4,Eastern,STORMONT DUNDAS GLENGARRY,Open to traffic,Provincial,10/02/2012,78.9,,78.9,,0,,64.1,,64.9,,61.6,,63.7,,88.1
;
run;

proc freq data=workx.commas;
 tables commas;
run;quit;

proc print data=workx.commas;
run;
