/** 
import raw data file
set output column names
**/

DATA rawData;
	INFILE "~/my_shared_file_links/yeunjoosong0/PQHS414/Module03/M03_raw_data_0.csv" 
		dlm = ',' firstobs = 2;
	INPUT Student Status $ SAS_exp R_exp Python_exp stat_knowledge;
RUN;




/** 
import and print
**/

FILENAME filePath "~/my_shared_file_links/yeunjoosong0/PQHS414/Module03/M03_raw_data_0.csv" 
	TERMSTR = LF;


PROC IMPORT DATAFILE = filePath
		    OUT = WORK.RAWDATA
		    DBMS = filePath
		    REPLACE;
RUN;

PROC PRINT DATA = WORK.RAWDATA; 
RUN;
