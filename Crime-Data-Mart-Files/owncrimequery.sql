create database Crime;
create schema Crime;



select FCrime.ViolentCrime,
DYear.Year,
DCity.City
from Crime.FactCrime AS FCrime
inner join Crime.DimYear as DYear on FCrime.YearID = DYear.YearID
inner join Crime.DimCity as DCity on FCrime.CityID = DCity.CityID
where DYear.Year = '2007' and DCity.City = 'Tampa'

--what robberies occured on chinese new year in the state of florida


SELECT 
    DSTATE.State,
    SUM(FCRIME.Robbery) AS TOTALROBERY
FROM Crime.FactCrime AS FCRIME
INNER JOIN Crime.DimYear AS DYEAR ON FCRIME.YearID = DYEAR.YearID
INNER JOIN Crime.DimCity AS DCITY on FCRIME.CityID = DCITY.CityID
INNER JOIN Crime.DimState AS DSTATE on DSTATE.StateID = DCITY.StateID
WHERE DYEAR.ChineseNewYear = 'YES' AND DSTATE.State = 'Florida'
GROUP BY DSTATE.State
ORDER BY TOTALROBERY ASC
--another way to do this:
/*
USE [Crime]
GO

-- Find the YearID for Chinese New Year
DECLARE @ChineseNewYearYearID INT

SELECT @ChineseNewYearYearID = [YearID]
FROM [Crime].[DimYear]
WHERE [ChineseNewYear] = 'Yes' 

-- Find the StateID for Florida
DECLARE @FloridaStateID INT

SELECT @FloridaStateID = [StateID]
FROM [Crime].[DimState]
WHERE [State] = 'Florida'

-- Retrieve the robberies data for Chinese New Year in Florida
SELECT
    [City].[City] AS [City],
    [FactCrime].[Robbery] AS [RobberyCount]
FROM [Crime].[FactCrime]
JOIN [Crime].[DimCity] AS [City] ON [FactCrime].[CityID] = [City].[CityID]

*/

--which city has the top crime rate? crime rate =aggregation of all crimes
USE [Crime]
GO

-- Calculate the total crime rate for each city
--the top one would be our desired city
SELECT 
    TOP(1)
    DCITY.City,
    SUM(FCRIME.ViolentCrime + FCRIME.MurderAndNonEgligentManslaughter + FCRIME.ForcibleRape + FCRIME.Robbery +
    FCRIME.AggravatedAssault + FCRIME.PropertyCrime + FCRIME.Buglary + FCRIME.LarcenyTheft + FCRIME.MotorVehicleTheft + FCRIME.Arson)
    AS TOTALCRIME 
FROM Crime.DimCity AS DCITY
INNER JOIN Crime.FactCrime AS FCRIME ON FCRIME.CityID = DCITY.CityID
GROUP BY DCITY.City
ORDER BY TOTALCRIME DESC;


--which state has the lowest crime? crime = all 10 crimes
USE [Crime]
GO

-- Calculate the total crime rate for each state
--the top one value would be our desired state
SELECT 
    TOP (1)
    DSTATE.State,
    SUM(FCRIME.ViolentCrime + FCRIME.MurderAndNonEgligentManslaughter + FCRIME.ForcibleRape + FCRIME.Robbery +
    FCRIME.AggravatedAssault + FCRIME.PropertyCrime + FCRIME.Buglary + FCRIME.LarcenyTheft + FCRIME.MotorVehicleTheft + FCRIME.Arson)
    AS TOTALCRIME 
FROM Crime.DimState AS DSTATE
INNER JOIN Crime.DimCity AS DCITY ON DSTATE.StateID = DCITY.StateID
INNER JOIN Crime.FactCrime AS FCRIME ON FCRIME.CityID = DCITY.CityID
GROUP BY DSTATE.State
ORDER BY TOTALCRIME ASC;


--which cities have high population and are high in arson?
--Define: high population = greater than 1,000,000
--Define: high arson =  greater than 100




select DCITY.City,
FCrime.Population,
FCrime.Arson
from Crime.DimCity as DCITY
inner join Crime.FactCrime as FCrime on FCrime.CityID = DCity.CityID
where FCrime.Population > 1000000 and FCrime.Arson > 100
order by FCrime.Population desc