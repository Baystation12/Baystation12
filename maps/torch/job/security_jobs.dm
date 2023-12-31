/datum/job/warden
	title = "Brig Chief"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief of Security"
	economic_power = 5
	minimal_player_age = 7
	ideal_character_age = 35
	minimum_character_age = list(SPECIES_HUMAN = 27)
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/security/brig_chief
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/security/brig_chief/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8,
	)

	skill_points = 3
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_EVA = SKILL_TRAINED,
		SKILL_COMBAT = SKILL_EXPERIENCED,
		SKILL_WEAPONS = SKILL_TRAINED,
		SKILL_FORENSICS = SKILL_BASIC,
		SKILL_HAULING = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX
	)

	access = list(
		access_security, access_brig, access_armory, access_forensics_lockers,
		access_maint_tunnels, access_external_airlocks, access_emergency_storage,
		access_eva, access_sec_doors, access_solgov_crew, access_gun, access_torch_fax,
		access_radio_sec
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/detective
	title = "Forensic Technician"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief of Security"
	economic_power = 5
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 35
	alt_titles = list(
		"Criminal Investigator"
	)
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/security/forensic_tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/civilian = /singleton/hierarchy/outfit/job/torch/crew/security/forensic_tech/contractor,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/security/forensic_tech/fleet,
		/datum/mil_branch/solgov = /singleton/hierarchy/outfit/job/torch/crew/security/forensic_tech/agent
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/sol/agent
	)

	skill_points = 5
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_FORENSICS = SKILL_EXPERIENCED,
		SKILL_HAULING = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_WEAPONS     = SKILL_EXPERIENCED,
		SKILL_FORENSICS   = SKILL_MAX
	)

	access = list(
		access_security, access_brig, access_forensics_lockers,
		access_maint_tunnels, access_emergency_storage,
		access_sec_doors, access_solgov_crew, access_morgue,
		access_torch_fax, access_network, access_radio_sec
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/officer
	title = "Master at Arms"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief of Security"
	economic_power = 4
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 25
	alt_titles = list() // This is a hack. Overriding a list var with null does not actually override it due to the particulars of dm list init. Do not "clean up" without testing.
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/security/maa
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/security/maa/fleet,
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5
	)

	skill_points = 5
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_EVA = SKILL_TRAINED,
		SKILL_COMBAT = SKILL_TRAINED,
		SKILL_WEAPONS = SKILL_TRAINED,
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_FORENSICS = SKILL_BASIC
	)

	max_skill = list(
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX
	)

	access = list(
		access_security, access_brig, access_maint_tunnels,
		access_external_airlocks, access_emergency_storage,
		access_eva, access_sec_doors, access_solgov_crew,
		access_radio_sec
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)
