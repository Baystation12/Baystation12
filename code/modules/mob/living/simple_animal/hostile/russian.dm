/mob/living/simple_animal/hostile/russian
	name = "russian"
	desc = "For the Motherland!"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	can_escape = TRUE
	a_intent = I_HURT
	var/corpse = /obj/effect/landmark/corpse/russian
	var/dropped_weapon = /obj/item/material/knife/combat
	natural_weapon = /obj/item/material/knife/combat
	unsuitable_atmos_damage = 15
	faction = "russian"
	status_flags = CANPUSH

	ai_holder_type = /datum/ai_holder/simple_animal/humanoid

/mob/living/simple_animal/hostile/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"
	corpse = /obj/effect/landmark/corpse/russian/ranged
	dropped_weapon = /obj/item/gun/projectile/revolver
	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/gunshot/gunshot2.ogg'
	casingtype = /obj/item/ammo_casing/pistol/magnum


/mob/living/simple_animal/hostile/russian/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	if(dropped_weapon)
		new dropped_weapon (src.loc)
	qdel(src)
	return