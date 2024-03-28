
--Business Question1:  for all agencies in the table, what is the  max  SalaryRangeFrom(Starting Salary)?
SELECT
    DimJobDetails.Agency AS Agency,
    MAX(FactJobMeasures.SalaryRangeFrom) AS MaxStartingSalary
FROM usjobs.FactJobMeasures
JOIN usjobs.DimJobDetails ON FactJobMeasures.JobDetailsID = DimJobDetails.JobDetailsID
GROUP BY DimJobDetails.Agency
order by DimJobDetails.Agency asc


--Business Question2: What is the average salary range for jobs in different work location?


SELECT
    jl.WorkLocation AS WorkLocation,
    AVG(fjm.SalaryRangeFrom) AS AverageSalaryRangeFrom,
    AVG(fjm.SalaryRangeTo) AS AverageSalaryRangeTo
FROM usjobs.FactJobMeasures fjm
JOIN usjobs.DimJobLocation jl ON fjm.JobLocationID = jl.JobLocationID
GROUP BY jl.WorkLocation
ORDER BY jl.WorkLocation;



