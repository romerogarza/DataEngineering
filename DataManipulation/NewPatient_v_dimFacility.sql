USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_dimFacility]    Script Date: 9/5/2022 10:10:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [NewPatient].[v_dimFacility] AS

select distinct
	case 
		when building = 'Community Vaccination Clinic' then 'Community Vaccination Clinic'
		when building = 'Employee Health Services' then 'Employee Health Services'
		when building = 'KC Health Trust' then 'KC Health Trust'
		when building = 'MH Acute Care Clinic' then 'MH Acute Care Clinic'
		when building = 'MH Anticoag' then 'Meritas Health Cardiology'
		when building = 'MH Briarcliff' then 'Meritas Health Briarcliff'
		when building = 'MH Card -Indep' then 'Meritas Health Cardiology'
		when building = 'MH Card -ES' then 'Meritas Health Cardiology'
		when building = 'MH Card -Eng' then 'Meritas Health Cardiology'
		when building = 'MH Cardiology-NKC' then 'Meritas Health Cardiology'
		when building = 'MH Card -NO' then 'Meritas Health Cardiology'
		when building = 'MH Card -Richmd' then 'Meritas Health Cardiology'
		when building = 'MH Card -SC' then 'Meritas Health Cardiology'
		when building = 'MH Card -Tremnt' then 'Meritas Health Cardiology'
		when building = 'MH Comp Surg' then 'Meritas Health Comprehensive Surgery'
		when building = '' then ''
		when building = 'MH Endocrine' then 'Meritas Health Endocrinology'
		when building = 'MH ENT' then 'Meritas Health ENT'
		when building = 'MH ENT North Oak' then 'Meritas Health ENT'
		when building = 'MH Exp 64th St' then 'Meritas Health Express'
		when building = 'MH Exp Gladstn' then 'Meritas Health Express'
		when building = 'MH Exp Liberty' then 'Meritas Health Express'
		when building = 'MH Gashland' then 'Meritas Health Gashland'
		when building = 'MH Gashland-UC' then 'Meritas Health Gashland'
		when building = 'MH Landmark' then 'Meritas Health Landmark'
		when building = 'MH Neurology' then 'Meritas Health Neurology'
		when building = 'MH Neurology-BP' then 'Meritas Health Neurology'
		when building = 'MH Neurosurgery' then 'Meritas Health Neurosurgery'
		when building = 'MH NKC Schools' then 'Meritas Health NKC Schools'
		when building = 'MH NKC' then 'Meritas Health North Kansas City'
		when building = 'MH Oakview' then 'Meritas Health Oakview'
		when building = 'MH Obs & Gyn' then 'Meritas Health Obstetrics & Gynecology'
		when building = 'MH Park Plaza' then 'Meritas Health Park Plaza'
		when building = 'MH Pav Women' then 'Meritas Health Pavilion for Women'
		when building = 'MH Pediatrics' then 'Meritas Health Pediatrics'
		when building = 'MH Pediatrics- Tiffany Springs' then 'Meritas Health Pediatrics'
		when building = 'MH Platte City' then 'Meritas Health Platte City'
		when building = 'MH Psychiatry' then 'Meritas Health Psychiatry'
		when building = 'MH Pulmonary' then 'Meritas Health Pulmonary Medicine'
		when building = 'MH Richmond' then 'Meritas Health Richmond'
		when building = 'MH Smithville' then 'Meritas Health Smithville'
		when building = 'MH Surg Trauma' then 'Meritas Health Surgery & Trauma'
		when building = 'MH Surg Trma-BP' then 'Meritas Health Surgery & Trauma'
		when building = 'MH Total Weight Loss Center' then 'Meritas Health Total Weight Loss Center'
		when building = 'MH Vivion' then 'Meritas Health Vivion'
		when building = 'NKCH Main' then 'NKCH'
		when building = 'NKCH Inpt Rehab' then 'NKCH Inpt Rehab'
		when building = 'Univ of KS Cardiothoracic Surgery at NKC' then 'Meritas Health Cardiology'
		end as Grouped_Facility
	,building
from
	NewPatient.Appointment_with_cd
where
	building != ''

GO