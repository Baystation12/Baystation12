/datum/job/exploration_leader
	title = "Exploration Leader"
	department = "Экспедиционный"
	department_flag = EXP

	total_positions = 1
	spawn_positions = 1
	supervisors = "Директору Исследований и Капитану"
	selection_color = "#68099e"
	minimal_player_age = 14
	economic_power = 9
	ideal_character_age = 35
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/el
	allowed_branches = list(/datum/mil_branch/employee)
	allowed_ranks = list(/datum/mil_rank/civ/nt)
	min_skill = list(	SKILL_BUREAUCRACY = SKILL_BASIC,
						SKILL_EVA         = SKILL_ADEPT,
						SKILL_SCIENCE     = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_BASIC,
						SKILL_MEDICAL     = SKILL_BASIC)

	max_skill = list(	SKILL_PILOT       = SKILL_MAX,
						SKILL_SCIENCE     = SKILL_MAX,
						SKILL_COMBAT      = SKILL_EXPERT,
						SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 22

	access = list(access_el, access_explorer, access_eva, access_bridge, access_heads, access_emergency_storage, access_tech_storage, access_guppy_helm, access_expedition_shuttle, access_expedition_shuttle_helm, access_guppy, access_hangar)



	software_on_spawn = list(/datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

	// TODO: SIERRA PORT need_exp_to_play = 2

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
	ideal_character_age = 20
	economic_power = 6
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/explorer
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)
	min_skill = list(	SKILL_EVA     = SKILL_BASIC,
						SKILL_SCIENCE = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC)


	max_skill = list(	SKILL_SCIENCE = SKILL_MAX,
						SKILL_COMBAT  = SKILL_EXPERT,
						SKILL_WEAPONS = SKILL_EXPERT)
	required_role = list("Exploration Leader", "Expeditionary Pilot")

	access = list(access_explorer, access_eva, access_emergency_storage, access_guppy_helm, access_expedition_shuttle, access_guppy, access_hangar)



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
	ideal_character_age = 24
	economic_power = 7
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/pilot
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)
	min_skill = list(	SKILL_EVA     = SKILL_BASIC,
						SKILL_SCIENCE = SKILL_BASIC,
						SKILL_PILOT   = SKILL_ADEPT,
						SKILL_MEDICAL = SKILL_BASIC)

	max_skill = list(	SKILL_SCIENCE = SKILL_MAX,
						SKILL_PILOT   = SKILL_MAX,
						SKILL_COMBAT  = SKILL_EXPERT,
						SKILL_WEAPONS = SKILL_EXPERT)

	access = list(	access_explorer, access_eva, access_emergency_storage, access_guppy_helm,
					access_expedition_shuttle, access_guppy, access_hangar, access_expedition_shuttle_helm)



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
	ideal_character_age = 34
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/medic
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	minimal_player_age = 8
	skill_points = 26
	economic_power = 8


	min_skill = list(	SKILL_EVA     = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC,
						SKILL_HAULING = SKILL_BASIC,
						SKILL_SCIENCE = SKILL_BASIC,
						SKILL_ANATOMY = SKILL_BASIC)

	max_skill = list(	SKILL_MEDICAL = SKILL_MAX,
						SKILL_SCIENCE = SKILL_MAX,
						SKILL_COMBAT  = SKILL_EXPERT,
						SKILL_WEAPONS = SKILL_EXPERT)
	required_role = list("Exploration Leader", "Expeditionary Pilot")

	access = list(	access_explorer, access_eva, access_emergency_storage, access_field_med,
					access_guppy_helm, access_expedition_shuttle, access_guppy, access_hangar)



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
	ideal_character_age = 28
	economic_power = 7
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/exploration/engineer
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	skill_points = 20

	min_skill = list(	SKILL_EVA          = SKILL_BASIC,
						SKILL_CONSTRUCTION = SKILL_BASIC,
						SKILL_ELECTRICAL   = SKILL_BASIC,
						SKILL_HAULING      = SKILL_BASIC,
						SKILL_ATMOS        = SKILL_BASIC,
						SKILL_SCIENCE      = SKILL_BASIC,
						SKILL_COMPUTER     = SKILL_BASIC,
						SKILL_ENGINES      = SKILL_BASIC,
						SKILL_MEDICAL      = SKILL_BASIC)

	max_skill = list(	SKILL_CONSTRUCTION = SKILL_MAX,
						SKILL_ELECTRICAL   = SKILL_MAX,
						SKILL_SCIENCE      = SKILL_MAX,
						SKILL_COMBAT       = SKILL_EXPERT,
						SKILL_WEAPONS      = SKILL_EXPERT)
	required_role = list("Exploration Leader", "Expeditionary Pilot")

	access = list(	access_explorer, access_eva, access_emergency_storage, access_field_eng,
	 				access_guppy_helm, access_expedition_shuttle, access_guppy, access_hangar)



	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/explorer_engineer/get_description_blurb()
	return "Вы - Исследователь. В ваши обязанности входит участие в миссиях на удаленные объекты, \
	организуемые Лидером Экспедиции или заменяющим его лицом. Вы ищите всё, что может предоставить НТ \
	экономическую или научную выгоду - залежи драгоценных металлов, новые формы жизни, инопланетные артефакты и \
	неизвестные технологии. Вы будете иметь дело с опасной атмосферой, агрессивной флорой и фауной, сбойными дронами \
	на заброшенных объектах, враждебно настроенными к вам роботами и аномалиями... Но не это ли то, за что Корпорация \
	вам так хорошо платит?"
