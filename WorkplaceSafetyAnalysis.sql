USE [Practice]
GO

/*								

									Workplace Safety Data Analysis


*/

--1	How many incidents occurred at each plant?

select 
	plant, 
	count ("incident Type") as NumberOfIncidents 
from WorkplaceSafetyData
group by plant;


--2	 What is the total incident cost per department?
	
select 
	Department, 
	sum("incident Cost") as IncidenceCostByDept
from WorkplaceSafetyData
group by Department;


--3	Which incident type resulted in the highest total days lost?

SELECT 
	"Incident Type", 
	MAX(CAST("Days Lost" AS DECIMAL(10,2))) AS max_days_lost
FROM WorkplaceSafetyData
GROUP BY "Incident Type"
ORDER BY max_days_lost DESC;


--	4 What is the distribution of incident types by shift?

select 
	"incident type", 
	"shift", 
	count("incident type") as NumberOfIncidenceByShift
from WorkplaceSafetyData
group by "incident type", "shift"

--	5 What is the average incident cost for each injury location?
select 
	"injury location", 
	avg("incident cost") as AverageCost
from WorkplaceSafetyData
group by "injury location"
	
--6	Which age group has the highest number of incidents?

select 
	"age group", 
	count(*) as NumberOfIncidents
from WorkplaceSafetyData
group by "age group"
order by NumberOfIncidents desc

--7	How many incidents were reported as 'Lost Time' by each plant?

select 
	"plant","report type", 
	count("incident type") as NumberOfIncidents
from WorkplaceSafetyData
where "Report type" = 'Lost Time'
group by "plant", "report type"
	

--8	Which department had the highest number of 'Crush & Pinch' incidents?

select 
	"department",
	"incident type", 
	count("incident type") as NumberOfIncidents
from WorkplaceSafetyData
where "incident type" = 'Crush & Pinch'
group by "department", "incident type"
order by NumberOfIncidents desc

--2nd method to return only the department with the highest number of incident of crush & Pinch	

WITH RankedIncidents AS (
SELECT 
	"department", 
	"incident type", 
	COUNT("incident type") AS NumberOfIncidents,
    ROW_NUMBER() OVER (ORDER BY COUNT("incident type") DESC) AS RowNum
FROM WorkplaceSafetyData
WHERE "incident type" = 'Crush & Pinch'
GROUP BY "department", "incident type"
)
SELECT 
	"department", 
	"incident type", 
	NumberOfIncidents
FROM RankedIncidents
WHERE RowNum = 1;
	
-- 9	Which plants reported the most "Near Miss" incidents?
		
select 
	"plant",
	"report type", 
	count("report type") as NumberOfReports
from WorkplaceSafetyData
where "report type" = 'Near Miss'
group by "plant", "report type"
order by NumberOfReports desc

--2nd method to return only the plant with the highest number of reports for 'Near Miss'	

WITH MostNearMiss AS (
SELECT 
	"plant", 
	"report type", 
	COUNT("report type") AS NumberOfReports,
           ROW_NUMBER() OVER (ORDER BY COUNT("report type") DESC) AS RowNum
FROM WorkplaceSafetyData
WHERE "report type" = 'Near Miss'
    GROUP BY "plant", "report type"
)
SELECT 
	"plant", 
	"report type", 
	NumberOfReports
FROM MostNearMiss
WHERE RowNum = 1;


-- 10	What is the total number of incidents by year and month?
Select 
	year("date") as "year", 
	count (*) as NumberOfIncidents
from WorkplaceSafetyData
group by year("date");

Select 
	format("date", 'MMMM') as "Month", 
	count (*) as NumberOfIncidents, 
	month("date") as MonthNumber
from WorkplaceSafetyData
group by 
	format("date", 'MMMM'),month("date")
order by 
	month("date");

--11	Which gender has the most reported incidents?
select 
	"gender", 
	count(*) as numberOfIncidents
from WorkplaceSafetyData
group by "gender"
order by numberOfIncidents desc

-- 12	What is the total cost of incidents per year?
Select 
	year("date") as "year", 
	sum("incident cost") as TotalCostofIncident
from WorkplaceSafetyData
group by year("date");

--13	Which incident resulted in the highest cost?
with HighestIncidentCost as(
select*,
	max("incident cost") over(partition by ("incident type") ) as HighestCost
from WorkplaceSafetyData)

select top 1* from HighestIncidentCost
where "incident cost" = HighestCost

-- 14	What is the total cost of incidents for each report type?
select 
	"report type",
	sum("incident cost") as TotalCost
from WorkplaceSafetyData
group by "report type"

--15	Which departments had incidents with more than 2 days lost?
Select 
	distinct(department) 
from WorkplaceSafetyData
where "days lost" > 2

--16	What is the average number of days lost per incident type?
select 
	"incident type", 
	AVG(CAST("Days Lost" AS DECIMAL(10,2))) as AverageDaysLost
from WorkplaceSafetyData
group by "Incident type"

--17	What is the distribution of incidents by shift (Day, Afternoon, Night)?

select 
	"shift", 
	count("incident type") as NumberOfIncidenceByShift
from WorkplaceSafetyData
group by "shift";

--18	Which months have the highest number of incidents?
Select 
	format("date", 'MMMM') as "Month", 
	count (*) as NumberOfIncidents, 
	month("date") as MonthNumber
from WorkplaceSafetyData
group by 
	format("date", 'MMMM'),
	month("date")
order by NumberOfIncidents desc;

--19	What is the total cost of "Vehicle" related incidents?

select 
	sum("incident cost") as TotalCost
from WorkplaceSafetyData 
where "incident type" = 'Vehicle'

--20	Which age group is most affected by "Falling Object" incidents?

select 
	"age group",
	"incident type",
	count("incident type") as NumberOfIncidents
from WorkplaceSafetyData
where "incident type" = 'Falling Object'
group by 
	"age group",
	"incident type"
order by NumberOfIncidents desc
