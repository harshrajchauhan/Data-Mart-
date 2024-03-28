create database usjobs;
use  usjobs;
create schema usjobs;



--creation of the Applicant_Hired Table

create table usjobs.Applicant_Hired(
    aid  INT IDENTITY(1,1) NOT NULL primary key,
    firstname varchar(50),
    lastname varchar(50),
    internalposting varchar(50),
    externalposting varchar(50),
    applicantdob date,
    salary float,
    experience varchar(20),
    noticeperiod int,
    bonusamt float
    );


----create table query for the  NYC_Jobs  table

create table usjobs.NYC_Jobs(
    [sid] int identity(1,1) not null primary key,
    [JobID] NVARCHAR(max) NOT NULL,
    [Agency] [nvarchar](max) NOT NULL,
    [BusinessTitle] [nvarchar](max) NOT NULL ,
    [CivilServiceTitle] [nvarchar](max) NOT NULL ,
    [TitleClassification] [nvarchar](max) NOT NULL,
    [TitleCodeNo] [nvarchar](max) NOT NULL ,
    [Level] [nvarchar](max) NOT NULL,
    [JobCategory] [nvarchar](max) NOT NULL,
    [CareerLevel] [nvarchar](max) NOT NULL,
    [SalaryFrequency] [nvarchar](max) NOT NULL,
    [FullTimePartTimeindicator] [nvarchar](max) NULL,
    [WorkLocation] NVARCHAR(max) NOT NULL,
    [DivisionWorkUnit] [nvarchar](max) NOT NULL ,
    [WorkLocation1] [nvarchar](max) NULL,
    [MinimumQualRequirements] [nvarchar](max) NULL,
    [PreferredSkills] [nvarchar](max) NULL,
    [AdditionalInformation] [nvarchar](max) NULL,
    [ToApply]  NVARCHAR(max) NULL,
    [HoursShift] [nvarchar](max) NULL,
    [ResidencyRequirement] [nvarchar](max) NOT NULL,
    [PostingDate] DATE  NOT NULL,
    [PostUntil] [nvarchar](max) NULL,
    [PostingUpdated] [date] NOT NULL,
    [ProcessDate] [date] NOT NULL,
    [PostingType] [nvarchar](max) NOT NULL,
    [RecruitmentContact] [nvarchar](max) NULL,
    [SalaryRangeFrom] [float] NOT NULL,
    [SalaryRangeTo] [float] NOT NULL,
    [OfPositions] [int] NOT NULL,
        [aid] int not null Foreign key REFERENCES usjobs.Applicant_Hired(aid)
);

--creation of data mart for NYC_Jobs using Dimension and Fact Tables.

-- DimApplicantDetails
CREATE TABLE usjobs.DimApplicantDetails (
   ApplicantDetailsid int identity(1,1) not null PRIMARY KEY,
    firstname NVARCHAR(max),
    lastname NVARCHAR(max),
    applicantdob date,
    experience varchar(20)
    
);

-- DimApplicantPosting
CREATE TABLE usjobs.DimApplicantPosting (
    ApplicantPostingid int identity(1,1) not null PRIMARY KEY,
    internalposting varchar(50),
    externalposting varchar(50),
    
);




-- DimJobDetails
CREATE TABLE usjobs.DimJobDetails (
    JobDetailsID int identity(1,1) not null PRIMARY KEY,
    JobID NVARCHAR(max),
    RecruitmentContact NVARCHAR(max),
    Agency NVARCHAR(max)
    
);

--DimJobTitle
    CREATE TABLE usjobs.DimJobTitle(
    JobTitleID int identity(1,1) not null Primary key,
    BusinessTitle NVARCHAR(max),
    CivilServiceTitle NVARCHAR(max),
    TitleClassification NVARCHAR(max),
    TitleCodeNo NVARCHAR(max)

    );

--DimJobCharacteristics

    CREATE TABLE usjobs.DimJobCharacteristics(
    JobCharID int identity(1,1) not null primary key,
    Level NVARCHAR(max),
    JobCategory NVARCHAR(max),
    CareerLevel NVARCHAR(max),
    SalaryFrequency NVARCHAR(max),
    FullTimePartTimeindicator NVARCHAR(max)
);


-- DimJobLocation
CREATE TABLE usjobs.DimJobLocation (
    JobLocationID INT identity(1,1) not null PRIMARY KEY,
    WorkLocation NVARCHAR(max),
    DivisionWorkUnit NVARCHAR(max),
    WorkLocation1 NVARCHAR(max)
);
-- DimJobDescription
CREATE TABLE usjobs.DimJobDescription (
    JobDescriptionID INT identity(1,1) not null  PRIMARY KEY,
    MinimumQualRequirements NVARCHAR(max),
    PreferredSkills NVARCHAR(max),
    AdditionalInformation NVARCHAR(max)
    JobDescription nvarchar(max)
);

-- DimApplicationDetails
CREATE TABLE usjobs.DimApplicationDetails (
    DetailsID INT identity(1,1) not null  PRIMARY KEY,
    ToApply  NVARCHAR(max),
    HoursShift NVARCHAR(max),
    ResidencyRequirement NVARCHAR(max)
);

-- DimPosting
CREATE TABLE usjobs.DimPosting (
    PostingID INT identity(1,1) not null  PRIMARY KEY,
    PostingDate DATE,
    PostUntil DATE,
    PostingUpdated DATE,
    ProcessDate DATE,
    PostingType NVARCHAR(max),
    
);



-- Create FactJobMeasures (Fact Table)
CREATE TABLE usjobs.FactJobMeasures (
    FactID INT identity(1,1) not null PRIMARY KEY,
    ApplicantDetailsid int ,
    ApplicantPostingid int,
    JobDetailsID INT,
    JobTitleID INT,
    JobCharID INT,
    JobLocationID INT,
    JobDescriptionID INT,
    DetailsID INT,
    PostingID INT,
    OfPositions INT,
    SalaryRangeFrom float,
    SalaryRangeTo float,
    salary float,
    noticeperiod int,
    bonusamt float,

    FOREIGN KEY (ApplicantDetailsid) REFERENCES usjobs.DimApplicantDetails(ApplicantDetailsid),
    FOREIGN KEY (ApplicantPostingid) REFERENCES usjobs.DimApplicantPosting(ApplicantPostingid),
    FOREIGN KEY (JobDetailsID) REFERENCES usjobs.DimJobDetails(JobDetailsID),
    FOREIGN KEY (JobTitleID) REFERENCES usjobs.DimJobTitle(JobTitleID),
    FOREIGN KEY (JobCharID) REFERENCES usjobs.DimJobCharacteristics(JobCharID),
    FOREIGN KEY (JobLocationID) REFERENCES usjobs.DimJobLocation(JobLocationID),
    FOREIGN KEY (JobDescriptionID) REFERENCES usjobs.DimJobDescription(JobDescriptionID),
    FOREIGN KEY (DetailsID) REFERENCES usjobs.DimApplicationDetails(DetailsID),
    FOREIGN KEY (PostingID) REFERENCES usjobs.DimPosting(PostingID),
);





--creating the staging table

CREATE TABLE [usjobs].[StagingJobs](
    Staging_id int not null IDENTITY(1,1) PRIMARY KEY,
    aid int not null,
    sid int not null,
    ApplicantDetailsid int  null,
    firstname NVARCHAR(max) not null,
    lastname NVARCHAR(max) not null,
    applicantdob date,
    experience varchar(20),
    ApplicantPostingid int  not null ,
    internalposting varchar(50) not null,
    externalposting varchar(50) not null,
    [JobDetailsID] int not null ,
    [JobID] NVARCHAR(max) NOT NULL,
    [Agency] [nvarchar](max) NOT NULL,
    [JobTitleID] INT not null,
    [BusinessTitle] [nvarchar](max) NOT NULL ,
    [CivilServiceTitle] [nvarchar](max) NOT NULL ,
    [TitleClassification] [nvarchar](max) NOT NULL,
    [TitleCodeNo] [nvarchar](max) NOT NULL ,
    [JobCharID] INT not null,
    [Level] [nvarchar](max) NOT NULL,
    [JobCategory] [nvarchar](max) NOT NULL,
    [CareerLevel] [nvarchar](max) NOT NULL,
    [SalaryFrequency] [nvarchar](max) NOT NULL,
    [FullTimePartTimeindicator] [nvarchar](max) NULL,
    [JobLocationID] INT not null,
    [WorkLocation] NVARCHAR(max) NOT NULL,
    [DivisionWorkUnit] [nvarchar](max) NOT NULL ,
    [WorkLocation1] [nvarchar](max) NULL,
    [JobDescriptionID] [int] NOT NULL,
    [MinimumQualRequirements] [nvarchar](max) NULL,
    [PreferredSkills] [nvarchar](max) NULL,
    [AdditionalInformation] [nvarchar](max) NULL,
    [DetailsID] INT not null ,
    [ToApply]  NVARCHAR(max) NULL,
    [HoursShift] [nvarchar](max) NULL,
    [ResidencyRequirement] [nvarchar](max) NOT NULL,
    [PostingID] INT not null ,
    [PostingDate] DATE  NOT NULL,
    [PostUntil] [nvarchar](max) NULL,
    [PostingUpdated] [date] NOT NULL,
    [ProcessDate] [date] NOT NULL,
    [PostingType] [nvarchar](max) NOT NULL,
    [RecruitmentContact] [nvarchar](max) NULL,
    [SalaryRangeFrom] [float] NOT NULL,
    [SalaryRangeTo] [float] NOT NULL,
    [OfPositions] [int] NOT NULL,
    salary float,
    noticeperiod int,
    bonusamt float,
    JobDescription nvarchar(max)
    
);