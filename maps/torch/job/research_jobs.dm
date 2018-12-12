/datum/job/senior_scientist
	title = "Senior Researcher"
	department = "Science"
	department_flag = SCI

	total_positions = 1
	spawn_positions = 1
	supervisors = "the Research Director and the Workplace Liaison"
	selection_color = "#3e633e"
	economic_power = 12
	minimal_player_age = 3
	ideal_character_age = 50
	alt_titles = list(
		"Research Supervisor")
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/senior_scientist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(access_tox, access_tox_storage, access_research, access_mining, access_mining_office,
						access_mining_station, access_xenobiology, access_xenoarch, access_nanotrasen,
						access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_petrov_helm, access_guppy_helm,
						access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_maint, access_robotics)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_FINANCE     = SKILL_BASIC,
	                    SKILL_BOTANY      = SKILL_BASIC,
	                    SKILL_ANATOMY     = SKILL_BASIC,
	                    SKILL_DEVICES     = SKILL_ADEPT,
	                    SKILL_SCIENCE     = SKILL_ADEPT)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)
	skill_points = 20
	required_education = EDUCATION_TIER_DOCTORATE

/datum/job/scientist
	title = "Scientist"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Research Director and the Workplace Liaison"
	selection_color = "#3e633e"
	economic_power = 10
	ideal_character_age = 45
	minimal_player_age = 0
	alt_titles = list(
		"Xenoarcheologist",
		"Anomalist",
		"Researcher",
		"Xenobiologist",
		"Xenobotanist",
		"Psychologist" = /decl/hierarchy/outfit/job/torch/passenger/research/scientist/psych)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_DEVICES     = SKILL_BASIC,
	                    SKILL_SCIENCE     = SKILL_ADEPT)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/scientist
	allowed_branches = list(/datum/mil_branch/civilian,
							/datum/mil_branch/solgov)
	allowed_ranks = list(/datum/mil_rank/civ/contractor,
						 /datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/scientist/solgov)

	access = list(access_tox, access_tox_storage, access_research, access_petrov, access_petrov_helm,
						access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
						access_xenoarch, access_nanotrasen, access_expedition_shuttle, access_guppy, access_hangar,
						access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry)
	minimal_access = list()
	skill_points = 20
	required_education = EDUCATION_TIER_MASTERS

/datum/job/guard
	title = "Security Guard"
	department = "Science"
	department_flag = SCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director, the Workplace Liaison and science personnel"
	selection_color = "#3e633e"
	economic_power = 6
	minimal_player_age = 0
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/guard
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_COMBAT  = SKILL_BASIC,
	                    SKILL_WEAPONS = SKILL_BASIC)

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX)

	access = list(access_tox, access_tox_storage,access_research, access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard, access_hangar, access_petrov, access_petrov_helm, access_expedition_shuttle, access_guppy,
						access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_security, access_petrov_maint)
	required_education = EDUCATION_TIER_DROPOUT
	maximum_education = EDUCATION_TIER_BACHELOR

/datum/job/scientist_assistant
	title = "Research Assistant"
	department = "Science"
	department_flag = SCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director, the Workplace Liaison and science personnel"
	selection_color = "#3e633e"
	economic_power = 3
	ideal_character_age = 30
	alt_titles = list(
		"Custodian" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/janitor,
		"Testing Assistant" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/testsubject,
		"Laboratory Technician",
		"Intern",
		"Clerk",
		"Field Assistant")

	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/assist
	allowed_branches = list(/datum/mil_branch/civilian,
							/datum/mil_branch/solgov)
	allowed_ranks = list(/datum/mil_rank/civ/contractor,
						 /datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/assist/solgov)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

	access = list(access_research, access_mining_office, access_nanotrasen, access_petrov, access_expedition_shuttle, access_guppy, access_hangar)
	required_education = EDUCATION_TIER_DROPOUT
	maximum_education = EDUCATION_TIER_BACHELOR

/datum/job/xenolife_technician
	title = "Xenolife Technician"
	department = "Science"
	department_flag = SCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Research Director"
	selection_color = "#3e633e"
	economic_power = 7
	ideal_character_age = 35
	minimal_player_age = 0
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_SCIENCE     = SKILL_ADEPT,
						SKILL_ANATOMY     = SKILL_BASIC,
						SKILL_BOTANY     = SKILL_BASIC)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/research
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)
	allowed_ranks = list(
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/ec/o1 = /decl/hierarchy/outfit/job/torch/crew/research/commissioned
	)

	access = list(access_tox_storage, access_research, access_petrov, access_xenobiology, access_guppy_helm,
						access_expedition_shuttle, access_guppy, access_hangar,  access_solgov_crew, access_emergency_storage)
	minimal_access = list()
	skill_points = 16
	required_education = EDUCATION_TIER_BACHELOR
	maximum_education = EDUCATION_TIER_DOCTORATE

/datum/job/roboticist
	title = "Roboticist"
	department = "Science"
	department_flag = SCI

	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 0
	supervisors = "the Research Director and the Workplace Liason"
	selection_color = "#3e633e"
	economic_power = 9
	alt_titles = list(
		"Mechsuit Technician")
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/roboticist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_COMPUTER		= SKILL_ADEPT,
	                    SKILL_DEVICES		= SKILL_ADEPT)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_EXPERT,
	                    SKILL_ENGINES      = SKILL_EXPERT,
	                    SKILL_DEVICES      = SKILL_MAX,
	                    SKILL_ANATOMY      = SKILL_EXPERT,
	                    SKILL_MEDICAL      = SKILL_EXPERT)
	skill_points = 20

	access = list(access_robotics, access_robotics_engineering, access_tech_storage, access_solgov_crew, access_research, access_mining_office, access_nanotrasen, access_petrov, access_expedition_shuttle)
	minimal_access = list()
	required_education = EDUCATION_TIER_TRADE
	maximum_education = EDUCATION_TIER_DOCTORATE

/datum/job/roboticist/get_description_blurb()
	return "You are the Roboticist. You are responsible for repairing, upgrading and handling ship synthetics, such as robots. You are also responsible for the production of exosuits (mechs) and simple bots for various departments. You answer to the Research Director and the Workplace Liaison."