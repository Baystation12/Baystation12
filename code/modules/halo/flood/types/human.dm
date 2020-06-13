
/mob/living/simple_animal/hostile/flood/combat_form/human
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "marine_infested"
	icon_living = "marine_infested"
	icon_dead = "marine_dead"
	//
	move_to_delay = 6
	health = 100
	maxHealth = 100
	melee_damage_lower = 25
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/ODST
	name = "Flood infested ODST"
	icon = 'code/modules/halo/flood/flood_combat_odst.dmi'
	icon_state = "odst_infested"
	icon_living = "odst_infested"
	icon_dead = "odst_dead"
	//
	move_to_delay = 6
	health = 125 //Combat forms need to be hardier.
	maxHealth = 125
	resistance = 5
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/ODST/New()
	. = ..()
	var/gun_type_spawn = pick(ODST_FLOOD_GUN_LIST)
	pickup_gun(new gun_type_spawn (loc))

/mob/living/simple_animal/hostile/flood/combat_form/guard
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_depotguard.dmi'
	icon_state = "guard_infested"
	icon_living = "guard_infested"
	icon_dead = "guard_dead"
	inventory = list(/obj/item/ammo_magazine/m762_ap/MA37)
	move_to_delay = 6
	health = 100 //Combat forms need to be hardier.
	maxHealth = 100
	melee_damage_lower = 25
	melee_damage_upper = 30
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/oni
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_oni.dmi'
	icon_state = "oni_infested"
	icon_living = "oni_infested"
	icon_dead = "oni_dead"
	//
	move_to_delay = 6
	health = 100 //Combat forms need to be hardier.
	maxHealth = 100
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bashed"
