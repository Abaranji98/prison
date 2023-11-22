-- creating a database if database is already not exist

CREATE DATABASE IF NOT EXISTS prison;

-- creating a table Age_group 

CREATE TABLE Age_group 
 (
    state_name VARCHAR(30),
    is_state BOOLEAN,
    year INTEGER,
    category VARCHAR(50),
    type VARCHAR(50),
    gender VARCHAR(10),
    age_16_18 INTEGER,
    age_18_30 INTEGER,
    age_30_50 INTEGER,
    age_50_above INTEGER,
	total INTEGER
);

-- import the data into the table successfully 
-- check the data is properly inserted 

SELECT * FROM Age_group;

-- creating a table crime_inmates_convicted

CREATE TABLE crime_inmates_convicted
 (
    state_ut VARCHAR(30),
    year INTEGER,
    crime_head VARCHAR(40),
    grand_total INTEGER
);

-- import the data into the table successfully 
-- check the data is properly inserted 

SELECT * FROM crime_inmates_convicted;

-- creating a table crime_inmates_under_trial

CREATE TABLE crime_inmates_under_trial
 (
    state_ut VARCHAR(30),
    year INTEGER,
    crime_head VARCHAR(60),
    grand_total INTEGER
);

-- import the data into the table successfully 
-- check the data is properly inserted 

SELECT * FROM crime_inmates_under_trial;

-- creating a table education

CREATE TABLE education
 (
    state_name VARCHAR(30),
    is_state BOOLEAN,
    year INTEGER,
    gender VARCHAR(10),
    education VARCHAR(50),
    convicts INTEGER,
    under_trial INTEGER,
    detenues INTEGER,
    others INTEGER,
	Total INTEGER
);

-- import the data into the table successfully 
-- check the data is properly inserted 

SELECT * FROM education;

-- creating a table inmates_escapee

CREATE TABLE inmates_escapee
 (
    state_name VARCHAR(30),
    year INTEGER,
    detail VARCHAR(55),
    male INTEGER,
    female INTEGER,
    total INTEGER
);

-- import the data into the table successfully 
-- check the data is properly inserted 

SELECT * FROM inmates_escapee;

-- creating a table sentence_period

CREATE TABLE sentence_period
 (
    state_name VARCHAR(30),
    is_state BOOLEAN,
    year INTEGER,
    gender VARCHAR(10),
    sentence_period VARCHAR(50),
    age_16_18_years INTEGER,
    age_18_30_years INTEGER,
    age_30_50_years INTEGER,
    age_50_above INTEGER,
	total INTEGER
);

-- import the data into the table successfully 
-- check the data is properly inserted 

SELECT * FROM sentence_period;

-- to get no of tables available in current data base you are working

SELECT COUNT(table_name) as C_table
FROM information_schema.tables
WHERE table_schema = 'public';

-- to check the number of column and name of the column in the table age_group

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'age_group';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'age_group';

-- give no of entities in age_group

SELECT COUNT(*) as Entities
FROM public.age_group;

-- to check the number of column and name of the column in the table crime_inmates_convicted

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'crime_inmates_convicted';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'crime_inmates_convicted';

-- give no of entities in crime_inmates_convicted

SELECT COUNT(*) as Entities
FROM public.crime_inmates_convicted;

-- to check the number of column and name of the column in the table crime_inmates_under_trial

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'crime_inmates_under_trial';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'crime_inmates_under_trial';

-- give no of entities in crime_inmates_under_trial

SELECT COUNT(*) as Entities
FROM public.crime_inmates_under_trial;

-- to check the number of column and name of the column in the table education

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'education';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'education';

-- give no of entities in education

SELECT COUNT(*) as Entities
FROM public.education;

-- to check the number of column and name of the column in the table inmates_escapee

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'inmates_escapee';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'inmates_escapee';

-- give no of entities in inmates_escapee

SELECT COUNT(*) as Entities
FROM public.inmates_escapee;

-- to check the number of column and name of the column in the table sentence_period

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'sentence_period';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND TABLE_NAME = 'sentence_period';

-- give no of entities in sentence_period

SELECT COUNT(*) as Entities
FROM public.sentence_period;

-- QUERY 1;

-- NOTE:
-- ON THE FIRST CODE PARTITION IS GIVEN AS CRIME HEAD IT WILL CREATE A WINDOW AND DO THE SUM ON SPECIFIC FUNCTION
-- ON THE SECOND CODE OVER() IS NOT PARTITION DONE IT CONSIDER ALL THE GIVEN DATA  AS ITS PARTITION

SELECT DISTINCT CRIME_HEAD, SUM(GRAND_TOTAL) OVER (PARTITION BY CRIME_HEAD) AS T1
FROM CRIME_INMATES_CONVICTED;

WITH T AS (
    SELECT DISTINCT CRIME_HEAD, SUM(GRAND_TOTAL) OVER (PARTITION BY CRIME_HEAD) AS T1
    FROM CRIME_INMATES_CONVICTED
)
SELECT DISTINCT CRIME_HEAD, T1 AS NO_OF_PRISONERS, ROUND(T1 / SUM(T1) OVER () * 100, 2) AS PERCENTAGE_OF_PRISONERS
FROM T 
ORDER BY  PERCENTAGE_OF_PRISONERS DESC;

-- 2.Find yearly Convicts, Detenus and Under Trials Prisoner, show by making Three different Columns.
-- Method 1 we use group by
-- Method 2 we use distinct and partion

select * from age_group;

SELECT YEAR,
SUM(CASE WHEN TYPE = 'Convicts' THEN Total ELSE 0 END) AS NO_OF_CONVICTS,
SUM(CASE WHEN TYPE = 'Detenus' THEN Total ELSE 0 END) AS NO_OF_DETENUS,
SUM(CASE WHEN TYPE = 'Under Trials' THEN Total ELSE 0 END) AS NO_OF_UNDER_TRIALS
FROM AGE_GROUP
GROUP BY YEAR;

SELECT DISTINCT YEAR,
SUM(CASE WHEN TYPE = 'Convicts' THEN TOTAL ELSE 0 END) OVER(PARTITION BY YEAR) AS NO_OF_CONVICTS,
SUM(CASE WHEN TYPE = 'Detenus' THEN TOTAL ELSE 0 END) OVER(PARTITION BY YEAR) AS NO_OF_DETENUS,
SUM(CASE WHEN TYPE = 'Under Trials' THEN TOTAL ELSE 0 END) OVER(PARTITION BY YEAR)  AS NO_OF_UNDER_TRIALS
FROM AGE_GROUP;

-- 3.Total No of Inmates try escaping from prison and their percentage with total Number

SELECT YEAR ,SUM(TOTAL) AS TOTAL_PRISONERS 
FROM AGE_GROUP
GROUP BY 1;

SELECT YEAR ,SUM(TOTAL) AS TOTAL_ESCAPEE
FROM  INMATES_ESCAPEE
GROUP BY 1;
 
WITH PRISONER AS 
(
    SELECT YEAR,  SUM(TOTAL) AS TOTAL_PRISONERS
    FROM AGE_GROUP
    GROUP BY YEAR
),
ESCAPEE AS 
(
    SELECT YEAR,SUM(TOTAL)  AS TOTAL_ESCAPEE
    FROM INMATES_ESCAPEE
    GROUP BY YEAR
)
SELECT A.YEAR, A.TOTAL_PRISONERS, B.TOTAL_ESCAPEE,
			CONCAT(ROUND((B.TOTAL_ESCAPEE* 100 / ( A.TOTAL_PRISONERS)) , 2), '%') AS PERCENTAGE_ESCAPEE
FROM PRISONER AS A
JOIN ESCAPEE AS B
ON A.YEAR = B.YEAR;

-- QUERY 4
-- Percentage of people whose decision are either pending or innocent
-- the total number of convicted inmates for a specific year as x.t1
-- the total number of under trial inmates for the specific year as y.t2

SELECT DISTINCT  YEAR,SUM(GRAND_TOTAL) OVER(PARTITION BY YEAR) AS T1
FROM CRIME_INMATES_CONVICTED;

SELECT DISTINCT YEAR,SUM(GRAND_TOTAL) OVER(PARTITION BY YEAR) AS T2
FROM CRIME_INMATES_UNDER_TRIAL;

WITH X AS 
(
SELECT YEAR,SUM(GRAND_TOTAL) OVER(PARTITION BY YEAR) AS T1
FROM CRIME_INMATES_CONVICTED
),
Y AS 
(
SELECT YEAR,SUM(GRAND_TOTAL) OVER(PARTITION BY YEAR) AS T2
FROM CRIME_INMATES_UNDER_TRIAL
)
SELECT DISTINCT X.YEAR,T1 AS TOTAL_CONVICTED,T2 AS INMATES_UNDER_TRIAL,
					((Y.T2)*100/(X.T1)) AS DECISION_PENDING
FROM X
INNER JOIN Y
ON X.YEAR = Y.YEAR;

- 5.Percentage of People got Capital Punishment, Life Imprisonment combined.

SELECT YEAR ,SUM(TOTAL) AS TOTAL_PRISONERS 
FROM AGE_GROUP
GROUP BY 1;
        
SELECT * FROM SENTENCE_PERIOD;

WITH PRISONER AS 
(
        SELECT YEAR ,SUM(TOTAL) AS TOTAL_PRISONERS 
        FROM AGE_GROUP
        GROUP BY 1
),
SENTENCE AS 
(
        SELECT YEAR,SUM(TOTAL) AS TOTAL_SENTENCE
        FROM SENTENCE_PERIOD
        WHERE SENTENCE_PERIOD = 'Capital Punishment' OR SENTENCE_PERIOD = 'Life Punishment'
        GROUP BY 1
)
SELECT *,
CONCAT(ROUND((TOTAL_SENTENCE/(TOTAL_PRISONERS))*100,2),'%') AS PERCENTAGE_COMBINED
FROM PRISONER
JOIN SENTENCE 
USING(YEAR);

-- 6.Arrange sentence_period in descending order

SELECT SENTENCE_PERIOD,SUM(TOTAL) AS TOTAL
FROM SENTENCE_PERIOD
GROUP BY 1
ORDER BY 2;

-- QUESTION NO 7
-- Find no of Prisoner Yearly between 2001-2013 and increment in percentage.
-- Second query there is no null term will happen.

SELECT 
    YEAR, 
    SUM(TOTAL) AS TOTAL_PRISONERS,
    CASE 
        WHEN LAG(SUM(TOTAL), 1, 0) OVER (ORDER BY YEAR) = 0 THEN NULL
        ELSE ROUND(((SUM(TOTAL) - LAG(SUM(TOTAL), 1, 0) OVER (ORDER BY YEAR)) / LAG(SUM(TOTAL), 1, 0) OVER (ORDER BY YEAR)) * 100, 2)
    END AS PERCENTAGE_INCREMENT
FROM AGE_GROUP
GROUP BY YEAR;

SELECT 
    YEAR,
    SUM(TOTAL) AS TOTAL_PRISONERS,
    CASE 
        WHEN COALESCE(LAG(SUM(TOTAL)) OVER (ORDER BY YEAR), 0) = 0 THEN 0
        ELSE ROUND(((SUM(TOTAL) - COALESCE(LAG(SUM(TOTAL)) OVER (ORDER BY YEAR), 0)) / COALESCE(LAG(SUM(TOTAL)) OVER (ORDER BY YEAR), 1)) * 100, 2)
    END AS PERCENTAGE_INCREMENT
FROM AGE_GROUP
GROUP BY YEAR;

-- 8 Prisoners Education categorized by female and male in Percentage

SELECT  EDUCATION,
ROUND((FEMALE_PRISONERS/SUM(FEMALE_PRISONERS) OVER())*100,2) AS PERCENTAGE_FEMALE,
ROUND((MALE_PRISONERS/SUM(MALE_PRISONERS) OVER())*100,2) AS PERCENTAGE_MALE
FROM
(
SELECT EDUCATION,
SUM(CASE WHEN GENDER = 'Female' THEN TOTAL ELSE 0 END) AS FEMALE_PRISONERS,
SUM(CASE WHEN GENDER = 'Male' THEN TOTAL ELSE 0 END) AS MALE_PRISONERS
FROM EDUCATION
GROUP BY 1
) AS F ;

-- 9.Gender gap in literacy state wise in ascending order BY female percentage

select * from education

WITH M AS (
    SELECT STATE_NAME, EDUCATION, SUM(TOTAL) AS M1
    FROM EDUCATION 
    WHERE GENDER = 'Male'
    GROUP BY STATE_NAME, EDUCATION
),
F AS (
    SELECT STATE_NAME, EDUCATION, SUM(TOTAL) AS F1
    FROM EDUCATION 
    WHERE GENDER = 'Female'
    GROUP BY STATE_NAME, EDUCATION
)
SELECT 
    M.STATE_NAME,
    COALESCE(SUM(M.M1), 0) AS MALE_LITERATE,
    COALESCE(SUM(F.F1), 0) AS FEMALE_LITERATE,
    CONCAT(COALESCE((SUM(F.F1) * 100.0 / NULLIF(SUM(M.M1) + SUM(F.F1), 0)), 0),'%') AS PERCENTAGE_FEMALE_LITERATE,
	CONCAT(COALESCE((SUM(M.M1) * 100.0 / NULLIF(SUM(M.M1) + SUM(F.F1), 0)), 0),'%') AS PERCENTAGE_MALE_LITERATE
FROM M
LEFT JOIN F USING (STATE_NAME, EDUCATION)
GROUP BY M.STATE_NAME
ORDER BY PERCENTAGE_FEMALE_LITERATE;

-- 10. No of Foreign Prisoner in India Yearly.

SELECT * FROM AGE_GROUP;

SELECT YEAR,SUM(TOTAL) AS FOREIGN_PRISONERS
FROM AGE_GROUP
WHERE CATEGORY = 'Foreigners'
GROUP BY 1
ORDER BY 1;

-- 11.Yearly Female and Male Prisoner and Their Percentage

SELECT *,
       CONCAT(ROUND((FEMALE_PRISONERS / (MALE_PRISONERS + FEMALE_PRISONERS)) * 100, 2),'%') AS PERCENTAGE_FEMALE,
       CONCAT(ROUND((MALE_PRISONERS / (MALE_PRISONERS + FEMALE_PRISONERS)) * 100, 2),'%') AS PERCENTAGE_MALE
FROM
(
    SELECT YEAR,
           SUM(CASE WHEN GENDER = 'Female' THEN TOTAL ELSE 0 END) AS FEMALE_PRISONERS,
           SUM(CASE WHEN GENDER = 'Male' THEN TOTAL ELSE 0 END) AS MALE_PRISONERS
    FROM AGE_GROUP
    GROUP BY 1
) AS F;




 






























