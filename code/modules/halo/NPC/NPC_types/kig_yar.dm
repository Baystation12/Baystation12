
/mob/living/simple_animal/npc/kig_yar
	icon_state = "Kig-Yar_m"
	species_type = /datum/species/kig_yar
	npc_job_title = "NPC Kig-Yar"
	jumpsuits = list(/obj/item/clothing/under/kigyar/armless)
	accepted_currency = "gekz"
	emote_hear = list("hisses softly","blinks and narrows their eyes","suns themself")
	emote_see = list("shifts from side to side","scratches their arm","examines their nails","stares at at the ground aimlessly","looks bored")
	speak = list("I know place you get good weapons. Yes. Cheap.",\
		"You want fuel? Hah! Like you afford ship.",\
		"Many high value ore in system. I show you, guard you from pirate, yes?",\
		"Hairy ape, hairless ape. All same to Kig'Yar.",\
		"My sister is good fighter. She fetch high price for short time.")
	speak_chance = 5

/mob/living/simple_animal/npc/kig_yar/weapons
	npc_job_title = "NPC Kig'Yar weapon trader"
	jumpsuits = list(/obj/item/clothing/under/kigyar)
	hats = list(/obj/item/clothing/head/helmet/kigyar)
	hat_chance = 100
	wander = 0
	trade_categories_by_name =  list("weapon_cov")
	interact_screen = 2

/mob/living/simple_animal/npc/kig_yar/ore
	npc_job_title = "NPC Kig'Yar ore trader"
	wander = 0
	trade_categories_by_name =  list("ore")
	interact_screen = 2

/mob/living/simple_animal/npc/kig_yar/crops
	npc_job_title = "NPC Kig'Yar crops trader"
	wander = 0
	trade_categories_by_name =  list("crops")
	interact_screen = 2
