/datum/job/qm
	title = "Deck Chief"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Executive Officer"
	economic_power = 5
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 27)
	ideal_character_age = 35
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/supply/deckofficer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/supply/deckofficer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8
	)

	skill_points = 5
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_EXPERIENCED,
		SKILL_FINANCE = SKILL_TRAINED,
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_EVA = SKILL_BASIC,
		SKILL_MECH = HAS_PERK
	)

	access = list(
		access_maint_tunnels, access_bridge, access_emergency_storage, access_tech_storage,  access_cargo, access_guppy_helm,
		access_cargo_bot, access_qm, access_mailsorting, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_mining, access_mining_office, access_mining_station, access_commissary, access_teleporter, access_eva, access_torch_fax,
		access_radio_sup, access_radio_exp, access_radio_comm
	)

	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/cargo_tech
	title = "Deck Technician"
	department = "Supply"
	department_flag = SUP
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Deck Chief"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 24
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/supply/tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/supply/tech/fleet,
		/datum/mil_branch/civilian = /singleton/hierarchy/outfit/job/torch/crew/supply/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/civ/contractor
	)

	skill_points = 5
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_FINANCE = SKILL_BASIC,
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_EVA = SKILL_BASIC,
		SKILL_MECH = HAS_PERK
	)

	access = list(
		access_maint_tunnels, access_emergency_storage, access_cargo, access_guppy_helm,
		access_cargo_bot, access_mailsorting, access_solgov_crew, access_expedition_shuttle,
		access_guppy, access_hangar, access_commissary, access_radio_sup
	)

	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/mining
	title = "Prospector"
	department = "Supply"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Deck Chief"
	economic_power = 7
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 25
	alt_titles = list(
		"Drill Technician",
		"Shaft Miner",
		"Salvage Technician")

	skill_points = 5
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_EVA = SKILL_TRAINED,
		SKILL_PILOT = SKILL_TRAINED,
		SKILL_DEVICES = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_BASIC,
		SKILL_ELECTRICAL = SKILL_BASIC
	)

	outfit_type = /singleton/hierarchy/outfit/job/torch/passenger/research/prospector
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(
		access_mining, access_mining_office, access_mining_station,
		access_expedition_shuttle, access_guppy, access_hangar,
		access_guppy_helm, access_solgov_crew, access_eva,
		access_radio_exp, access_radio_sup
	)
