/datum/job/senior_scientist
	title = "Senior Researcher"
	department = "Научный"
	department_flag = SCI

	total_positions = 1
	spawn_positions = 1
	supervisors = "Директору Исследований"
	selection_color = "#633d63"
	economic_power = 12

	minimal_player_age = 10
	minimum_character_age = list(SPECIES_HUMAN = 27)
	ideal_character_age = 30
	alt_titles = list(
			"Research Supervisor"
		)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/research/senior_scientist
	allowed_branches = list(/datum/mil_branch/employee)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	access = list(
			access_tox,					access_tox_storage,	access_research,	access_mining,		access_mining_office,
			access_mining_station,		access_xenobiology,	access_xenoarch,	access_robotics,	access_guppy_helm,
			access_expedition_shuttle,	access_guppy,		access_hangar,		access_petrov,		access_petrov_helm,
			access_research_storage
		)



	min_skill = list(
			SKILL_BUREAUCRACY	=	SKILL_BASIC,
			SKILL_COMPUTER		=	SKILL_BASIC,
			SKILL_FINANCE		=	SKILL_BASIC,
			SKILL_BOTANY		=	SKILL_BASIC,
			SKILL_ANATOMY		=	SKILL_BASIC,
			SKILL_DEVICES		=	SKILL_TRAINED,
			SKILL_SCIENCE		=	SKILL_TRAINED
		)

	max_skill = list(
			SKILL_DEVICES		=	SKILL_MAX,
			SKILL_SCIENCE		=	SKILL_MAX,
			SKILL_ANATOMY		=	SKILL_MAX
		)
	skill_points = 30

	possible_goals = list(/datum/goal/achievement/notslimefodder)
	// SIERRA TODO: need_exp_to_play
	// need_exp_to_play = 2

/datum/job/senior_scientist/get_description_blurb()
	return "Самый старший член исследовательской команды, старший научный сотрудник, отвечает за то,чтобы остальные сотрудники отдела знали, что они должны делать, и делать это быстро и профессионально.\
	Его работа заключается в том, чтобы привести приказы директора исследований в действие и контролировать повседневную работу отдела, чтобы быть уверенным, что все сделано правильно."

/datum/job/scientist
	title = "Scientist"
	department = "Научный"
	department_flag = SCI
	total_positions = 6
	spawn_positions = 6
	supervisors = "Директору Исследований и Старшему Исследователю"
	economic_power = 10
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 27
	alt_titles = list(
			"Xenoarcheologist",
			"Anomalist",
			"Researcher",
			"Xenobiologist",
			"Xenobotanist"
		)
	min_skill = list(
			SKILL_BUREAUCRACY	=	SKILL_BASIC,
			SKILL_COMPUTER		=	SKILL_BASIC,
			SKILL_DEVICES		=	SKILL_BASIC,
			SKILL_SCIENCE		=	SKILL_TRAINED
		)

	max_skill = list(
			SKILL_DEVICES		=	SKILL_MAX,
			SKILL_SCIENCE		=	SKILL_MAX,
			SKILL_CHEMISTRY		=	SKILL_MAX
		)

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/research/scientist
	allowed_branches = list(
			/datum/mil_branch/employee,
			/datum/mil_branch/contractor
		)
	allowed_ranks = list(
			/datum/mil_rank/civ/nt,
			/datum/mil_rank/civ/contractor
		)

	access = list(
			access_tox,				access_tox_storage,			access_research,	access_petrov,		access_petrov_helm,
			access_mining_office,	access_mining_station,		access_xenobiology,	access_guppy_helm, 	access_hangar,
			access_xenoarch,		access_expedition_shuttle,	access_guppy, access_research_storage
		)


	skill_points = 22
	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/scientist/get_description_blurb()
	return "Ученый - одна из самых распространенных и разнообразных рабочих профессий на борту корабля.\
	Будучи ученым на Сьерре, Вы можете собирать и исследовать множество уникальных инструментов и гаджетов,\
	создавать взрывоопасные или очень полезные бомбы, улетать на поверхность планет и странные места за пределами корабля на Хароне или Гуппи в горных или археологических целях, и даже взаимодействовать с неизвестной инопланетной жизнью."

/datum/job/roboticist
	title = "Roboticist"
	department = "Научный"
	department_flag = SCI

	total_positions = 2
	spawn_positions = 2
	supervisors = "Директору Исследований и Старшему Исследователю"
	selection_color = "#633d63"
	economic_power = 6
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 27
	alt_titles = list(
			"Biomechanical Engineer",
			"Exosuit Technician",
		)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/research/roboticist
	allowed_branches = list(
			/datum/mil_branch/employee,
			/datum/mil_branch/contractor
		)
	allowed_ranks = list(
			/datum/mil_rank/civ/nt,
			/datum/mil_rank/civ/contractor
		)
	min_skill = list(
			SKILL_COMPUTER		=	SKILL_TRAINED,
			SKILL_DEVICES		=	SKILL_TRAINED,
			SKILL_EVA			=	SKILL_TRAINED,
			SKILL_ANATOMY		=	SKILL_TRAINED,
			SKILL_MECH			=	HAS_PERK,
			SKILL_MEDICAL		=	SKILL_BASIC,
			SKILL_ELECTRICAL	=	SKILL_TRAINED
		)

	max_skill = list(
			SKILL_CONSTRUCTION	=	SKILL_MAX,
			SKILL_ELECTRICAL	=	SKILL_MAX,
			SKILL_ATMOS			=	SKILL_EXPERIENCED,
			SKILL_ENGINES		=	SKILL_EXPERIENCED,
			SKILL_DEVICES		=	SKILL_MAX,
			SKILL_MEDICAL		=	SKILL_EXPERIENCED,
			SKILL_ANATOMY		=	SKILL_EXPERIENCED
		)

	skill_points = 22

	access = list(
			access_robotics,
			access_research,
			access_tech_storage,
			access_research_storage
		)


/datum/job/roboticist/get_description_blurb()
	return "Корабельный роботехник, в первую очередь, занимается производством и обслуживанием киборгов и роботов корабля.\
	Он также может быть призван собирать различные экзокостюмы, ремонтировать протезированные конечности у членов экипажа и пересаживать чей-то мозг в корпус киборга или полностью синтетический юнит."

/datum/job/scientist_assistant
	title = "Research Assistant"
	department = "Научный"
	department_flag = SCI

	total_positions = 4
	spawn_positions = 4
	supervisors = "Директору Исследований и остальному научному персоналу"
	selection_color = "#633d63"
	economic_power = 3
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 24
	ideal_character_age = 30
	alt_titles = list(
			"Testing Assistant" = /singleton/hierarchy/outfit/job/sierra/crew/research/assist/testsubject,
			"Laboratory Technician",
			"Science Intern",
			"Clerk (RND)",
			"Field Assistant"
		)

	max_skill = list(
			SKILL_DEVICES		=	SKILL_MAX,
			SKILL_SCIENCE		=	SKILL_MAX,
			SKILL_CHEMISTRY		=	SKILL_MAX
		)

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/research/assist
	allowed_branches = list(
			/datum/mil_branch/employee,
			/datum/mil_branch/contractor
		)
	allowed_ranks = list(
			/datum/mil_rank/civ/nt,
			/datum/mil_rank/civ/contractor
		)

	access = list(
			access_research,	access_mining_office,
			access_petrov,		access_expedition_shuttle,
			access_guppy,		access_hangar,
			access_research_storage
		)


	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/scientist_assistant/get_description_blurb()
	return "Научный ассистент служит, в основном, для того, чтобы помогать ученым любыми способами, которые им нужны,\
	и, благодаря этому, служит отличной отправной точкой для новых игроков, желающих узнать больше об исследованиях."
