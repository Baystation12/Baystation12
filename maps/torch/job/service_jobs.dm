/datum/job/chief_steward
	title = "Chief Steward"
	department = "Service"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	minimum_character_age = list(SPECIES_HUMAN = 28)
	ideal_character_age = 35
	economic_power = 6
	minimal_player_age = 7
	supervisors = "the Executive Officer"
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/service/chief_steward
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/service/chief_steward/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e6
	)

	skill_points = 5
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_COOKING = SKILL_TRAINED,
		SKILL_BOTANY = SKILL_TRAINED,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

	access = list(
		access_bridge,
		access_torch_fax,
		access_chief_steward,
		access_solgov_crew,
		access_radio_comm,
		access_radio_serv,
		access_emergency_storage,
		access_janitor,
		access_commissary,
		access_hydroponics,
		access_kitchen,
		access_o_mess
	)

/datum/job/chaplain
	title = "Chaplain"
	department = "Service"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 40
	economic_power = 6
	minimal_player_age = 0
	supervisors = "the Executive Officer"
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/service/chaplain
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /singleton/hierarchy/outfit/job/torch/crew/service/chaplain/ec,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/service/chaplain/fleet)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/ec/o1)

	skill_points = 5
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC
	)

	access = list(
		access_morgue, access_chapel_office,
		access_crematorium, access_solgov_crew,
		access_radio_serv
	)

/datum/job/janitor
	title = "Sanitation Technician"
	department = "Service"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Steward"
	minimum_character_age = list(SPECIES_HUMAN = 20)
	ideal_character_age = 20
	alt_titles = list(
		"Custodian",
		"Janitor")
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/service/janitor
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /singleton/hierarchy/outfit/job/torch/crew/service/janitor/ec,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/service/janitor/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4
	)

	skill_points = 5
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_DEVICES = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_BASIC,
		SKILL_ELECTRICAL = SKILL_BASIC
	)

	access = list(
		access_maint_tunnels, access_emergency_storage,
		access_janitor, access_solgov_crew,
		access_radio_serv
	)


/datum/job/chef
	title = "Steward"
	department = "Service"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	minimum_character_age = list(SPECIES_HUMAN = 20)
	supervisors = "the Chief Steward"
	alt_titles = list(
		"Bartender",
		"Cook",
		"Culinary Specialist"
	)
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/service/cook
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /singleton/hierarchy/outfit/job/torch/crew/service/cook/ec,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/service/cook/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5
	)

	skill_points = 5
	min_skill = list(
		SKILL_BOTANY = SKILL_TRAINED,
		SKILL_CHEMISTRY = SKILL_BASIC,
		SKILL_COOKING = SKILL_TRAINED
	)

	access = list(
		access_commissary,
		access_hydroponics,
		access_kitchen,
		access_radio_serv,
		access_solgov_crew,
		access_o_mess
	)


/datum/job/crew
	title = "Crewman"
	department = "Service"
	department_flag = SRV
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Chief Steward"
	minimum_character_age = list(SPECIES_HUMAN = 20)
	ideal_character_age = 20
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/service/crewman
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /singleton/hierarchy/outfit/job/torch/crew/service/crewman/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4
	)

	skill_points = 5
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_EVA = SKILL_BASIC
	)

	access = list(
		access_maint_tunnels, access_emergency_storage,
		access_solgov_crew, access_radio_serv
	)
