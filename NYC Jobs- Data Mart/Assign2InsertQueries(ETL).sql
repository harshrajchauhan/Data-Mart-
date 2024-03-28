--Inserting the records into staging table from the NYCJobs.CSV, Applicant_Hired.CSV (Source table) which was imported into Azure Data Studio(jobspr.NYC_Dummy) using Import Wizard

INSERT INTO usjobs.StagingJobs (  
    
    aid ,
    sid ,
    firstname,
    lastname ,
    applicantdob ,
    experience ,
    internalposting ,
    externalposting ,
    [JobID] ,
    [Agency] ,
    [BusinessTitle]  ,
    [CivilServiceTitle] ,
    [TitleClassification] ,
    [TitleCodeNo]  ,
    [Level] ,
    [JobCategory] ,
    [CareerLevel] ,
    [SalaryFrequency] ,
    [FullTimePartTimeindicator] ,
    [WorkLocation] ,
    [DivisionWorkUnit]  ,
    [WorkLocation1] ,
    [MinimumQualRequirements] ,
    [PreferredSkills] ,
    [AdditionalInformation] ,
    [ToApply]  ,
    [HoursShift] ,
    [ResidencyRequirement] ,
    [PostingDate] ,
    [PostUntil] ,
    [PostingUpdated] ,
    [ProcessDate] ,
    [PostingType] ,
    [RecruitmentContact] ,
    [SalaryRangeFrom] ,
    [SalaryRangeTo] ,
    [OfPositions] ,
    salary ,
    noticeperiod ,
    bonusamt ,
    JobDescription


    

    
)
    SELECT  

    usjobs.Applicant_Hired.aid ,
    usjobs.NYC_Jobs.sid ,

    usjobs.Applicant_Hired.firstname,
    usjobs.Applicant_Hired.lastname ,
    usjobs.Applicant_Hired.applicantdob ,
    usjobs.Applicant_Hired.experience ,

    usjobs.Applicant_Hired.internalposting ,
    usjobs.Applicant_Hired.externalposting ,

    usjobs.NYC_Jobs.[JobID] ,
    usjobs.NYC_Jobs.[Agency] ,

    usjobs.NYC_Jobs.[BusinessTitle]  ,
    usjobs.NYC_Jobs.[CivilServiceTitle] ,
    usjobs.NYC_Jobs.[TitleClassification] ,
    usjobs.NYC_Jobs.[TitleCodeNo]  ,

    usjobs.NYC_Jobs.[Level] ,
    usjobs.NYC_Jobs.[JobCategory] ,
    usjobs.NYC_Jobs.[CareerLevel] ,
    usjobs.NYC_Jobs.[SalaryFrequency] ,
    usjobs.NYC_Jobs.[FullTimePartTimeindicator] ,

    usjobs.NYC_Jobs.[WorkLocation] ,
    usjobs.NYC_Jobs.[DivisionWorkUnit]  ,
    usjobs.NYC_Jobs.[WorkLocation1] ,

    usjobs.NYC_Jobs.[MinimumQualRequirements] ,
    usjobs.NYC_Jobs.[PreferredSkills] ,
    usjobs.NYC_Jobs.[AdditionalInformation] ,

    usjobs.NYC_Jobs.[ToApply]  ,
    usjobs.NYC_Jobs.[HoursShift] ,
    usjobs.NYC_Jobs.[ResidencyRequirement] ,
    
    usjobs.NYC_Jobs.[PostingDate] ,
    usjobs.NYC_Jobs.[PostUntil] ,
    usjobs.NYC_Jobs.[PostingUpdated] ,
    usjobs.NYC_Jobs.[ProcessDate] ,
    usjobs.NYC_Jobs.[PostingType] ,
    usjobs.NYC_Jobs.[RecruitmentContact] ,
    usjobs.NYC_Jobs.[SalaryRangeFrom] ,
    usjobs.NYC_Jobs.[SalaryRangeTo] ,
    usjobs.NYC_Jobs.[OfPositions] ,
    usjobs.Applicant_Hired.salary ,
    usjobs.Applicant_Hired.noticeperiod ,
    usjobs.Applicant_Hired.bonusamt ,
    usjobs.NYC_Jobs.JobDescription
    FROM usjobs.NYC_Jobs JOIN usjobs.Applicant_Hired 
    ON usjobs.NYC_Jobs.aid = usjobs.Applicant_Hired.aid;


-- Insert data into DimApplicantDetails  from the staging table

INSERT INTO usjobs.DimApplicantDetails (firstname,lastname, applicantdob,experience )
SELECT distinct firstname,lastname, applicantdob,experience 
FROM usjobs.StagingJobs
order by [experience] asc;

-- UPDATE ApplicantDetailsid in Staging table
UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.ApplicantDetailsid = usjobs.DimApplicantDetails.ApplicantDetailsid
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimApplicantDetails ON 
usjobs.StagingJobs.[experience] = usjobs.DimApplicantDetails.[experience];


-- Insert data into DimApplicantPosting  from the staging table
INSERT INTO usjobs.DimApplicantPosting(internalposting, externalposting)
SELECT distinct internalposting, externalposting
FROM usjobs.StagingJobs
order by [internalposting] asc;

-- UPDATE ApplicantPostingid in Staging table

UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.ApplicantPostingid = usjobs.DimApplicantPosting.ApplicantPostingid
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimApplicantPosting ON 
usjobs.StagingJobs.[internalposting] = usjobs.DimApplicantPosting.[internalposting];



-- Insert data into DimJobDetails  from the staging table
INSERT INTO usjobs.DimJobDetails (JobID, RecruitmentContact, Agency)
SELECT distinct JobID, RecruitmentContact, Agency
FROM usjobs.StagingJobs
order by [JobID] asc;


-- UPDATE JobDetailsID in Staging table

UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.JobDetailsID = usjobs.DimJobDetails.JobDetailsID
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimJobDetails ON 
usjobs.StagingJobs.[JobID] = usjobs.DimJobDetails.[JobID];

-- Insert data into DimJobTitle  from the staging table

INSERT INTO usjobs.DimJobTitle (BusinessTitle,CivilServiceTitle, TitleClassification,TitleCodeNo )
SELECT distinct BusinessTitle,CivilServiceTitle, TitleClassification,TitleCodeNo 
FROM usjobs.StagingJobs
order by [TitleCodeNo] asc;

-- UPDATE JobTitleID in Staging table
UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.JobTitleID = usjobs.DimJobTitle.JobTitleID
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimJobTitle ON 
usjobs.StagingJobs.[TitleCodeNo] = usjobs.DimJobTitle.[TitleCodeNo];


-- Insert data into DimJobCharacteristics  from the staging table
INSERT INTO usjobs.DimJobCharacteristics(Level, JobCategory, CareerLevel, SalaryFrequency, FullTimePartTimeindicator)
SELECT distinct Level, JobCategory, CareerLevel, SalaryFrequency, FullTimePartTimeindicator
FROM usjobs.StagingJobs
order by [Level] asc;

-- UPDATE JobCharID in Staging table

UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.JobCharID = usjobs.DimJobCharacteristics.JobCharID
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimJobCharacteristics ON 
usjobs.StagingJobs.[Level] = usjobs.DimJobCharacteristics.[Level];


-- Insert data into DimJobLocation from the staging table
INSERT INTO usjobs.DimJobLocation (WorkLocation, DivisionWorkUnit, WorkLocation1)
SELECT distinct WorkLocation, DivisionWorkUnit, WorkLocation1
FROM usjobs.StagingJobs
order by [WorkLocation] asc;

-- UPDATE JobLocationID in Staging table

UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.JobLocationID = usjobs.DimJobLocation.JobLocationID
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimJobLocation ON 
usjobs.StagingJobs.[WorkLocation] = usjobs.DimJobLocation.[WorkLocation];


-- Insert data into DimJobDescription from the staging table
INSERT INTO usjobs.DimJobDescription (MinimumQualRequirements, PreferredSkills, AdditionalInformation,JobDescription)
SELECT distinct MinimumQualRequirements, PreferredSkills, AdditionalInformation,JobDescription
FROM usjobs.StagingJobs
order by MinimumQualRequirements asc;

-- UPDATE JobDescriptionID in Staging table

UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.JobDescriptionID = usjobs.DimJobDescription.JobDescriptionID
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimJobDescription ON 
usjobs.StagingJobs.[MinimumQualRequirements] = usjobs.DimJobDescription.[MinimumQualRequirements];



-- Insert data into DimApplicationDetails from the staging table
INSERT INTO usjobs.DimApplicationDetails (ToApply, HoursShift, ResidencyRequirement)
SELECT distinct ToApply, HoursShift, ResidencyRequirement
FROM usjobs.StagingJobs
order by [HoursShift] asc;

-- UPDATE DetailsID in Staging table

UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.DetailsID = usjobs.DimApplicationDetails.DetailsID
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimApplicationDetails ON 
usjobs.StagingJobs.[ToApply] = usjobs.DimApplicationDetails.[ToApply];


-- Insert data into DimPostingDates  from the staging table
INSERT INTO usjobs.DimPosting (PostingDate, PostUntil, PostingUpdated, ProcessDate, PostingType )
SELECT distinct PostingDate, PostUntil, PostingUpdated, ProcessDate,PostingType 
FROM usjobs.StagingJobs
order by [PostingDate] asc;

-- UPDATE PostingID in Staging table

UPDATE usjobs.StagingJobs
SET usjobs.StagingJobs.PostingID = usjobs.DimPosting.PostingID
FROM usjobs.StagingJobs
INNER JOIN usjobs.DimPosting ON 
usjobs.StagingJobs.[PostingDate] = usjobs.DimPosting.[PostingDate];




----Inserting into Fact Table from Staging

INSERT INTO usjobs.FactJobMeasures 
    (
        ApplicantDetailsid,
    ApplicantPostingid,
    JobDetailsID ,
    JobTitleID ,
    JobCharID ,
    JobLocationID ,
    JobDescriptionID ,
    DetailsID ,
    PostingID ,
    OfPositions ,
    SalaryRangeFrom ,
    SalaryRangeTo,
    salary ,
    noticeperiod ,
    bonusamt 
      )

		   SELECT
           
     ApplicantDetailsid,
    ApplicantPostingid,
    JobDetailsID ,
    JobTitleID ,
    JobCharID ,
    JobLocationID ,
    JobDescriptionID ,
    DetailsID ,
    PostingID ,
    OfPositions ,
    SalaryRangeFrom ,
    SalaryRangeTo,
    salary ,
    noticeperiod ,
    bonusamt 
		  FROM usjobs.StagingJobs;


