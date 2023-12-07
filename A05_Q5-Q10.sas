/* Question 5 */
LIBNAME lib05 xlsx'~/my_shared_file_links/yeunjoosong0/PQHS414/Module05/M05_class_data.xlsx';

PROC CONTENTS DATA = lib05.MODULE01;
RUN;



/* Question 6 */
PROC IMPORT DATAFILE = '~/my_shared_file_links/yeunjoosong0/PQHS414/Module05/M05_class_data.xlsx'
	OUT = classData
	dbms = xlsx
    replace;
    sheet = 'Module00';
RUN;

DATA "~/PQHS414/Module05/module00.sas7bdat";
  SET classData;
RUN;

PROC CONTENTS DATA = classData;
RUN;



/* Question 7 */
PROC UNIVARIATE DATA = lib05.MODULE00;
	VAR Experience_in_R;
RUN;

PROC UNIVARIATE DATA = lib05.MODULE00;
	VAR Experience_in_SAS;
RUN;


/* Question 8 */
PROC FREQ DATA = lib05.MODULE00;
	TABLE STATUS Experience_in_Python;
RUN;



/* Question 9 */
DATA q9_data;
  SET SASHELP.FAILURE;
  FORMAT Count DOLLAR16.;
RUN;

PROC PRINT DATA = q9_data (obs = 10);
RUN;



/* Question 10 */
data dateFormats;
    fmt1 = today();
    format fmt1 yymmdd10.;
    put fmt1;
    
    fmt2 = today();
    format fmt2 date7.;
    put fmt2;
    
    fmt3 = today();
    format fmt3 date9.;
    put fmt3;
run;


