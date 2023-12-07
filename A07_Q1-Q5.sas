/* Question 1 */
%PUT 'ODS in SAS stands for the output delivery system, 
		which has lots of options that can help users
		create clean, nice looking reports that can be
		understood.';
		
		
		
/* Question 2 */
DATA q9;
	SET SASHELP.HEART;
RUN;

DATA q9_b;
	SET q9;
	bmi = Weight / (Height ** 2) * 703;
	KEEP Height Weight Sex bmi;
RUN;

/* turn on ODS graphics */
ODS GRAPHICS ON;

PROC MEANS DATA = q9_b MEAN VAR RANGE MAXDEC = 2;
	CLASS SEX;
RUN;

PROC UNIVARIATE DATA = q9_b NOPRINT;
	CLASS SEX;
	HISTOGRAM BMI;
RUN;
	


/* Question 3 */
%LET folderPath = /home/u63563888/PQHS414/Module07;

/* part a */
DATA q3;
	SET SASHELP.FAILURE;
RUN;

PROC EXPORT DATA = q3(FIRSTOBS = 1 OBS = 35) 
			OUTFILE = "&folderPath/Assignment07_Q3.xlsx"
			DBMS = XLSX;
	SHEET = 'dataset_a';
RUN;

/* part b */ 
LIBNAME q3lib xlsx "&folderPath/Assignment07_Q3.xlsx";

DATA q3lib.dataset_b;
	SET q3(FIRSTOBS = 36 OBS = 70);
RUN;

LIBNAME q3lib clear; 



/* Question 4 */
DATA q4;
	SET SASHELP.VTABLE;
RUN;

PROC MEANS DATA = q4 MIN MAX MEAN MEDIAN;
	VAR NOBS NVAR;
	OUTPUT OUT = q4_results;
RUN;

PROC EXPORT DATA = q4_results 
			OUTFILE = "&folderPath/Assignment07_Q4.xlsx"
			DBMS = XLSX
			REPLACE;
	SHEET = 'sashelp_dataset_description';
RUN;



/* Question 5 */
ODS PDF FILE = "&folderPath/q5_pdf.pdf";
ODS HTML5 FILE = "&folderPath/q5_html.html";
ODS POWERPOINT FILE = "&folderPath/q5_ppt.pptx";

/* part a */
%LET q5folderPath = ~/my_shared_file_links/yeunjoosong0/PQHS414/Module05;

LIBNAME q5lib xlsx "&q5folderPath/M05_class_data.xlsx";

DATA q5data;
  SET q5lib.Module00;
RUN;
 
LIBNAME q5lib CLEAR;

/* part b */
PROC MEANS DATA = q5data;
RUN;

PROC SGPLOT DATA = q5data;
	HISTOGRAM Experience_in_SAS;
RUN;

PROC SGPLOT DATA = q5data;
	HISTOGRAM Experience_in_R;
RUN;

PROC SGPLOT DATA = q5data;
	HISTOGRAM Experience_in_Python;
RUN;

PROC SGPLOT DATA = q5data;
	HISTOGRAM Statistics_Knowledge;
RUN;

/* part c */
ODS NOPROCTITLE;

PROC FREQ DATA = q5data;
	TABLE Experience_in_SAS * Experience_in_R;
RUN;

TITLE 'Experience Levels Among 414 Students in SAS and R';
PROC SGPLOT DATA = q5data NOAUTOLEGEND;
	LOESS x = Experience_in_R y = Experience_in_SAS;
RUN;
TITLE;

TITLE 'Experience Level Density Curves Among 414 Students in SAS and R';
PROC SGPLOT DATA = q5data;
  DENSITY Experience_in_R / LEGENDLABEL = 'R Experience';
  DENSITY Experience_in_SAS / LEGENDLABEL = 'SAS Experience';
  XAXIS LABEL = 'Experience Level' MAX = 5;
RUN;
TITLE;

/* part d - ODS's were opened at beginning of question 5 */
ODS PDF CLOSE;
ODS HTML5 CLOSE;
ODS POWERPOINT CLOSE;


/* side by side bar ? */
PROC SGPLOT DATA = q5data;
  VBAR Experience_in_R/
  group =  Experience_in_SAS groupdisplay = cluster;
RUN;



/* Question 6 */
%let Year=2015;
%let basin=WP;

**************************************************;
*  Creating a Map with PROC SGMAP                *;
*   Requires SAS 9.4M5 or later                  *;
**************************************************;

LIBNAME pg1 "/home/u63563888/EPG1V2/data";

*Preparing the data for map labels;
data map;
	set pg1.storm_final;
	length maplabel $ 20;
	where season=&year and basin="&basin";
	if maxwindmph<60 then MapLabel=" ";
	else maplabel=cats(name,"-",maxwindmph,"mph");
	keep lat lon maplabel maxwindmph;
run;

*Creating the map;
title1 "Tropical Storms in &year Season";
title2 "Basin=&basin";
footnote1 "Storms with MaxWind>65mph are labeled";

proc sgmap plotdata=map;
    *openstreetmap;
    esrimap url='https://services.arcgisonline.com/arcgis/rest/services/World_Physical_Map';
            bubble x=lon y=lat size=maxwindmph / datalabel=maplabel datalabelattrs=(color=red size=8);
run;
title;footnote;

**************************************************;
*  Creating a Bar Chart with PROC SGPLOT         *;
**************************************************;
title "Number of Storms in &year";
proc sgplot data=pg1.storm_final;
	where season=&year;
	vbar BasinName / datalabel dataskin=matte categoryorder=respdesc;
	xaxis label="Basin";
	yaxis label="Number of Storms";
run;



