/datum/job/chief_steward
	title = "Chief Steward"
	department = "Обслуживания"
	department_flag = SRV

	total_positions = 1
	spawn_positions = 1
	minimum_character_age = list(SPECIES_HUMAN = 28)
	ideal_character_age = 35
	economic_power = 6
	minimal_player_age = 7
	supervisors = "Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/chief_steward
	allowed_branches = list(/datum/mil_branch/employee)
	allowed_ranks = list(/datum/mil_rank/civ/nt)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_COOKING = SKILL_TRAINED,
		SKILL_BOTANY = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

	access = list(
		access_chief_steward,
		access_emergency_storage,
		access_heads,
		access_janitor,
		access_kitchen,
		access_bar,
		access_actor,
		access_bridge,
		access_maint_tunnels,
		access_hydroponics,
		access_kitchen,
		access_commissary,
		access_RC_announce
	)

/datum/job/chief_steward/get_description_blurb()
	return "Главный Стюард - это шеф-повар, руководитель кафетерия, старший бармен, главный уборщик и сантехник в одном лице.\
	Ваша главная задача это следить за тем, что бы экипаж был сытым, судно было чистым, а члены экипажа были заняты своей работой.\
	Если ваши повар, бармен, официанты, уборщики, актеры не знают что делать - вы должны направить их на нужный путь.\
	Вы их начальник, любимая мама, нелюбимая мачеха и ненавесная теща в одном лице. ЗАСТАВЛЯЙТЕ ИХ РАБОТАТЬ.\
	Вы старший сотрудник, позволяющий Главе Персонала переключиться на более важные для корпорации дела. Делай все для этого необходимое."


/datum/job/chaplain
	title = "Chaplain"
	department = "Обслуживания"
	department_flag = SRV

	total_positions = 1
	spawn_positions = 1
	minimum_character_age = list(SPECIES_HUMAN = 28)
	ideal_character_age = 40
	economic_power = 4
	minimal_player_age = 0
	supervisors = "Главному Стюарду и Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/chaplain
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
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
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	alt_titles = list("Sanitation Technician")
	supervisors = "Главному Стюарду и Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/janitor
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
	min_skill = list(SKILL_HAULING = SKILL_BASIC)
	access = list(access_maint_tunnels, access_emergency_storage, access_janitor)

/datum/job/janitor/get_description_blurb()
	return "Уборщик отвечает за чистоту и порядок на корабле. В основном Ваша задача будет состоять в уборке различного вида мусора, такого как: различные пустые пачки от фастфуда, алюминиевые банки из-под газировки, осколки от стекла и т.п.\
	Также Вы должны заменять перегоревшие или разбитые лампочки."


/datum/job/cook
	title = "Cook"
	department = "Обслуживания"
	department_flag = SRV

	total_positions = 1
	spawn_positions = 1
	ideal_character_age = 24
	alt_titles = list("Culinary Specialist")
	supervisors = "Главному Стюарду и Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/cook
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
	min_skill = list(
		SKILL_COOKING = SKILL_TRAINED,
		SKILL_BOTANY = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	access = list(access_maint_tunnels, access_hydroponics, access_kitchen, access_commissary)

/datum/job/cook/get_description_blurb()
	return "Вы - повар, чья миссия на этом корабле - спасти экипаж от поедания невкусной и отвратительной, с кулинарной точки зрения, еды из автоматов.\
	Только ради Вашей великой цели корпорация закупила передовое кулинарное оборудование и большой запас продуктов, перевести который за одну смену сможете только Вы и никто больше!"


/datum/job/steward
	title = "Steward"
	department = "Обслуживания"
	department_flag = SRV

	total_positions = 2
	spawn_positions = 2
	ideal_character_age = 20
	alt_titles = list(
		"Bar-Steward",
		"Waiter",
		"Botanist"
	)
	supervisors = "Главному Стюарду и Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/cook
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)
	min_skill = list(
		SKILL_COOKING = SKILL_BASIC,
		SKILL_BOTANY = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	access = list(access_hydroponics, access_kitchen)

/datum/job/steward/get_description_blurb()
	return "Стюарды исполняют роль младшего повара, помощника бармена, а так же вы ответственны за состояние и чистоту кафетерия.\
	Вам поручено не только управлять кухней и кафе, но и сделать столовую приятным и гостеприимным местом, где можно поесть, выпить и пообщаться."


/datum/job/bartender
	title = "Bartender"
	total_positions = 1
	spawn_positions = 1
	department = "Обслуживания"
	department_flag = SRV
	ideal_character_age = 30
	alt_titles = list("Barista")
	supervisors = "Главному Стюарду и Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/bartender
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
	access = list(access_hydroponics, access_bar, access_commissary)
	min_skill = list(
		SKILL_COOKING = SKILL_BASIC,
		SKILL_BOTANY = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

/datum/job/bartender/get_description_blurb()
	return "Основная часть работы бармена состоит в том, чтобы принимать заказы на выпивку у посетителей бара и смешивать ингредиенты, чтобы сделать коктейли для экипажа."


/datum/job/actor
	title = "Actor"
	department = "Обслуживания"
	department_flag = SRV

	total_positions = 2
	spawn_positions = 2
	ideal_character_age = 24
	minimal_player_age = 15
	supervisors = "Главному Стюарду и Главе Персонала"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/service/actor
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)

	access = list(access_actor)

/datum/job/actor/get_description_blurb()
	return "Актёр развлекает экипаж и старается сделать его смену более разнообразной."
