/mob/living/simple_animal/hostile/kamerr
	name = "Ka'merr"
	desc = {"\
		A tall, alien raptor-like creature. It has patches of feathers around \
		its neck, and is equipped with a thick plasteel collar. Its bony \
		limbs end in dangerous-looking claws.\
	"}
	icon = 'icons/mob/simple_animal/kamerr.dmi'
	icon_state = "kamerr"
	icon_living = "kamerr"
	icon_dead = "kamerrdead"
	maxHealth = 100
	health = 100
	ai_holder = /datum/ai_holder/simple_animal/melee
	natural_weapon = /obj/item/natural_weapon/claws/strong
	say_list_type = /datum/say_list/kamerr
	bleed_colour = "#1d2cbf"


/datum/say_list/kamerr
	emote_hear = list(
		"growls!",
		"screeches incoherently!"
	)
