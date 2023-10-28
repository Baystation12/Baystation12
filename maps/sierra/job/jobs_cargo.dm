/datum/job/qm
	title = "Quartermaster"
	department = "Снабжения"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главе Персонала"
	economic_power = 8
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 23)
	ideal_character_age = 25
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/supply/quartermaster
	allowed_branches = list(/datum/mil_branch/employee)
	allowed_ranks = list(/datum/mil_rank/civ/nt)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_FINANCE     = SKILL_BASIC,
		SKILL_HAULING     = SKILL_BASIC,
		SKILL_EVA         = SKILL_BASIC
	)

	skill_points = 14

	access = list(		access_maint_tunnels, access_emergency_storage, access_tech_storage,  access_cargo, access_guppy_helm,
						access_cargo_bot, access_qm, access_mailsorting, access_expedition_shuttle, access_guppy, access_hangar,
						access_mining, access_mining_office, access_mining_station, access_commissary, access_external_airlocks)



	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)
	// SIERRA TODO: need_exp_to_play
	// need_exp_to_play = 2

/datum/job/qm/get_description_blurb()
	return " Квартирмейстр, так же известен как КМ, отвечает за работу отдела снабжения (который по другому называют Карго).\
	Он следит за правильным оформлением бланков заказов и за тем, чтобы карготехник своевременно принимал и отправлял заказы."

/datum/job/cargo_tech
	title = "Cargo Technician"
	department = "Снабжения"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "Квартирмейстеру и Главе Персонала"
	minimum_character_age = list(SPECIES_HUMAN = 22)
	ideal_character_age = 24
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/supply/tech
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_FINANCE     = SKILL_BASIC,
		SKILL_HAULING     = SKILL_BASIC
	)

	access = list(access_maint_tunnels, access_emergency_storage, access_cargo, access_guppy_helm, access_commissary,
						access_cargo_bot, access_mining_office, access_mailsorting, access_expedition_shuttle, access_guppy, access_hangar)



	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/cargo_tech/get_description_blurb()
	return "Спустя долгого перетаскивания тяжёлых грузов из точки А в точку В Вы превратились из Ассистента Карго в настоящего Карготехника.\
	Поздравляем Вас с повышением, а если Вы его каким-то образом получили незаслуженно - бегите перечитывать специальное руководство,\
	чтобы хоть как-то выглядеть в глазах Вашего начальника в лице Главы Персонала и старшего сотрудника Вашего департамента в виде Квартирмейстера обнадёживающе.\
	Следите за складом, делайте заказы в центр поставок, жалуйтесь на прорванные трубы, сортируйте мусор, жмите на рычаг, Кронк, и снова жалуйтесь, но уже на нехватку кредитов на балансе отдела."

/datum/job/mining
	title = "Prospector"
	department = "Снабжения"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "Квартирмейстеру и Главе Персонала"
	selection_color = "#515151"
	economic_power = 7
	minimum_character_age = list(SPECIES_HUMAN = 22)
	ideal_character_age = 24
	alt_titles = list(
		"Drill Technician",
		"Shaft Miner",
		"Salvage Technician")
	min_skill = list(
		SKILL_MECH    = SKILL_BASIC,
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_EVA     = SKILL_BASIC
	)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/supply/prospector
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	access = list(access_mining, access_mining_office, access_mining_station,
						access_expedition_shuttle, access_guppy, access_hangar, access_guppy_helm)



/datum/job/mining/get_description_blurb()
	return "Шахтер - это специализированная спасательная, добывающая, археологическая и поисковая рабочая лошадка.\
	Он присоединяется к экспедиционным миссиям для поиска и добычи ценных минералов, образцов и артефактов для нужд экипажа корабля."

/datum/job/cargo_assistant
	title = "Cargo Assistant"
	department = "Снабжения"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "Квартирмейстеру и Главе Персонала"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	selection_color = "#515151"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/supply/assistant
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_FINANCE     = SKILL_BASIC,
		SKILL_HAULING     = SKILL_BASIC
	)

	access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mining_office, access_mailsorting, access_hangar, access_guppy, access_guppy_helm, access_commissary)



	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/cargo_tech/get_description_blurb()
	return "Папа, мама, бабушка, дедушка, второй папа, всегда говорили Вам, что без хорошего образования Вы будете грузчиком. Однако они не ожидали, что Вы станете космическим грузчиком.\
	Поздравляем, Вы стали ассистентом департамента снабжения. Бегайте по мелким поручениям Вашего начальника - Главы Персонала и старшего сотрудника склада - Квартирмейстер.\
	Учитесь максимально быстро перетаскивать грузы с одного конца судна на другой, слушайтесь старших по должности ребят, в чьих интересах не дать заказать Вам оружие для раздачи его всем желающим."
