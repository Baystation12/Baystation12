// Frost spiders inject cryotoxin, slowing people down (which is very bad if trying to run from spiders).

/mob/living/simple_animal/hostile/giant_spider/frost
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes."

	icon_state = "frost"
	icon_living = "frost"
	icon_dead = "frost_dead"

	maxHealth = 175
	health = 175

	poison_per_bite = 5
	poison_type = /datum/reagent/cryoxadone
	// heat_resist = -0.50
	// cold_resist = 0.75

// Sif variant with a somewhat different desc.
