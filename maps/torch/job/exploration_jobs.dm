/datum/job/pathfinder
	title = "Pathfinder"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главному научному офицеру"
	selection_color = "#68099e"
	minimal_player_age = 1
	economic_power = 10
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/pathfinder
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_ADEPT,
	                    SKILL_SCIENCE     = SKILL_ADEPT,
	                    SKILL_PILOT       = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 22

	access = list(
		access_pathfinder, access_explorer, access_eva, access_maint_tunnels, access_bridge, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_expedition_shuttle_helm,
		access_guppy, access_hangar, access_petrov, access_petrov_helm, access_petrov_analysis, access_petrov_phoron,
		access_petrov_toxins, access_petrov_chemistry, access_petrov_maint, access_tox, access_tox_storage, access_research,
		access_xenobiology, access_xenoarch, access_torch_fax, access_radio_comm, access_radio_exp, access_radio_sci, access_research_storage,
		access_exploration_guard //Proxima EC rework addition
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/pathfinder/get_description_blurb()
	return "Вы - Первопроходец. Ваша обязанность - организовывать и вести экспедиции в удалённые места, выполняя Главную Миссию ЭК. \
	Вы командуете Исследователями и Морпехами. Присматривайте за тем, чтобы Ваши мужщины и женщины не потратили всю энергию шаттла на зарядку батарей. \
	Убедитесь, что экспедиция имеет припасы и необходимый персонал. Вы можете пилотировать Харон, в случае, если никто другой не может. \
	Как только Вы попали на исследовательскую миссию, Ваш долг - гарантировать, что любой предмет, представляющий научный интерес, будет принесёт обратно на судна и транспортирован к нужной научной лаборатории."

/datum/job/nt_pilot
	title = "Shuttle Pilot"
	supervisors = "Командующему и Исполнительному Офицеру, и Первопроходцу"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	selection_color = "#68099e"
	economic_power = 8
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/pilot
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/second = /decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot,
		/datum/mil_rank/civ/first = /decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7
	)

	access = list(
		access_mining_office, access_petrov, access_petrov_helm, access_petrov_maint, access_mining_station,
		access_expedition_shuttle, access_expedition_shuttle_helm, access_guppy, access_hangar, access_guppy_helm,
		access_mining, access_pilot, access_solgov_crew, access_eva, access_explorer, access_research,
		access_radio_exp, access_radio_sci, access_radio_sup, access_maint_tunnels, access_emergency_storage
	)
	min_skill = list(	SKILL_EVA   = SKILL_BASIC,
						SKILL_PILOT = SKILL_ADEPT,
						SKILL_MEDICAL = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

/datum/job/nt_pilot/get_description_blurb()
	return "Вы - пилот экспедиции. Ваша задача - обслуживать Харон и управлять им. Вы подчиняетесь Первопроходцу. Удостоверьтесь, что Харон имеет топливо в баках, а также энергию для полёта. \
	Не забывайте приглядывать за остальной командой."

/datum/job/explorer
	title = "Explorer"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 3
	spawn_positions = 3
	supervisors = "Командующему и Исполнительному Офицеру, и Первопроходцу"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/explorer
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)

	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC
					)

	max_skill = list(   SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/explorer/get_description_blurb()
	return "Вы - Исследователь. Ваша задача - участвовать в экспедициях в удалённые места. Первопроходец - лидер Вашей команды. \
	Вы должны искать все, что представляет экономический или научный интерес для ЦПСС - месторождения полезных ископаемых, инопланетную флору/фауну, артефакты. \
	Вы также, вероятно, столкнетесь с опасной средой, агрессивной дикой природой или неисправными системами защиты, поэтому действуйте осторожно."

/datum/job/expmed
	title = "Exploration Medic"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Командующему и Исполнительному Офицеру, и Первопроходцу"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 20)
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/expmed
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/exploration/expmed/army
		)

	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_ADEPT
					)
	max_skill = list(   SKILL_MEDICAL	  = SKILL_EXPERT,
						SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 22

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp, access_radio_med,
		access_medical
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							/datum/computer_file/program/deck_management)

/datum/job/expmed/get_description_blurb()
	return "Вы - Исследователь-медик. Ваша задача - участвовать в экспедициях в удалённые места. Первопроходец - лидер Вашей команды. \
	Ваша цель - лечение и спасение остальных участников экспедиции. Учтите, что вы не профессиональный хирург, поэтому не пытайтесь проводить операции на шаттле, у Вас нет квалификации для этого."

/datum/job/expeng
	title = "Exploration Engineer"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Командующему и Исполнительному Офицеру, и Первопроходцу"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 20)
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/expeng
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/exploration/expeng/army
		)

	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_CONSTRUCTION = SKILL_BASIC,
						SKILL_ELECTRICAL = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC
					)
	max_skill = list(   SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 22

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp, access_radio_eng
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/expeng/get_description_blurb()
	return "Вы - Исследователь-инженер. Ваша задача - участвовать в экспедициях в удалённые места. Первопроходец - лидер Вашей команды. \
	Ваша цель - поддерживать шаттл в рабочем состоянии и проделывать проходы везде, где скажет ваш босс."

/datum/job/expmar
	title = "Expedition Marine Guard"
	department = "Экспедиционный"
	department_flag = EXP
	total_positions = 2
	spawn_positions = 2
	supervisors = "Командующему и Исполнительному Офицеру, и Первопроходцу"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 21
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/expmar
	allowed_branches = list(
		/datum/mil_branch/army
		)

	allowed_ranks = list(
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC,
						SKILL_WEAPONS = SKILL_ADEPT
					)
	max_skill = list(   SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp,
		access_exploration_guard
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/expmar/get_description_blurb()
	return "Вы - охранник экспедиции. Ваша задача - участвовать в экспедициях в удалённые места и обеспечивать безопасность экспедиции. Первопроходец - лидер Вашей команды. \
	Слушайте его и повинуйтесь любой ценой. Постарайтесь не растратить весь запас батарей."
