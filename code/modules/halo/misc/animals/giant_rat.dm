/mob/living/simple_animal/hostile/giant_rat
	name = "giant rat"
	desc = "Living off refuse with no natural predators deep underground has let it grow huge."
	icon = 'code/modules/halo/misc/animals/giant_rat.dmi'
	icon_state = "idle"
	icon_living = "idle"
	icon_dead = "dead"
	meat_amount = 5
	speed = 4
	mob_size = MOB_LARGE
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	health = 100
	maxHealth = 100

	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 25

	break_stuff_probability = 5

	harvest_products = list(/obj/item/stack/material/animalhide/rat, /obj/item/stack/material/animalhide/rat)

/obj/item/stack/material/animalhide/rat
	name = "rat hide"
	desc = "The by-product of rat farming."
	singular_name = "rat hide piece"
	icon_state = "sheet-rat"
	icon = 'code/modules/halo/misc/animals/giant_rat.dmi'
