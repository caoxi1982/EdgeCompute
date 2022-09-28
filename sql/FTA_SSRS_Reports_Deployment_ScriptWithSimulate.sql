SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
USE "AlarmEvent"
--***********************************************
--Create simulateMap table for grafana
--***********************************************
CREATE TABLE [dbo].[SimulateMap](
	[City] [nvarchar](100) NOT NULL,
	[Latitude] [decimal](13, 10) NOT NULL,
	[Longitude] [decimal](13, 10) NOT NULL,
	[OEE] [decimal](6, 3) NOT NULL,
	[Volume] [int] NOT NULL,
	[timestamp] [datetime] NULL,
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[Availability] [decimal](6, 3) NULL,
	[SafetyDayLost] [int] NULL,
	[Training] [decimal](6, 3) NULL,
	[PowerConsumption] [decimal](15, 3) NULL,
	[GasConsumption] [decimal](15, 3) NULL,
	[Performance] [decimal](6, 3) NULL,
	[Quality] [decimal](6, 3) NULL,
	[SafetyRunningDays] [int] NULL,
 CONSTRAINT [PK_SimulateMap] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('BeiJing',39.8949000000,116.3220000000,78.500,1000,'2022-08-25 00:00:00.000',2,98.000,0,60.000,345.000,23.400,67.000,94.000)
INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('ShangHai',31.2305200000,121.4736670000,67.300,800,'2022-08-25 00:00:00.000',8,78.000,0,56.700,305.800,15.700,65.000,81.000)
INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('ChengDu',30.5729600000,104.0663010000,83.900,1200,'2022-08-25 00:00:00.000',9,99.000,1,87.500,360.700,34.000,78.000,93.000)
INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('ChongQing',29.5637000000,106.5504830000,66.000,700,'2022-08-25 00:00:00.000',10,85.000,0,45.900,300.900,17.400,62.000,91.000)
INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('JiNan',36.6520690000,117.1201280000,82.100,1467,'2022-08-25 00:00:00.000',11,99.000,0,23.500,401.200,30.800,83.000,97.000)
INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('WeiHai',37.5133150000,122.1205190000,83.100,1578,'2022-08-25 00:00:00.000',12,99.000,0,65.900,411.000,28.800,85.000,99.000)
INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('ShenYang',41.6775760000,123.4646750000,65.700,632,'2022-08-25 00:00:00.00',13,82.500,1,56.800,200.800,13.800,67.000,91.000)
INSERT INTO [dbo].[SimulateMap]
           ([City],[Latitude],[Longitude],[OEE],[Volume],[timestamp],[Availability],[SafetyDayLost],[Training],[PowerConsumption],[GasConsumption],[Performance],[Quality],[SafetyRunningDays])
     VALUES
           ('JiangYin',31.9216420000,120.2847940000,52.000,240,'2022-08-25 00:00:00.000',14,60.000,0,98.800,210.900,14.600,73.000,92.000)

GO
--***********************************************
--Remove old reporting content
--***********************************************

IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpAllAlarmsEventsHistory' and xtype='V') DROP VIEW vpAllAlarmsEventsHistory


DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpDateTimeToTicks' and xtype='FN') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpDateTimeToTicks' and sys.objects.type='FN')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpDateTimeToTicks')
		EXEC (@DropFunctionName)
	END
GO

DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpDateTimeToTicks' and xtype='FN') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpDateTimeToTicks' and sys.objects.type='FN')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpDateTimeToTicks')
		EXEC (@DropFunctionName)
	END
GO

DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpDateToTicks' and xtype='FN') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpDateToTicks' and sys.objects.type='FN')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpDateToTicks')
		EXEC (@DropFunctionName)
	END
GO

DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpTimeToTicks' and xtype='FN') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpTimeToTicks' and sys.objects.type='FN')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpTimeToTicks')
		EXEC (@DropFunctionName)
	END
GO


DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpMonthToDays' and xtype='FN') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpMonthToDays' and sys.objects.type='FN')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpMonthToDays')
		EXEC (@DropFunctionName)
	END
GO


DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpFormatDate' and xtype='FN') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpFormatDate' and sys.objects.type='FN')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpFormatDate')
		EXEC (@DropFunctionName)
	END
GO

DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetFenceposts' and xtype='IF') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetFenceposts' and sys.objects.type='IF')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpGetFenceposts')
		EXEC (@DropFunctionName)
	END
GO


DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetStartEndTicks' and xtype='IF') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetStartEndTicks' and sys.objects.type='IF')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpGetStartEndTicks')
		EXEC (@DropFunctionName)
	END
GO

DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpSplitDelimitedParameters' and xtype='TF') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSplitDelimitedParameters' and sys.objects.type='TF')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpSplitDelimitedParameters')
		EXEC (@DropFunctionName)
	END
GO



DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT * from ..sysobjects WHERE name=N'vpSSRSParameterParser' and xtype='TF') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSParameterParser' and sys.objects.type='TF')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpSSRSParameterParser')
		EXEC (@DropFunctionName)
	END
GO

DECLARE @UserFunctionName AS Varchar(60)
DECLARE @DropFunctionName as Varchar(100)
IF EXISTS (SELECT * from ..sysobjects WHERE name=N'vpSSRSTrimAlarmName' and xtype='FN') 
	BEGIN
		Set @UserFunctionName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTrimAlarmName' and sys.objects.type='FN')
		Set @DropFunctionName=('Drop Function ' + @UserFunctionName +'.vpSSRSTrimAlarmName')
		EXEC (@DropFunctionName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSDisabledAlarms' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSDisabledAlarms' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSDisabledAlarms')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSDuration_Total' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSDuration_Total' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSDuration_Total')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSFrequency_Total' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSFrequency_Total' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSFrequency_Total')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSGetAllEventsInTimePeriod' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSGetAllEventsInTimePeriod' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSGetAllEventsInTimePeriod')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSGetAllEventsTriggeredInTimePeriod' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSGetAllEventsTriggeredInTimePeriod' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSGetAllEventsTriggeredInTimePeriod')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSHourly_Duration' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSHourly_Duration' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSHourly_Duration')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSHourly_Frequency' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSHourly_Frequency' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSHourly_Frequency')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSMaintAlarmFaults' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSMaintAlarmFaults' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSMaintAlarmFaults')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSMaintControllerEvents' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSMaintControllerEvents' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSMaintControllerEvents')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSShelvedAlarms' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSShelvedAlarms' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSShelvedAlarms')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSStaleAlarms' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSStaleAlarms' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSStaleAlarms')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopShelved_Duration' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopShelved_Duration' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopShelved_Duration')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopShelved_Frequency' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopShelved_Frequency' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopShelved_Frequency')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSSuppressedAlarms' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSSuppressedAlarms' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSSuppressedAlarms')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopDisabled_Duration' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopDisabled_Duration' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopDisabled_Duration')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopDisabled_Frequency' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopDisabled_Frequency' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopDisabled_Frequency')
		EXEC (@DropProcedureName)
	END
GO


DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopDuration' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopDuration' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopDuration')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopFrequency' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopFrequency' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopFrequency')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopSuppressed_Duration' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopSuppressed_Duration' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopSuppressed_Duration')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopSuppressed_Frequency' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopSuppressed_Frequency' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopSuppressed_Frequency')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopTimeToAck' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopTimeToAck' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopTimeToAck')
		EXEC (@DropProcedureName)
	END
GO


DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSTopUnack' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSTopUnack' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSTopUnack')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSGetAllEventsInTimePeriodbyClass' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSGetAllEventsInTimePeriodbyClass' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSGetAllEventsInTimePeriodbyClass')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSEventAssociationIDHistory' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSEventAssociationIDHistory' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSEventAssociationIDHistory')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT xtype from ..sysobjects WHERE name=N'vpSSRSGetAllEventsInTimePeriod_Stale' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpSSRSGetAllEventsInTimePeriod_Stale' and sys.objects.type='P')
		Set @DropProcedureName=('Drop Procedure ' + @UserProcedureName +'.vpSSRSGetAllEventsInTimePeriod_Stale')
		EXEC (@DropProcedureName)
	END
GO

IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpDateParts' and xtype='U') DROP TABLE vpDateParts
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpEventTypes' and xtype='U') DROP TABLE vpEventTypes
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpPriorities' and xtype='U') DROP TABLE vpPriorities
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpRowNums' and xtype='U') DROP TABLE vpRowNums

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpEventConditionHistory' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpEventConditionHistory' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpEventConditionHistory')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpEventConditionLive' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpEventConditionLive' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpEventConditionLive')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpEventConditionPointInTime' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpEventConditionPointInTime' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpEventConditionPointInTime')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetAllEvents' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetAllEvents' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetAllEvents')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetCountOfAllOccurrences' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetCountOfAllOccurrences' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetCountOfAllOccurrences')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetDateParts' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetDateParts' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetDateParts')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetEventTypes' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetEventTypes' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetEventTypes')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetPriorities' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetPriorities' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetPriorities')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetUniqueCountOfAllOccurrences' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetUniqueCountOfAllOccurrences' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetUniqueCountOfAllOccurrences')
		EXEC (@DropProcedureName)
	END
GO


DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetUniqueEventNames' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetUniqueEventNames' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetUniqueEventNames')
		EXEC (@DropProcedureName)
	END
GO


DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetUniqueEventNamesByArea' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetUniqueEventNamesByArea' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetUniqueEventNamesByArea')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetUniqueNetworkNames' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetUniqueNetworkNames' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetUniqueNetworkNames')
		EXEC (@DropProcedureName)
	END
GO


DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetVersion' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetVersion' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetVersion')
		EXEC (@DropProcedureName)
	END
GO


DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpGetAllEventsInTimePeriod' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpGetAllEventsInTimePeriod' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpGetAllEventsInTimePeriod')
		EXEC (@DropProcedureName)
	END
GO

DECLARE @UserProcedureName AS Varchar(60)
DECLARE @DropProcedureName as Varchar(100)
IF EXISTS (SELECT name from ..sysobjects WHERE name=N'vpEventPareto' and xtype='P') 
	BEGIN
		Set @UserProcedureName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'vpEventPareto' and sys.objects.type='P')
		Set @DropProcedureName=('Drop PROCEDURE ' + @UserProcedureName +'.vpEventPareto')
		EXEC (@DropProcedureName)
	END
GO


IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms1' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms1
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms2' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms2
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms3' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms3
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms4' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms4
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms5' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms5
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms6' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms6
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms7' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms7
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms8' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms8
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms9' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms9
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms10' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms10
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms11' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms11
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms12' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms12
END
GO

IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms13' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms13
END
GO


IF EXISTS (SELECT name from sysindexes WHERE name=N'idx_vpSSRSAlarms14' and id=(Select id from sysobjects where name=N'AllEvent' and Type='U'))
BEGIN
DROP INDEX AllEvent.idx_vpSSRSAlarms14
END
GO


--***********************************************
--END Old Content Removal Section
--***********************************************

--***********************************************
--Create NEW indexes
--***********************************************
SET ANSI_PADDING ON


CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms1] ON [dbo].[AllEvent]
(
	[EventAssociationID] ASC,
	[EventTimeStamp] ASC,
	[SourceName] ASC,
	[ConditionName] ASC,
	[ServerName] ASC,
	[Active] ASC,
	[ChangeMask] ASC,
	[Acked] ASC,
	[Suppressed] ASC,
	[Disabled] ASC,
	[Shelved] ASC
)
INCLUDE ( 	[Severity],
	[Priority],
	[Message],
	[AlarmClass],
	[InputValue],
	[LimitValue],
	[Tag1Value],
	[Tag2Value],
	[Tag3Value],
	[Tag4Value]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

	GO



CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms2] ON [dbo].[AllEvent]
(
	[ServerName] ASC,
	[EventTimeStamp] ASC,
	[Active] ASC,
	[ChangeMask] ASC,
	[SourceName] ASC,
	[ConditionName] ASC,
	[EventAssociationID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms3] ON [dbo].[AllEvent]
(
	[SourceName] ASC,
	[ServerName] ASC,
	[EventTimeStamp] ASC,
	[Active] ASC,
	[ChangeMask] ASC,
	[EventAssociationID] ASC,
	[ConditionName] ASC,
	[Acked] ASC
)
INCLUDE ( 	[TicksTimeStamp]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms4] ON [dbo].[AllEvent]
(
	[SourceName] ASC,
	[ServerName] ASC,
	[EventTimeStamp] ASC,
	[Active] ASC,
	[ChangeMask] ASC,
	[EventAssociationID] ASC,
	[ConditionName] ASC,
	[Acked] ASC,
	[Suppressed] ASC
)
INCLUDE ( 	[TicksTimeStamp]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms5] ON [dbo].[AllEvent]
(
	[SourceName] ASC,
	[ServerName] ASC,
	[EventTimeStamp] ASC,
	[Active] ASC,
	[ChangeMask] ASC,
	[EventAssociationID] ASC,
	[ConditionName] ASC,
	[Acked] ASC,
	[Suppressed] ASC,
	[Disabled] ASC
)
INCLUDE ( 	[TicksTimeStamp]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms6] ON [dbo].[AllEvent]
(
	[SourceName] ASC,
	[ServerName] ASC,
	[EventTimeStamp] ASC,
	[Active] ASC,
	[ChangeMask] ASC,
	[EventAssociationID] ASC,
	[ConditionName] ASC,
	[Acked] ASC,
	[Suppressed] ASC,
	[Disabled] ASC,
	[Shelved] ASC
)
INCLUDE ( 	[TicksTimeStamp]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms7] ON [dbo].[AllEvent]
(
	[Active] ASC,
	[SourceName] ASC,
	[ServerName] ASC,
	[EventTimeStamp] ASC,
	[ChangeMask] ASC,
	[EventAssociationID] ASC,
	[ConditionName] ASC,
	[Acked] ASC,
	[Suppressed] ASC,
	[Disabled] ASC,
	[Shelved] ASC
)
INCLUDE ( 	[TicksTimeStamp],
	[Severity],
	[Priority],
	[Message],
	[AlarmClass],
	[InputValue],
	[LimitValue],
	[Tag1Value],
	[Tag2Value],
	[Tag3Value],
	[Tag4Value]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--Disabled
CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms8] ON [dbo].[AllEvent]
(
	[ConditionName] ASC,
	[EventTimeStamp] ASC,
	[SourceName] ASC
)
INCLUDE ( 	[Message]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--Disabled
CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms9] ON [dbo].[AllEvent]
(
	[ConditionName] ASC,
	[EventTimeStamp] ASC,
	[SourceName] ASC,
	[ServerName] ASC
)
INCLUDE ( 	[SourcePath],
	[Severity],
	[Priority],
	[Message],
	[AlarmClass],
	[InputValue],
	[LimitValue],
	[EventAssociationID],
	[Tag1Value],
	[Tag2Value],
	[Tag3Value],
	[Tag4Value]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--Disabled
CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms10] ON [dbo].[AllEvent]
(
	[Disabled] ASC,
	[TicksTimeStamp] ASC,
	[ConditionName] ASC,
	[EventTimeStamp] ASC,
	[SourceName] ASC,
	[ServerName] ASC
)
INCLUDE ( 	[SourcePath],
	[Severity],
	[Priority],
	[Message],
	[AlarmClass],
	[InputValue],
	[LimitValue],
	[EventAssociationID],
	[Tag1Value],
	[Tag2Value],
	[Tag3Value],
	[Tag4Value]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--Suppressed
CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms11] ON [dbo].[AllEvent]
(
	[Suppressed] ASC
)
INCLUDE ( 	[TicksTimeStamp],
	[Message]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--Suppressed
CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms12] ON [dbo].[AllEvent]
(
	[ConditionName] ASC,
	[EventTimeStamp] ASC,
	[SourceName] ASC,
	[Suppressed] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--Suppressed
CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms13] ON [dbo].[AllEvent]
(
	[EventTimeStamp] ASC,
	[ConditionName] ASC,
	[SourceName] ASC,
	[Suppressed] ASC,
	[ServerName] ASC,
	[TicksTimeStamp] ASC
)
INCLUDE ( 	[SourcePath],
	[Severity],
	[Priority],
	[Message],
	[AlarmClass],
	[InputValue],
	[LimitValue],
	[EventAssociationID],
	[Tag1Value],
	[Tag2Value],
	[Tag3Value],
	[Tag4Value]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--Shelved
CREATE NONCLUSTERED INDEX [idx_vpSSRSAlarms14] ON [dbo].[AllEvent]
(
	[Shelved] ASC,
	[TicksTimeStamp] ASC,
	[SourceName] ASC,
	[ServerName] ASC,
	[EventTimeStamp] ASC,
	[ConditionName] ASC,
	[EventAssociationID] ASC
)
INCLUDE ( 	[SourcePath],
	[Severity],
	[Priority],
	[Message],
	[AlarmClass],
	[InputValue],
	[LimitValue],
	[Tag1Value],
	[Tag2Value],
	[Tag3Value],
	[Tag4Value],
	[AutoUnshelveTime]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO



--***********************************************
--Create NEW Functions
-- [dbo].[vpSSRSParameterParser] 以“|”为分隔符区分输入参数  EX:
-- String = "aaa|bbb|ccc|ddd"
-- 得到表格Parameters
-- ParameterNumber  ParameterName
--  1                aaa
-- 	2                bbb
-- 	3                ccc
-- 	4                ddd
--***********************************************

CREATE FUNCTION [dbo].[vpSSRSParameterParser] ( @ParameterString varchar(5000) )
RETURNS @Parameters TABLE
   (
		ParameterNumber int,
		ParameterName nvarchar(512)
   )
AS
BEGIN

	DECLARE @ParameterNumber INT
	DECLARE @DividerLocation INT
	
	SET @ParameterNumber = 1
	SET @DividerLocation = CHARINDEX('|',@ParameterString)

	WHILE @DividerLocation <> 0
		BEGIN
		
			INSERT @Parameters (ParameterNumber,ParameterName)

				SELECT @ParameterNumber,substring(@ParameterString,0,CHARINDEX('|',@ParameterString))
			
		
			SET @ParameterString = 	(SUBSTRING(@ParameterString,(CHARINDEX('|',@ParameterString)+1),LEN(@ParameterString)))
			SET @ParameterNumber = @ParameterNumber + 1
			SET @DividerLocation = CHARINDEX('|',@ParameterString)
			
		END
		
	INSERT @Parameters (ParameterNumber,ParameterName)

		SELECT @ParameterNumber,@ParameterString

   RETURN
END

GO

CREATE function [dbo].[vpSSRSTrimAlarmName]  (@cSearchExpression nvarchar(4000), @cExpressionSearched  nvarchar(4000), @nOccurrence  smallint = 1 )
returns smallint
as
    begin
      if @nOccurrence > 0
         begin
            declare @i smallint, @length smallint, @StartingPosition  smallint
            select  @length  = datalength(@cExpressionSearched)/(case SQL_VARIANT_PROPERTY(@cExpressionSearched,'BaseType') when 'nvarchar' then 2  else 1 end) 
            select  @cSearchExpression = reverse(@cSearchExpression), @cExpressionSearched = reverse(@cExpressionSearched)
            select  @i = 0, @StartingPosition  = -1 
            while @StartingPosition <> 0 and @nOccurrence > @i
               select  @i = @i + 1, @StartingPosition  = charindex(@cSearchExpression  COLLATE Latin1_General_BIN,
                                                                   @cExpressionSearched  COLLATE Latin1_General_BIN, @StartingPosition + 1)
            if @StartingPosition <> 0
              select @StartingPosition = 2 - @StartingPosition +  @length - datalength(@cSearchExpression)/(case SQL_VARIANT_PROPERTY(@cSearchExpression,'BaseType') when 'nvarchar' then 2  else 1 end) 
         end
      else
         set @StartingPosition =  NULL
         
      return @StartingPosition
    end
GO


--***********************************************
--Create NEW Procedures
--***********************************************

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[vpSSRSGetAllEventsInTimePeriod] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(4000),
	@ServerName	NVARCHAR (4000),
	@LocalTime datetime,
	@TopicName NVARCHAR(4000),
	@StaleDays int
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int
	DECLARE @OriginalStart datetime

	

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(MINUTE,@LocalTime,getutcdate()))
	SET @OriginalStart = DATEADD(MINUTE,@DateDifference,@from_dt)
	SET @from_dt = DATEADD(MINUTE,@DateDifference,@from_dt)
	SET @to_dt = DATEADD(MINUTE,@DateDifference,@to_dt)
	--Add Stale Days Calculation
	SET @from_dt = DATEADD(DAY,-@StaleDays,@from_dt)

	
	If @alarm = '' or @alarm is NULL Set @alarm = '%'
	If @alarm = 'All Alarms' Set @alarm = '%'
		
	
	CREATE TABLE #Parameters (ParameterProperty nvarchar(512),ParameterValue nvarchar(512))
		
	--Account for possible Square Brackets in Name For searching
	SET @alarm = REPLACE (@alarm,'[','![')
	SET @alarm = REPLACE (@alarm,']','!]')
	SET @TopicName = REPLACE (@TopicName,'[Blank]','')


	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'TopicName', ParameterName FROM vpSSRSParameterParser (@TopicName)
		
	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'ServerName', ParameterName FROM vpSSRSParameterParser (@ServerName)

	UPDATE #Parameters SET ParameterValue = '[' + ParameterValue WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = ParameterValue + ']' WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = '' Where ParameterValue = '[Blank]' AND ParameterProperty = 'Class'

Select
	DATEADD(MINUTE,-@DateDifference,ActiveAlarms.EventTimeStamp) as ActiveTime,
	DATEADD(MINUTE,-@DateDifference,Inact.EventTimeStamp) as InactiveTime, 
	DATEADD(MINUTE,-@DateDifference,Acked.EventTimeStamp) as AckedTime, 
	Substring(ActiveAlarms.Source,dbo.vpSSRSTrimAlarmName('.',ActiveAlarms.Source,1)+1,len(ActiveAlarms.Source)) AS Alarm,
	Severity.Severity,
	Priority.Priority,
	Tag1Value.Tag1Value, 
	Tag2Value.Tag2Value, 
	Tag3Value.Tag3Value, 
	Tag4Value.Tag4Value, 
	datediff(s, ActiveAlarms.EventTimeStamp, CAST((CASE Inact.EventTimeStamp WHEN NULL THEN getdate() ELSE Inact.EventTimeStamp END) AS datetime)) as Duration,
	Message.Message,
	DATEADD(MINUTE,-@DateDifference,Suppressed.EventTimeStamp) as SuppressedTime,
	DATEADD(MINUTE,-@DateDifference,Disabled.EventTimeStamp) as DisabledTime,
	InputValue.InputValue, 
	LimitValue.LimitValue, 
	DATEADD(MINUTE,-@DateDifference,Shelved.EventTimeStamp) as ShelvedTime,
	AlarmClass.AlarmClass,
	EventAssociationID,
	ServerName,
	ActiveAlarms.Source as Source
	FROM
	(select distinct 
		EventAssociationID, 
		(SourceName + ' ' + ConditionName) as Source, 
		EventTimeStamp 
		from 
		AllEvent
		Where 
		Active=1 AND EventType=2 AND
		((ChangeMask=129) OR (ChangeMask=131) or (ChangeMask = 143) or (ChangeMask = 147)) 
		AND EventTimeStamp >= @from_dt and EventTimeStamp <= @to_dt AND 
		(ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
		AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
		AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
		) AS ActiveAlarms
		outer apply
			(select top 1 eventtimestamp
				from AllEvent
				where 
					Active = 0 and 
					EventAssociationID=ActiveAlarms.EventAssociationID and 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventTimeStamp >= @From_dt and 
					EventTimeSTamp >= ActiveAlarms.EventTimeStamp AND
					eventtimestamp <= @to_dt
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Inact
		outer apply
			(select top 1 eventtimestamp
				from AllEvent
				where 
					Acked = 1 and 
					EventAssociationID=ActiveAlarms.EventAssociationID and 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventTimeStamp >= @From_dt and 
					EventTimeSTamp >= ActiveAlarms.EventTimeStamp AND
					eventtimestamp <= @to_dt
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Acked
		outer apply
			(select top 1 eventtimestamp
				from AllEvent
				where 
					Suppressed = 1 and 
					EventAssociationID=ActiveAlarms.EventAssociationID and 
					EventTimeStamp >= @From_dt and 
					eventtimestamp <= @to_dt
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Suppressed
		outer apply
				(select top 1 eventtimestamp
					from AllEvent
					where 
						Disabled = 1 and 
						EventAssociationID=ActiveAlarms.EventAssociationID and 
						EventTimeStamp >= @From_dt and 
						eventtimestamp <= @to_dt
						AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
						AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
						AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
					order by EventTimeStamp) as Disabled
		outer apply
			(select top 1 eventtimestamp
				from AllEvent
				where 
					Shelved = 1 and 
					EventAssociationID=ActiveAlarms.EventAssociationID and 
					EventTimeStamp >= @From_dt and 
					eventtimestamp <= @to_dt
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Shelved
		outer apply
			(select top 1 Message
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and 
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Message
		outer apply
			(select top 1 AlarmClass
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as AlarmClass
		outer apply
			(select top 1 LimitValue
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as LimitValue
		outer apply
			(select top 1 InputValue
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as InputValue
		outer apply
			(select top 1 Tag1Value
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Tag1Value
		outer apply
			(select top 1 Tag2Value
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Tag2Value
		outer apply
			(select top 1 Tag3Value
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Tag3Value
		outer apply
			(select top 1 Tag4Value
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Tag4Value
		outer apply
			(select top 1 Priority
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Priority
		outer apply
			(select top 1 Severity
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Severity
		outer apply
			(select top 1 ConditionName
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Condition
		outer apply
			(select top 1 ServerName
				from AllEvent
				where 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventAssociationID=ActiveAlarms.EventAssociationID and
					EventTimeStamp = ActiveAlarms.EventTimeStamp
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as ServerName

				WHERE ActiveAlarms.EventTimeStamp >= @OriginalStart OR Inact.EventTimeStamp IS NULL
				
	Order by ActiveAlarms.EventTimeStamp desc

DROP TABLE #Parameters


END

GO



Create
 PROCEDURE [dbo].[vpSSRSEventAssociationIDHistory] (
	@EventAssociationID NVARCHAR(4000),
	@LocalTime datetime
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(MINUTE,@LocalTime,getutcdate()))

			
SELECT 
	dateadd(MINUTE,-@DateDifference,EventTimeStamp) as EventTimeStamp,
	ServerName,
	SourceName, 
	Conditionname,
	Message,
	Active,
	Acked,
	Suppressed,
	Disabled,
	Shelved,
	AutoUnshelveTime

FROM
	AllEvent

WHERE
	EventAssociationID=@EventAssociationID
	and EventType = 2
ORDER BY 
	EventTimeStamp 

END

GO



CREATE PROCEDURE [dbo].[vpSSRSDisabledAlarms] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(200),
	@ServerName	NVARCHAR (512),
	@LocalTime datetime,
	@TopicName NVARCHAR(512)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int

	DECLARE @UserTableName AS Varchar(60)
	Set @UserTableName=(select sys.schemas.name from sys.objects inner join sys.schemas on sys.objects.schema_id=sys.schemas.schema_id where sys.objects.name=N'AllEvent' and sys.objects.type='U' )
	SET @UserTableName = '[' + @UserTableName + ']'
	
	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(HH,getutcdate(),@LocalTime))

	SET @from_dt = DATEADD(HH,-@DateDifference,@from_dt)
	
	SET @to_dt = DATEADD(HH,-@DateDifference,@to_dt)
	
	
	If @alarm = '' or @alarm is NULL Set @alarm = '%'
	If @alarm = 'All Alarms' Set @alarm = '%'
	If @ServerName = '' or @servername is null Set @ServerName = '%'
	
	CREATE TABLE #Parameters (ParameterProperty nvarchar(512),ParameterValue nvarchar(512))
		
	--Account for possible Square Brackets in Name For searching
	SET @alarm = REPLACE (@alarm,'[','![')
	SET @alarm = REPLACE (@alarm,']','!]')
	SET @TopicName = REPLACE (@TopicName,'[Blank]','')

	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'TopicName', ParameterName FROM vpSSRSParameterParser (@TopicName)
		
	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'ServerName', ParameterName FROM vpSSRSParameterParser (@ServerName)

	UPDATE #Parameters SET ParameterValue = '[' + ParameterValue WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = ParameterValue + ']' WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'

	
	SELECT 
			  

			 dateadd(hh,@DateDifference, AlarmList.DisabledTime) AS DisabledTime,
             DATEADD(hh,@DateDifference,AlarmList.EnabledTime) AS EnabledTime,
             AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END) as 'Alarm'   ,
             AlarmData.Severity, 
             AlarmData.Priority, 
             AlarmData.Tag1Value, 
             AlarmData.Tag2Value, 
             AlarmData.Tag3Value, 
             AlarmData.Tag4Value,
			 AlarmData.Message,
             AlarmData.InputValue,
             AlarmData.LimitValue, 
             AlarmData.AlarmClass,
			 Datediff(ss,cast(AlarmList.DisabledTime as datetime),(CASE WHEN ISNULL(cast(AlarmList.EnabledTime as datetime),1)=1 THEN cast(@to_dt as datetime) ELSE cast(AlarmList.EnabledTime as datetime) END)) AS 'Duration',
             SourcePath + '/' + AlarmData.ServerName + '::' + AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END) as SourceLong,
             (SUBSTRING((AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)),([dbo].vpSSRSTrimAlarmName('.',(AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)),1))+1,LEN(AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)))) AS SourceShort,
			 AlarmData.EventAssociationID
   
            
    FROM
    
	(SELECT DisabledAlarms.EventTimeStamp as DisabledTime, min(EnabledAlarms.EventTimeStamp) as EnabledTime,DisabledAlarms.ConditionName FROM
    (Select SourceName,EventTimeStamp,ConditionName FROM AllEvent
    WHERE (Disabled = 1) and EventType = 2
		AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
		AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
		AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
		AND (EventTimeStamp >= '' + convert(varchar, @from_dt, 121) + '' AND (EventTimeStamp <= convert(varchar,@to_dt, 121)))
		AND Message <> 'Alarm fault: Alarm input quality is bad'
		AND Message LIKE '%Alarm disabled%'
    GROUP BY SourceName,ConditionName,EventTimeStamp) AS DisabledAlarms
    LEFT OUTER JOIN
    (
    Select SourceName,EventTimeStamp,ConditionName FROM AllEvent
    WHERE Message LIKE '%Alarm enabled%' AND EventType = 2
    GROUP BY SourceName,ConditionName,EventTimeStamp) AS EnabledAlarms
    ON DisabledAlarms.SourceName=EnabledAlarms.SourceName AND DisabledAlarms.ConditionName=EnabledAlarms.ConditionName AND DisabledAlarms.EventTimeStamp < EnabledAlarms.EventTimeStamp
    GROUP BY DisabledAlarms.EventTimeStamp,DisabledAlarms.ConditionName ) AS AlarmList
	LEFT OUTER JOIN
						  AllEvent AS AlarmData ON AlarmList.ConditionName = AlarmData.ConditionName AND 
						  AlarmList.DisabledTime = AlarmData.EventTimeStamp
						  ORDER BY AlarmList.DisabledTime desc


DROP TABLE #Parameters

END

GO



CREATE PROCEDURE [dbo].[vpSSRSSuppressedAlarms] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(200),
	@ServerName	NVARCHAR (512),
	@LocalTime datetime,
	@TopicName NVARCHAR(512)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(HH,getutcdate(),@LocalTime))

	SET @from_dt = DATEADD(HH,-@DateDifference,@from_dt)
	
	SET @to_dt = DATEADD(HH,-@DateDifference,@to_dt)
	
	
	If @alarm = '' or @alarm is NULL Set @alarm = '%'
	If @alarm = 'All Alarms' Set @alarm = '%'
	If @ServerName = '' or @servername is null Set @ServerName = '%'
	
	CREATE TABLE #Parameters (ParameterProperty nvarchar(512),ParameterValue nvarchar(512))
		
	--Account for possible Square Brackets in Name For searching
	SET @alarm = REPLACE (@alarm,'[','![')
	SET @alarm = REPLACE (@alarm,']','!]')
	SET @TopicName = REPLACE (@TopicName,'[Blank]','')

	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'TopicName', ParameterName FROM vpSSRSParameterParser (@TopicName)
		
	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'ServerName', ParameterName FROM vpSSRSParameterParser (@ServerName)


	UPDATE #Parameters SET ParameterValue = '[' + ParameterValue WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = ParameterValue + ']' WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = '' Where ParameterValue = '[Blank]' AND ParameterProperty = 'Class'


	SELECT 
             dateadd(hh,@DateDifference, AlarmList.SuppressedTime) AS SuppressedTime,
             DATEADD(hh,@DateDifference,AlarmList.UnsuppressedTime) AS UnsuppressedTime,
             AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END) as 'Alarm'   ,
             AlarmData.Severity, 
             AlarmData.Priority, 
             AlarmData.Tag1Value, 
             AlarmData.Tag2Value, 
             AlarmData.Tag3Value, 
             AlarmData.Tag4Value,
             AlarmData.Message,
             AlarmData.InputValue,
             AlarmData.LimitValue, 
             AlarmData.AlarmClass,
             (SELECT CASE When ISNULL(cast(AlarmList.UnsuppressedTime as datetime),1)=1 THEN (Datediff(second,cast(AlarmList.SuppressedTime as datetime),dateadd(hh,-@datedifference,cast(@to_dt as datetime)))) ELSE (Datediff(second,cast(AlarmList.SuppressedTime as datetime),cast(AlarmList.UnsuppressedTime as datetime))) END) AS 'Suppressed Duration',
             SourcePath + '/' + AlarmData.ServerName + '::' + AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END) as SourceLong,
             (SUBSTRING((AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)),([dbo].vpSSRSTrimAlarmName('.',(AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)),1))+1,LEN(AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)))) AS SourceShort,
			 AlarmData.EventAssociationID
             
    FROM
    
	(SELECT SuppressedAlarms.EventTimeStamp as SuppressedTime, min(UnsuppressedAlarms.EventTimeStamp) as UnsuppressedTime,SuppressedAlarms.ConditionName FROM
    (Select SourceName,EventTimeStamp,ConditionName FROM AllEvent
    WHERE (Suppressed = 1)
		AND EventType = 2
		AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
		AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
		AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
		AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
		AND (EventTimeStamp >= @from_dt AND EventTimeStamp <= @to_dt)
		AND Message <> 'Alarm fault: Alarm input quality is bad'
		AND Message LIKE '%Alarm Suppressed%'
    GROUP BY SourceName,ConditionName,EventTimeStamp) AS SuppressedAlarms
    LEFT OUTER JOIN
    (
    Select SourceName,EventTimeStamp,ConditionName FROM AllEvent
    WHERE (Suppressed = 0)
    GROUP BY SourceName,ConditionName,EventTimeStamp) AS UnsuppressedAlarms
    ON SuppressedAlarms.SourceName=UnsuppressedAlarms.SourceName AND SuppressedAlarms.ConditionName=UnsuppressedAlarms.ConditionName AND SuppressedAlarms.EventTimeStamp < UnsuppressedAlarms.EventTimeStamp
    GROUP BY SuppressedAlarms.EventTimeStamp,SuppressedAlarms.ConditionName ) AS AlarmList
	LEFT OUTER JOIN
						  dbo.AllEvent AS AlarmData ON AlarmList.ConditionName = AlarmData.ConditionName AND 
						  AlarmList.SuppressedTime = AlarmData.EventTimeStamp
						  ORDER BY AlarmList.SuppressedTime


DROP TABLE #Parameters

END

GO



CREATE PROCEDURE [dbo].[vpSSRSShelvedAlarms] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(200),
	@ServerName	NVARCHAR (512),
	@LocalTime datetime,
	@TopicName NVARCHAR(512)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(HH,getutcdate(),@LocalTime))

	SET @from_dt = DATEADD(HH,-@DateDifference,@from_dt)
	
	SET @to_dt = DATEADD(HH,-@DateDifference,@to_dt)
	
	
	If @alarm = '' or @alarm is NULL Set @alarm = '%'
	If @alarm = 'All Alarms' Set @alarm = '%'
	If @ServerName = '' or @servername is null Set @ServerName = '%'
	
	CREATE TABLE #Parameters (ParameterProperty nvarchar(512),ParameterValue nvarchar(512))
		
	--Account for possible Square Brackets in Name For searching
	SET @alarm = REPLACE (@alarm,'[','![')
	SET @alarm = REPLACE (@alarm,']','!]')
	SET @TopicName = REPLACE (@TopicName,'[Blank]','')

	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'TopicName', ParameterName FROM vpSSRSParameterParser (@TopicName)
		
	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'ServerName', ParameterName FROM vpSSRSParameterParser (@ServerName)
		

	UPDATE #Parameters SET ParameterValue = '[' + ParameterValue WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = ParameterValue + ']' WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'


	SELECT 
             dateadd(hh,@DateDifference, AlarmList.ShelvedTime) AS Shelved,
             DATEADD(hh,@DateDifference,AlarmList.UnshelvedTime) AS UnShelvedTime,
             DATEADD(hh,@DateDifference,AlarmData.AutoUnshelveTime) as AutoUnshelveTime   ,
             AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END) as 'Alarm'   ,
             AlarmData.Severity, 
             AlarmData.Priority, 
             AlarmData.Tag1Value, 
             AlarmData.Tag2Value, 
             AlarmData.Tag3Value, 
             AlarmData.Tag4Value,
             AlarmData.Message,
             AlarmData.InputValue,
             AlarmData.LimitValue, 
             AlarmData.AlarmClass,
             Datediff(ss,(CASE WHEN cast(AlarmList.ShelvedTime as datetime) > @from_dt THEN cast(AlarmList.ShelvedTime as datetime) ELSE @from_dt END),CASE WHEN ISNULL(cast(AlarmList.Unshelvedtime as datetime),1)=1 THEN @to_dt ELSE cast(AlarmList.Unshelvedtime as datetime) END) AS 'Shelved Duration',
             SourcePath + '/' + AlarmData.ServerName + '::' + AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END) as SourceLong,
             (SUBSTRING((AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)),([dbo].vpSSRSTrimAlarmName('.',(AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)),1))+1,LEN(AlarmData.SourceName + (CASE AlarmData.ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + AlarmData.ConditionName END)))) AS SourceShort,
			 AlarmData.EventAssociationID
             
    FROM
    
	(Select ShelvedAlarms.EventAssociationID,ShelvedAlarms.eventtimestamp as ShelvedTime, min(UnShelvedAlarms.eventtimestamp) AS UnshelvedTime,ShelvedAlarms.ConditionName From 
		(
			SELECT      eventtimestamp, EventAssociationID, ConditionName
				FROM          dbo.AllEvent AS AllEvent_1
				WHERE      (Shelved = 1)		
				AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
				AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
				AND (EventTimeStamp >= @from_dt AND EventTimeStamp <= @to_dt)
				AND EventType = 2
				GROUP BY EventAssociationID, ConditionName,EventTimeStamp) AS ShelvedAlarms
				LEFT OUTER JOIN        
		(
			SELECT     eventtimestamp, EventAssociationID, ConditionName
				FROM          dbo.AllEvent AS AllEvent_1
				WHERE      (Shelved = 0) AND EventType = 2
				GROUP BY EventAssociationID, ConditionName,EventTimeStamp) AS UnShelvedAlarms
				ON ShelvedAlarms.EventAssociationID=UnShelvedAlarms.EventAssociationID AND ShelvedAlarms.ConditionName=UnShelvedAlarms.ConditionName AND ShelvedAlarms.eventtimestamp < UnShelvedAlarms.eventtimestamp
				Group By ShelvedAlarms.EventAssociationID,ShelvedAlarms.eventtimestamp,ShelvedAlarms.ConditionName) AS AlarmList
	LEFT OUTER JOIN
						  dbo.AllEvent AS AlarmData ON AlarmList.EventAssociationID = AlarmData.EventAssociationID AND AlarmList.ConditionName = AlarmData.ConditionName AND 
						  AlarmList.ShelvedTime = AlarmData.EventTimeStamp
						  ORDER BY dateadd(hh,@DateDifference, AlarmList.ShelvedTime)


DROP TABLE #Parameters

END
GO

CREATE PROCEDURE [dbo].[vpSSRSMaintAlarmFaults] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(200),
	@ServerName	NVARCHAR (512),
	@LocalTime datetime,
	@TopicName NVARCHAR(512)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(HH,getutcdate(),@LocalTime))

	SET @from_dt = DATEADD(HH,-@DateDifference,@from_dt)
	
	SET @to_dt = DATEADD(HH,-@DateDifference,@to_dt)
	
	
	If @alarm = '' or @alarm is NULL Set @alarm = '%'
	If @alarm = 'All Alarms' Set @alarm = '%'
	If @ServerName = '' or @servername is null Set @ServerName = '%'
	
	CREATE TABLE #Parameters (ParameterProperty nvarchar(512),ParameterValue nvarchar(512))
		
	--Account for possible Square Brackets in Name For searching
	SET @alarm = REPLACE (@alarm,'[','![')
	SET @alarm = REPLACE (@alarm,']','!]')
	SET @TopicName = REPLACE (@TopicName,'[Blank]','')

	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'TopicName', ParameterName FROM vpSSRSParameterParser (@TopicName)
		
	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'ServerName', ParameterName FROM vpSSRSParameterParser (@ServerName)
		

	UPDATE #Parameters SET ParameterValue = '[' + ParameterValue WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = ParameterValue + ']' WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'



SELECT     dateadd(hh,@DateDifference,EventTimeStamp) AS EventTimeStamp, SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END) as 'Alarm',
			Severity,Priority,InputValue,LimitValue,Tag1Value,Tag2Value,Tag3Value,Tag4Value,Message,
						SourcePath + '/' + ServerName + '::' + SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END) as SourceLong,
            (SUBSTRING((SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END)),([dbo].vpSSRSTrimAlarmName('.',(SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END)),1))+1,LEN(SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END)))) AS SourceShort,
			EventAssociationID

FROM          dbo.AllEvent
WHERE      
		((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
        AND EventType = 2 
		AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
		AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
		AND (Message = 'Alarm fault: Alarm input quality is bad' or Message = 'Alarm fault cleared: Alarm input quality is good')
		AND (EventTimeStamp >= @from_dt AND EventTimeStamp <= @to_dt)
ORDER BY EventTimeStamp desc


DROP TABLE #Parameters

END

GO

CREATE PROCEDURE [dbo].[vpSSRSGetAllEventsInTimePeriod_Stale] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(4000),
	@ServerName	NVARCHAR (4000),
	@LocalTime datetime,
	@TopicName NVARCHAR(4000),
	@StaleDays int
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int
	DECLARE @OriginalStart datetime

	

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(MINUTE,@LocalTime,getutcdate()))
	SET @OriginalStart = DATEADD(MINUTE,@DateDifference,@from_dt)
	SET @from_dt = DATEADD(MINUTE,@DateDifference,@from_dt)
	SET @to_dt = DATEADD(MINUTE,@DateDifference,@to_dt)
	--Add Stale Days Calculation
	SET @StaleDays = @StaleDays + 60
	SET @from_dt = DATEADD(DAY,-@StaleDays,@from_dt)

	
	If @alarm = '' or @alarm is NULL Set @alarm = '%'
	If @alarm = 'All Alarms' Set @alarm = '%'
		
	
	CREATE TABLE #Parameters (ParameterProperty nvarchar(512),ParameterValue nvarchar(512))
		
	--Account for possible Square Brackets in Name For searching
	SET @alarm = REPLACE (@alarm,'[','![')
	SET @alarm = REPLACE (@alarm,']','!]')
	SET @TopicName = REPLACE (@TopicName,'[Blank]','')


	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'TopicName', ParameterName FROM vpSSRSParameterParser (@TopicName)
		
	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'ServerName', ParameterName FROM vpSSRSParameterParser (@ServerName)

	UPDATE #Parameters SET ParameterValue = '[' + ParameterValue WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = ParameterValue + ']' WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = '' Where ParameterValue = '[Blank]' AND ParameterProperty = 'Class'

Select
	DATEADD(MINUTE,-@DateDifference,ActiveAlarms.EventTimeStamp) as ActiveTime,
	DATEADD(MINUTE,-@DateDifference,Inact.EventTimeStamp) as InactiveTime, 
	Substring(ActiveAlarms.Source,dbo.vpSSRSTrimAlarmName('.',ActiveAlarms.Source,1)+1,len(ActiveAlarms.Source)) AS Alarm, 
	EventAssociationID,
	ActiveAlarms.Source as Source
	FROM
	(select distinct 
		EventAssociationID, 
		(SourceName + ' ' + ConditionName) as Source, 
		EventTimeStamp 
		from 
		AllEvent 
		Where 
		Active=1 AND EventType=2 AND
		((ChangeMask=129) OR (ChangeMask=131) or (ChangeMask = 143) or (ChangeMask = 147)) 
		AND EventTimeStamp >= @from_dt and EventTimeStamp <= @to_dt AND 
		(ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
		AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
		AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
		) AS ActiveAlarms
		outer apply
			(select top 1 eventtimestamp
				from AllEvent 
				where 
					Active = 0 and 
					EventAssociationID=ActiveAlarms.EventAssociationID and 
					(SourceName + ' ' + ConditionName) = ActiveAlarms.Source and
					EventTimeStamp >= @From_dt and 
					EventTimeSTamp >= ActiveAlarms.EventTimeStamp AND
					eventtimestamp <= @to_dt
					AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
					AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
					AND ((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
				order by EventTimeStamp) as Inact
	
			WHERE Inact.EventTimeStamp IS NULL
				

DROP TABLE #Parameters

END

GO

CREATE PROCEDURE [dbo].[vpSSRSMaintControllerEvents] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(200),
	@ServerName	NVARCHAR (512),
	@LocalTime datetime,
	@TopicName NVARCHAR(512)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(HH,getutcdate(),@LocalTime))

	SET @from_dt = DATEADD(HH,-@DateDifference,@from_dt)
	
	SET @to_dt = DATEADD(HH,-@DateDifference,@to_dt)
	
	
	If @alarm = '' or @alarm is NULL Set @alarm = '%'
	If @alarm = 'All Alarms' Set @alarm = '%'
	If @ServerName = '' or @servername is null Set @ServerName = '%'
	
	CREATE TABLE #Parameters (ParameterProperty nvarchar(512),ParameterValue nvarchar(512))
		
	--Account for possible Square Brackets in Name For searching
	SET @alarm = REPLACE (@alarm,'[','![')
	SET @alarm = REPLACE (@alarm,']','!]')
	SET @TopicName = REPLACE (@TopicName,'[Blank]','')

	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'TopicName', ParameterName FROM vpSSRSParameterParser (@TopicName)
		
	INSERT #Parameters (ParameterProperty,ParameterValue)
		SELECT 'ServerName', ParameterName FROM vpSSRSParameterParser (@ServerName)
		

	UPDATE #Parameters SET ParameterValue = '[' + ParameterValue WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = ParameterValue + ']' WHERE ParameterValue <> '' AND ParameterProperty = 'TopicName'
	UPDATE #Parameters SET ParameterValue = '' Where ParameterValue = '[Blank]' AND ParameterProperty = 'Class'


SELECT     dateadd(hh,@DateDifference,EventTimeStamp) AS EventTimeStamp, SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END) as 'Alarm',
			Severity,Priority,InputValue,LimitValue,Tag1Value,Tag2Value,Tag3Value,Tag4Value,Message,
			SourcePath + '/' + ServerName + '::' + SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END) as SourceLong,
            (SUBSTRING((SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END)),([dbo].vpSSRSTrimAlarmName('.',(SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END)),1))+1,LEN(SourceName + (CASE ConditionName WHEN 'TRIP' THEN '' ELSE ' ' + ConditionName END)))) AS SourceShort,
			EventAssociationID
FROM          dbo.AllEvent
WHERE      
		((SourceName LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName=@alarm or (SourceName + ' ' + ConditionName) LIKE @alarm or ((SourceName + ' ' + ConditionName) LIKE ('%' + @alarm + '%') ESCAPE '!') or SourceName + ' ' + ConditionName = @alarm)
        AND EventType = 2
		AND (SUBSTRING(SourceName,0,(CHARINDEX(']',SourceName,0)+1)) IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'TopicName'))
		AND (ServerName IN (Select ParameterValue from #Parameters WHERE ParameterProperty = 'ServerName'))
		AND (Message LIKE '%controller%')
		AND (EventTimeStamp >= @from_dt AND EventTimeStamp <= @to_dt)
ORDER BY EventTimeStamp desc


DROP TABLE #Parameters

END


GO

CREATE PROCEDURE [dbo].[vpSSRSHourly_Frequency] (
	@from_dt DateTime,
	@to_dt DateTime,
	@alarm NVARCHAR(4000),
	@ServerName	NVARCHAR (4000),
	@LocalTime datetime,
	@TopicName NVARCHAR(4000),
	@StaleDays int
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateDifference Int
	DECLARE @OriginalStart datetime

	

	--Determine difference between server and local time zone
	SET @DateDifference = (select datediff(MINUTE,@LocalTime,getutcdate()))
	SET @OriginalStart = DATEADD(MINUTE,@DateDifference,@from_dt)
	SET @from_dt = DATEADD(MINUTE,@DateDifference,@from_dt)
	SET @to_dt = DATEADD(MINUTE,@DateDifference,@to_dt)
	--Add Stale Days Calculation
