// Thermic spiders inject a special variant of thermite that burns someone from the inside.

/mob/living/simple_animal/hostile/giant_spider/thermic
	desc = "Mirage-cloaked and orange, it makes you shudder to look at it. This one has simmering orange eyes."

	icon_state = "pit"
	icon_living = "pit"
	icon_dead = "pit_dead"

	maxHealth = 115
	health = 115

	heat_resist = 0.75
	cold_resist = -0.50

	poison_chance = 30
	poison_per_bite = 2
	poison_type = /datum/reagent/toxin/pyrotoxin
