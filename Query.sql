
SELECT *
FROM CoronaVirusDataset 

----------------------------------------------
-- Q1. Checking NULL values

SELECT *
FROM CoronaVirusDataset 
where Province is null or Country_Region is null

SELECT *
FROM CoronaVirusDataset 
where Latitude is null or longitude is null -- 33,594 rows are NULL

SELECT *
FROM CoronaVirusDataset 
where Confirmed is null or Deaths is null or Recovered is null or Date is null

----------------------------------------------
-- Q2. Updating null values with zeros

UPDATE CoronaVirusDataset
SET Latitude = 0
WHERE Latitude IS NULL;

UPDATE CoronaVirusDataset
SET longitude = 0
WHERE longitude IS NULL;

----------------------------------------------
-- Q3. check total number of rows

SELECT count(*) as number_of_rows
FROM CoronaVirusDataset      -- 78386 rows

----------------------------------------------
-- Q4. Check what is start_date and end_date

SELECT TOP 1 Date as start_date
FROM CoronaVirusDataset
ORDER by start_date asc      -- 2020-01-22

SELECT TOP 1 Date as end_date
FROM CoronaVirusDataset
ORDER by end_date desc      -- 2021-06-13

----------------------------------------------
-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT MONTH(Date)) AS Number_Of_Months
FROM CoronaVirusDataset
WHERE YEAR(Date) = '2020'    -- 12

SELECT COUNT(DISTINCT MONTH(Date)) AS Number_Of_Months
FROM CoronaVirusDataset
WHERE YEAR(Date) = '2021'    -- 6

----------------------------------------------
-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT MONTH(Date) as Month,
				AVG(Confirmed) as AVG_Confirmed,
				AVG(Deaths) as AVG_Deaths,
				AVG(Recovered) as AVG_Recovered
FROM CoronaVirusDataset
GROUP by MONTH(Date)
ORDER by Month

----------------------------------------------
-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

WITH FrequencyCTE AS(
SELECT MONTH(Date) AS MONTH, confirmed, Deaths, Recovered,
	   ROW_NUMBER() OVER ( PARTITION BY MONTH(Date) ORDER BY COUNT (*)DESC ) AS RN
FROM CoronaVirusDataset
GROUP BY MONTH(Date),Confirmed , Deaths, Recovered
 )
SELECT MONTH, Confirmed as Most_Freq_Confirmed ,Deaths as Most_Freq_Deaths, Recovered as Most_Freq_Recoverd
FROM FrequencyCTE
WHERE RN = 1
ORDER BY MONTH;

----------------------------------------------
-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT YEAR(Date) as YEAR, MIN(confirmed) as MIN_confirmed,
	   MIN(deaths) as MIN_deaths, MIN(recovered) as MIN_recovered
FROM CoronaVirusDataset
GROUP by YEAR(Date)

----------------------------------------------
-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT YEAR(Date) as YEAR, MAX(confirmed) as MAX_confirmed,
	   MAX(deaths) as MAX_deaths, MAX(recovered) as MAX_recovered
FROM CoronaVirusDataset
GROUP by YEAR(Date)

----------------------------------------------
-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT MONTH(Date) as '2020_MONTHs', SUM(confirmed) as TOTAL_confirmed,
	   SUM(deaths) as TOTAL_deaths, SUM(recovered) as TOTAL_recovered
FROM CoronaVirusDataset
WHERE YEAR(Date) = '2020'
GROUP by MONTH(Date)
ORDER by '2020_MONTHs'


SELECT MONTH(Date) as '2021_MONTHs', SUM(confirmed) as TOTAL_confirmed,
	   SUM(deaths) as TOTAL_deaths, SUM(recovered) as TOTAL_recovered
FROM CoronaVirusDataset
WHERE YEAR(Date) = '2021'
GROUP by MONTH(Date)
ORDER by '2021_MONTHs'

----------------------------------------------
-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
 SUM(Confirmed) AS Total_Confirmed_Cases,
 AVG(Confirmed) AS Avg_Confirmed_Case,
 ROUND(VAR(Confirmed),2) AS Variance_Confirmed_Cases,
 ROUND(STDEV(Confirmed),2) AS StandardDeviation_Confirmed_Cases
FROM CoronaVirusDataset;

----------------------------------------------
-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total death cases, their average, variance & STDEV )

SELECT 
 MONTH(Date) AS MONTH,
 SUM(Deaths) AS Total_Deaths_Cases,
 AVG(Deaths) AS Avg_Deaths_Case,
 ROUND(VAR(Deaths),2) AS Variance_Deaths_Cases,
 ROUND(STDEV(Deaths),2) AS StandardDeviation_Deaths_Cases
FROM CoronaVirusDatasetGROUP BY MONTH(Date)ORDER BY MONTH(Date);

----------------------------------------------
-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total recovered cases, their average, variance & STDEV )

SELECT
 SUM(Deaths) AS Total_Deaths_Cases,
 AVG(Deaths) AS Avg_Deaths_Case,
 ROUND(VAR(Deaths),2) AS Variance_Deaths_Cases,
 ROUND(STDEV(Deaths),2) AS StandardDeviation_Deaths_Cases
FROM CoronaVirusDataset;

----------------------------------------------
-- Q14. Find Country having highest number of the Confirmed case

SELECT TOP 1 Country_Region, SUM(Confirmed) as highest_Confirmed_case_Country
FROM CoronaVirusDataset
GROUP by Country_Region
ORDER by 2 DESC;               --  US    -->	 33461982

----------------------------------------------
-- Q15. Find Country having lowest number of the death case

SELECT TOP 5 Country_Region, SUM(deaths) as lowest_Death_case_Country
FROM CoronaVirusDataset
GROUP by Country_Region
ORDER by 2 ASC;         -- ( Marshall Islands, Samoa, Kiribati, Dominica ) = 0 Death_cases

----------------------------------------------
-- Q16. Find top 5 countries having highest recovered case

SELECT TOP 5 Country_Region, SUM(recovered) as highest_top_5_Recovered_case_Country
FROM CoronaVirusDataset
GROUP by Country_Region
ORDER by 2 DESC;        -- ( India, Brazil, US, Turkey, Russia )






