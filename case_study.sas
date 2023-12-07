/************************************************************
**********
**********     ACCESS DATA
**********
************************************************************/

PROC IMPORT DATAFILE = "/home/u63563888/PQHS414/Module10/TSAClaims2002_2017.csv" 
			DBMS = csv
			OUT = tsaData
			REPLACE;
	GUESSINGROWS = max;
RUN;



/************************************************************
**********
**********     LOOK AT DATA
**********
************************************************************/

PROC FREQ DATA = tsaData;
	TABLE Claim_Type Claim_Site Disposition;
RUN;



/************************************************************
**********
**********     DATA CLEANING
**********
************************************************************/

/* remove entirely duplicate records */
PROC SORT DATA = tsaData OUT = temp NODUPKEY;
	BY _all_;
RUN;

/* sort by incident date */
PROC SORT DATA = temp OUT = temp2;
	BY Incident_Date;
RUN;

/* clean variables */
DATA temp3;
	SET temp2;
	
	IF Claim_Type IN ("-", "") THEN Claim_Type = "Unknown";
	ELSE IF Claim_Type = 'Passenger Property Loss/Personal Injur' THEN 
		Claim_Type='Passenger Property Loss';
	ELSE IF Claim_Type = 'Passenger Property Loss/Personal Injury' THEN
		Claim_Type='Passenger Property Loss';
	ELSE IF Claim_Type = 'Property Damage/Personal Injury' THEN
		Claim_Type='Property Damage';
		
	IF Claim_Site IN ("-", "") THEN Claim_Site = "Unknown";
		
	IF Disposition IN ("-", "") THEN Disposition = "Unknown";
	ELSE IF Disposition='Closed: Canceled' THEN
		Disposition='Closed:Canceled';
	ELSE IF Disposition='losed: Contractor Claim' THEN
		Disposition='Closed:Contractor Claim';
RUN;
	

/* convert state and state name */
DATA temp4;
	SET temp3;
	STATE = UPCASE(STATE);
	STATENAME = PROPCASE(STATENAME);
RUN;

/* create new flag variable */
DATA temp5;
	SET temp4;
	date_issues = 0;
	IF (Incident_Date = . OR
		Date_Received = . OR
		YEAR(Incident_Date) < 2002 OR
		YEAR(Incident_Date) > 2017 OR
		YEAR(Date_Received) < 2002 OR
		YEAR(Date_Received) > 2017 OR 
		Incident_Date > Date_Received) then date_issues = 1;

RUN;

/* drop county and city */
DATA temp6;
	SET temp5;
	DROP COUNTY CITY;
RUN;

/* format currency and date */
DATA temp7;
	SET temp6;
	FORMAT Close_Amount dollar10.2;
	FORMAT Incident_Date date9.;
	FORMAT Date_Received date9.;
RUN;

LIBNAME tsa "/home/u63563888/PQHS414/Module10";

/* permanent labels */
DATA tsa.claims_cleaned;
	SET temp7;
	LABEL Airport_Code = "Airport Code"
			Airport_Name = "Airport Name"
			Claim_Number = "Claim Number"
			Claim_Site = "Claim Site"
			Claim_Type = "Claim Type"
			Close_Amount = "Close Amount"
			Date_Issues = "Date Issues"
			Date_Received = "Date Received"
			Incident_Date = "Incident Date"
			Item_Category = "Item Category";
RUN;



/************************************************************
**********
**********     DATA REPORT
**********
************************************************************/

ODS HTML FILE = "/home/u63563888/PQHS414/Module10/report.html";

DATA repData;
	SET tsa.claims_cleaned;
	incident_year = YEAR(Incident_Date);
	LABEL incident_year = "Incident Year";
RUN;

/* date issues overall */
PROC FREQ DATA = repData;
	TABLE date_issues;
RUN;

/* remove those with data issues */
DATA noIssue;
	SET repData;
	WHERE date_issues = 0;
RUN;

/* claims by year */
PROC FREQ DATA = noIssue;
	TABLE incident_year;
RUN;

TITLE 'Number of Claims by Year';
PROC SGPLOT DATA = noIssue;
  VBAR incident_year ;
RUN;


/* state level */
%LET state = CA;

DATA stateData;
	SET noIssue;
	WHERE STATE = "&state";
RUN;


PROC FREQ DATA = stateData;
	TABLE Claim_Type Claim_Site Disposition;
RUN;


PROC MEANS DATA = stateData MEAN MIN MAX SUM MAXDEC = 0;
	VAR Close_Amount;
RUN;

ODS HTML CLOSE;