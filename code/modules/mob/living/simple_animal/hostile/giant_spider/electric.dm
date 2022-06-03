// Electric spiders fire taser-like beams at their enemies.

/mob/living/simple_animal/hostile/giant_spider/electric
	desc = "Spined and yellow, it makes you shudder to look at it. This one has flickering gold eyes."

	icon_state = "spark"
	icon_living = "spark"
	icon_dead = "spark_dead"

	maxHealth = 120
	health = 120


	base_attack_cooldown = 15
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/beam/stun/electric_spider

	poison_chance = 15
	poison_per_bite = 3
	poison_type = "stimm"

	shock_resist = 0.75

	ai_holder = /datum/ai_holder/simple_animal/ranged/electric_spider

/obj/item/projectile/beam/stun/electric_spider
	name = "stun beam"
	agony = 20

// The electric spider's AI.
/datum/ai_holder/simple_animal/ranged/electric_spider

/datum/ai_holder/simple_animal/ranged/electric_spider/max_range(atom/movable/AM)
	if (isliving(AM))
		var/mob/living/L = AM
		if (L.incapacitated(INCAPACITATION_DISABLED) || L.stat == UNCONSCIOUS) // If our target is stunned, go in for the kill.
			return TRUE
	return ..() // Do ranged if possible otherwise.
