USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_ov_facility_appt_type_perc]    Script Date: 9/5/2022 10:14:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_ov_facility_appt_type_perc] as

select distinct
	facility
	,appt_location
	,appt_type
	,count(appt_type) over (partition by facility, appt_location, appt_type) as appt_type_cnt
	,count(appt_type) over (partition by facility, appt_location) as appt_type_tot
	,round(
		convert(float,count(appt_type) over (partition by facility, appt_location, appt_type))/
		convert(float,count(appt_type) over (partition by facility, appt_location))
		,4) as appt_type_perc
from
	NewPatient.v_Appointments

--order by facility, appt_location, appt_type, appt_type_cnt
GO


