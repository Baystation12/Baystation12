
/mob/living/simple_animal/npc/kig_yar_weapons
	npc_job_title = "NPC Kig'Yar weapon trader"
	species_type = /datum/species/kig_yar
	jumpsuits = list(/obj/item/clothing/under/kigyar)
	hats = list(/obj/item/clothing/head/helmet/kigyar)
	hat_chance = 100
	accepted_currency = "gekz"
	wander = 0
	trade_categories_by_name =  list("weapon_cov")

/mob/living/simple_animal/npc/kig_yar_ore
	npc_job_title = "NPC Kig'Yar ore trader"
	species_type = /datum/species/kig_yar
	jumpsuits = list(/obj/item/clothing/under/kigyar/armless)
	accepted_currency = "gekz"
	wander = 0
	trade_categories_by_name =  list("ore")

/mob/living/simple_animal/npc/kig_yar_crops
	npc_job_title = "NPC Kig'Yar crops trader"
	species_type = /datum/species/kig_yar
	jumpsuits = list(/obj/item/clothing/under/kigyar/armless)
	accepted_currency = "gekz"
	wander = 0
	trade_categories_by_name =  list("crops")
