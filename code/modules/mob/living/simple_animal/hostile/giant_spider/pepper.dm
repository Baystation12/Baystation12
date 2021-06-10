// Pepper spiders inject condensed capsaicin into their victims.

/mob/living/simple_animal/hostile/giant_spider/pepper
	desc = "Red and brown, it makes you shudder to look at it. This one has glinting red eyes."

	icon_state = "pepper"
	icon_living = "pepper"
	icon_dead = "pepper_dead"

	maxHealth = 210
	health = 210

	poison_chance = 20
	poison_per_bite = 5
	poison_type = /datum/reagent/capsaicin/condensed

/mob/living/simple_animal/hostile/giant_spider/pepper/Initialize()
	// adjust_scale(1.1)
	return ..()
