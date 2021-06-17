/mob/living/simple_animal/hostile/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	maxHealth = 100
	health = 100
	can_escape = TRUE

	harm_intent_damage = 5

	natural_weapon = /obj/item/melee/energy/sword/pirate/activated
	unsuitable_atmos_damage = 15
	var/corpse = /obj/effect/landmark/corpse/pirate
	var/weapon1 = /obj/item/melee/energy/sword/pirate

	faction = "pirate"

	ai_holder_type = /datum/ai_holder/simple_animal/melee/pirate

/mob/living/simple_animal/hostile/pirate/ranged
	name = "Pirate Gunner"
	icon_state = "pirateranged"
	icon_living = "pirateranged"
	icon_dead = "piratemelee_dead"
	projectilesound = 'sound/weapons/laser.ogg'
	ranged = 1
	rapid = 1
	projectiletype = /obj/item/projectile/beam
	corpse = /obj/effect/landmark/corpse/pirate/ranged
	weapon1 = /obj/item/gun/energy/laser

	ai_holder_type = /datum/ai_holder/simple_animal/pirate/ranged

/mob/living/simple_animal/hostile/pirate/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	qdel(src)
	return

/datum/ai_holder/simple_animal/pirate/ranged
	pointblank = TRUE		// They get close? Just shoot 'em!
	firing_lanes = TRUE		// But not your buddies!
	// conserve_ammo = TRUE	// And don't go wasting bullets!

/datum/ai_holder/simple_animal/melee/pirate
	speak_chance = 0