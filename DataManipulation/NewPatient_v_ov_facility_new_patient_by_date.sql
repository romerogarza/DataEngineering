USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_ov_facility_new_patient_by_date]    Script Date: 9/5/2022 10:15:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_ov_facility_new_patient_by_date] as

select
	a.*
	,ROW_NUMBER() over (order by facility, appt_location, appt_month) as sort
from(
	select distinct
		facility
		,appt_location
		,appt_month
		,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location, appt_month) as new_patient_cnt
		,count(appt_type) over (partition by facility, appt_location, appt_month) as appt_cnt
		,case when count(appt_type) over (partition by facility, appt_location, appt_month) = 0 then 0 else
			round(
			convert(float,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location, appt_month))/
			convert(float,count(appt_type) over (partition by facility, appt_location, appt_month))
			,4) end as new_patient_perc
		,count(case when sch_state = 'Canceled' then 1 end) over (partition by facility, appt_location, appt_month) canceled_cnt
		,count(case when sch_state = 'No Show' then 1 end) over (partition by facility, appt_location, appt_month) no_show_cnt
		,count(case when sch_state in ('No Show','Canceled') then 1 end) over (partition by facility, appt_location, appt_month) cancelation_cnt
		,count(sch_state) over (partition by facility, appt_location, appt_month) num_of_appt
		,case when count(sch_state) over (partition by facility, appt_location, appt_month) = 0 then 0 else
			round(
			convert(float,count(case when sch_state in ('No Show','Canceled') then 1 end) over (partition by facility, appt_location, appt_month))/
			convert(float,count(sch_state) over (partition by facility, appt_location, appt_month))
			,4) end as cancelation_perc
		,count(case when sch_state in ('No Show','Canceled') and appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location, appt_month) newpat_cancelation_cnt
		,case when count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location, appt_month) = 0 then 0 else
			round(
			convert(float,count(case when sch_state in ('No Show','Canceled') and appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location, appt_month))/
			convert(float,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location, appt_month))
			,4) end as newpat_can_perc
	from
		NewPatient.v_Appointments
	)a
where
	appt_month >= dateadd(month,-11,(select max(appt_month) from NewPatient.v_Appointments))
--order by facility ,appt_location ,appt_month
--select top 1000 * from NewPatient.v_Appointments
GO


