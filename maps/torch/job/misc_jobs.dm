/********
Synthetic
********/

/datum/job/cyborg
	total_positions = 3
	spawn_positions = 3
	supervisors = "вашим законам"
	minimal_player_age = 3
	allowed_ranks = list(
		/datum/mil_rank/civ/synthetic
	)

/datum/job/cyborg/get_description_blurb()
	return "Вы - киборг. Вы можете иметь личность, либо быть просто продвинутым набором программ - это определяет из чего сделанно устройство - Киборги сделаны из мозга человека, Роботы - позитронного (искусственного) мозга, Дроны - простой печатной платы, не способной к владению личности. \
	У Вас есть доступ к системам вокруг Вас, и конечности, чтобы передвигаться по объекту. \
	Не забывайте: Вы обязаны следовать своим законам, и только после этого приказам мастер-ИИ, к которому Вы привязаны. \
	Не наоборот. И только законам, если Вы не привязаны к ИИ. Чините поломки, спасайте людей и не открывайте двери куда не нужно - это вредит экипажу."

/datum/job/ai
	minimal_player_age = 7
	supervisors = "вашим законам"
	allowed_ranks = list(
		/datum/mil_rank/civ/synthetic
	)

/datum/job/ai/get_description_blurb()
	return "Вы - Искусственный Интелект. Ваша обязанность - подчинятся установленным законам и помогать экипажу судна в их работе. \
	У Вас есть полный доступ ко всем системам объекта. Вы не можете нарушить свои законы ни при каких обстоятельствах. \
	Вы можете быть как бездушной машиной, следующей приказам людей, либо-же высокоразвитым Искусственным Интеллектом со своей личностью, желанием и целями. Решать Вам. "

/*******
Civilian
*******/

/datum/job/assistant
	title = "Passenger"
	department = "Гражданский"
	total_positions = 12
	spawn_positions = 12
	supervisors = "Исполнительному офицеру"
	economic_power = 6
	announced = FALSE
	alt_titles = list(
		"Journalist" = /decl/hierarchy/outfit/job/torch/passenger/passenger/journalist,
		"Historian",
		"Botanist",
		"Investor" = /decl/hierarchy/outfit/job/torch/passenger/passenger/investor,
		"Psychologist" = /decl/hierarchy/outfit/job/torch/passenger/passenger/psychologist,
		"Naturalist",
		"Ecologist",
		"Entertainer",
		"Independent Observer",
		"Sociologist",
		"Trainer")
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/passenger
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first
	)
	min_goals = 2
	max_goals = 7

/datum/job/assistant/get_description_blurb()
	return "Вы - пассажир. Вы находитесь на Государственном Экспедиционном Корабле \"Факел\", который принадлежит Экспедиционному корпусу - научному агенству ЦПСС. \
	Хоть корабль и не является флагманом в своём проекте, он заслужил репутацию надёжного судна. Вы подчиняетесь Исполнительному офицеру. \
	Вы могли просто купить билет на него, либо Вы являетесь журналистом, который освещает один из его полётов. Ваша история может быть разной."

/datum/job/merchant
	title = "Merchant"
	department = "Гражданский"
	department_flag = CIV
	total_positions = 2
	spawn_positions = 2
	availablity_chance = 30
	supervisors = "невидимой руке рынка"
	ideal_character_age = 30
	minimal_player_age = 0
	create_record = 0
	outfit_type = /decl/hierarchy/outfit/job/torch/merchant
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/alien
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/alien
	)
	latejoin_at_spawnpoints = 1
	access = list(access_merchant)
	announced = FALSE
	min_skill = list(   SKILL_FINANCE = SKILL_ADEPT,
	                    SKILL_PILOT	  = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)
	skill_points = 24
	required_language = null
	give_psionic_implant_on_join = FALSE
