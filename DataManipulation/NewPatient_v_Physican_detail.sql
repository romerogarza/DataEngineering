USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_Physican_detail]    Script Date: 9/5/2022 10:19:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_Physican_detail] as

select
	facility
	,appt_location
	,physician
	,case when physician_ind = 1 then 'Physician' else 'Non-Physician' end as physician_ind
	,appt_day
	,total_appointments
	,lag(total_appointments, 1) over (partition by facility, appt_location, physician order by facility, appt_location, physician, appt_day) as prior_day_appointments
	,Canceled_appointments
	,No_Show_appointments
	,Canceled_and_No_Show_appointments
	,New_Patient_appointments
	,total_physician_appointments_by_month
	,total_facility_appointments_by_month
from(
	select distinct
		facility
		,appt_location
		,physician
		,physician_ind
		,appt_day
		,count(*) over (partition by facility, appt_location, physician, appt_day) as total_appointments
		,count(case when sch_state = 'Canceled' then 1 end) over (partition by facility, appt_location, physician, appt_day) as Canceled_appointments
		,count(case when sch_state = 'No Show' then 1 end) over (partition by facility, appt_location, physician, appt_day) as No_Show_appointments
		,count(case when sch_state = 'No Show' or sch_state = 'Canceled' then 1 end) over (partition by facility, appt_location, physician, appt_day) as Canceled_and_No_Show_appointments
		,count(case when appt_type = 'New Patient' then 1 end) over (partition by facility, appt_location, physician, appt_day) as New_Patient_appointments
		,count(*) over (partition by facility, appt_location, physician, appt_month) as total_physician_appointments_by_month
		,count(*) over (partition by facility, appt_location, appt_month) as total_facility_appointments_by_month
	from(
		select
			a.*
			,case 
				when PHYSICIAN like '% DO%' then 1
				when PHYSICIAN like '%MD%' then 1
				when PHYSICIAN like '%M,%' then 1
				when PHYSICIAN like '%CPNP%' then 1
				when PHYSICIAN like '%ANP-C%' then 1
				when PHYSICIAN like '%PA-C%' then 1
				when PHYSICIAN like '%FNP%' then 1
				when PHYSICIAN like '%FNP-C%' then 1
				when PHYSICIAN like '%FNP-BC%' then 1
				when PHYSICIAN like '%PMHNP-BC%' then 1
				when PHYSICIAN like '%LCSW%' then 1
				when PHYSICIAN like '% NP%' then 1
				when PHYSICIAN like '%NP-C%' then 1
				when PHYSICIAN like '%PsyD%' then 1
				when PHYSICIAN like '%PHD%' then 1
				when PHYSICIAN like '%DNP%' then 1
				when PHYSICIAN like '%APRN%' then 1
				when PHYSICIAN like '%AuD%' then 1
				when PHYSICIAN like '% PA%' then 1
				when PHYSICIAN like '%CNS%' then 1
				else 0
				end as physician_ind
			from
				NewPatient.v_Appointments a
		)a
	)b
--order by facility, appt_location, physician, appt_day
GO