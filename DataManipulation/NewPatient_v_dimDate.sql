USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_dimDate]    Script Date: 9/5/2022 10:09:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create VIEW [NewPatient].[v_dimDate] AS

select
	DateKey
	,Date
	,Month_Name
	,Year
	,ROW_NUMBER() over (order by DateKey) as Sort
from(
	select distinct
		replace(CONVERT(DATE, CONVERT(VARCHAR(7), BEG_DT_TM, 120) + '-01'),'-','') as DateKey
		,CONVERT(DATE, CONVERT(VARCHAR(7), BEG_DT_TM, 120) + '-01') as date
		,DATENAME(month,BEG_DT_TM) as Month_Name
		,DATENAME(year,BEG_DT_TM) as Year
		--,ROW_NUMBER() over (order by DateKey) as Sort
	from
		NewPatient.Appointment_with_cd
	)a
GO


