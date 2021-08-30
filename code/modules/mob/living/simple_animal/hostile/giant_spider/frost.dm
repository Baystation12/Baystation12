// Frost spiders inject cryotoxin, slowing people down (which is very bad if trying to run from spiders).

/mob/living/simple_animal/hostile/giant_spider/frost
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes."

	icon_state = "frost"
	icon_living = "frost"
	icon_dead = "frost_dead"

	maxHealth = 175
	health = 175

	poison_per_bite = 5
	poison_type = /datum/reagent/toxin/cryotoxin

	natural_weapon = /obj/item/natural_weapon/bite/spider/frost

/obj/item/natural_weapon/bite/spider/frost
	force = 15
