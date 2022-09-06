USE [PROJECTS]
GO
/****** Object:  StoredProcedure [NewPatient].[appointments_daily_update]    Script Date: 9/5/2022 10:00:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [NewPatient].[appointments_daily_update] AS

BEGIN
	CREATE table #appointments (
			SCH_APPT_ID			bigint
			,PERSON_ID			nvarchar(MAX)
			,FIRST_NAME			nvarchar(MAX)
			,LAST_NAME			nvarchar(MAX)
			,GENDER				nvarchar(MAX)
			,ZIPCODE			nvarchar(MAX)
			,DURATION			int
			,ACTIVITY_CD		nvarchar(MAX)
			,SCH_STATE_CD		nvarchar(MAX)
			,SCH_ROLE_CD		nvarchar(MAX)
			,ACTIVE_STATUS_CD	nvarchar(MAX)
			,APPT_LOCATION_CD	nvarchar(MAX)
			,BEG_DT_TM_TZ		datetime
			,END_DT_TM_TZ		datetime
			,SB_APPT_TYPE_CD	nvarchar(MAX)
			,FACILITY			nvarchar(MAX)
			,BUILDING			nvarchar(MAX)
			,UNIT				nvarchar(MAX)
			,ROOM				nvarchar(MAX)
			,BED				nvarchar(MAX)
			,ENCNTR_TYPE_CD		nvarchar(MAX)
			,ENCNTR_PRSNL_R_CD	nvarchar(MAX)
			,PHYSICIAN			nvarchar(MAX)
			,LOC_FACILITY		int
			,LOC_BUILDING		int
			,FIN				int
			,BIRTH_DT			nvarchar(10)
			,ENCNTR_ID			bigint
			,UPDATE_DT_TM		datetime2
		)
		
		BEGIN

			DECLARE @FirstDay as VARCHAR(10) = (select dateadd(day,-4,convert(date,getdate())))
			DECLARE @NextDay as VARCHAR(11) = (select dateadd(day,-1,convert(date,getdate())))

			insert into #appointments
			/*Checked Out & No Shows*/
			SELECT distinct
				s.sch_appt_id
				,p.NAME_FULL_FORMATTED AS Patient
				,p.NAME_FIRST as FIRST_NAME
				,p.NAME_LAST as LAST_NAME
				,(select display from enterprise.cerner.code_value where code_value = p.sex_cd) as gender
				,case when len(zipcode) > 5 then left(zipcode,5) else zipcode end as zipcode
				,s.duration
				,(select display from enterprise.cerner.code_value where code_value = s.activity_cd) as activity_cd
				,(select display from enterprise.cerner.code_value where code_value = s.SCH_STATE_CD) as "S_SCH_STATE_DISP"
				,(select display from enterprise.cerner.code_value where code_value = s.sch_role_cd) as sch_role_cd
				,(select display from enterprise.cerner.code_value where code_value = s.active_status_cd) as activity_status_cd
				,(select display from enterprise.cerner.code_value where code_value = s.appt_location_cd) as appt_location_cd
				,DATEADD(MINUTE, DATEDIFF(MINUTE, getutcdate(), getdate()), s.BEG_DT_TM) as BEG_DT_TM_TZ
				,DATEADD(MINUTE, DATEDIFF(MINUTE, getutcdate(), getdate()), s.END_DT_TM) as END_DT_TM_TZ
				,(select display from enterprise.cerner.code_value where code_value = se.APPT_TYPE_CD) as "SB_APPT_TYPE_CD"
				,(select display from enterprise.cerner.code_value where code_value = e.LOC_FACILITY_CD) as FACILITY
				,(select display from enterprise.cerner.code_value where code_value = e.LOC_BUILDING_CD) as BUILDING
				,(select display from enterprise.cerner.code_value where code_value = e.LOC_NURSE_UNIT_CD) as UNIT
				,(select display from enterprise.cerner.code_value where code_value = e.LOC_ROOM_CD) as ROOM
				,(select display from enterprise.cerner.code_value where code_value = e.LOC_BED_CD) as BED
				,(select display from enterprise.cerner.code_value where code_value = e.encntr_type_cd) as encntr_type_cd
				,s2.ROLE_DESCRIPTION  as ENCNTR_PRSNL_R_CD
				,(select display from enterprise.cerner.code_value where code_value = s2.RESOURCE_CD) as PHYSICIAN
				,e.LOC_FACILITY_CD as LOC_FACILITY
				,e.LOC_BUILDING_CD as LOC_BUILDING
				,ea.alias as FIN
				,CAST(p.BIRTH_DT_TM AS DATE) AS BIRTH_DT
				,e.encntr_id
				,getdate() as update_dt_tm
			FROM
				enterprise.cerner.sch_appt s
				join enterprise.cerner.sch_appt s2 
					on s2.sch_event_id = s.sch_event_id 
					and s2.schedule_id = s.schedule_id /*Most Recent*/ 
					and s2.primary_role_ind = 1 --and s2.ROLE_DESCRIPTION in (''Providers'',''Resource'')
					and s2.beg_effective_dt_tm <= sysutcdatetime() 
					and s2.end_effective_dt_tm > sysutcdatetime()
				join enterprise.cerner.person p 
					on p.person_id = s.person_id
					and p.active_ind = 1
					and p.beg_effective_dt_tm <= sysutcdatetime() 
					and p.end_effective_dt_tm > sysutcdatetime()
				join enterprise.cerner.sch_event se 
					on se.sch_event_id = s.sch_event_id 
					and se.active_ind = 1
					and se.beg_effective_dt_tm <= sysutcdatetime() 
					and se.end_effective_dt_tm > sysutcdatetime()
				left join enterprise.cerner.encounter e 
					on s.encntr_id = e.encntr_id
					and e.active_ind = 1
					and e.beg_effective_dt_tm <= sysutcdatetime() 
					and e.end_effective_dt_tm > sysutcdatetime()
				left join enterprise.cerner.encntr_alias ea 
					on e.encntr_id = ea.encntr_id 
					and ea.encntr_alias_type_cd = 1077 
					and ea.updt_cnt = 0
					and ea.active_ind = 1
					and ea.beg_effective_dt_tm <= sysutcdatetime() 
					and ea.end_effective_dt_tm > sysutcdatetime()
				left join (
						select 
							a.parent_entity_id 
							,case when a.zipcode like '%-%' then replace(a.zipcode,'-','') else a.zipcode end as zipcode 
							,a.beg_effective_dt_tm
							,a.end_effective_dt_tm
						from 
							enterprise.cerner.address a
						where
							a.address_type_cd = 756 
							and a.active_ind = 1)a 
					on p.person_id = a.parent_entity_id
					and a.beg_effective_dt_tm <= sysutcdatetime() 
					and a.end_effective_dt_tm > sysutcdatetime()
			where 
				s.sch_role_cd = 4572 /*patient*/
				and s.active_ind = 1
				and s.appt_location_cd > 0
				and s.BEG_DT_TM >= @FirstDay
				and s.END_DT_TM < @NextDay
				and s.sch_state_cd in (4537,4543)
			UNION ALL
			/*Cancellations*/
			SELECT distinct
				s.sch_appt_id
				,p.NAME_FULL_FORMATTED AS Patient
				,p.NAME_FIRST as FIRST_NAME
				,p.NAME_LAST as LAST_NAME
				,(select display from enterprise.cerner.code_value where code_value = p.sex_cd) as gender
				,case when len(zipcode) > 5 then left(zipcode,5) else zipcode end as zipcode
				,s.duration
				,(select display from enterprise.cerner.code_value where code_value = s.activity_cd) as activity_cd
				,(select display from enterprise.cerner.code_value where code_value = s.SCH_STATE_CD) as "S_SCH_STATE_DISP"
				,(select display from enterprise.cerner.code_value where code_value = s.sch_role_cd) as sch_role_cd
				,(select display from enterprise.cerner.code_value where code_value = s.active_status_cd) as activity_status_cd
				,(select display from enterprise.cerner.code_value where code_value = s.appt_location_cd) as appt_location_cd
				,DATEADD(MINUTE, DATEDIFF(MINUTE, getutcdate(), getdate()), s.BEG_DT_TM) as BEG_DT_TM_TZ
				,DATEADD(MINUTE, DATEDIFF(MINUTE, getutcdate(), getdate()), s.END_DT_TM) as END_DT_TM_TZ
				,(select display from enterprise.cerner.code_value where code_value = sb.appt_type_cd) as sb_appt_type_cd
				,null as Facility
				,(select display from enterprise.cerner.code_value where code_value = sb.LOCATION_CD) as Building
				,null as unit
				,null as room
				,null as bed
				,null as encntr_type_cd
				,s2.ROLE_DESCRIPTION as ENCNTR_PRSNL_R_CD
				,(select display from enterprise.cerner.code_value where code_value = s2.RESOURCE_CD) as PHYSICIAN
				,null as LOC_FACILITY
				,sb.LOCATION_CD as LOC_BUILDING
				,null as FIN
				,CAST(p.BIRTH_DT_TM AS DATE) AS BIRTH_DT
				,e.encntr_id
				,getdate() as update_dt_tm
			FROM
				enterprise.cerner.sch_appt s
				join enterprise.cerner.sch_appt s2 
					on s2.sch_event_id = s.sch_event_id 
					and s2.schedule_id = s.schedule_id /*Most Recent*/ 
					and s2.primary_role_ind = 1 
					and (s2.ROLE_DESCRIPTION in ('Providers','Resource','Provider') OR s2.ROLE_DESCRIPTION is null)
					and s2.active_ind = 1
					and s2.beg_effective_dt_tm <= sysutcdatetime() 
					and s2.end_effective_dt_tm > sysutcdatetime()
				join enterprise.cerner.person p 
					on p.person_id = s.person_id
					and p.active_ind = 1
					and p.beg_effective_dt_tm <= sysutcdatetime() 
					and p.end_effective_dt_tm > sysutcdatetime()
				join enterprise.cerner.sch_event se 
					on se.sch_event_id = s.sch_event_id 
					and se.active_ind = 1
					and se.beg_effective_dt_tm <= sysutcdatetime() 
					and se.end_effective_dt_tm > sysutcdatetime()
				join enterprise.cerner.sch_booking sb 
					on sb.booking_id = s.booking_id 
					and sb.active_ind = 1
					and sb.beg_effective_dt_tm <= sysutcdatetime() 
					and sb.end_effective_dt_tm > sysutcdatetime()
				left join enterprise.cerner.encounter e 
					on s.encntr_id = e.encntr_id
					and e.active_ind = 1
					and e.beg_effective_dt_tm <= sysutcdatetime() 
					and e.end_effective_dt_tm > sysutcdatetime()
				left join enterprise.cerner.encntr_alias ea 
					on e.encntr_id = ea.encntr_id 
					and ea.encntr_alias_type_cd = 1077 
					and ea.updt_cnt = 0
					and ea.active_ind = 1
					and ea.beg_effective_dt_tm <= sysutcdatetime() 
					and ea.end_effective_dt_tm > sysutcdatetime()
				left join (
						select 
							a.parent_entity_id 
							,case when a.zipcode like '%-%' then replace(a.zipcode,'-','') else a.zipcode end as zipcode 
							,a.beg_effective_dt_tm
							,a.end_effective_dt_tm
						from 
							enterprise.cerner.address a
						where
							a.address_type_cd = 756 
							and a.active_ind = 1)a 
					on p.person_id = a.parent_entity_id
					and a.beg_effective_dt_tm <= sysutcdatetime() 
					and a.end_effective_dt_tm > sysutcdatetime()
			where 
				s.sch_role_cd = 4572 /*patient*/
				and s.active_ind = 1
				and s.BEG_DT_TM >= @FirstDay
				and s.END_DT_TM < @NextDay
				and s.SCH_STATE_CD = 4535 /*Cancelled*/
		END
		BEGIN
			delete
			from
				NewPatient.Appointments
			where
				sch_appt_id in (select sch_appt_id from #appointments)
		END
		BEGIN
			INSERT INTO NewPatient.Appointments
			SELECT * FROM #appointments
		END
END
