/mob/living/simple_animal/passive/tomato
	name = "tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"
	turns_per_move = 5
	maxHealth = 15
	health = 15
	response_help  = "prods"
	response_disarm = "pushes aside"
	response_harm   = "smacks"
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite
	pass_flags = PASS_FLAG_TABLE
	density = FALSE

	meat_type = /obj/item/reagent_containers/food/snacks/tomatomeat
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   null

	ai_holder = /datum/ai_holder/simple_animal/passive/tomato

/datum/ai_holder/simple_animal/passive/tomato
	speak_chance = 0
