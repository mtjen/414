/* set library */
LIBNAME tropLib "/home/u63563888/EPG1V2/data";



/* Question 5 */
/* demo part */
data tropical_storm;
    set tropLib.storm_summary;
    drop Hem_EW Hem_NS Lat Lon;
    where Type="TS";
    MaxWindKM=MaxWindMPH*1.60934;
    format MaxWindKM 3.;
    StormType="Tropical Storm";
run;

/* Part a */
DATA q5_a;
	SET tropical_storm;
	WHERE Season = 1980;
	storm_length = EndDate - StartDate;
RUN;

DATA q5_a_11_days;
	SET q5_a;
	WHERE storm_length = 11;
RUN;

/* Part b */
DATA q5_b;
	SET tropical_storm;
	WHERE Basin = 'EP' AND Season = 1980;
RUN;

/* Part c */ 
DATA q5_c;
	SET tropical_storm;
	WHERE Type = 'NR' AND Season = 1981;
RUN;

/* confirm that there are no NR types */
PROC FREQ DATA = tropical_storm;
	TABLE Type;
RUN;

/* Part d */
DATA q5_d;
	SET tropical_storm;
	WHERE Season = 1981;
RUN;

PROC SORT DATA = q5_d;
	BY descending MaxWindMPH;
RUN;



/* Question 6 */
/* demo part */
data storm_new;
    set tropLib.storm_damage;
    drop Summary;
    YearsPassed=yrdif(Date,today(),"age");
    Anniversary=mdy(month(Date),day(Date),year(today()));
    format YearsPassed 4.1 Date Anniversary mmddyy10.; 
run; 

/* Part a */
DATA q6_a;
	SET storm_new;
RUN;
 
PROC SORT DATA = q6_a;
	BY descending Cost;
RUN;

/* Part b */ 
DATA q6_b;
	SET storm_new;
RUN;

PROC SORT DATA = q6_b;
	BY descending YearsPassed;
RUN;

/* Part c */
DATA q6_c;
	SET storm_new;
	WHERE MONTH(Anniversary) = 9 AND DAY(Anniversary) = 26;
RUN;



/* Question 7 */
/* demo part */
data indian atlantic pacific;
    set troplib.storm_summary;
    length Ocean $ 8;
    keep Basin Season Name MaxWindMPH Ocean;
    Basin=upcase(Basin);
    OceanCode=substr(Basin,2,1);
    if OceanCode="I" then do;
       Ocean="Indian";
       output indian;
    end;
    else if OceanCode="A" then do;
       Ocean="Atlantic"; 
       output atlantic;
    end;
    else do;
       Ocean="Pacific";
       output pacific;
    end;
run;

/* Part b */ 
PROC FREQ DATA = atlantic ORDER = Freq;
	TABLE Season;
RUN;

PROC FREQ DATA = indian ORDER = Freq;
	TABLE Season;
RUN;

PROC FREQ DATA = pacific ORDER = Freq;
	TABLE Season;
RUN;



/* Question 8 */
/* demo part */
DATA q8;
	SET tropLib.np_summary;
	IF Type = 'NM' THEN ParkType = 'Monument';
	ELSE IF Type = 'NP' THEN ParkType = 'Park';
	ELSE IF Type IN ('NPRE', 'PRE', 'PRESERVE') THEN ParkType = 'Preserve';
	ELSE IF Type = 'NS' THEN ParkType = 'Seashore';
	ELSE ParkType = 'River';
RUN;

PROC FREQ DATA = tropLib.np_summary;
	TABLE Type;
RUN;

PROC FREQ DATA = q8;
	TABLE ParkType;
RUN;



/* Question 9 */
DATA q9;
	SET SASHELP.HEART;
RUN;

/* Part a */
DATA q9_a;
	SET q9;
	WHERE Sex = 'Female';
RUN;

/* Part b */
DATA q9_b;
	SET q9;
	bmi = Weight / (Height ** 2) * 703;
	KEEP Height Weight bmi;
RUN;



/* Question 10 */
DATA q10;
	SET SASHELP.FAILURE;
RUN;

/* Part a */
DATA q10_a;
	SET q10;
	LENGTH isAboveTen $ 5;
	IF Count >= 10 THEN isAboveTen = 'True';
	IF Count < 10 THEN isAboveTen = 'False';
	KEEP Count isAboveTen;
RUN;

/* Part b */
DATA q10_b;
	SET q10;
	LENGTH isAboveTen $ 5;
	IF Count >= 10 THEN isAboveTen = 'True';
	ELSE isAboveTen = 'False';
	KEEP Count isAboveTen;
RUN;


