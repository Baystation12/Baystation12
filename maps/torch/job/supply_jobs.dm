/datum/job/cargo_tech
	title = "Deck Technician"
	department = "Supply"
	selection_color = "#964B00"
	department_flag = SUP
	total_positions = 3
	spawn_positions = 3
	supervisors = "Офицеру обеспечения"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 24
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/supply/tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/supply/tech/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/supply/contractor,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/supply/tech/army
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_FINANCE     = SKILL_BASIC,
	                    SKILL_HAULING     = SKILL_BASIC,
	                    SKILL_MECH        =	SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)

	access = list(
		access_maint_tunnels, access_emergency_storage, access_cargo, access_guppy_helm,
		access_cargo_bot, access_mailsorting, access_solgov_crew, access_expedition_shuttle,
		access_guppy, access_hangar, access_commissary, access_radio_sup
	)

	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/cargo_tech/get_description_blurb()
	return "Вы - Палубный техник. Ваша задача - доставлять заказы в пункт назначения и разгружать дрон доставки.\
	Не забывайте сортировать мусор и зарабатывать кредиты снабжения для своего отдела."

/datum/job/mining
	title = "Prospector"
	department = "Supply"
	selection_color = "#964B00"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "Офицеру обеспечения"
	economic_power = 7
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 25
	alt_titles = list(
		"Drill Technician",
		"Shaft Miner",
		"Salvage Technician")
	min_skill = list(   SKILL_HAULING = SKILL_ADEPT,
	                    SKILL_EVA     = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)

	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/prospector
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/passenger/research/prospector/ec
		)
	allowed_ranks = list(
		/datum/mil_rank/civ/three ,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/ec/e3
	)

	access = list(
		access_mining, access_mining_office, access_mining_station,
		access_expedition_shuttle, access_guppy, access_hangar,
		access_guppy_helm, access_solgov_crew, access_eva,
		access_radio_exp, access_radio_sup
	)

/datum/job/mining/get_description_blurb()
	return "Вы - шахтёр. Ваша миссия - добывать ресурсы на астероидах и доставлять их на судно. \
	Вы подчиняетесь Начальнику палубы и Исполнительному офицеру (в случае, если Вы контрактник, то ещё и Корпоративному связному). \
	Не забывайте спрашивать у сотрудников отдела, какие ресурсы им нужны. "
