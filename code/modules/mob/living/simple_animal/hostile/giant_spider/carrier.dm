// Carriers are not too dangerous on their own, but they create more spiders when dying.

/mob/living/simple_animal/hostile/giant_spider/carrier
	desc = "Furry, beige, and red, it makes you shudder to look at it. This one has luminous green eyes."
	icon_state = "carrier"
	icon_living = "carrier"
	icon_dead = "carrier_dead"

	maxHealth = 100
	health = 100

	natural_weapon = /obj/item/natural_weapon/bite/spider/carrier

	poison_per_bite = 3
	poison_type = /datum/reagent/chloralhydrate

	movement_cooldown = 5

	var/spiderling_count = 0
	var/spiderling_type = /obj/effect/spider/spiderling
	var/swarmling_type = /mob/living/simple_animal/hostile/giant_spider/hunter
	var/swarmling_faction = "spiders"
	/// Odds that a spiderling will be a swarmling instead.
	var/swarmling_prob = 10

/mob/living/simple_animal/hostile/giant_spider/carrier/Initialize()
	spiderling_count = rand(4, 8)
	scale(1.2)
	return ..()

/mob/living/simple_animal/hostile/giant_spider/carrier/death()
	visible_message(SPAN_WARNING("\The [src]'s abdomen splits as it rolls over, spiderlings crawling from the wound."))
	addtimer(CALLBACK(src, .proc/spawn_swarmlings), 1 SECOND)
	return ..()

/mob/living/simple_animal/hostile/giant_spider/carrier/proc/spawn_swarmlings()
	var/list/new_spiders = list()
	for (var/i = 1 to spiderling_count)
		if (QDELETED(src))
			break
		if (prob(swarmling_prob))
			var/mob/living/simple_animal/hostile/giant_spider/swarmling = new swarmling_type(loc)
			var/swarm_health = round(swarmling.maxHealth * 0.4, 1)
			swarmling.name = "spiderling"
			swarmling.maxHealth = swarm_health
			swarmling.health = swarm_health
			swarmling.natural_weapon = /obj/item/natural_weapon/bite/spider/swarmling
			swarmling.faction = swarmling_faction
			swarmling.scale(0.75)
			new_spiders += swarmling
		else
			new spiderling_type(loc)


/mob/living/simple_animal/hostile/giant_spider/carrier/recursive
	desc = "Furry, beige, and red, it makes you shudder to look at it. This one has luminous green eyes. \
	You have a distinctly <span style='font-family: comic sans ms'>bad</span> feeling about this."

	swarmling_type = /mob/living/simple_animal/hostile/giant_spider/carrier/recursive


/obj/item/natural_weapon/bite/spider/carrier
	force = 15

/obj/item/natural_weapon/bite/spider/swarmling
	force = 2
