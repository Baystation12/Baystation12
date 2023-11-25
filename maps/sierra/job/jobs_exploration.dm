/datum/job/exploration_leader
	title = "Exploration Leader"
	department = "Экспедиционный"
	department_flag = EXP

	total_positions = 1
	spawn_positions = 1
	supervisors = "Директору Исследований и Капитану"
	selection_color = "#68099e"

	minimal_player_age = 14

	minimum_character_age = list(SPECIES_HUMAN = 26)
	ideal_character_age = 29
	economic_power = 9
	skill_points = 22

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/el
	allowed_branches = list(/datum/mil_branch/employee)
	allowed_ranks = list(/datum/mil_rank/civ/nt)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_EVA         = SKILL_TRAINED,
		SKILL_SCIENCE     = SKILL_TRAINED,
		SKILL_PILOT       = SKILL_BASIC,
		SKILL_MEDICAL     = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT   = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_COMBAT  = SKILL_EXPERIENCED,
		SKILL_WEAPONS = SKILL_EXPERIENCED
	)
	access = list(
		access_el,
		access_explorer,
		access_eva,
		access_bridge,
		access_heads,
		access_emergency_storage,
		access_tech_storage,
		access_guppy_helm,
		access_expedition_shuttle,
		access_expedition_shuttle_helm,
		access_guppy,
		access_hangar,
		access_research
	)
	software_on_spawn = list(
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)
	// SIERRA TODO: need_exp_to_play
	// need_exp_to_play = 2

/datum/job/exploration_leader/get_description_blurb()
	return "Вы - Экспедиционный Лидер. В ваши обязанности входит организация и участие в миссиях на удаленные объекты. \
	Вы ищите всё, что может предоставить НТ экономическую или научную выгоду - залежи драгоценных металлов, новые \
	формы жизни, инопланетные артефакты и неизвестные технологии. Вы будете вести свою экспедицию прямиком через ад - \
	опасную атмосферу, агрессивную флору и фауну, сбойных дронов, враждебно настроенными к вам роботов и \
	аномалии... Но не это ли то, за что Корпорация платит вам почти столько же, сколько главе?"

/datum/job/explorer
	title = "Explorer"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 3
	spawn_positions = 3
	supervisors = "Лидеру Экспедиции и Директору Исследований"
	selection_color = "#68099e"

	minimal_player_age = 4

	minimum_character_age = list(SPECIES_HUMAN = 22)
	ideal_character_age = 24
	economic_power = 6

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/explorer
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(
		SKILL_EVA     = SKILL_BASIC,
		SKILL_SCIENCE = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC
	)
	max_skill = list(
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_COMBAT  = SKILL_EXPERIENCED,
		SKILL_WEAPONS = SKILL_EXPERIENCED
	)
	// SIERRA TODO: required_role
	// required_role = list("Exploration Leader", "Expeditionary Pilot")
	access = list(
		access_explorer,
		access_eva,
		access_emergency_storage,
		access_guppy_helm,
		access_expedition_shuttle,
		access_guppy,
		access_hangar,
		access_research
	)
	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/explorer/get_description_blurb()
	return "Вы - Исследователь. В ваши обязанности входит участие в миссиях на удаленные объекты, \
	организуемые Лидером Экспедиции или заменяющим его лицом. Вы ищите всё, что может предоставить НТ \
	экономическую или научную выгоду - залежи драгоценных металлов, новые формы жизни, инопланетные артефакты и \
	неизвестные технологии. Вы будете иметь дело с опасной атмосферой, агрессивной флорой и фауной, сбойными дронами \
	на заброшенных объектах, враждебно настроенными к вам роботами и аномалиями... Но не это ли то, за что Корпорация \
	вам так хорошо платит?"

/datum/job/explorer_pilot
	title = "Expeditionary Pilot"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Лидеру Экспедиции и Директору Исследований"
	selection_color = "#68099e"

	minimal_player_age = 14

	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 26
	economic_power = 7

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/pilot
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(
		SKILL_EVA     = SKILL_BASIC,
		SKILL_SCIENCE = SKILL_BASIC,
		SKILL_PILOT   = SKILL_TRAINED,
		SKILL_MEDICAL = SKILL_BASIC
	)
	max_skill = list(
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_PILOT   = SKILL_MAX,
		SKILL_COMBAT  = SKILL_EXPERIENCED,
		SKILL_WEAPONS = SKILL_EXPERIENCED
	)
	access = list(
		access_explorer,
		access_eva,
		access_emergency_storage,
		access_guppy_helm,
		access_expedition_shuttle,
		access_guppy,
		access_hangar,
		access_expedition_shuttle_helm,
		access_research
	)
	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/explorer_pilot/get_description_blurb()
	return "Вы - Исследователь. В ваши обязанности входит участие в миссиях на удаленные объекты, \
	организуемые Лидером Экспедиции или заменяющим его лицом. Вы ищите всё, что может предоставить НТ \
	экономическую или научную выгоду - залежи драгоценных металлов, новые формы жизни, инопланетные артефакты и \
	неизвестные технологии. Вы будете иметь дело с опасной атмосферой, агрессивной флорой и фауной, сбойными дронами \
	на заброшенных объектах, враждебно настроенными к вам роботами и аномалиями... Но не это ли то, за что Корпорация \
	вам так хорошо платит?"

/datum/job/explorer_medic
	title = "Field Medic"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Лидеру Экспедиции и Директору Исследований"
	selection_color = "#68099e"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/medic
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	minimal_player_age = 8

	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 26
	economic_power = 8
	skill_points = 26

	min_skill = list(
		SKILL_EVA     = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_HAULING = SKILL_BASIC,
		SKILL_SCIENCE = SKILL_BASIC,
		SKILL_ANATOMY = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_COMBAT  = SKILL_EXPERIENCED,
		SKILL_WEAPONS = SKILL_EXPERIENCED
	)
	// SIERRA TODO: required_role
	// required_role = list("Exploration Leader", "Expeditionary Pilot")
	access = list(
		access_explorer,
		access_eva,
		access_emergency_storage,
		access_field_med,
		access_guppy_helm,
		access_expedition_shuttle,
		access_guppy,
		access_hangar,
		access_research
	)
	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/explorer_medic/get_description_blurb()
	return "Вы - Исследователь. В ваши обязанности входит участие в миссиях на удаленные объекты, \
	организуемые Лидером Экспедиции или заменяющим его лицом. Вы ищите всё, что может предоставить НТ \
	экономическую или научную выгоду - залежи драгоценных металлов, новые формы жизни, инопланетные артефакты и \
	неизвестные технологии. Вы будете иметь дело с опасной атмосферой, агрессивной флорой и фауной, сбойными дронами \
	на заброшенных объектах, враждебно настроенными к вам роботами и аномалиями... Но не это ли то, за что Корпорация \
	вам так хорошо платит?"

/datum/job/explorer_engineer
	title = "Field Engineer"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Лидеру Экспедиции и Директору Исследований"
	selection_color = "#68099e"

	minimal_player_age = 8

	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 26
	economic_power = 7
	skill_points = 20

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/engineer
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(
		SKILL_EVA          = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_BASIC,
		SKILL_ELECTRICAL   = SKILL_BASIC,
		SKILL_HAULING      = SKILL_BASIC,
		SKILL_ATMOS        = SKILL_BASIC,
		SKILL_SCIENCE      = SKILL_BASIC,
		SKILL_COMPUTER     = SKILL_BASIC,
		SKILL_ENGINES      = SKILL_BASIC,
		SKILL_MEDICAL      = SKILL_BASIC
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
		SKILL_SCIENCE      = SKILL_MAX,
		SKILL_COMBAT       = SKILL_EXPERIENCED,
		SKILL_WEAPONS      = SKILL_EXPERIENCED
	)
	// SIERRA TODO: required_role
	// required_role = list("Exploration Leader", "Expeditionary Pilot")
	access = list(
		access_explorer,
		access_eva,
		access_emergency_storage,
		access_field_eng,
		access_guppy_helm,
		access_expedition_shuttle,
		access_guppy,
		access_hangar,
		access_research
	)
	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/explorer_engineer/get_description_blurb()
	return "Вы - Исследователь. В ваши обязанности входит участие в миссиях на удаленные объекты, \
	организуемые Лидером Экспедиции или заменяющим его лицом. Вы ищите всё, что может предоставить НТ \
	экономическую или научную выгоду - залежи драгоценных металлов, новые формы жизни, инопланетные артефакты и \
	неизвестные технологии. Вы будете иметь дело с опасной атмосферой, агрессивной флорой и фауной, сбойными дронами \
	на заброшенных объектах, враждебно настроенными к вам роботами и аномалиями... Но не это ли то, за что Корпорация \
	вам так хорошо платит?"
