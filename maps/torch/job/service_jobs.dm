/datum/job/chaplain
	title = "Chaplain"
	department = "Обслуживания"
	department_flag = SRV
	selection_color = "#964B00"
	total_positions = 1
	spawn_positions = 1
	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 40
	economic_power = 6
	minimal_player_age = 0
	supervisors = "Исполнительному офицеру"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/chaplain
	alt_titles = list(
		"Celebrant",
		"Priest",
		"Psionic Confessor"
	)  //PRX
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/chaplain/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/chaplain/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/service/chaplain/army
		)
	allowed_ranks = list(
		/datum/mil_rank/civ/three ,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/army/o1,
		/datum/mil_rank/army/o2,
		/datum/mil_rank/ec/o1)
	min_skill = list(SKILL_BUREAUCRACY = SKILL_BASIC)

	access = list(
		access_morgue, access_chapel_office,
		access_crematorium, access_solgov_crew,
		access_radio_serv
	)


/datum/job/chaplain/get_description_blurb()
	return "Вы - свещенник. Ваша работа - проповедовать религию на судне и организовывать похороны. Вы подчиняетесь Исполнительному офицеру. \
	Проводите церемонии, проповеди и всё связанное с религией. Несите слово Божье на судно."

/datum/job/chaplain/equip(var/mob/living/carbon/human/H)
	if(H.mind?.role_alt_title == "Psionic Confessor")
		psi_faculties = list("[PSI_COERCION]" = PSI_RANK_OPERANT)
	return ..()

/datum/job/janitor
	title = "Sanitation Technician"
	department = "Обслуживания"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	supervisors = "Исполнительному офицеру"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	selection_color = "#964B00"
	alt_titles = list(
		"Janitor")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/janitor
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/janitor/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/janitor/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/service/janitor/army
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt
	)
	min_skill = list(   SKILL_HAULING = SKILL_BASIC)

	access = list(
		access_maint_tunnels, access_emergency_storage,
		access_janitor, access_solgov_crew,
		access_radio_serv
	)

/datum/job/janitor/get_description_blurb()
	return "Вы - Уборщик. Ваша задача - поддерживать судно в частоте. Вы подчиняетесь Исполнительному офицеру. \
	Мойте полы, убирайте мусор и чистите туалеты. Превратите судно в рай для санитарного инспектора."

/datum/job/chef
	title = "Steward"
	department = "Обслуживания"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	minimum_character_age = list(SPECIES_HUMAN = 18)
	selection_color = "#964B00"
	supervisors = "Исполнительному офицеру"
	alt_titles = list(
		"Bartender",
		"Cook",
		"Culinary Specialist"
	)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/cook
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/cook/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/cook/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/service/cook/army
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5
	)
	min_skill = list(
		SKILL_BOTANY = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC,
		SKILL_COOKING = SKILL_ADEPT
	)
	access = list(
		access_commissary,
		access_hydroponics,
		access_kitchen,
		access_radio_serv,
		access_solgov_crew,
		access_o_mess
	)

/datum/job/chef/get_description_blurb()
	return "Вы - Стюард. Ваша работа - готовить различные напитки и блюда для членов экипажа и пассажиров. Вы подчиняетесь Исполнительному офицеру. \
	Готовьте блюда и смешивайте напитки."

/datum/job/crew
	title = "Crewman"
	department = "Обслуживания"
	department_flag = SRV
	total_positions = 5
	spawn_positions = 5
	supervisors = "Исполнительному офицеру и персоналу ЦПСС"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/crewman
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/crewman/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4
	)

	access = list(
		access_maint_tunnels, access_emergency_storage,
		access_solgov_crew, access_radio_serv
	)

/datum/job/crew/get_description_blurb()
	return "Вы - Матрос. Ваша работа - помогать остальному экипажу в их работе. Вы подчиняетесь Исполнительному офицеру."
