USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_ov_new_patient_perc]    Script Date: 9/5/2022 10:17:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_ov_new_patient_perc] as

select distinct
	facility
	,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility) as new_patient_cnt
	,count(appt_type) over (partition by facility) as appt_cnt
	,round(
		convert(float,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility))/
		convert(float,count(appt_type) over (partition by facility))
		,4) as new_patient_perc
	,count(case when sch_state = 'Canceled' then 1 end) over (partition by facility) canceled_cnt
	,count(case when sch_state = 'No Show' then 1 end) over (partition by facility) no_show_cnt
	,count(case when sch_state in ('No Show','Canceled') then 1 end) over (partition by facility) cancelation_cnt
	,count(sch_state) over (partition by facility) num_of_appt
	,round(
		convert(float,count(case when sch_state in ('No Show','Canceled') then 1 end) over (partition by facility))/
		convert(float,count(sch_state) over (partition by facility))
		,4) as cancelation_perc
	,count(case when sch_state in ('No Show','Canceled') and appt_type = 'New Patient' then 1 end) over (partition by facility) newpat_cancelation_cnt
	,round(
		convert(float,count(case when sch_state in ('No Show','Canceled') and appt_type = 'New Patient' then 1 end) over (partition by facility))/
		convert(float,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility))
		,4) as newpat_can_perc
from
	NewPatient.v_Appointments

--select top 1000 * from NewPatient.v_Appointments
GO