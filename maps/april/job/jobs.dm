/datum/map/april
	allowed_jobs = list(/datum/job/fallout/overseer, /datum/job/fallout/hop, /datum/job/fallout/hos,
						/datum/job/fallout/detective, /datum/job/fallout/officer, /datum/job/fallout/cmo, /datum/job/fallout/doctor,
						/datum/job/fallout/chemist, /datum/job/fallout/psychiatrist, /datum/job/fallout/rd, /datum/job/fallout/scientist, /datum/job/fallout/roboticist,
						/datum/job/fallout/chief_engineer, /datum/job/fallout/engineer, /datum/job/fallout/cyborg, /datum/job/fallout/bartender, /datum/job/fallout/chef,
						/datum/job/fallout/hydro, /datum/job/fallout/qm, /datum/job/fallout/cargo_tech, /datum/job/fallout/mining, /datum/job/fallout/janitor,
						/datum/job/fallout/sheriff, /datum/job/fallout/sheriff/deputy, /datum/job/fallout/wastedoc, /datum/job/fallout/hotel, /datum/job/fallout/hotelmaid,
						/datum/job/fallout/solareng, /datum/job/fallout/settler, /datum/job/fallout/merchant
)



/datum/job/fallout/overseer
	title = "Overseer"
	department = "Command"
	head_position = 1
	department_flag = COM
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	ideal_character_age = 70 // Old geezer captains ftw
	outfit_type = /decl/hierarchy/outfit/job/captain/fallout
	announced = 1

/datum/job/fallout/overseer/get_access()
	return get_all_station_access()

/datum/job/fallout/hop
	title = "Head of Personnel"
	head_position = 1
	department_flag = COM|CIV
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the overseer"
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 14
	economic_modifier = 10
	ideal_character_age = 50

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)

	outfit_type = /decl/hierarchy/outfit/job/hop/fallout
	announced = 1



//--------------------------
//Security
//--------------------------
/datum/job/fallout/hos
	title = "Head of Security"
	head_position = 1
	department = "Security"
	department_flag = SEC|COM
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the overseer"
	selection_color = "#8e2929"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/security/hos/fallout
	announced = 1

/datum/job/fallout/detective
	title = "Detective"
	department = "Security"
	department_flag = SEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#601c1c"
	alt_titles = list("Forensic Technician" = /decl/hierarchy/outfit/job/security/detective/forensic)
	economic_modifier = 5
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/security/detective/fallout

/datum/job/fallout/officer
	title = "Security Officer"
	department = "Security"
	department_flag = SEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the head of security"
	selection_color = "#601c1c"
	alt_titles = list("Junior Officer")
	economic_modifier = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/security/officer/fallout



//--------------------------
//MEDICAL
//--------------------------
/datum/job/fallout/cmo
	title = "Chief Medical Officer"
	head_position = 1
	department = "Medical"
	department_flag = MED|COM
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the overseer"
	selection_color = "#026865"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks)

	minimal_player_age = 14
	ideal_character_age = 50
	outfit_type = /decl/hierarchy/outfit/job/medical/cmo/fallout
	announced = 1

/datum/job/fallout/doctor
	title = "Medical Doctor"
	department = "Medical"
	department_flag = MED
	faction = "Station"
	minimal_player_age = 3
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"
	economic_modifier = 7
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology)
	alt_titles = list(
		"Surgeon",
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician/,
		"Nurse",
		"Virologist" = /decl/hierarchy/outfit/job/medical/doctor/virologist/fallout)
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor/fallout

/datum/job/fallout/chemist
	title = "Chemist"
	department = "Medical"
	department_flag = MED
	faction = "Station"
	minimal_player_age = 7
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"
	economic_modifier = 5
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)
	alt_titles = list("Pharmacist")
	outfit_type = /decl/hierarchy/outfit/job/medical/chemist/fallout

/datum/job/fallout/psychiatrist
	title = "Psychiatrist"
	department = "Medical"
	department_flag = MED
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	minimal_player_age = 3
	supervisors = "the chief medical officer"
	selection_color = "#013d3b"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	alt_titles = list("Psychologist" = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist)
	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist/fallout



//--------------------------
//SCIENCE
//--------------------------
/datum/job/fallout/rd
	title = "Research Director"
	head_position = 1
	department = "Science"
	department_flag = COM|SCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the overseer"
	selection_color = "#ad6bad"
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_player_age = 14
	ideal_character_age = 50
	outfit_type = /decl/hierarchy/outfit/job/science/rd/fallout
	announced = 1

/datum/job/fallout/scientist
	title = "Scientist"
	department = "Science"
	faction = "Station"
	department_flag = SCI
	total_positions = 3
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#633d63"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_hydroponics)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_xenobiology, access_hydroponics)
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/science/scientist/fallout

/datum/job/fallout/roboticist
	title = "Roboticist"
	department = "Science"
	faction = "Station"
	department_flag = SCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#633d63"
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	alt_titles = list("Biomechanical Engineer","Mechatronic Engineer")
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/science/roboticist/fallout



//--------------------------
//ENGINEERING
//--------------------------
/datum/job/fallout/chief_engineer
	title = "Chief Engineer"
	head_position = 1
	department = "Engineering"
	faction = "Station"
	department_flag = ENG|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the overseer"
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	economic_modifier = 10

	ideal_character_age = 50


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer/fallout
	announced = 1

/datum/job/fallout/engineer
	title = "Station Engineer"
	department = "Engineering"
	faction = "Station"
	department_flag = ENG
	total_positions = 3
	spawn_positions = 3
	supervisors = "the overseer"
	selection_color = "#5b4d20"
	economic_modifier = 5
	minimal_player_age = 7
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_emergency_storage)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_emergency_storage)
	alt_titles = list("Maintenance Technician","Engine Technician","Electrician",
		"Atmospheric Technician" = /decl/hierarchy/outfit/job/engineering/atmos/fallout)
	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer/fallout


/datum/job/fallout/cyborg
	title = "Cyborg"
	faction = "Station"
	department_flag = MSC
	total_positions = 2
	spawn_positions = 2
	supervisors = "your laws"	//Nodrak
	selection_color = "#254c25"
	minimal_player_age = 7
	alt_titles = list("Android", "Robot")
	account_allowed = 0
	economic_modifier = 0
	outfit_type = /decl/hierarchy/outfit/job/silicon/cyborg

/datum/job/fallout/cyborg/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1



//--------------------------
//CIVILIAN
//--------------------------
/datum/job/fallout/bartender
	title = "Bartender"
	department = "Service"
	faction = "Station"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)
	outfit_type = /decl/hierarchy/outfit/job/service/bartender/fallout

/datum/job/fallout/chef
	title = "Chef"
	department = "Service"
	faction = "Station"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")
	outfit_type = /decl/hierarchy/outfit/job/service/chef/fallout

/datum/job/fallout/hydro
	title = "Botanist"
	department = "Service"
	faction = "Station"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Hydroponicist")
	outfit_type = /decl/hierarchy/outfit/job/service/gardener/fallout

/datum/job/fallout/qm
	title = "Quartermaster"
	department = "Supply"
	faction = "Station"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_player_age = 3
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/cargo/qm/fallout

/datum/job/fallout/cargo_tech
	title = "Cargo Technician"
	department = "Supply"
	faction = "Station"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)
	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech/fallout

/datum/job/fallout/mining
	title = "Shaft Miner"
	department = "Supply"
	faction = "Station"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	alt_titles = list("Drill Technician","Prospector")
	outfit_type = /decl/hierarchy/outfit/job/cargo/mining/fallout

/datum/job/fallout/janitor
	title = "Janitor"
	department = "Service"
	faction = "Station"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	access = list(access_janitor, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_medical)
	minimal_access = list(access_janitor, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_medical)
	alt_titles = list("Custodian","Sanitation Technician")
	outfit_type = /decl/hierarchy/outfit/job/service/janitor/fallout


//--------------------------
//Settlers
//--------------------------
/datum/job/fallout/sheriff
	title = "Sheriff"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 1
	spawn_positions = 1
	supervisors = "none"
	outfit_type = /decl/hierarchy/outfit/settler/sheriff

/datum/job/fallout/sheriff/deputy
	title = "Deputy"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Sheriff"
	outfit_type = /decl/hierarchy/outfit/settler/sheriff/deputy

/datum/job/fallout/wastedoc
	title = "Frontier Doctor"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 2
	spawn_positions = 2
	supervisors = "none"
	outfit_type = /decl/hierarchy/outfit/settler/wastedoc

/datum/job/fallout/hotel
	title = "Hotel Manager"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 1
	spawn_positions = 1
	supervisors = "none"
	outfit_type = /decl/hierarchy/outfit/settler/manager

/datum/job/fallout/hotelmaid
	title = "Hotel Maid"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the hotel manager"
	outfit_type = /decl/hierarchy/outfit/settler/maid

/datum/job/fallout/solareng
	title = "Solar Field Engineer"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 1
	spawn_positions = 1
	supervisors = "none"
	outfit_type = /decl/hierarchy/outfit/settler/solareng

/datum/job/fallout/settler
	title = "Settler"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 10
	spawn_positions = 10
	supervisors = "none"
	outfit_type = /decl/hierarchy/outfit/settler/settler

/datum/job/fallout/merchant
	title = "Merchant"
	faction = "Station"
	selection_color = "#b82e00"
	total_positions = 2
	spawn_positions = 2
	supervisors = "none"
	outfit_type = /decl/hierarchy/outfit/settler/merchant