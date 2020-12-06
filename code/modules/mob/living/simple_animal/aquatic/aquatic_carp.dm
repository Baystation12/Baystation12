/mob/living/simple_animal/hostile/retaliate/aquatic/carp
	name = "carp"
	desc = "A ferocious fish. May be too hardcore."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	faction = "fishes"
	meat_amount = 3

	maxHealth = 20
	health = 20
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish/carp

/mob/living/simple_animal/hostile/retaliate/aquatic/carp/New()
	..()
	default_pixel_x = rand(-8,8)
	default_pixel_y = rand(-8,8)
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y