/mob/living/simple_animal/hostile/retaliate/aquatic/carp
	name = "carp"
	desc = "A ferocious fish. May be too hardcore."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	faction = "fishes"
	maxHealth = 20
	health = 20
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	melee_damage_flags = DAM_SHARP

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish/carp
	meat_amount = 3
	bone_amount = 5
	skin_amount = 5
	bone_material = MATERIAL_BONE_FISH
	skin_material = MATERIAL_SKIN_FISH

/mob/living/simple_animal/hostile/retaliate/aquatic/carp/New()
	..()
	default_pixel_x = rand(-8,8)
	default_pixel_y = rand(-8,8)
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y