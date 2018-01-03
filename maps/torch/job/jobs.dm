/datum/map/torch
	species_to_job_whitelist = list(
		/datum/species/nabber = list(/datum/job/cyborg, /datum/job/janitor, /datum/job/scientist_assistant,
			/datum/job/roboticist, /datum/job/cargo_contractor, /datum/job/chef, /datum/job/engineer_contractor, /datum/job/doctor_contractor, /datum/job/bartender),
		/datum/species/vox = list(/datum/job/cyborg, /datum/job/merchant, /datum/job/stowaway)
	)

#define HUMAN_ONLY_JOBS /datum/job/captain, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/representative, /datum/job/sea, /datum/job/pathfinder, /datum/job/warden
	species_to_job_blacklist = list(
		/datum/species/unathi  = list(HUMAN_ONLY_JOBS, /datum/job/liaison, /datum/job/officer, /datum/job/detective), //Other jobs unavailable via branch restrictions,
		/datum/species/skrell  = list(HUMAN_ONLY_JOBS),
		/datum/species/tajaran = list(HUMAN_ONLY_JOBS),
		/datum/species/machine = list(HUMAN_ONLY_JOBS),
		/datum/species/diona   = list(HUMAN_ONLY_JOBS, /datum/job/guard, /datum/job/officer, /datum/job/detective),	//Other jobs unavailable via branch restrictions,
	)
#undef HUMAN_ONLY_JOBS

	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos,
						/datum/job/liaison, /datum/job/representative, /datum/job/sea, /datum/job/bridgeofficer, /datum/job/solgov_pilot,
						/datum/job/pathfinder, /datum/job/explorer,
						/datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist,
						/datum/job/officer, /datum/job/warden, /datum/job/detective,
						/datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor,
						/datum/job/psychiatrist,
						/datum/job/qm, /datum/job/cargo_tech, /datum/job/cargo_contractor,
						/datum/job/janitor, /datum/job/chef, /datum/job/bartender,
						/datum/job/senior_scientist, /datum/job/nt_pilot, /datum/job/scientist, /datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant,
						/datum/job/cyborg,
						/datum/job/crew, /datum/job/assistant,
						/datum/job/merchant, /datum/job/stowaway
						)


/datum/map/torch/setup_map()
	..()
	for(var/job_type in GLOB.using_map.allowed_jobs)
		var/datum/job/job = decls_repository.get_decl(job_type)
		// Most species are restricted from SCG security and command roles
		if((job.department_flag & (COM)) && job.allowed_branches.len && !(/datum/mil_branch/civilian in job.allowed_branches))
			for(var/species_name in list(SPECIES_IPC, SPECIES_TAJARA, SPECIES_SKRELL, SPECIES_UNATHI))
				var/datum/species/S = all_species[species_name]
				var/species_blacklist = species_to_job_blacklist[S.type]
				if(!species_blacklist)
					species_blacklist = list()
					species_to_job_blacklist[S.type] = species_blacklist
				species_blacklist |= job.type

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
		/datum/mil_rank/ec/o6
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/card_mod,
							 /datum/computer_file/program/camera_monitor)

/datum/job/hop
	title = "Executive Officer"
	supervisors = "the Commanding Officer"
	department = "Command"
	department_flag = COM
	minimal_player_age = 21
	economic_modifier = 10
	ideal_character_age = 45
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/XO
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/XO/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/XO/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o5,
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
			            access_medical_equip, access_solgov_crew, access_robotics_engineering, access_emergency_armory, access_gun, access_expedition_shuttle, access_guppy,
			            access_seneng, access_senmed, access_senadv, access_hangar, access_guppy_helm, access_expedition_shuttle_helm, access_aquila, access_aquila_helm, access_explorer, access_pathfinder)
	minimal_access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_medical, access_morgue, access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_change_ids, access_ai_upload, access_teleporter, access_eva, access_heads,
			            access_all_personal_lockers, access_chapel_office, access_tech_storage, access_atmospherics, access_bar, access_janitor, access_crematorium,
			            access_kitchen, access_cargo, access_construction, access_chemistry, access_cargo_bot, access_hydroponics, access_library, access_virology,
			            access_cmo, access_qm, access_network, access_surgery, access_mailsorting, access_heads_vault, access_ce,
			            access_hop, access_hos, access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_sec_doors, access_psychiatrist,
			            access_medical_equip, access_solgov_crew, access_robotics_engineering, access_emergency_armory, access_gun, access_expedition_shuttle, access_guppy,
			            access_seneng, access_senmed, access_senadv, access_hangar, access_guppy_helm, access_aquila, access_aquila_helm, access_explorer, access_pathfinder)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/card_mod,
							 /datum/computer_file/program/camera_monitor)



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
						access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_petrov_helm, access_guppy_helm)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/aidiag,
							 /datum/computer_file/program/camera_monitor)

/datum/job/cmo
	title = "Chief Medical Officer"
	supervisors = "the Commanding Officer and the Executive Officer"
	economic_modifier = 10
	minimal_player_age = 21
	ideal_character_age = 48
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/cmo
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/cmo/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/ec/o3,
		/datum/mil_rank/fleet/o2
	)

	access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads,
			            access_chapel_office, access_crematorium, access_chemistry, access_virology,
			            access_cmo, access_surgery, access_RC_announce, access_keycard_auth, access_psychiatrist,
			            access_medical_equip, access_solgov_crew, access_senmed)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

/datum/job/chief_engineer
	title = "Chief Engineer"
	supervisors = "the Commanding Officer and the Executive Officer"
	economic_modifier = 9
	ideal_character_age = 40
	minimal_player_age = 21
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/chief_engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o3,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine/o3,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine/o2,
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/marine/o1
	)

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_ai_upload, access_teleporter, access_eva, access_heads,
			            access_tech_storage, access_robotics, access_atmospherics, access_janitor, access_construction,
			            access_network, access_ce, access_RC_announce, access_keycard_auth, access_tcomsat,
			            access_solgov_crew, access_robotics_engineering, access_seneng, access_hangar, access_robotics)
	minimal_access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_ai_upload, access_teleporter, access_eva, access_heads,
			            access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_network, access_ce, access_RC_announce, access_keycard_auth, access_tcomsat,
			            access_solgov_crew, access_robotics_engineering, access_seneng, access_hangar, access_robotics)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/ntnetmonitor,
							 /datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/hos
	title = "Chief of Security"
	supervisors = "the Commanding Officer and the Executive Officer"
	economic_modifier = 8
	minimal_player_age = 21
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/cos
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/cos/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/cos/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o3,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine/o3,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine/o2,
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/marine/o1
	)

	access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads,
			            access_hos, access_RC_announce, access_keycard_auth, access_sec_doors,
			            access_solgov_crew, access_gun, access_emergency_armory)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/liaison
	title = "NanoTrasen Liaison"
	department = "Support"
	department_flag = SPT

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
						access_hangar, access_petrov, access_petrov_helm)

/datum/job/representative
	title = "SolGov Representative"
	department = "Support"
	department_flag = SPT

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
			            access_heads, access_cargo, access_solgov_crew, access_hangar)


/datum/job/sea
	title = "Senior Enlisted Advisor"
	department = "Support"
	department_flag = SPT

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commanding Officer and the Executive Officer"
	selection_color = "#2f2f7f"
	minimal_player_age = 21
	economic_modifier = 8
	ideal_character_age = 45
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/sea
	allowed_branches = list(
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/sea/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/sea/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e9,
		/datum/mil_rank/marine/e9,
		/datum/mil_rank/fleet/e9_alt1,
		/datum/mil_rank/marine/e9_alt1,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine/e8_alt
	)


	access = list(access_security, access_medical, access_engine, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_heads, access_all_personal_lockers, access_janitor,
			            access_kitchen, access_cargo, access_RC_announce, access_keycard_auth, access_guppy_helm,
			            access_solgov_crew, access_gun, access_expedition_shuttle, access_guppy, access_senadv, access_hangar, access_emergency_armory)

	software_on_spawn = list(/datum/computer_file/program/camera_monitor)

/datum/job/bridgeofficer
	title = "Bridge Officer"
	department = "Support"
	department_flag = SPT

	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commanding Officer and heads of staff"
	selection_color = "#2f2f7f"
	minimal_player_age = 18
	economic_modifier = 7
	ideal_character_age = 24
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/marine/o1
	)


	access = list(access_security, access_medical, access_engine, access_maint_tunnels, access_emergency_storage,
			            access_heads, access_janitor, access_kitchen, access_cargo, access_RC_announce, access_keycard_auth,
			            access_solgov_crew)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/solgov_pilot
	title = "SolGov Pilot"
	department = "Exploration"
	department_flag = EXP

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commanding Officer and the Executive Officer"
	selection_color = "#68099e"
	minimal_player_age = 5
	economic_modifier = 7
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/solgov_pilot
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/exploration/solgov_pilot/fleet,
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/ec/o1
	)


	access = list(access_maint_tunnels, access_external_airlocks, access_eva, access_emergency_storage, access_solgov_crew, access_aquila, access_aquila_helm,
						access_expedition_shuttle, access_expedition_shuttle_helm, access_guppy, access_guppy_helm, access_hangar, access_solgov_crew, access_heads, access_explorer, access_cent_creed) //Yes, the last one is weird. It's used to make intercoms work.

/datum/job/pathfinder
	title = "Pathfinder"
	department = "Exploration"
	department_flag = EXP

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commanding Officer and the Executive Officer"
	selection_color = "#68099e"
	minimal_player_age = 7
	economic_modifier = 7
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/pathfinder
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)
	allowed_ranks = list(
		/datum/mil_rank/ec/o3,
		/datum/mil_rank/ec/o1
	)


	access = list(access_pathfinder, access_explorer, access_eva, access_maint_tunnels, access_heads, access_emergency_storage, access_tech_storage, access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar, access_cent_creed)

/datum/job/explorer
	title = "Explorer"
	department = "Exploration"
	department_flag = EXP
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Commanding Officer, Executive Officer, and Pathfinder"
	selection_color = "#68099e"
	minimal_player_age = 4
	ideal_character_age = 20
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/explorer
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)

	allowed_ranks = list(
		/datum/mil_rank/ec/e2,
		/datum/mil_rank/ec/e4
	)

	access = list(access_explorer, access_maint_tunnels, access_eva, access_emergency_storage, access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar, access_cent_creed)

/datum/job/senior_engineer
	title = "Senior Engineer"
	department = "Engineering"
	department_flag = ENG

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
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine/e8,
		/datum/mil_rank/ec/e7,
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

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

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
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/marine/e4,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/ec/e2,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2
	)

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_solgov_crew)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/engineer_contractor
	title = "Maintenance Assistant"
	department = "Engineering"
	department_flag = ENG

	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Engineer and Engineering Personnel"
	minimal_player_age = 7
	selection_color = "#5b4d20"
	alt_titles = list(
		"Mechanic",
		"Supermatter Specialist",
		"Information Systems Technician")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_solgov_crew)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/roboticist
	title = "Roboticist"
	department = "Engineering"
	department_flag = ENG

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

	access = list(access_robotics, access_robotics_engineering, access_tech_storage, access_morgue, access_medical, access_robotics_engineering, access_solgov_crew)
	minimal_access = list()


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
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/brig_officer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/security/brig_officer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine/e8,
		/datum/mil_rank/ec/e7,
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
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/detective
	title = "Forensic Technician"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief of Security"
	economic_modifier = 5
	minimal_player_age = 7
	ideal_character_age = 35
	alt_titles = list("Criminal Investigator")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/marine,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/marine/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5,
		/datum/mil_rank/civ/marshal
	)

	access = list(access_security, access_brig, access_forensics_lockers,
			            access_maint_tunnels, access_emergency_storage,
			            access_sec_doors, access_solgov_crew, access_morgue)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/officer
	title = "Master at Arms"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief of Security"
	alt_titles = list(
		"Military Police")
	economic_modifier = 4
	minimal_player_age = 10
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/maa
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/maa/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/security/maa/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e2,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/marine/e4
	)


	access = list(access_security, access_brig, access_maint_tunnels,
						access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_solgov_crew)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/senior_doctor
	title = "Physician"
	department = "Medical"
	department_flag = MED

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
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/senior/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o1
	)

	access = list(access_medical, access_morgue, access_virology, access_maint_tunnels, access_emergency_storage,
			            access_crematorium, access_chemistry, access_surgery,
			            access_medical_equip, access_solgov_crew, access_senmed)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

/datum/job/doctor
	title = "Corpsman"
	minimal_player_age = 7
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Chief Medical Officer"
	economic_modifier = 7
	ideal_character_age = 40
	alt_titles = list(
		"Field Medic" = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/medic,
		"Medical Technician",
		"Nurse")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/fleet
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/medical/doctor,
		/datum/mil_branch/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/fleet/e6
	)

	access = list(access_medical, access_morgue, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_surgery, access_medical_equip, access_solgov_crew)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

/datum/job/doctor_contractor
	title = "Medical Contractor"
	department = "Medical"
	department_flag = MED

	total_positions = 3
	spawn_positions = 3
	supervisors = "the Chief Medical Officer and Medical Personnel"
	selection_color = "#013d3b"
	economic_modifier = 3
	ideal_character_age = 30
	alt_titles = list(
		"Orderly" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/orderly,
		"Mortician" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/mortus,
		"Virologist" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/virologist,
		"Xenosurgeon" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/xenosurgeon,
		"Paramedic" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/paramedic,
		"Chemist" = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/chemist)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/contractor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_medical, access_morgue, access_crematorium, access_virology, access_surgery, access_medical_equip, access_solgov_crew,
		            access_eva, access_maint_tunnels, access_emergency_storage, access_external_airlocks, access_chemistry)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

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
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/fleet)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/ec/o1)


	access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_psychiatrist, access_solgov_crew)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

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
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/marine/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine/o2,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine/e5,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/marine/e6,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/marine/e7,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine/e8
	)

	access = list(access_maint_tunnels, access_heads, access_emergency_storage, access_tech_storage,  access_cargo, access_guppy_helm,
						access_cargo_bot, access_qm, access_mailsorting, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/supply)

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
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/supply/tech/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/supply/tech/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/marine/e4
	)

	access = list(access_maint_tunnels, access_emergency_storage, access_cargo, access_guppy_helm,
						access_cargo_bot, access_mailsorting, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/supply)

/datum/job/cargo_contractor
	title = "Supply Assistant"
	department = "Supply"
	department_flag = SUP

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Deck Officer and Supply Personnel"
	ideal_character_age = 20
	selection_color = "#515151"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/supply/contractor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting, access_hangar, access_guppy, access_guppy_helm, access_solgov_crew)

	software_on_spawn = list(/datum/computer_file/program/supply)

/datum/job/janitor
	title = "Sanitation Technician"
	department = "Service"
	department_flag = SRV

	total_positions = 2
	spawn_positions = 2
	supervisors = "the Executive Officer"
	ideal_character_age = 20
	alt_titles = list(
		"Janitor")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/janitor
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/janitor/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/janitor/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/service/janitor/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/marine/e4
	)

	access = list(access_maint_tunnels, access_emergency_storage, access_janitor, access_solgov_crew)
	minimal_access = list()

/datum/job/chef
	title = "Cook"
	department = "Service"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Executive Officer"
	alt_titles = list(
		"Chef",
		"Culinary Specialist"
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/cook
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/cook/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/cook/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/service/cook/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/ec/e2,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/marine/e4
	)

	access = list(access_maint_tunnels, access_hydroponics, access_kitchen, access_solgov_crew)
	minimal_access = list()

/datum/job/bartender
	department = "Service"
	department_flag = SRV
	supervisors = "the Executive Officer"
	ideal_character_age = 30
	selection_color = "#515151"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/bartender
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_hydroponics, access_bar, access_solgov_crew)
	minimal_access = list()


/datum/job/crew
	title = "Crewman"
	department = "Service"
	department_flag = SRV

	total_positions = 5
	spawn_positions = 5
	supervisors = "the Executive Officer and SolGov Personnel"
	selection_color = "#515151"
	ideal_character_age = 20
	alt_titles = list(
		"Engineer Trainee",
		"Corpsman Trainee",
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/crewman
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/crewman/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/service/crewman/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e2,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/marine/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine/e3,
		/datum/mil_rank/ec/e4,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/marine/e4
	)


	access = list(access_maint_tunnels, access_emergency_storage, access_solgov_crew)

/datum/job/senior_scientist
	title = "Senior Researcher"
	department = "Science"
	department_flag = SCI

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Research Director"
	selection_color = "#633d63"
	economic_modifier = 12
	minimal_player_age = 10
	ideal_character_age = 50
	alt_titles = list(
		"Research Supervisor")
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/senior_scientist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_tox, access_tox_storage, access_research, access_mining, access_mining_office,
						access_mining_station, access_xenobiology, access_xenoarch, access_nanotrasen,
						access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_petrov_helm, access_guppy_helm)

/datum/job/nt_pilot
	title = "NanoTrasen Pilot"
	supervisors = "the Research Director"
	department = "Science"
	department_flag = SCI

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Research Director and NanoTrasen Personnel"
	selection_color = "#633d63"
	economic_modifier = 10
	minimal_player_age = 5
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(access_research, access_mining_office,
						access_mining_station, access_nanotrasen, access_expedition_shuttle, access_expedition_shuttle_helm, access_guppy,
						access_hangar, access_petrov, access_petrov_helm, access_guppy_helm, access_mining)
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

	access = list(access_tox, access_tox_storage, access_research, access_petrov, access_petrov_helm,
						access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
						access_xenoarch, access_nanotrasen, access_expedition_shuttle, access_guppy, access_hangar)
	minimal_access = list()


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
						access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_guppy_helm)
	minimal_access = list()


/datum/job/guard
	title = "Security Guard"
	department = "Science"
	department_flag = SCI

	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director and NanoTrasen Personnel"
	selection_color = "#633d63"
	economic_modifier = 6
	minimal_player_age = 3
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/guard
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	access = list(access_tox, access_tox_storage,access_research, access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard, access_hangar, access_petrov, access_expedition_shuttle, access_guppy)


/datum/job/scientist_assistant
	title = "Research Assistant"
	department = "Science"
	department_flag = SCI

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

	access = list(access_research, access_mining_office, access_nanotrasen, access_petrov, access_expedition_shuttle, access_guppy)


/datum/job/assistant
	title = "Passenger"
	total_positions = 12
	spawn_positions = 12
	supervisors = "the Executive Officer"
	selection_color = "#515151"
	economic_modifier = 1
	alt_titles = list(
		"Private Investigator" = /decl/hierarchy/outfit/job/torch/passenger/passenger/PI,
		"Journalist" = /decl/hierarchy/outfit/job/torch/passenger/passenger/journalist,
		"Historian",
		"Botanist",
		"Investor",
		"Naturalist",
		"Ecologist",
		"Entertainer",
		"Independent Observer",
		"Sociologist",
		"Off-Duty")
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/passenger
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/offduty,
		/datum/mil_rank/civ/nt
	)

/datum/job/cyborg
	total_positions = 3
	spawn_positions = 3
	supervisors = "your laws"


/datum/job/merchant
	title = "Merchant"
	department = "Civilian"
	department_flag = CIV

	total_positions = 2
	spawn_positions = 2
	availablity_chance = 30
	supervisors = "the invisible hand of the market"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 7
	create_record = 0
	outfit_type = /decl/hierarchy/outfit/job/torch/merchant
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/civ)
	latejoin_at_spawnpoints = 1
	access = list(access_merchant)
	announced = FALSE

/datum/job/stowaway
	title = "Stowaway"
	department = "Civilian"
	department_flag = CIV

	total_positions = 1
	spawn_positions = 1
	availablity_chance = 20
	supervisors = "yourself"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 7
	create_record = 0
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/job/torch/stowaway
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/civ)
	latejoin_at_spawnpoints = 1
	announced = FALSE