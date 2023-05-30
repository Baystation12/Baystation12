/datum/job/senior_scientist
	title = "Senior Researcher"
	department = "Научный"
	department_flag = SCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главному научному офицеру"
	selection_color = "#633d63"
	economic_power = 12
	minimal_player_age = 3
	minimum_character_age = list(SPECIES_HUMAN = 30)
	ideal_character_age = 50
	alt_titles = list(
		"Research Supervisor",
		"Research Overseer")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/research/senior_scientist
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
		access_petrov_maint, access_torch_fax, access_radio_sci, access_radio_exp
	)

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
	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/senior_scientist/get_description_blurb()
	return "Вы - Старший научный сотрудник. Ваша задача - обеспечивать учёных работой и заниматся исследованием различных областей науки. \
	Вы подчиняетесь Главному научному офицеру и являетесь вторым человеком на судне по вопросам науки после него. \
	Будьте правой рукой ГНО, делайте бомбы и открывайте порталы в другие измерения. Сила науки находится в ваших руках."

/datum/job/scientist
	title = "Scientist"
	department = "Научный"
	total_positions = 6
	spawn_positions = 6
	supervisors = "Главному научному офицеру и старшему научному сотруднику"
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
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_DEVICES     = SKILL_BASIC,
	                    SKILL_SCIENCE     = SKILL_ADEPT)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/research/scientist
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/civ/second = /decl/hierarchy/outfit/job/torch/passenger/research/scientist,
		/datum/mil_rank/civ/first = /decl/hierarchy/outfit/job/torch/passenger/research/scientist,
		/datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/scientist/solgov
	)

	access = list(
		access_tox, access_tox_storage, access_research, access_petrov, access_petrov_helm,
		access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
		access_xenoarch, access_nanotrasen, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control, access_torch_fax,
		access_petrov_maint, access_radio_sci, access_radio_exp, access_research_storage
	)
	skill_points = 20
	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/scientist/get_description_blurb()
	return "Вы - Научный сотрудник. Ваша задача - проводить анализ различных вещей и проверять свои гипотизы на практике. \
	Вы подчиняетесь Главному научному офицеру и старшему научному сотруднику. \
	Продвиньте науку вперёд, а также постарайтесь не взорвать отдел."

/datum/job/scientist_assistant
	title = "Research Assistant"
	department = "Научный"
	department_flag = SCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "Главному научному офицеру и научному персоналу"
	selection_color = "#633d63"
	economic_power = 3
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 30
	alt_titles = list(
		"Custodian" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/janitor,
		"Testing Assistant" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/testsubject,
		"Intern",
		"Clerk",
		"Field Assistant")

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/research
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/civ/three = /decl/hierarchy/outfit/job/torch/passenger/research/assist,
		/datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/assist/solgov
	)
	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

	access = list(
		access_tox, access_tox_storage, access_research, access_petrov,
		access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
		access_xenoarch, access_nanotrasen, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control,
		access_radio_sci, access_radio_exp, access_research_storage
	)
	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/scientist_assistant/get_description_blurb()
	return "Вы - Научный сотрудник. Вы учитесь основам науки благодаря помощи своих опытных коллег. \
	Вы подчиняетесь Главному научному офицеру и остальному научному персоналу."

/datum/job/research_guard
	title = "Research Guard"
	department = "Научный"
	department_flag = SCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главному научному офицеру"
	selection_color = "#473d63"
	alt_titles = list(
		"Protection Agent")
	economic_power = 5
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 26)
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research_guard
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/passenger/research_guard/ec
	)

	allowed_ranks = list(
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_ADEPT,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_ADEPT
						)

	max_skill = list(   SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 20

	access = list(
		access_research_security, access_tox, access_tox_storage, access_maint_tunnels, access_research, access_xenobiology, access_xenoarch, access_nanotrasen, access_solgov_crew,
		access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_petrov_helm, access_guppy_helm,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_maint, access_radio_sci
	)

	software_on_spawn = list(/datum/computer_file/program/camera_monitor)

/datum/job/research_guard/get_description_blurb()
	return "Вы - охранник научного отдела. Вы являетесь работником Организации Экспедиционного Корпуса. \
	Обеспечивайте безопасность сотрудников и оборудования научного отдела. Не ешьте слишком много пончиков. \
	Стоит отметить, что Вы отвечаете за охрану только научного отдела и не должны патрулировать остальное судно. Помогать службе безопасности Факела следует только в крайних случаях."
