USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_Appointments]    Script Date: 9/5/2022 10:05:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_Appointments] as

select
*
from(
	select 
		f.group_1 as facility
		,a.person_id as person
		,a.physician
		,a.gender
		,datediff(year,a.birth_dt,getdate()) as age
		,left(a.zipcode,5) as zipcode
		,a.SCH_STATE_CD as sch_state
		,case 
			when a.appt_location_cd = 'MH Acute Care Clinic' then 'Meritas Health Acute Care Clinic' 
			when a.appt_location_cd = 'MH Anticoag' then 'Meritas Health Anticoagulation Clinic' 
			when a.appt_location_cd = 'MH Briarcliff Suite 100' then 'Meritas Health Briarcliff'
			when a.appt_location_cd = 'MH Briarcliff Suite 200' then 'Meritas Health Briarcliff'
			when a.appt_location_cd = 'MH Card -Eng' then 'Meritas Health Englewood'
			when a.appt_location_cd = 'MH Card -ES' then 'Meritas Health Excelsior Springs'
			when a.appt_location_cd = 'MH Card -Indep' then 'Meritas Health Independence'
			when a.appt_location_cd = 'MH Card -NO' then 'Meritas Health North Oak'
			when a.appt_location_cd = 'MH Card -Richmd' then 'Meritas Health Richmond'
			when a.appt_location_cd = 'MH Card -SC' then 'Meritas Health Shoal Creek/Liberty'
			when a.appt_location_cd = 'MH Card -Tremnt' then 'Meritas Health Tremont'
			when a.appt_location_cd = 'MH Card-NKC' then 'Meritas Health Cardiology NKCH'
			when a.appt_location_cd = 'MH CTS' then 'Meritas Health Comprehensive Surgery'
			when a.appt_location_cd = 'MH Comp Surg' then 'Meritas Health Comprehensive Surgery'
			when a.appt_location_cd = 'MH Endocrine' then 'Meritas Health Endocrinology'
			when a.appt_location_cd = 'MH ENT' then 'Meritas Health ENT'
			when a.appt_location_cd = 'MH ENT North Oak' then 'Meritas Health ENT'
			when a.appt_location_cd = 'MH Exp 64th St' then 'Meritas Health Express'
			when a.appt_location_cd = 'MH Exp Gladstn' then 'Meritas Health Express'
			when a.appt_location_cd = 'MH Exp Liberty' then 'Meritas Health Express'
			when a.appt_location_cd = 'MH Gashland' then 'Meritas Health Gashland'
			when a.appt_location_cd = 'MH Gashland-UC' then 'Meritas Health Gashland'
			when a.appt_location_cd = 'MH Landmark' then 'Meritas Health Landmark'
			when a.appt_location_cd = 'MH Neurology' then 'Meritas Health Neurology'
			when a.appt_location_cd = 'MH Neurology-BP' then 'Meritas Health Neurology'
			when a.appt_location_cd = 'MH Neurosurgery' then 'Meritas Health Neurosurgery'
			when a.appt_location_cd = 'MH NKC' then 'Meritas Health North Kansas City'
			when a.appt_location_cd = 'MH NKC Schools' then 'Meritas Health NKC Schools'
			when a.appt_location_cd = 'MH Oakview' then 'Meritas Health Oakview'
			when a.appt_location_cd = 'MH Obs & Gyn' then 'Meritas Health Obstetrics & Gynecology'
			when a.appt_location_cd = 'MH Park Plaza' then 'Meritas Health Park Plaza'
			when a.appt_location_cd = 'MH Pav Women' then 'Meritas Health Pavilion for Women'
			when a.appt_location_cd = 'MH Pediatrics' then 'Meritas Health Pediatrics'
			when a.appt_location_cd = 'MH Pediatrics- Tiffany Springs' then 'Meritas Health Pediatrics'
			when a.appt_location_cd = 'MH Platte City' then 'Meritas Health Platte City'
			when a.appt_location_cd = 'MH Psychiatry' then 'Meritas Health Psychiatry'
			when a.appt_location_cd = 'MH Pulmonary Med Suite 605' then 'Meritas Health Pulmonary Medicine'
			when a.appt_location_cd = 'MH Pulmonary Med Suite 620' then 'Meritas Health Pulmonary Medicine'
			when a.appt_location_cd = 'MH Richmond' then 'Meritas Health Richmond'
			when a.appt_location_cd = 'MH Smithville' then 'Meritas Health Smithville'
			when a.appt_location_cd = 'MH Surg Trauma' then 'Meritas Health Surgery & Trauma'
			when a.appt_location_cd = 'MH Surg Trma-BP' then 'Meritas Health Surgery & Trauma'
			when a.appt_location_cd = 'MH Total Weight Loss Center' then 'Meritas Health Total Weight Loss Center'
			when a.appt_location_cd = 'MH Vivion' then 'Meritas Health Vivion'
			when a.appt_location_cd = 'P/T' then 'Physical Therapy'
			else a.appt_location_cd
			end as appt_location
		,case 
			when a.sb_appt_type_cd like '%New Patient%' then 'New Patient'
			when a.sb_appt_type_cd like '%--%' then RIGHT(a.sb_appt_type_cd,len(a.sb_appt_type_cd)-2)
			when a.sb_appt_type_cd like '%xTWLC%' then RIGHT(a.sb_appt_type_cd,len(a.sb_appt_type_cd)-1)
			when a.sb_appt_type_cd = 'New Medicare Patient' then 'New Patient'
			when a.sb_appt_type_cd = 'Office Visit - Extended' then 'Office Visit'
			when a.sb_appt_type_cd = 'Office Visit - UC' then 'Office Visit'
			when a.sb_appt_type_cd = 'TeleHealth - Extended' then 'TeleHealth'
			when a.sb_appt_type_cd = 'LAB - AMB' then 'Laboratory'
			when a.sb_appt_type_cd = 'ALT Visit' then 'ALT (Blood Test) Visit'
			when a.sb_appt_type_cd = 'ER Follow Up' then 'Follow Up'
			when a.sb_appt_type_cd = 'Hospital Follow Up' then 'Follow Up'
			when a.sb_appt_type_cd = 'Audio New - Medicare' then 'New Patient'
			when a.sb_appt_type_cd = 'Audio Return - Medicare' then 'Audio Follow Up'
			when a.sb_appt_type_cd = 'Audio Return Patient' then 'Audio Follow Up'
			when a.sb_appt_type_cd = 'Dizzy Return Patient' then 'Follow Up'
			when a.sb_appt_type_cd = 'New GYN' then 'New Patient'
			else a.sb_appt_type_cd 
			end as appt_type
		,case
			when a.appt_location_cd = 'MH Card-NKC' then 'Cardiology'
			when a.appt_location_cd = 'MH Card -NO' then 'Cardiology'
			when a.appt_location_cd = 'MH Card -Eng' then 'Cardiology'
			when a.appt_location_cd = 'MH Card -ES' then 'Cardiology'
			when a.appt_location_cd = 'MH Card -Indep' then 'Cardiology'
			when a.appt_location_cd = 'MH Card -Richmd' then 'Cardiology'
			when a.appt_location_cd = 'MH Card -SC' then 'Cardiology'
			when a.appt_location_cd = 'MH Card -Tremnt' then 'Cardiology'
			when a.appt_location_cd = 'MH Anticoag' then 'Cardiology'
			when a.appt_location_cd = '' then 'Cardiology'
			when a.appt_location_cd = '' then 'Cardiology'
			when a.appt_location_cd = '' then 'Cardiology'
			else 'Non-Cardiology'
			end as Cardiology
		,CONVERT(DATE, CONVERT(VARCHAR(7), a.beg_dt_tm_tz, 120) + '-01') as appt_month
		,CONVERT(DATE, a.beg_dt_tm_tz) as appt_day
	from
		NewPatient.Appointments a
		join NewPatient.v_facility_group_one f on a.appt_location_cd = f.appt_location_cd and f.group_1 = 'Meritas Health'
	where
		CONVERT(DATE, CONVERT(VARCHAR(7), a.beg_dt_tm_tz, 120) + '-01') <= getdate()
)a
where
	appt_location not in ('Meritas Health Acute Care Clinic', 'Meritas Health Excelsior Springs', 'Meritas Health Express'
	,'Meritas Health NKC Schools', 'Meritas Health Oakview')
--order by facility, appt_location, appt_type
GO


