/datum/map/torch
	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos,
						/datum/job/liaison, /datum/job/representative, /datum/job/sea,
						/datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist,
						/datum/job/officer, /datum/job/warden, /datum/job/detective,
						/datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor,
						/datum/job/virologist, /datum/job/chemist, /datum/job/psychiatrist,
						/datum/job/qm, /datum/job/cargo_tech, /datum/job/cargo_contractor,
						/datum/job/janitor, /datum/job/chef, /datum/job/bartender,
						/datum/job/scientist, /datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant,
						/datum/job/ai, /datum/job/cyborg,
						/datum/job/crew, /datum/job/assistant
						/*/datum/job/merchant*/
						)


/datum/job/captain
	title = "Commanding Officer"
	supervisors = "the Sol Central Government and the Sol Code of Military Justice"
	minimal_player_age = 21
	economic_modifier = 15
	ideal_character_age = 50
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/CO
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o6
	)


/datum/job/hop
	title = "Executive Officer"
	supervisors = "the Commanding Officer"
	minimal_player_age = 21
	economic_modifier = 10
	ideal_character_age = 45
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/XO
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o5,
		/datum/mil_rank/marine/o5,
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/marine/o4
	)


	access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_medical, access_morgue, access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_change_ids, access_ai_upload, access_teleporter, access_eva, access_heads,
			            access_all_personal_lockers, access_chapel_office, access_tech_storage, access_atmospherics, access_bar, access_janitor, access_crematorium, access_robotics,
			            access_kitchen, access_cargo, access_construction, access_chemistry, access_cargo_bot, access_hydroponics, access_library, access_virology,
			            access_cmo, access_qm, access_network, access_surgery, access_mailsorting, access_heads_vault, access_ce,
			            access_hop, access_hos, access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_sec_doors, access_psychiatrist,
			            access_medical_equip, access_solgov_crew, access_robotics_engineering, access_emergency_armory, access_gun, access_calypso, access_guppy)
	minimal_access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_medical, access_morgue, access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_change_ids, access_ai_upload, access_teleporter, access_eva, access_heads,
			            access_all_personal_lockers, access_chapel_office, access_tech_storage, access_atmospherics, access_bar, access_janitor, access_crematorium,
			            access_kitchen, access_cargo, access_construction, access_chemistry, access_cargo_bot, access_hydroponics, access_library, access_virology,
			            access_cmo, access_qm, access_network, access_surgery, access_mailsorting, access_heads_vault, access_ce,
			            access_hop, access_hos, access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_sec_doors, access_psychiatrist,
			            access_medical_equip, access_solgov_crew, access_robotics_engineering, access_emergency_armory, access_gun, access_calypso, access_guppy)


/datum/job/rd
	title = "Research Director"
	supervisors = "NanoTrasen and the Commanding Officer"
	economic_modifier = 20
	minimal_player_age = 14
	ideal_character_age = 60
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/rd
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_tox, access_tox_storage, access_emergency_storage, access_teleporter, access_heads, access_rd,
						access_research, access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_RC_announce, access_keycard_auth, access_xenoarch, access_nanotrasen, access_sec_guard,
						access_calypso, access_guppy)
	minimal_access = list(access_tox, access_tox_storage, access_emergency_storage, access_teleporter, access_heads, access_rd,
						access_research, access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_RC_announce, access_keycard_auth, access_xenoarch, access_nanotrasen, access_sec_guard,
						access_calypso, access_guppy)


/datum/job/cmo
	title = "Chief Medical Officer"
	supervisors = "the Commanding Officer and the Executive Officer"
	economic_modifier = 10
	minimal_player_age = 21
	ideal_character_age = 48
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/cmo
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/marine/o4,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine/o3,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine/o2
	)

	access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads,
			            access_chapel_office, access_crematorium, access_chemistry, access_virology,
			            access_cmo, access_surgery, access_RC_announce, access_keycard_auth, access_psychiatrist,
			            access_medical_equip, access_solgov_crew)
	minimal_access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads,
			            access_chapel_office, access_crematorium, access_chemistry, access_virology,
			            access_cmo, access_surgery, access_RC_announce, access_keycard_auth, access_psychiatrist,
			            access_medical_equip, access_solgov_crew)

/datum/job/chief_engineer
	title = "Chief Engineer"
	supervisors = "the Commanding Officer and the Executive Officer"
	economic_modifier = 9
	ideal_character_age = 40
	minimal_player_age = 21
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/chief_engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine/o3,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine/o2,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/marine/o1
	)

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_ai_upload, access_teleporter, access_eva, access_heads,
			            access_tech_storage, access_robotics, access_atmospherics, access_janitor, access_construction,
			            access_network, access_ce, access_RC_announce, access_keycard_auth, access_tcomsat,
			            access_solgov_crew, access_robotics_engineering)
	minimal_access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_ai_upload, access_teleporter, access_eva, access_heads,
			            access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_network, access_ce, access_RC_announce, access_keycard_auth, access_tcomsat,
			            access_solgov_crew, access_robotics_engineering)

/datum/job/hos
	title = "Chief of Security"
	supervisors = "the Commanding Officer and the Executive Officer"
	economic_modifier = 8
	minimal_player_age = 21
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/cos
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine/o3,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine/o2,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/marine/o1
	)

	access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads,
			            access_hos, access_RC_announce, access_keycard_auth, access_sec_doors,
			            access_solgov_crew, access_emergency_armory, access_gun)
	minimal_access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads,
			            access_hos, access_RC_announce, access_keycard_auth, access_sec_doors,
			            access_solgov_crew, access_emergency_armory, access_gun)

/datum/job/liaison
	title = "NanoTrasen Liaison"
	department = "Command"
	department_flag = COM
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "NanoTrasen and Corporate Regulations"
	selection_color = "#2f2f7f"
	economic_modifier = 15
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/cl
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_liaison, access_tox, access_tox_storage, access_heads, access_research,
						access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard,
						access_calypso, access_guppy)
	minimal_access = list(access_liaison, access_tox, access_tox_storage, access_heads, access_research,
						access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard,
						access_calypso, access_guppy)

/datum/job/representative
	title = "SolGov Representative"
	department = "Command"
	department_flag = COM
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Sol Central Government and the SCG Charter"
	selection_color = "#2f2f7f"
	economic_modifier = 15
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/representative
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/civ)

	access = list(access_representative, access_security,access_medical, access_engine,
			            access_heads,access_cargo, access_solgov_crew, access_calypso, access_guppy)
	minimal_access = list(access_representative, access_security,access_medical, access_engine,
			            access_heads,access_cargo, access_solgov_crew, access_calypso, access_guppy)


/datum/job/sea
	title = "Senior Enlisted Advisor"
	department = "Command"
	department_flag = COM
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Commanding Officer and the Executive Officer"
	minimal_player_age = 21
	economic_modifier = 8
	ideal_character_age = 45
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/sea
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e9,
		/datum/mil_rank/marine/e9,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine/e8
	)


	access = list(access_security, access_medical, access_engine, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads, access_all_personal_lockers, access_janitor,
			            access_kitchen, access_cargo, access_RC_announce, access_keycard_auth,
			            access_solgov_crew, access_gun, access_calypso, access_guppy, access_senadv)
	minimal_access = list(access_security, access_medical, access_engine, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads, access_all_personal_lockers, access_janitor,
			            access_kitchen, access_cargo, access_RC_announce, access_keycard_auth,
			            access_solgov_crew, access_gun, access_calypso, access_guppy, access_senadv)

/datum/job/senior_engineer
	title = "Senior Engineer"
	department = "Engineering"
	department_flag = ENG
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Engineer"
	selection_color = "#5b4d20"
	economic_modifier = 6
	minimal_player_age = 14
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine/e8_alt,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/marine/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/marine/e6,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5
	)

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			             access_tcomsat, access_solgov_crew, access_seneng)
	minimal_access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_tcomsat, access_solgov_crew, access_seneng)


/datum/job/engineer
	title = "Engineer"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief Engineer"
	economic_modifier = 5
	minimal_player_age = 7
	ideal_character_age = 30
	alt_titles = list(
		"Maintenance Technician",
		"Engine Technician",
		"Damage Control Technician",
		"EVA Technician",
		"Electrician",
		"Atmospheric Technician",
		"Junior Engineer")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/marine/e4,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3
	)

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_solgov_crew)
	minimal_access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_solgov_crew)


/datum/job/engineer_contractor
	title = "Maintenance Assistant"
	department = "Engineering"
	department_flag = ENG
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Engineer and Engineering Personnel"
	selection_color = "#5b4d20"
	alt_titles = list(
		"Mechanic",
		"Information Systems Technician")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_engine, access_emergency_storage, access_janitor, access_construction)
	minimal_access = list(access_engine, access_emergency_storage, access_janitor, access_construction)


/datum/job/roboticist
	title = "Roboticist"
	department = "Engineering"
	department_flag = ENG
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Engineer"
	selection_color = "#5b4d20"
	economic_modifier = 6
	alt_titles = list(
		"Biomechanical Engineer",
		"Mechsuit Technician")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_robotics, access_robotics_engineering, access_tech_storage, access_morgue, access_medical, access_robotics_engineering)
	minimal_access = list(access_robotics, access_robotics_engineering, access_tech_storage, access_morgue, access_medical, access_robotics_engineering)


/datum/job/warden
	title = "Brig Officer"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief of Security"
	economic_modifier = 5
	minimal_player_age = 14
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/brig_officer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine/e8_alt,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/marine/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/marine/e6,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5
	)

	access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_solgov_crew, access_gun)
	minimal_access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_solgov_crew, access_gun)

/datum/job/detective
	title = "Forensic Technician"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief of Security"
	economic_modifier = 5
	minimal_player_age = 7
	ideal_character_age = 35
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/marine/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5
	)

	access = list(access_security, access_forensics_lockers,
			            access_maint_tunnels, access_emergency_storage,
			            access_sec_doors, access_solgov_crew)
	minimal_access = list(access_security, access_forensics_lockers,
			            access_maint_tunnels, access_emergency_storage,
			            access_sec_doors, access_solgov_crew)


/datum/job/officer
	title = "Master at Arms"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Chief of Security"
	alt_titles = list() //will add MP if job alt-titles can ever be separated by branch
	economic_modifier = 4
	minimal_player_age = 10
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/maa
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/marine/e4
	)


	access = list(access_security, access_brig, access_maint_tunnels,
						access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_solgov_crew)
	minimal_access = list(access_security, access_brig, access_maint_tunnels,
						access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_solgov_crew)


/datum/job/senior_doctor
	title = "Senior Physician"
	department = "Medical"
	department_flag = MED
	faction = "Station"
	minimal_player_age = 14
	ideal_character_age = 45
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#013d3b"
	economic_modifier = 8
	alt_titles = list(
		"Surgeon",
		"Trauma Surgeon")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/senior
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e6
	)

	access = list(access_medical, access_morgue, access_maint_tunnels, access_emergency_storage,
			            access_crematorium, access_chemistry, access_surgery,
			            access_medical_equip, access_solgov_crew, access_senmed)
	minimal_access = list(access_medical, access_morgue, access_maint_tunnels, access_emergency_storage,
			            access_crematorium, access_chemistry, access_surgery,
			            access_medical_equip, access_solgov_crew, access_senmed)


/datum/job/doctor
	title = "Physician"
	minimal_player_age = 7
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Chief Medical Officer"
	economic_modifier = 7
	ideal_character_age = 40
	alt_titles = list(
		"Corpsman",
		"Emergency Physician",
		"Nurse")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/doctor
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5
	)

	access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_surgery, access_medical_equip, access_solgov_crew)
	minimal_access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_surgery, access_medical_equip, access_solgov_crew)


/datum/job/doctor_contractor
	title = "Medical Assistant"
	department = "Medical"
	department_flag = MED
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Medical Officer and Medical Personnel"
	selection_color = "#013d3b"
	economic_modifier = 3
	ideal_character_age = 30
	alt_titles = list(
		"Orderly" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/orderly,
		"Medical Resident" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/resident,
		"Xenosurgeon" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/xenosurgeon,
		"Mortician" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/mortus)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/contractor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_medical, access_morgue, access_surgery, access_medical_equip)
	minimal_access = list(access_medical, access_morgue, access_surgery, access_medical_equip)


/datum/job/virologist
	title = "Virologist"
	department = "Medical"
	department_flag = MED
	faction = "Station"
	minimal_player_age = 3
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Medical Officer"
	selection_color = "#013d3b"
	economic_modifier = 9
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/virologist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_medical, access_morgue, access_crematorium, access_virology)
	minimal_access = list(access_medical, access_morgue, access_crematorium, access_virology)

/datum/job/chemist
	title = "Chemist"
	minimal_player_age = 7
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Medical Officer"
	economic_modifier = 5
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/chemist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_medical, access_medical_equip, access_chemistry)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)

/datum/job/psychiatrist
	title = "Counselor"
	total_positions = 1
	spawn_positions = 1
	ideal_character_age = 40
	economic_modifier = 5
	supervisors = "the Chief Medical Officer"
	alt_titles = list(
		"Psychiatrist" = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/psychiatrist,
		"Chaplain" = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/chaplain,
	)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/counselor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)


	access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_psychiatrist)
	minimal_access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_psychiatrist)


/datum/job/qm
	title = "Deck Officer"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Executive Officer"
	economic_modifier = 5
	minimal_player_age = 7
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/supply/deckofficer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/marine/o1,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/marine/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/marine/e7
	)

	access = list(access_maint_tunnels, access_emergency_storage, access_tech_storage,  access_cargo,
						access_cargo_bot, access_qm, access_mailsorting, access_solgov_crew, access_calypso, access_guppy)
	minimal_access = list(access_maint_tunnels, access_emergency_storage, access_tech_storage,  access_cargo,
						access_cargo_bot, access_qm, access_mailsorting, access_solgov_crew, access_calypso, access_guppy)


/datum/job/cargo_tech
	title = "Deck Technician"
	department = "Supply"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Deck Officer and Executive Officer"
	minimal_player_age = 3
	ideal_character_age = 24
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/supply/tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3
	)

	access = list(access_maint_tunnels, access_emergency_storage, access_cargo,
						access_cargo_bot, access_mailsorting, access_solgov_crew, access_calypso, access_guppy)
	minimal_access = list(access_maint_tunnels, access_emergency_storage, access_cargo,
						access_cargo_bot, access_mailsorting, access_solgov_crew, access_calypso, access_guppy)


/datum/job/cargo_contractor
	title = "Supply Assistant"
	department = "Supply"
	department_flag = SUP
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Deck Officer and Supply Personnel"
	ideal_character_age = 20
	selection_color = "#515151"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/supply/contractor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_cargo, access_cargo_bot, access_mailsorting)
	minimal_access = list(access_cargo, access_cargo_bot, access_mailsorting)


/datum/job/janitor
	title = "Sanitation Technician"
	department = "Service"
	department_flag = SRV
	faction = "Station"
	supervisors = "the Executive Officer"
	minimal_player_age = 3
	ideal_character_age = 20
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/janitor
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3
	)

	access = list(access_maint_tunnels, access_emergency_storage, access_janitor, access_solgov_crew)
	minimal_access = list(access_maint_tunnels, access_emergency_storage, access_janitor, access_solgov_crew)

/datum/job/chef
	title = "Cook"
	department = "Service"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Executive Officer"
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/cook
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3
	)

	access = list(access_maint_tunnels, access_hydroponics, access_kitchen, access_solgov_crew)
	minimal_access = list(access_maint_tunnels, access_hydroponics, access_kitchen, access_solgov_crew)

/datum/job/bartender
	department = "Service"
	department_flag = SRV
	supervisors = "the Executive Officer"
	ideal_character_age = 30
	selection_color = "#515151"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/bartender
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_hydroponics, access_bar)
	minimal_access = list(access_hydroponics, access_bar)


/datum/job/crew
	title = "Crewman"
	department = "Service"
	department_flag = SRV
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Executive Officer and SolGov Personnel"
	selection_color = "#515151"
	ideal_character_age = 20
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/crewman
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2
	)


	access = list(access_maint_tunnels, access_emergency_storage, access_solgov_crew)
	minimal_access = list(access_maint_tunnels, access_emergency_storage, access_solgov_crew)


/datum/job/scientist
	title = "Scientist"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Research Director"
	economic_modifier = 10
	minimal_player_age = 7
	ideal_character_age = 45
	alt_titles = list(
		"Xenoarcheologist",
		"Anomalist",
		"Researcher",
		"Xenobiologist",
		"Xenobotanist",
		"Psychologist" = /decl/hierarchy/outfit/job/torch/passenger/research/scientist/psych)

	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/scientist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_tox, access_tox_storage, access_research,
						access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_calypso, access_guppy)
	minimal_access = list(access_tox, access_tox_storage, access_research,
						access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_calypso, access_guppy)


/datum/job/mining
	title = "Prospector"
	department = "Science"
	department_flag = SCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director"
	selection_color = "#633d63"
	economic_modifier = 7
	ideal_character_age = 25
	alt_titles = list(
		"Drill Technician",
		"Shaft Miner",
		"Salvage Technician")

	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/prospector
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_research, access_mining, access_mining_office, access_mining_station, access_nanotrasen,
						access_calypso, access_guppy)
	minimal_access = list(access_research, access_mining, access_mining_office, access_mining_station, access_nanotrasen,
						access_calypso, access_guppy)


/datum/job/guard
	title = "Security Guard"
	department = "Science"
	department_flag = SCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Research Director and NanoTrasen Personnel"
	selection_color = "#633d63"
	economic_modifier = 6
	minimal_player_age = 3
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/guard
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_tox, access_tox_storage,access_research, access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard)
	minimal_access = list(access_tox, access_tox_storage,access_research, access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard)


/datum/job/scientist_assistant
	title = "Research Assistant"
	department = "Science"
	department_flag = SCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director and NanoTrasen Personnel"
	selection_color = "#633d63"
	economic_modifier = 3
	ideal_character_age = 30
	alt_titles = list(
		"Custodian" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/janitor,
		"Testing Assistant" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/testsubject,
		"Laboratory Technician",
		"Intern",
		"Clerk",
		"Field Assistant")

	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/assist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_research, access_mining_office, access_nanotrasen)
	minimal_access = list(access_research, access_mining_office, access_nanotrasen)


/datum/job/assistant
	title = "Passenger"
	total_positions = 8
	spawn_positions = 8
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	alt_titles = list(
		"Private Investigator",
		"Journalist",
		"Historian",
		"Botanist",
		"Investor",
		"Naturalist",
		"Ecologist",
		"Entertainer",
		"Independent Observer",
		"Sociologist")
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/passenger
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/nt
	)


/* Leaving this in for consultation with Welp, not sure a better way to set this up
/datum/job/merchant
	title = "merchant"
	faction = "None"
	total_positions = 0 //to be opened by admins when desired
	spawn_positions = 0
	supervisors = "the invisible hand of the market"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/torch/merchant


	access = list(access_merchant)
	minimal_access = list(access_merchant)
*/

//Torch ID Cards (they have to be here to make the outfits work, no way around it)

/obj/item/weapon/card/id/torch
	name = "identification card"
	desc = "An identification card issued to personnel aboard the SEV Torch."
	icon_state = "id"
	item_state = "card-id"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/torch/silver
	desc = "A silver identification card belonging to heads of staff."
	icon_state = "silver"
	item_state = "silver_id"
	job_access_type = /datum/job/hop

/obj/item/weapon/card/id/torch/gold
	desc = "A golden identification card belonging to the Commanding Officer."
	icon_state = "gold"
	item_state = "gold_id"
	job_access_type = /datum/job/captain

/obj/item/weapon/card/id/torch/captains_spare
	name = "commanding officer's spare ID"
	desc = "The skipper's spare ID."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Commanding Officer"
	assignment = "Commanding Officer"
/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()


// SolGov Crew and Contractors
/obj/item/weapon/card/id/torch/crew
	desc = "An identification card issued to SolGov crewmembers aboard the SEV Torch."
	icon_state = "solgov"
	job_access_type = /datum/job/crew


/obj/item/weapon/card/id/torch/contractor
	desc = "An identification card issued to private contractors aboard the SEV Torch."
	icon_state = "civ"
	job_access_type = /datum/job/assistant


/obj/item/weapon/card/id/torch/silver/medical
	job_access_type = /datum/job/cmo

/obj/item/weapon/card/id/torch/crew/medical
	job_access_type = /datum/job/doctor

/obj/item/weapon/card/id/torch/crew/medical/senior
	job_access_type = /datum/job/senior_doctor

/obj/item/weapon/card/id/torch/contractor/medical
	job_access_type = /datum/job/doctor_contractor

/obj/item/weapon/card/id/torch/contractor/medical/chemist
	job_access_type = /datum/job/chemist

/obj/item/weapon/card/id/torch/contractor/medical/virologist
	job_access_type = /datum/job/virologist

/obj/item/weapon/card/id/torch/contractor/medical/counselor
	job_access_type = /datum/job/psychiatrist


/obj/item/weapon/card/id/torch/silver/security
	job_access_type = /datum/job/hos

/obj/item/weapon/card/id/torch/crew/security
	job_access_type = /datum/job/officer

/obj/item/weapon/card/id/torch/crew/security/brigofficer
	job_access_type = /datum/job/warden

/obj/item/weapon/card/id/torch/crew/security/forensic
	job_access_type = /datum/job/detective


/obj/item/weapon/card/id/torch/silver/engineering
	job_access_type = /datum/job/chief_engineer

/obj/item/weapon/card/id/torch/crew/engineering
	job_access_type = /datum/job/engineer

/obj/item/weapon/card/id/torch/crew/engineering/senior
	job_access_type = /datum/job/senior_engineer

/obj/item/weapon/card/id/torch/contractor/engineering
	job_access_type = /datum/job/engineer_contractor

/obj/item/weapon/card/id/torch/contractor/engineering/roboticist
	job_access_type = /datum/job/roboticist


/obj/item/weapon/card/id/torch/crew/supply/deckofficer
	job_access_type = /datum/job/qm

/obj/item/weapon/card/id/torch/crew/supply
	job_access_type = /datum/job/cargo_tech

/obj/item/weapon/card/id/torch/contractor/supply
	job_access_type = /datum/job/cargo_contractor


/obj/item/weapon/card/id/torch/crew/service //unused
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/torch/crew/service/janitor
	job_access_type = /datum/job/janitor

/obj/item/weapon/card/id/torch/crew/service/chef
	job_access_type = /datum/job/chef

/obj/item/weapon/card/id/torch/contractor/service //unused
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/torch/contractor/service/bartender
	job_access_type = /datum/job/bartender


/obj/item/weapon/card/id/torch/crew/representative
	job_access_type = /datum/job/representative

/obj/item/weapon/card/id/torch/crew/sea
	job_access_type = /datum/job/sea


//NanoTrasen and Passengers

/obj/item/weapon/card/id/torch/passenger
	desc = "A card issued to passengers aboard the SEV Torch."
	icon_state = "id"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/torch/passenger/research
	desc = "A card issued to NanoTrasen personnel aboard the SEV Torch."
	icon_state = "corporate"
	job_access_type = /datum/job/scientist_assistant

/obj/item/weapon/card/id/torch/silver/research
	job_access_type = /datum/job/rd

/obj/item/weapon/card/id/torch/passenger/research/scientist
	job_access_type = /datum/job/scientist

/obj/item/weapon/card/id/torch/passenger/research/mining
	job_access_type = /datum/job/mining

/obj/item/weapon/card/id/torch/research/guard
	job_access_type = /datum/job/guard

/obj/item/weapon/card/id/torch/research/liaison
	job_access_type = /datum/job/liaison

//Merchant
/*
/obj/item/weapon/card/id/torch/merchant
	desc = "An identification card issued to Merchants, indicating their right to sell and buy goods."
	icon_state = "trader"
	job_access_type = /datum/job/merchant
*/


/************
* SEV Torch *
************/

/* These are the accesses that overwrite exiting ones, not sure how to handle this from a code-side because it's a duplicate def
/var/const/access_robotics = 29
/datum/access/robotics
	id = access_robotics
	desc = "Robotics"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_network = 42
/datum/access/network
	id = access_network
	desc = "Station Network"
	region = ACCESS_REGION_COMMAND
*/

//other accesses follow

/var/const/access_solgov_crew = 80
/datum/access/solgov_crew
	id = access_solgov_crew
	desc = "SolGov Crew"
	region = ACCESS_REGION_GENERAL

/var/const/access_nanotrasen = 81
/datum/access/nanotrasen
	id = access_nanotrasen
	desc = "NanoTrasen Personnel"
	region = ACCESS_REGION_RESEARCH

/var/const/access_robotics_engineering = 82 //two accesses so that you can give access to the lab without giving access to the borgs
/datum/access/robotics_engineering
	id = access_robotics_engineering
	desc = "Biomechanical Engineering"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_emergency_armory = 83
/datum/access/emergency_armory
	id = access_emergency_armory
	desc = "Emergency Armory"
	region = ACCESS_REGION_COMMAND

/var/const/access_liaison = 84
/datum/access/liaison
	id = access_liaison
	desc = "NanoTrasen Liaison"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO and RD cannot enter and access can't be added with computer.

/var/const/access_representative = 85
/datum/access/representative
	id = access_representative
	desc = "SolGov Representative"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO cannot enter and access can't be added with computer.

/var/const/access_sec_guard = 86
/datum/access/sec_guard
	id = access_sec_guard
	desc = "Security Guard"
	region = ACCESS_REGION_RESEARCH

/var/const/access_gun = 87
/datum/access/gun
	id = access_gun
	desc = "Gunnery"
	region = ACCESS_REGION_COMMAND

/var/const/access_calypso = 88
/datum/access/calypso
	id = access_calypso
	desc = "Calypso"
	region = ACCESS_REGION_GENERAL

/var/const/access_guppy = 89
/datum/access/guppy
	id = access_guppy
	desc = "General Utility Pod"
	region = ACCESS_REGION_GENERAL

/var/const/access_seneng = 90
/datum/access/seneng
	id = access_seneng
	desc = "Senior Engineer"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_senmed = 91
/datum/access/senmed
	id = access_senmed
	desc = "Senior Physician"
	region = ACCESS_REGION_MEDBAY

/var/const/access_senadv = 92
/datum/access/senadv
	id = access_senadv
	desc = "Senior Enlisted Advisor"
	region = ACCESS_REGION_COMMAND

//Job Outfits

/*
TORCH OUTFITS
Keeping them simple for now, just spawning with basic EC uniforms, and pretty much no gear. Gear instead goes in lockers. Keep this in mind if editing.
*/

/decl/hierarchy/outfit/job/torch
	name = OUTFIT_JOB_NAME("Torch Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda

/decl/hierarchy/outfit/job/torch/crew
	name = OUTFIT_JOB_NAME("Torch Crew Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew
	uniform = /obj/item/clothing/under/utility/expeditionary
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/job/torch/passenger
	name = OUTFIT_JOB_NAME("Torch Passenger")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/passenger
	uniform = /obj/item/clothing/under/utility

//Command Outfits
/decl/hierarchy/outfit/job/torch/crew/command
	name = OUTFIT_JOB_NAME("Torch Command Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/command
	l_ear = /obj/item/device/radio/headset/headset_com


/decl/hierarchy/outfit/job/torch/crew/command/CO
	name = OUTFIT_JOB_NAME("Commanding Officer")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/utility/expeditionary/command
	l_ear = /obj/item/device/radio/headset/heads/torchcaptain
	shoes = /obj/item/clothing/shoes/dress
	backpack = /obj/item/weapon/storage/backpack/captain
	satchel_one = /obj/item/weapon/storage/backpack/satchel_cap
	id_type = /obj/item/weapon/card/id/torch/gold
	pda_type = /obj/item/device/pda/captain

/decl/hierarchy/outfit/job/torch/crew/command/XO
	name = OUTFIT_JOB_NAME("Executive Officer")
	uniform = /obj/item/clothing/under/utility/expeditionary/command
	l_ear = /obj/item/device/radio/headset/heads/torchxo
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/silver
	pda_type = /obj/item/device/pda/heads/hop

/decl/hierarchy/outfit/job/torch/passenger/research/rd
	name = OUTFIT_JOB_NAME("Research Director - Torch")
	l_ear = /obj/item/device/radio/headset/heads/torchntcommand
	uniform = /obj/item/clothing/under/rank/research_director
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/torch/silver/research
	pda_type = /obj/item/device/pda/heads/rd

/decl/hierarchy/outfit/job/torch/crew/command/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Torch")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/utility/expeditionary/medical/command
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/silver/medical
	pda_type = /obj/item/device/pda/heads/cmo
	pda_slot = slot_l_store
	backpack = /obj/item/weapon/storage/backpack/medic
	satchel_one = /obj/item/weapon/storage/backpack/satchel_med

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer
	name = OUTFIT_JOB_NAME("Chief Engineer - Torch")
	uniform = /obj/item/clothing/under/utility/expeditionary/engineering/command
	shoes = /obj/item/clothing/shoes/dress
	l_ear = /obj/item/device/radio/headset/heads/ce
	id_type = /obj/item/weapon/card/id/torch/silver/engineering
	pda_type = /obj/item/device/pda/heads/ce
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one = /obj/item/weapon/storage/backpack/satchel_eng
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/command/cos
	name = OUTFIT_JOB_NAME("Chief of Security")
	l_ear = /obj/item/device/radio/headset/heads/cos
	uniform = /obj/item/clothing/under/utility/expeditionary/security/command
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/silver/security
	pda_type = /obj/item/device/pda/heads/hos
	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/backpack/satchel_sec

/decl/hierarchy/outfit/job/torch/passenger/research/cl
	name = OUTFIT_JOB_NAME("NanoTrasen Liaison")
	l_ear = /obj/item/device/radio/headset/heads/torchntcommand
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/nt
	suit = /obj/item/clothing/suit/storage/toggle/internalaffairs/plain
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/research/liaison
	pda_type = /obj/item/device/pda/heads

/decl/hierarchy/outfit/job/torch/crew/representative
	name = OUTFIT_JOB_NAME("SolGov Representative")
	l_ear = /obj/item/device/radio/headset/headset_com
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/solgov
	suit = /obj/item/clothing/suit/storage/toggle/internalaffairs/plain
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/crew/representative
	pda_type = /obj/item/device/pda/heads

/decl/hierarchy/outfit/job/torch/crew/command/sea
	name = OUTFIT_JOB_NAME("Senior Enlisted Advisor")
	uniform = /obj/item/clothing/under/utility/expeditionary
	l_ear = /obj/item/device/radio/headset/heads/torchxo
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/sea
	pda_type = /obj/item/device/pda/heads

//Engineering Outfits

/decl/hierarchy/outfit/job/torch/crew/engineering
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/engineering
	l_ear = /obj/item/device/radio/headset/headset_eng
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one = /obj/item/weapon/storage/backpack/satchel_eng
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer
	name = OUTFIT_JOB_NAME("Senior Engineer")
	uniform = /obj/item/clothing/under/utility/expeditionary/engineering
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/engineering/senior
	pda_type =	/obj/item/device/pda/atmos

/decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer - Torch")
	uniform = /obj/item/clothing/under/utility/expeditionary/engineering
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/engineering
	pda_type = /obj/item/device/pda/engineering

/decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	name = OUTFIT_JOB_NAME("Engineering Assistant")
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/torch/contractor/engineering
	pda_type = /obj/item/device/pda/engineering

/decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	name = OUTFIT_JOB_NAME("Roboticist - Torch")
	uniform = /obj/item/clothing/under/rank/roboticist
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/torch/contractor/engineering/roboticist
	pda_type = /obj/item/device/pda/roboticist

//Security Outfits

/decl/hierarchy/outfit/job/torch/crew/security
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/security
	l_ear = /obj/item/device/radio/headset/headset_sec
	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/backpack/satchel_sec
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/torch/crew/security/brig_officer
	name = OUTFIT_JOB_NAME("Brig Officer")
	uniform = /obj/item/clothing/under/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/security/brigofficer
	pda_type = /obj/item/device/pda/warden

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech
	name = OUTFIT_JOB_NAME("Forensic Technician")
	uniform = /obj/item/clothing/under/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/security/forensic
	pda_type = /obj/item/device/pda/detective

/decl/hierarchy/outfit/job/torch/crew/security/maa
	name = OUTFIT_JOB_NAME("Master at Arms")
	uniform = /obj/item/clothing/under/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/security
	pda_type = /obj/item/device/pda/security

//Medical Outfits

/decl/hierarchy/outfit/job/torch/crew/medical
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	pda_type = /obj/item/device/pda/medical
	pda_slot = slot_l_store
	backpack = /obj/item/weapon/storage/backpack/medic
	satchel_one = /obj/item/weapon/storage/backpack/satchel_med

/decl/hierarchy/outfit/job/torch/crew/medical/senior
	name = OUTFIT_JOB_NAME("Senior Physician")
	uniform = /obj/item/clothing/under/utility/expeditionary/medical
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/medical/senior

/decl/hierarchy/outfit/job/torch/crew/medical/doctor
	name = OUTFIT_JOB_NAME("Physician")
	uniform = /obj/item/clothing/under/utility/expeditionary/medical
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/medical

/decl/hierarchy/outfit/job/torch/crew/medical/contractor
	name = OUTFIT_JOB_NAME("Medical Assistant")
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/white
	id_type = /obj/item/weapon/card/id/torch/contractor/medical

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/orderly
	name = OUTFIT_JOB_NAME("Orderly")
	uniform = /obj/item/clothing/under/rank/orderly

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/resident
	name = OUTFIT_JOB_NAME("Medical Resident")
	uniform = /obj/item/clothing/under/color/white

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/xenosurgeon
	name = OUTFIT_JOB_NAME("Xenosurgeon")
	uniform = /obj/item/clothing/under/rank/medical/purple

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/mortus
	name = OUTFIT_JOB_NAME("Mortician")
	uniform = /obj/item/clothing/under/rank/medical/black

/decl/hierarchy/outfit/job/torch/crew/medical/virologist
	name = OUTFIT_JOB_NAME("Virologist - Torch")
	uniform = /obj/item/clothing/under/rank/virologist
	shoes = /obj/item/clothing/shoes/white
	backpack = /obj/item/weapon/storage/backpack/virology
	satchel_one = /obj/item/weapon/storage/backpack/satchel_vir
	id_type = /obj/item/weapon/card/id/torch/contractor/medical/virologist

/decl/hierarchy/outfit/job/torch/crew/medical/chemist
	name = OUTFIT_JOB_NAME("Chemist - Torch")
	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/white
	backpack = /obj/item/weapon/storage/backpack/chemistry
	satchel_one = /obj/item/weapon/storage/backpack/satchel_chem
	id_type = /obj/item/weapon/card/id/torch/contractor/medical/chemist
	pda_type = /obj/item/device/pda/chemist

/decl/hierarchy/outfit/job/torch/crew/medical/counselor
	name = OUTFIT_JOB_NAME("Counselor")
	uniform = /obj/item/clothing/under/rank/psych/turtleneck
	shoes = /obj/item/clothing/shoes/white
	id_type = /obj/item/weapon/card/id/torch/contractor/medical/counselor

/decl/hierarchy/outfit/job/torch/crew/medical/counselor/psychiatrist
	name = OUTFIT_JOB_NAME("Psychiatrist - Torch")
	uniform = /obj/item/clothing/under/rank/psych

/decl/hierarchy/outfit/job/torch/crew/medical/counselor/chaplain
	name = OUTFIT_JOB_NAME("Chaplain - Torch")
	uniform = /obj/item/clothing/under/rank/chaplain

//Supply Outfits

/decl/hierarchy/outfit/job/torch/crew/supply
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/supply
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one  = /obj/item/weapon/storage/backpack/satchel_eng

/decl/hierarchy/outfit/job/torch/crew/supply/deckofficer
	name = OUTFIT_JOB_NAME("Deck Officer")
	uniform = /obj/item/clothing/under/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/supply/deckofficer
	pda_type = /obj/item/device/pda/quartermaster

/decl/hierarchy/outfit/job/torch/crew/supply/tech
	name = OUTFIT_JOB_NAME("Deck Technician")
	uniform = /obj/item/clothing/under/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/supply
	pda_type = /obj/item/device/pda/cargo

/decl/hierarchy/outfit/job/torch/crew/supply/contractor
	name = OUTFIT_JOB_NAME("Supply Assistant")
	uniform = /obj/item/clothing/under/rank/cargotech
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/torch/contractor/supply
	pda_type = /obj/item/device/pda/cargo


//Service Outfits

/decl/hierarchy/outfit/job/torch/crew/service
	l_ear = /obj/item/device/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/service

/decl/hierarchy/outfit/job/torch/crew/service/janitor
	name = OUTFIT_JOB_NAME("Sanitation Technician - Torch")
	uniform = /obj/item/clothing/under/utility/expeditionary
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/service/janitor
	pda_type = /obj/item/device/pda/janitor

/decl/hierarchy/outfit/job/torch/crew/service/cook
	name = OUTFIT_JOB_NAME("Cook - Torch")
	uniform = /obj/item/clothing/under/utility/expeditionary
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew/service/janitor
	pda_type = /obj/item/device/pda/chef

/decl/hierarchy/outfit/job/torch/crew/service/bartender
	name = OUTFIT_JOB_NAME("Bartender - Torch")
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/contractor/service/bartender
	pda_type = /obj/item/device/pda/bar

/decl/hierarchy/outfit/job/torch/crew/service/crewman
	name = OUTFIT_JOB_NAME("Crewman")
	uniform = /obj/item/clothing/under/utility/expeditionary
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/torch/crew
	pda_type = /obj/item/device/pda

//Passenger Outfits

/decl/hierarchy/outfit/job/torch/passenger/research
	hierarchy_type = /decl/hierarchy/outfit/job/torch/passenger/research
	l_ear = /obj/item/device/radio/headset/torchnanotrasen

/decl/hierarchy/outfit/job/torch/passenger/research/scientist
	name = OUTFIT_JOB_NAME("Scientist - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/device/pda/science
	backpack = /obj/item/weapon/storage/backpack/toxins
	satchel_one = /obj/item/weapon/storage/backpack/satchel_tox
	id_type = /obj/item/weapon/card/id/torch/passenger/research/scientist

/decl/hierarchy/outfit/job/torch/passenger/research/scientist/psych
	name = OUTFIT_JOB_NAME("Psychologist - Torch")
	uniform = /obj/item/clothing/under/rank/psych

/decl/hierarchy/outfit/job/torch/passenger/research/prospector
	name = OUTFIT_JOB_NAME("Prospector")
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/workboots
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one  = /obj/item/weapon/storage/backpack/satchel_eng
	id_type = /obj/item/weapon/card/id/torch/passenger/research/mining
	pda_type = /obj/item/device/pda/shaftminer
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/passenger/research/guard
	name = OUTFIT_JOB_NAME("Security Guard")
	uniform = /obj/item/clothing/under/rank/security2 //placeholder for full red/white ensemble
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/backpack/satchel_sec
	id_type = /obj/item/weapon/card/id/torch/research/guard
	pda_type = /obj/item/device/pda/security

/decl/hierarchy/outfit/job/torch/passenger/research/assist
	name = OUTFIT_JOB_NAME("Research Assistant - Torch")
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/device/pda/science
	id_type = /obj/item/weapon/card/id/torch/passenger/research

/decl/hierarchy/outfit/job/torch/passenger/research/assist/janitor
	name = OUTFIT_JOB_NAME("Custodian - Torch")
	uniform = /obj/item/clothing/under/rank/janitor

/decl/hierarchy/outfit/job/torch/passenger/research/assist/testsubject
	name = OUTFIT_JOB_NAME("Testing Assistant")
	uniform = /obj/item/clothing/under/color/orange

/decl/hierarchy/outfit/job/torch/passenger/passenger
	name = OUTFIT_JOB_NAME("Passenger - Torch")
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/torch/passenger

/*
/decl/hierarchy/outfit/job/torch/merchant
	name = OUTFIT_JOB_NAME("Merchant - Torch")
	uniform = /obj/item/clothing/under/color/black
	l_ear = null
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/torch/merchant
*/

