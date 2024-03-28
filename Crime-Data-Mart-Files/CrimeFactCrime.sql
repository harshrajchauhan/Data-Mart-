USE [Crime]
GO

/****** Object:  Table [Crime].[FactCrime]    Script Date: 2/3/2015 11:04:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Crime].[FactCrime](
	[CrimeID] [int] IDENTITY(1,1) NOT NULL,
	[Source_RowID] [int] NULL,
	[CityID] [int] NULL,
	[YearID] [int] NULL,
	[Population] [int] NULL,
	[ViolentCrime] [int] NULL,
	[MurderAndNonEgligentManslaughter] [int] NULL,
	[ForcibleRape] [int] NULL,
	[Robbery] [int] NULL,
	[AggravatedAssault] [int] NULL,
	[PropertyCrime] [int] NULL,
	[Buglary] [int] NULL,
	[LarcenyTheft] [int] NULL,
	[MotorVehicleTheft] [int] NULL,
	[Arson] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CrimeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Crime].[FactCrime]  WITH CHECK ADD  CONSTRAINT [FK_CityID] FOREIGN KEY([CityID])
REFERENCES [Crime].[DimCity] ([CityID])
GO

ALTER TABLE [Crime].[FactCrime] CHECK CONSTRAINT [FK_CityID]
GO

ALTER TABLE [Crime].[FactCrime]  WITH CHECK ADD  CONSTRAINT [FK_YearID] FOREIGN KEY([YearID])
REFERENCES [Crime].[DimYear] ([YearID])
GO

ALTER TABLE [Crime].[FactCrime] CHECK CONSTRAINT [FK_YearID]
GO


