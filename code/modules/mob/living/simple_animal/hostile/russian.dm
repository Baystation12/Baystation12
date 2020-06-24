/mob/living/simple_animal/hostile/russian
	name = "russian"
	desc = "For the Motherland!"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	can_escape = TRUE
	attacktext = "punched"
	a_intent = I_HURT
	var/corpse = /obj/effect/landmark/corpse/russian
	var/weapon1 = /obj/item/weapon/material/knife/combat
	unsuitable_atmos_damage = 15
	faction = "russian"
	status_flags = CANPUSH
	melee_damage_flags = DAM_SHARP|DAM_EDGE


/mob/living/simple_animal/hostile/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"
	corpse = /obj/effect/landmark/corpse/russian/ranged
	weapon1 = /obj/item/weapon/gun/projectile/revolver
	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/gunshot/gunshot2.ogg'
	casingtype = /obj/item/ammo_casing/pistol/magnum


/mob/living/simple_animal/hostile/russian/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	qdel(src)
	return
