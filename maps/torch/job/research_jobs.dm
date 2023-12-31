/datum/job/senior_scientist
	title = "Senior Researcher"
	department = "Science"
	department_flag = SCI

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Science Officer"
	selection_color = "#633d63"
	economic_power = 12
	minimal_player_age = 3
	minimum_character_age = list(SPECIES_HUMAN = 30)
	ideal_character_age = 50
	alt_titles = list(
		"Research Supervisor")
	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/research/senior_scientist
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1
	)

	access = list(
		access_tox, access_tox_storage, access_maint_tunnels, access_research, access_mining_office,
		access_mining_station, access_xenobiology, access_xenoarch, access_nanotrasen, access_solgov_crew,
		access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_petrov_helm, access_guppy_helm,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control,
		access_petrov_maint, access_torch_fax, access_radio_sci, access_radio_exp, access_research_storage
	)

	skill_points = 3
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_BOTANY = SKILL_TRAINED,
		SKILL_ANATOMY = SKILL_BASIC,
		SKILL_DEVICES = SKILL_TRAINED,
		SKILL_SCIENCE = SKILL_EXPERIENCED,
		SKILL_EVA = SKILL_BASIC,
		SKILL_PILOT = SKILL_BASIC
	)

	max_skill = list(
		SKILL_ANATOMY = SKILL_EXPERIENCED,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX
	)

	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/scientist
	title = "Scientist"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Chief Science Officer"
	economic_power = 10
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 45
	minimal_player_age = 0
	alt_titles = list(
		"Xenoarcheologist",
		"Anomalist",
		"Researcher",
		"Xenobiologist",
		"Xenobotanist"
	)

	skill_points = 3
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_BOTANY = SKILL_TRAINED,
		SKILL_ANATOMY = SKILL_BASIC,
		SKILL_DEVICES = SKILL_TRAINED,
		SKILL_SCIENCE = SKILL_TRAINED,
		SKILL_EVA = SKILL_BASIC,
		SKILL_PILOT = SKILL_BASIC
	)

	max_skill = list(
		SKILL_ANATOMY = SKILL_EXPERIENCED,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX
	)

	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/research/scientist
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/civ/contractor = /singleton/hierarchy/outfit/job/torch/passenger/research/scientist,
		/datum/mil_rank/sol/scientist = /singleton/hierarchy/outfit/job/torch/passenger/research/scientist/solgov
	)

	access = list(
		access_tox, access_tox_storage, access_research, access_petrov, access_petrov_helm,
		access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
		access_xenoarch, access_nanotrasen, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control, access_torch_fax,
		access_petrov_maint, access_radio_sci, access_radio_exp, access_research_storage
	)
	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/scientist_assistant
	title = "Research Assistant"
	department = "Science"
	department_flag = SCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief Science Officer and science personnel"
	selection_color = "#633d63"
	economic_power = 3
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 30
	alt_titles = list(
		"Testing Assistant",
		"Intern",
		"Clerk",
		"Field Assistant")

	outfit_type = /singleton/hierarchy/outfit/job/torch/crew/research
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/civ/contractor = /singleton/hierarchy/outfit/job/torch/passenger/research/assist,
		/datum/mil_rank/sol/scientist = /singleton/hierarchy/outfit/job/torch/passenger/research/assist/solgov
	)

	skill_points = 5
	min_skill = list(
		SKILL_BOTANY = SKILL_TRAINED,
		SKILL_ANATOMY = SKILL_BASIC,
		SKILL_DEVICES = SKILL_TRAINED,
		SKILL_SCIENCE = SKILL_BASIC,
		SKILL_EVA = SKILL_BASIC,
		SKILL_HAULING = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_ANATOMY = SKILL_MAX,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX
	)

	access = list(
		access_tox, access_tox_storage, access_research, access_petrov,
		access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
		access_xenoarch, access_nanotrasen, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control,
		access_radio_sci, access_radio_exp, access_research_storage
	)
	possible_goals = list(/datum/goal/achievement/notslimefodder)
