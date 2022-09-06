USE [PROJECTS]
GO

/****** Object:  Table [NewPatient].[Appointments]    Script Date: 9/5/2022 10:03:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [NewPatient].[Appointments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SCH_APPT_ID] [bigint] NULL,
	[PERSON_ID] [nvarchar](max) NULL,
	[FIRST_NAME] [nvarchar](max) NULL,
	[LAST_NAME] [nvarchar](max) NULL,
	[GENDER] [nvarchar](max) NULL,
	[ZIPCODE] [nvarchar](max) NULL,
	[DURATION] [int] NULL,
	[ACTIVITY_CD] [nvarchar](max) NULL,
	[SCH_STATE_CD] [nvarchar](max) NULL,
	[SCH_ROLE_CD] [nvarchar](max) NULL,
	[ACTIVE_STATUS_CD] [nvarchar](max) NULL,
	[APPT_LOCATION_CD] [nvarchar](max) NULL,
	[BEG_DT_TM_TZ] [datetime] NULL,
	[END_DT_TM_TZ] [datetime] NULL,
	[SB_APPT_TYPE_CD] [nvarchar](max) NULL,
	[FACILITY] [nvarchar](max) NULL,
	[BUILDING] [nvarchar](max) NULL,
	[UNIT] [nvarchar](max) NULL,
	[ROOM] [nvarchar](max) NULL,
	[BED] [nvarchar](max) NULL,
	[ENCNTR_TYPE_CD] [nvarchar](max) NULL,
	[ENCNTR_PRSNL_R_CD] [nvarchar](max) NULL,
	[PHYSICIAN] [nvarchar](max) NULL,
	[LOC_FACILITY] [int] NULL,
	[LOC_BUILDING] [int] NULL,
	[FIN] [int] NULL,
	[BIRTH_DT] [nvarchar](10) NULL,
	[ENCNTR_ID] [bigint] NULL,
	[UPDATE_DT_TM] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


