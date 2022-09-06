USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_facility_group_one]    Script Date: 9/5/2022 10:12:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [NewPatient].[v_facility_group_one] as

select distinct
	case 
		when appt_location_cd = 'MH Acute Care Clinic' then 'Meritas Health'
		when appt_location_cd = 'MH Anticoag' then 'Meritas Health'
		when appt_location_cd = 'MH Briarcliff Suite 100' then 'Meritas Health'
		when appt_location_cd = 'MH Briarcliff Suite 200' then 'Meritas Health'
		when appt_location_cd = 'MH Card -Eng' then 'Meritas Health'
		when appt_location_cd = 'MH Card -ES' then 'Meritas Health'
		when appt_location_cd = 'MH Card -Indep' then 'Meritas Health'
		when appt_location_cd = 'MH Card -NO' then 'Meritas Health'
		when appt_location_cd = 'MH Card -Richmd' then 'Meritas Health'
		when appt_location_cd = 'MH Card -SC' then 'Meritas Health'
		when appt_location_cd = 'MH Card -Tremnt' then 'Meritas Health'
		when appt_location_cd = 'MH Card-NKC' then 'Meritas Health'
		when appt_location_cd = 'MH Comp Surg' then 'Meritas Health'
		when appt_location_cd = 'MH CTS' then 'Meritas Health'
		when appt_location_cd = 'MH Endocrine' then 'Meritas Health'
		when appt_location_cd = 'MH ENT' then 'Meritas Health'
		when appt_location_cd = 'MH ENT North Oak' then 'Meritas Health'
		when appt_location_cd = 'MH Exp 64th St' then 'Meritas Health'
		when appt_location_cd = 'MH Exp Gladstn' then 'Meritas Health'
		when appt_location_cd = 'MH Exp Liberty' then 'Meritas Health'
		when appt_location_cd = 'MH Gashland' then 'Meritas Health'
		when appt_location_cd = 'MH Gashland-UC' then 'Meritas Health'
		when appt_location_cd = 'MH Landmark' then 'Meritas Health'
		when appt_location_cd = 'MH Neurology' then 'Meritas Health'
		when appt_location_cd = 'MH Neurology-BP' then 'Meritas Health'
		when appt_location_cd = 'MH Neurosurgery' then 'Meritas Health'
		when appt_location_cd = 'MH NKC' then 'Meritas Health'
		when appt_location_cd = 'MH NKC Schools' then 'Meritas Health'
		when appt_location_cd = 'MH Oakview' then 'Meritas Health'
		when appt_location_cd = 'MH Obs & Gyn' then 'Meritas Health'
		when appt_location_cd = 'MH Park Plaza' then 'Meritas Health'
		when appt_location_cd = 'MH Pav Women' then 'Meritas Health'
		when appt_location_cd = 'MH Pediatrics' then 'Meritas Health'
		when appt_location_cd = 'MH Pediatrics- Tiffany Springs' then 'Meritas Health'
		when appt_location_cd = 'MH Platte City' then 'Meritas Health'
		when appt_location_cd = 'MH Psychiatry' then 'Meritas Health'
		when appt_location_cd = 'MH Pulmonary Med Suite 605' then 'Meritas Health'
		when appt_location_cd = 'MH Pulmonary Med Suite 620' then 'Meritas Health'
		when appt_location_cd = 'MH Richmond' then 'Meritas Health'
		when appt_location_cd = 'MH Smithville' then 'Meritas Health'
		when appt_location_cd = 'MH Surg Trauma' then 'Meritas Health'
		when appt_location_cd = 'MH Surg Trma-BP' then 'Meritas Health'
		when appt_location_cd = 'MH Total Weight Loss Center' then 'Meritas Health'
		when appt_location_cd = 'MH Vivion' then 'Meritas Health'
		else 'NKCH'
	end as group_1
	,appt_location_cd
from
	NewPatient.Appointments
GO
