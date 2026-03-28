%let pgm=utl-altair-scl-reading-a-currupted-csv-recovering-the-most-good-data;

%stop_submission;

Altair scl reading a currupted csv recovering the most good data

Too long to post on a list. see github
https://github.com/rogerjdeangelis/utl-altair-scl-reading-a-currupted-csv-recovering-the-most-good-data

Altair community post
https://community.altair.com/discussion/52461/i-cannot-read-the-data-correctly-help?tab=all

The best way to read this messy csv is to put the data into max number of character columns(#commas+1)
where each column has length 255 and fill any of the missing trailing commas fields with missing values.
Post process to optimize lengths and deciding which columns are numeric.

 CONTENTS

    1 Count commas in each record
    2 read all records chr255
    3 optimize lengths

SOAPBOX ON
  Not a fan of CSV files, see github
  https://github.com/rogerjdeangelis/utl_flatfile
SOAPBOX OFF

/*                         _
/ |   ___ ___  _   _ _ __ | |_    ___ ___  _ __ ___  _ __ ___   __ _ ___
| |  / __/ _ \| | | | `_ \| __|  / __/ _ \| `_ ` _ \| `_ ` _ \ / _` / __|
| | | (_| (_) | |_| | | | | |_  | (_| (_) | | | | | | | | | | | (_| \__ \
|_|  \___\___/ \__,_|_| |_|\__|  \___\___/|_| |_| |_|_| |_| |_|\__,_|___/
*/

/*--- SINCE THE MUXIMUM NUMBER OF COMMAS IS 381, WE WILL READ 39 FIELDS ----/

options ps=64;
data workx.commas;
  infile "d:/csv/2536_bridge_conditions.csv" lrecl=500 missover;
  input;
  rec=_n_;
  commas=countc(_infile_,',');
  text=_infile_;
  if commas=0 then putlog commas= text;
run;

proc freq data=workx.commas;
 tables commas;
run;quit;

/**************************************************************************************************************************/
/*  WORKX.COMMAS TOTAL OBS=2,872                                                                                          */
/*                                                                                                                        */
/*  REC    COMMAS                                                                                                         */
/*                                                                                                                        */
/*    1      35     ,,RENSEIGNMENTS SUR L'EMPLACEMENT,,,RENSEIGNMENTS SUR LA STRUCTURE,,,,,,,,,  ...                      */
/*    2      35     ,,LOCATION INFORMATION,,,STRUCTURE INFORMATION,,,,,,,,,,,ADMINISTRATIVE INF  ...                      */
/*    3      35     ID,STRUCTURE,NOM DE LA ROUTE,LATITUDE,LONGITUDE,CATÉGORIE,SOUS-CATÉGORIE 1,  ...                      */
/*    4      11     ID,STRUCTURE,HWY NAME,LATITUDE,LONGITUDE,CATEGORY,SUBCATEGORY 1,TYPE 1,MATE  ...                      */
/*    5      10     MINOR REHAB",# OF SPANS,SPAN DETAILS,DECK LENGTH,WIDTH TOTAL,REGION,County,  ...                      */
/*    7      35     BCI",2013,2012,2011,2010,2009,2008,2007,2006,2005,2004,2003,2002,2001,2000   ...                      */
/*    8      35      1 -  32/,Highway 24 Underpass at Highway 403,403,43.167233,-80.275567,Brid  ...                      */
/*    9      35      1 -  43/,WEST STREET UNDERPASS,403,43.164531,-80.251582,Bridge,Beam/Girder  ...                      */
/*   10      35      1 -  44/,NORTH PARK STEET UNDERPASS,403,43.165918,-80.263791,Bridge,Beam/G  ...                      */
/* ...                                                                                                                    */
/* 2868      36    2868 49 -  37/,Manitou River Bridge in Sandfield,542,45.70309,-81.99843,Brid  ...                      */
/* 2869      36    2869 49 -  38/,McLelland Creek,6,45.68897,-81.85603,Bridge,Frame,"Rigid Fram  ...                      */
/* 2870      36    2870 49 -  50/,Mindemoya Creek Bridge,542,45.73237,-82.15656,Bridge,Frame,"R  ...                      */
/* 2871      36    2871 49 -  51/,Mindemoya Creek Bridge,551,45.73352,-82.16723,Bridge,Frame,"R  ...                      */
/* 2872      36    2872 49 -  73/,Kagawong Creek Tributary Bridge,540,45.90007,-82.26313,Bridge  ...                      */
/*                                                                                                                        */
/*                                                                                                                        */
/* FREQUENCY ANALYSIS                                                                                                     */
/*                                                                                                                        */
/* commas    Frequency     Percent     Frequency      Percent                                                             */
/* -----------------------------------------------------------                                                            */
/*      0           3        0.10             3         0.10                                                              */
/*      1          59        2.05            62         2.16                                                              */
/*      2           2        0.07            64         2.23                                                              */
/*     10           1        0.03            65         2.26                                                              */
/*     11           1        0.03            66         2.30                                                              */
/*     14           1        0.03            67         2.33                                                              */
/*     34          40        1.39           107         3.73                                                              */
/*     35        2074       72.21          2181        75.94                                                              */
/*     36         598       20.82          2779        96.76                                                              */
/*     37          80        2.79          2859        99.55                                                              */
/*     38          13        0.45          2872       100.00  max commas (39 posible data items)                          */
/*                                                                                                                        */
/*                                                                                                                        */
/* RECORDS WITHOUT AT LEAST ONE COMMA                                                                                     */
/*                                                                                                                        */
/* commas=0 E of Cty Rod 20 Exit 51                                                                                       */
/* commas=0 401                                                                                                           */
/* commas=0                                                                                                               */
/**************************************************************************************************************************/

/*                     _     _
  ___ ___  _   _ _ __ | |_  | | ___   __ _
 / __/ _ \| | | | `_ \| __| | |/ _ \ / _` |
| (_| (_) | |_| | | | | |_  | | (_) | (_| |
 \___\___/ \__,_|_| |_|\__| |_|\___/ \__, |
                                     |___/
*/

1                                          Altair SLC          18:23 Friday, March 27, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1         options ps=64;
2         data workx.commas;
3           infile "d:/csv/2536_bridge_conditions.csv" lrecl=500 missover;
4           input;
5           rec=_n_;
6           commas=countc(_infile_,',');
7           text=_infile_;
8           if commas=0 then putlog commas= text;
9         run;

NOTE: The infile 'd:\csv\2536_bridge_conditions.csv' is:
      Filename='d:\csv\2536_bridge_conditions.csv',
      Owner Name=SLC\suzie,
      File size (bytes)=772666,
      Create Time=16:12:54 Mar 27 2026,
      Last Accessed=18:14:40 Mar 27 2026,
      Last Modified=16:04:53 Mar 27 2026,
      Lrecl=500, Recfm=V

COMMAS=0 E of Cty Rod 20 Exit 51
COMMAS=0 401
COMMAS=0
NOTE: 2872 records were read from file 'd:\csv\2536_bridge_conditions.csv'
      The minimum record length was 0
      The maximum record length was 498

2

NOTE: Data set "WORKX.commas" has 2872 observation(s) and 3 variable(s)
NOTE: The data step took :
      real time : 0.142
      cpu time  : 0.125


10
11        proc freq data=workx.commas;
12         tables commas;
13        run;quit;
NOTE: 2872 observations were read from "WORKX.commas"
NOTE: Procedure freq step took :
      real time : 0.078
      cpu time  : 0.062


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.300
      cpu time  : 0.265

/*___                       _         _ _                              _
|___ \   _ __ ___  __ _  __| |   __ _| | |  _ __ ___  ___ ___  _ __ __| |___
  __) | | `__/ _ \/ _` |/ _` |  / _` | | | | `__/ _ \/ __/ _ \| `__/ _` / __|
 / __/  | | |  __/ (_| | (_| | | (_| | | | | | |  __/ (_| (_) | | | (_| \__ \
|_____| |_|  \___|\__,_|\__,_|  \__,_|_|_| |_|  \___|\___\___/|_|  \__,_|___/

*/

data workx.messy;  ;
 infile 'd:/csv/2536_bridge_conditions.csv' delimiter = ',' MISSOVER DSD lrecl=384;
 length v1-v39 $255;
 informat v1-v39 $255.;
 input  v1-v39;
run;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/*                     FIRST RECORD                   MIDDLE RECORD                  LAST  RECORD                         */
/*  -- CHARACTER --    ----------------------------   -------------------------      --------------------------           */
/*                                                                                                                        */
/* Variable  Typ       Value                          Value                          Value                                */
/*                                                                                                                        */
/* V1         C255                                    33 - 359/                      49 -  73/                            */
/* V2         C255                                    Regional Road 12 Underpass     Kagawong Creek Tributary Br          */
/* V3         C255     RENSEIGNMENTS SUR L'EMPLACE    7                              540                                  */
/* V4         C255                                    43.405834                      45.90007                             */
/* V5         C255                                    -80.596761                     -82.26313                            */
/* V6         C255     RENSEIGNMENTS SUR LA STRUCT    Bridge                         Bridge                               */
/* V7         C255                                    Slab                           Frame                                */
/* V8         C255                                    Rectangular Voided Slab        Rigid Frame, Slab                    */
/* V9         C255                                    Post-Tensioned Cast-In-Plac    Reinforced Cast-In-Place Co          */
/* V10        C255                                    1994                           1964                                 */
/* V11        C255                                                                   1990                                 */
/* V12        C255                                                                                                        */
/* V13        C255                                    2                              1                                    */
/* V14        C255                                    Total=84  (1)=42;(2)=42;       Total=6  (1)=6;                      */
/* V15        C255                                    85.1                           6.7                                  */
/* V16        C255                                    14.8                           11.7                                 */
/* V17        C255     RENSEIGNMENTS ADMINISTRATIV    West                           Northeastern                         */
/* V18        C255                                    WATERLOO                       MANITOULIN                           */
/* V19        C255                                    Open to traffic                Open to traffic                      */
/* V20        C255                                    Provincial                     Provincial                           */
/* V21        C255     RENSEIGNMENTS DE L'INSPECTI    04/09/2013                     05/23/2012                           */
/* V22        C255                                    76.9                           59.2                                 */
/* V23        C255                                    76.9                                                                */
/* V24        C255                                                                   59.2                                 */
/* V25        C255                                    77.1                                                                */
/* V26        C255                                                                   63.7                                 */
/* V27        C255                                    77.1                                                                */
/* V28        C255                                                                   65.4                                 */
/* V29        C255                                    74.8                                                                */
/* V30        C255                                                                   66.6                                 */
/* V31        C255                                    75                                                                  */
/* V32        C255                                                                   69.2                                 */
/* V33        C255                                    75                                                                  */
/* V34        C255                                                                                                        */
/* V35        C255                                    75                                                                  */
/* V36        C255                                                                                                        */
/* V37        C255                                                                                                        */
/* V38        C255                                                                                                        */
/* V39        C255                                                                                                        */
/**************************************************************************************************************************/

/*____                 _                       _   _                            _                  _   _
|___ /   _ __ ___  ___(_)_______    ___  _ __ | |_(_)_ __ ___  _   _ _ __ ___  | | ___ _ __   __ _| |_| |__
  |_ \  | `__/ _ \/ __| |_  / _ \  / _ \| `_ \| __| | `_ ` _ \| | | | `_ ` _ \ | |/ _ \ `_ \ / _` | __| `_ \
 ___) | | | |  __/\__ \ |/ /  __/ | (_) | |_) | |_| | | | | | | |_| | | | | | || |  __/ | | | (_| | |_| | | |
|____/  |_|  \___||___/_/___\___|  \___/| .__/ \__|_|_| |_| |_|\__,_|_| |_| |_||_|\___|_| |_|\__, |\__|_| |_|
                                        |_|                                                  |___/
*/

%utl_optlenpos(inp=workx.messy,out=workx.messy);

proc contents data=workx.messy;
run;

/**************************************************************************************************************************/
/*   Point to Observations    YES                                                                                         */
/*  Sorted                   NO                                                                                           */
/*  Data Representation      WINDOWS_64                                                                                   */
/*  Encoding                 wlatin1 Windows-1252 Western                                                                 */
/*                                                                                                                        */
/*            Engine/Host Dependent Information                                                                           */
/*                                                                                                                        */
/*  Data Set Page Size          16384                                                                                     */
/*  Number of Data Set Pages    57                                                                                        */
/*  File Name                   d:\wpswrkx\messy.sas7bdat                                                                 */
/*  Release Created             9.0101M3                                                                                  */
/*  Host Created                XP_PRO                                                                                    */
/*                                                                                                                        */
/*       Alphabetic List of Variables and Attributes                                                                      */
/*                                                                                                                        */
/*   Number    Variable    Type   Len  Pos                                                                                */
/*  ______________________________________                                                                                */
/*        1    V1          Char    33    0                                                                                */
/*        2    V2          Char    60   33                                                                                */
/*        3    V3          Char    31   93                                                                                */
/*        4    V4          Char    11  124                                                                                */
/*        5    V5          Char    11  135                                                                                */
/*        6    V6          Char    30  146                                                                                */
/*        7    V7          Char    30  176                                                                                */
/*        8    V8          Char    37  206                                                                                */
/*        9    V9          Char    37  243                                                                                */
/*       10    V10         Char    21  280                                                                                */
/*       11    V11         Char    26  301                                                                                */
/*       12    V12         Char    26  327                                                                                */
/*       13    V13         Char   134  353                                                                                */
/*       14    V14         Char   250  487                                                                                */
/*       15    V15         Char    19  737                                                                                */
/*       16    V16         Char    14  756                                                                                */
/*       17    V17         Char    29  770                                                                                */
/*       18    V18         Char    27  799                                                                                */
/*       19    V19         Char    15  826                                                                                */
/*       20    V20         Char    24  841                                                                                */
/*       21    V21         Char    62  865                                                                                */
/*       22    V22         Char    31  927                                                                                */
/*       23    V23         Char     4  958                                                                                */
/*       24    V24         Char     4  962                                                                                */
/*       25    V25         Char     4  966                                                                                */
/*       26    V26         Char     4  970                                                                                */
/*       27    V27         Char     4  974                                                                                */
/*       28    V28         Char     4  978                                                                                */
/*       29    V29         Char     4  982                                                                                */
/*       30    V30         Char     4  986                                                                                */
/*       31    V31         Char     4  990                                                                                */
/*       32    V32         Char     4  994                                                                                */
/*       33    V33         Char     4  998                                                                                */
/*       34    V34         Char     4 1002                                                                                */
/*       35    V35         Char     4 1006                                                                                */
/*       36    V36         Char     4 1010                                                                                */
/*       37    V37         Char     1 1014                                                                                */
/*       38    V38         Char     1 1015                                                                                */
/*       39    V39         Char     1 1016                                                                                */
/**************************************************************************************************************************/
/*           _   _           _           _
  ___  _ __ | |_(_)_ __ ___ (_)_______  | | ___   __ _
 / _ \| `_ \| __| | `_ ` _ \| |_  / _ \ | |/ _ \ / _` |
| (_) | |_) | |_| | | | | | | |/ /  __/ | | (_) | (_| |
 \___/| .__/ \__|_|_| |_| |_|_/___\___| |_|\___/ \__, |
      |_|                                        |___/
*/

1                                          Altair SLC          18:16 Friday, March 27, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx

NOTE: Library slchelp assigned as follows:
      Engine:        WPD
      Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp

NOTE: Library worksas assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\worksas

NOTE: Library workwpd assigned as follows:
      Engine:        WPD
      Physical Name: d:\workwpd


LOG:  18:16:44
NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.028
      cpu time  : 0.015


NOTE: AUTOEXEC processing completed

1          %utl_optlenpos(inp=workx.messy,out=workx.messy);





NOTE: Procedure contents step took :
      real time : 0.043
      cpu time  : 0.015


NOTE: Procedure sql step took :
      real time : 0.003
      cpu time  : 0.000



NOTE: 2872 observations were read from "WORKX.messy"
NOTE: 39 observations were read from "WORK.__layout"
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.015


NOTE: CALL EXECUTE generated line
2       +  data workx.messy( compress=binary label='Dataset workx.messy processed by utl_optlen') ;
3       +  retain
4       +  V1
5       +  V2
6       +  V3
...
40      +  V37
41      +  V38
42      +  V39
43      +  ;length
44      +  V1 $33
45      +  V2 $60
46      +  V3 $31
...
80      +  V37 $1
81      +  V38 $1
82      +  V39 $1
83      +  ;set workx.messy;format _all_;informat _all_;run;

83      +!                                                  quit;
NOTE: 2872 observations were read from "WORKX.messy"
NOTE: Data set "WORKX.messy" has 2872 observation(s) and 39 variable(s)
NOTE: Specifying compression for data set "WORKX.messy" has decreased its size from 180 to 57 pages (a 69% reduction)
NOTE: The data step took :
      real time : 0.027
      cpu time  : 0.031


84        proc contents data=workx.messy;
85        run;
NOTE: Procedure contents step took :
      real time : 0.078
      cpu time  : 0.000


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.280
      cpu time  : 0.140


/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
