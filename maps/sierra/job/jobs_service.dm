/datum/job/chaplain
	title = "Chaplain"
	department = "Обслуживания"
	department_flag = SRV

	total_positions = 1
	spawn_positions = 1
	ideal_character_age = 40
	economic_power = 4
	minimal_player_age = 0
	supervisors = "Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/chaplain
	allowed_branches = list(/datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)
	min_skill = list(SKILL_BUREAUCRACY = SKILL_BASIC)

	access = list(access_chapel_office)

/datum/job/chaplain/get_description_blurb()
	return "Свещеник отвечает за все процедуры связанные с религиозными службами,а также проводением похоронных церемоний."

/datum/job/janitor
	title = "Janitor"
	department = "Обслуживания"
	department_flag = SRV

	total_positions = 2
	spawn_positions = 2
	supervisors = "Главе Персонала"
	ideal_character_age = 20
	alt_titles = list(
		"Sanitation Technician")
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/janitor
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)
	min_skill = list(	SKILL_HAULING = SKILL_BASIC)

	access = list(access_maint_tunnels, access_emergency_storage, access_janitor)


/datum/job/janitor/get_description_blurb()
	return "Уборщик отвечает за чистоту и порядок на корабле. В основном Ваша задача будет состоять в уборке различного вида мусора, такого как: различные пустые пачки от фастфуда, алюминиевые банки из-под газировки, осколки от стекла и т.п.\
	Также Вы должны заменять перегоревшие или разбитые лампочки."

/datum/job/chef
	title = "Chef"
	department = "Обслуживания"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главе Персонала"
	alt_titles = list(
		"Cook",
		"Culinary Specialist"
		)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/cook
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)
	min_skill = list(	SKILL_COOKING   = SKILL_ADEPT,
						SKILL_BOTANY    = SKILL_BASIC,
						SKILL_CHEMISTRY = SKILL_BASIC)

	access = list(access_maint_tunnels, access_hydroponics, access_kitchen, access_commissary)



/datum/job/chef/get_description_blurb()
	return "Вы - повар, чья миссия на этом корабле - спасти экипаж от поедания невкусной и отвратительной, с кулинарной точки зрения, еды из автоматов.\
	Только ради Вашей великой цели корпорация закупила передовое кулинарное оборудование и большой запас продуктов, перевести который за одну смену сможете только Вы и никто больше!"

/datum/job/bartender
	title = "Bartender"
	department = "Обслуживания"
	department_flag = SRV
	supervisors = "Главе Персонала"
	ideal_character_age = 30
	selection_color = "#515151"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/bartender
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)

	access = list(access_hydroponics, access_commissary)


	min_skill = list(	SKILL_COOKING   = SKILL_BASIC,
						SKILL_BOTANY    = SKILL_BASIC,
						SKILL_CHEMISTRY = SKILL_BASIC)

/datum/job/bartender/get_description_blurb()
	return "Основная часть работы бармена состоит в том, чтобы принимать заказы на выпивку у посетителей бара и смешивать ингредиенты, чтобы сделать коктейли для экипажа."

/datum/job/actor
	title = "Actor"
	total_positions = 2
	spawn_positions = 2
	department = "Обслуживания"
	department_flag = SRV
	supervisors = "Главе Персонала"
	ideal_character_age = 24
	selection_color = "#515151"
	minimal_player_age = 15
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/actor
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)

	access = list(access_actor)

/datum/job/actor/get_description_blurb()
	return "Актёр развлекает экипаж и старается сделать его смену более разнообразной."
