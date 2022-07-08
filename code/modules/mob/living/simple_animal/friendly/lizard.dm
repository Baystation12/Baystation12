/mob/living/simple_animal/passive/lizard
	name = "lizard"
	desc = "A cute tiny lizard."
	icon = 'icons/mob/simple_animal/critter.dmi'
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard-dead"
	speak_emote = list("hisses")
	health = 5
	maxHealth = 5
	natural_weapon = /obj/item/natural_weapon/bite/weak
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	holder_type = /obj/item/holder/small
	mob_size = MOB_MINISCULE
	possession_candidate = 1
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	density = FALSE

	meat_amount = 1
	bone_amount = 1
	skin_amount = 1
	skin_material = MATERIAL_SKIN_LIZARD
