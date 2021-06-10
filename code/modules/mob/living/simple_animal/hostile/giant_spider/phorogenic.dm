// Phorogenic spiders explode when they die.
// You really shouldn't melee them.

/mob/living/simple_animal/hostile/giant_spider/phorogenic
	desc = "Crystalline and purple, it makes you shudder to look at it. This one has haunting purple eyes."

	icon_state = "phoron"
	icon_living = "phoron"
	icon_dead = "phoron_dead"

	maxHealth = 225
	health = 225
	taser_kill = FALSE //You will need more than a peashooter to kill the juggernaut.

	natural_weapon = /obj/item/natural_weapon/bite/spider/phorogenic

	attack_armor_pen = 15

	movement_cooldown = 15

	poison_chance = 30
	poison_per_bite = 0.5
	poison_type = /datum/reagent/toxin/phoron

	// tame_items = list(
	// /obj/item/weapon/tank/phoron = 20,
	// /obj/item/stack/material/phoron = 30
	// )

	var/exploded = FALSE
	var/explosion_dev_range		= 1
	var/explosion_heavy_range	= 2
	var/explosion_light_range	= 4
	var/explosion_flash_range	= 6 // This doesn't do anything iirc.

	var/explosion_delay_lower	= 1 SECOND	// Lower bound for explosion delay.
	var/explosion_delay_upper	= 2 SECONDS	// Upper bound.

/mob/living/simple_animal/hostile/giant_spider/phorogenic/Initialize()
	adjust_scale(1.25)
	return ..()

/mob/living/simple_animal/hostile/giant_spider/phorogenic/death()
	visible_message(SPAN_DANGER("\The [src]'s body begins to rupture!"))
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	spawn(0)
		// Flash black and red as a warning.
		for(var/i = 1 to delay)
			if(i % 2 == 0)
				color = "#000000"
			else
				color = "#FF0000"
			sleep(1)

	spawn(delay)
		// The actual boom.
		if(src && !exploded)
			visible_message(SPAN_DANGER("\The [src]'s body detonates!"))
			exploded = TRUE
			explosion(src.loc, explosion_dev_range, explosion_heavy_range, explosion_light_range, explosion_flash_range)
	return ..()

/obj/item/natural_weapon/bite/spider/phorogenic
	force = 30
