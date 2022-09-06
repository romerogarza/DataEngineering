USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_zipcode_all]    Script Date: 9/5/2022 10:20:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_zipcode_all] as

select
	area
	,appt_location
	,zipcode
	,city_state
	,count
	,area_count
	,concat(perc,'%') as perc
	,groupings
from
	NewPatient.v_facility_zipcode_map
union all
select
	area
	,'All' as appt_location
	,zipcode
	,city_state
	,count
	,area_count
	,concat(perc,'%') as perc
	,groupings
from
	NewPatient.v_ov_zipcode_map
GO