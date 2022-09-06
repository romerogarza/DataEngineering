USE [PROJECTS]
GO

/****** Object:  View [NewPatient].[v_facility_zipcode_map]    Script Date: 9/5/2022 10:12:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [NewPatient].[v_facility_zipcode_map] as

select
	area
	,appt_location
	,zipcode
	,city_state
	,count
	,area_count
	,perc
	,case
		when perc < round((max(perc) over (partition by appt_location))/3,2) then 'Low'
		when perc > (round((max(perc) over (partition by appt_location))/3,2))*2 then 'High'
		else 'Medium'
		end as groupings
from(
	select distinct
		area
		,appt_location
		,city_state
		,zipcode
		,count(full_name) over (partition by appt_location,zipcode) as count
		,count(full_name) over (partition by appt_location) as area_count
		,round((convert(float,count(full_name) over (partition by appt_location,zipcode))/
			convert(float,count(full_name) over (partition by appt_location)))*100,2) as perc
	from(
		select
			a.appt_month
			,a.appt_location
			,a.person as full_name
			,z.zipcode
			,z.county
			,z.city
			,z.state
			,z.city_state
			,case 
				when z.city_state = 'Basehor, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Blue Springs, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Excelsior Springs, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Independence, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Kansas City, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Kansas City, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Lees Summit, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Lenexa, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Liberty, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Mission, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Olathe, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Overland Park, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Platte City, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Prairie Village, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Raymore, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Riverside, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Shawnee, KS' then 'Kansas City Metro Area'
				when z.city_state = 'Smithville, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Dearborn, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Edgerton, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Plattsburg, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Trimble, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Kearney, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Belton, MO' then 'Kansas City Metro Area'
				when z.city_state = 'Gladstone, MO' then 'Kansas City Metro Area'
				when z.city_state = 'North Kansas City, MO' then 'Kansas City Metro Area'
				else 'Outside Kansas City Metro' end as Area
		from
			(select
				a.appt_month
				,a.appt_location
				,a.appt_type
				,a.person
				,case 
					when a.zipcode = '64013' then '64014'
					when a.zipcode = '66051' then '66061'
					when a.zipcode = '66063' then '66062'
					when a.zipcode = '64069' then '64068'
					when a.zipcode = '64162' then '64161'
					when a.zipcode = '64188' then '64118'
					when a.zipcode = '64144' then '64161'
					when a.zipcode = '64051' then '64052'
					when a.zipcode = '64190' then '64154'
					when a.zipcode = '64195' then '64152'
					when a.zipcode = '64168' then '64150'
					when a.zipcode = '66110' then '66102'
					when a.zipcode = '66117' then '66101'
					when a.zipcode = '64199' then '64106'
					when a.zipcode = '64198' then '64106'
					when a.zipcode = '64184' then '64106'
					when a.zipcode = '64180' then '64106'
					when a.zipcode = '64121' then '64127'
					when a.zipcode = '64191' then '64124'
					when a.zipcode = '64196' then '64105'
					when a.zipcode = '64141' then '64108'
					when a.zipcode = '64179' then '64108'
					when a.zipcode = '66119' then '66103'
					when a.zipcode = '64171' then '64111'
					when a.zipcode = '66222' then '66205'
					when a.zipcode = '66201' then '66202'
					when a.zipcode = '66286' then '66226'
					when a.zipcode = '66285' then '66215'
					when a.zipcode = '66282' then '66212'
					when a.zipcode = '66255' then '66213'
					when a.zipcode = '66225' then '66213'
					when a.zipcode = '66283' then '66223'
					when a.zipcode = '64148' then '64145'
					when a.zipcode = '64170' then '64131'
					else a.zipcode end as zipcode
			from
				NewPatient.v_Appointments a) a
				join ENTERPRISE.data_gov.v_zipcodes z on a.zipcode = z.zipcode
		where
			a.appt_type = 'New Patient'
			and a.zipcode is not null
		)a
	)b
/*order by
	appt_location, groupings*/
GO


