/* Question 6 */
LIBNAME pg1 "/home/u63563888/EPG1V2/data";

title "Class Students Who Are at Least 160cm Tall";
footnote "Date Format - Month/Day/Year";

proc sql;
	select UPPER(Name) as Name, Age, 
			Height*2.54 as HeightCM format=5.1, 
			Birthdate format=mmddyy10.
	    from pg1.class_birthdate
	    where Height*2.54 >= 160
	    order by Age desc;
quit;

title;
footnote;



/* Question 7 */
title "Most Costly Storms During/After 2010 Season";
title2 "Maximum Wind Speed Greater Than 156 MPH";
title3 "Storm Name contains 'M'";

proc sql;
	select Season, propcase(Name) as Name, 
			StartDate format = mmddyy8., 
			MaxWindMPH
	from pg1.storm_summary
	where season >= 2010 and
			MaxWindMPH > 156 and 
			Name like "%M%"
	order by Season desc, MaxWindMPH;
quit;

title;


/* Question 8 - include variable (Statehood) to compare values to date provided */
libname sql '~/PQHS414/Module08/SQLDatasetsV9/';

proc sql;
	validate
      select Name, Statehood
      from sql.unitedstates
      where Statehood lt '01Jan1800'd;
quit;



/* Question 9 - remove title within insert into step (only keep second) */
proc sql;
   insert into sql.newcountries
      set name='Bangladesh',
          capital='Dhaka',
          population=126391060
      set name='Japan',
          capital='Tokyo',
          population=126352003;
      
   title "World's Largest Countries";
   select name format=$20., 
          capital format=$15.,
          population format=comma15.0
      from sql.newcountries;



/* Question 10 - change dataset to the correct one (was pointing to non existing file) */
PROC IMPORT DATAFILE = '~/PQHS414/Module08/US_population_2019.xlsx'
	OUT = q10data
	DBMS = xlsx
    REPLACE;
RUN;

proc sql;
title 'Updated U.S. Population Data';
select state, population format=comma10. label='Population' from q10data;

options ls=84;
proc sql outobs=10;
   title 'UnitedStates';
   create table work.unitedstates as
   select * from sql.unitedstates;
   update work.unitedstates as u
      set population=(select population from q10data as n
               where u.name=n.state)
           where u.name in (select state from q10data);
    select Name format=$17., Capital format=$15.,
           Population, Area, Continent format=$13., Statehood format=date9.
       from work.unitedstates
;
