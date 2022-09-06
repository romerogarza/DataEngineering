USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_ov_facility_new_patient_perc]    Script Date: 9/5/2022 10:16:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_ov_facility_new_patient_perc] as

select distinct
	facility
	,appt_location
	,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location) as new_patient_cnt
	,count(appt_type) over (partition by facility, appt_location) as appt_cnt
	,case when count(appt_type) over (partition by facility, appt_location) = 0 then 0 else
		round(
		convert(float,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location))/
		convert(float,count(appt_type) over (partition by facility, appt_location))
		,4) end as new_patient_perc
	,count(case when sch_state = 'Canceled' then 1 end) over (partition by facility, appt_location) canceled_cnt
	,count(case when sch_state = 'No Show' then 1 end) over (partition by facility, appt_location) no_show_cnt
	,count(case when sch_state in ('No Show','Canceled') then 1 end) over (partition by facility, appt_location) cancelation_cnt
	,count(sch_state) over (partition by facility, appt_location) num_of_appt
	,case when count(sch_state) over (partition by facility, appt_location) = 0 then 0 else
		round(
		convert(float,count(case when sch_state in ('No Show','Canceled') then 1 end) over (partition by facility, appt_location))/
		convert(float,count(sch_state) over (partition by facility, appt_location))
		,4) end as cancelation_perc
	,count(case when sch_state in ('No Show','Canceled') and appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location) newpat_cancelation_cnt
	,case when count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location) = 0 then 0 else
		round(
		convert(float,count(case when sch_state in ('No Show','Canceled') and appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location))/
		convert(float,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location))
		,4) end as newpat_can_perc
	,avg(case when gender = 'Male' then age end) over (partition by facility, appt_location) as avg_m_age
	,avg(case when gender = 'Female' then age end) over (partition by facility, appt_location) as avg_f_age
	,round(
		convert(float,count(case when gender = 'Male' then 1 end) over (partition by facility, appt_location))/
		convert(float,count(gender) over (partition by facility, appt_location))
		,4) as gender_m_perc
	,round(
		convert(float,count(case when gender = 'Female' then 1 end) over (partition by facility, appt_location))/
		convert(float,count(gender) over (partition by facility, appt_location))
		,4) as gender_f_perc
from
	NewPatient.v_Appointments

--select top 1000 * from NewPatient.v_Appointments
GO