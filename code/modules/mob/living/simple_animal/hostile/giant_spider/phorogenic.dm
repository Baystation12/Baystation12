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

	movement_cooldown = 10

	poison_chance = 30
	poison_per_bite = 0.5
	poison_type = /datum/reagent/toxin/phoron

	var/exploded = FALSE
	var/explosion_dev_range		= 1
	var/explosion_heavy_range	= 2
	var/explosion_light_range	= 4
	var/explosion_flash_range	= 6

	/// Lower bound for explosion delay.
	var/explosion_delay_lower	= 3 SECONDS
	/// Upper bound for explosion delay.
	var/explosion_delay_upper	= 5 SECONDS

/mob/living/simple_animal/hostile/giant_spider/phorogenic/Initialize()
	SetTransform(scale = 1.25)
	return ..()

/mob/living/simple_animal/hostile/giant_spider/phorogenic/death()
	visible_message(SPAN_DANGER("\The [src]'s body begins to rupture!"))
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	addtimer(CALLBACK(src, .proc/flash, delay), 0)

	return ..()

/mob/living/simple_animal/hostile/giant_spider/phorogenic/proc/flash(delay)
	// Flash black and red as a warning.
	for (var/i = 1 to delay)
		if (i % 2 == 0)
			color = "#000000"
		else
			color = "#ff0000"
		sleep(1)

	detonate()

/mob/living/simple_animal/hostile/giant_spider/phorogenic/proc/detonate()
	// The actual boom.
	if (src && !exploded)
		visible_message(SPAN_DANGER("\The [src]'s body detonates!"))
		exploded = TRUE
		explosion(loc, explosion_dev_range, explosion_heavy_range, explosion_light_range, explosion_flash_range)
		qdel(src)

/obj/item/natural_weapon/bite/spider/phorogenic
	force = 30
