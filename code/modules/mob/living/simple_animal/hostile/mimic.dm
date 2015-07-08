//
// Abstract Class
//

/mob/living/simple_animal/hostile/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_living = "crate"

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"
	move_delay = 4
	maxHealth = 250
	health = 250

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "attacked"
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "mimic"

/mob/living/simple_animal/hostile/mimic/death()
	..()
	qdel(src)

//
// Crate Mimic
//


// Aggro when you try to open them. Will also pickup loot when spawns and drop it when dies.
/mob/living/simple_animal/hostile/mimic/crate
	attacktext = "bitten"
	knockdown_chance = 15
	var/attempt_open = 0

// Pickup loot
/mob/living/simple_animal/hostile/mimic/crate/initialize()
	..()
	for(var/obj/item/I in loc)
		I.loc = src

/mob/living/simple_animal/hostile/mimic/crate/proc/trigger()
	if(!attempt_open)
		visible_message("<b>[src]</b> starts to move!")
		attempt_open = 1

/mob/living/simple_animal/hostile/mimic/crate/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple_animal/hostile/mimic/crate/death()

	var/obj/structure/closet/crate/C = new(get_turf(src))
	// Put loot in crate
	for(var/obj/O in src)
		O.loc = C
	..()

//
// Copy Mimic
//

var/global/list/protected_objects = list(/obj/structure/table, /obj/structure/cable, /obj/structure/window, /obj/item/projectile/animate)

/mob/living/simple_animal/hostile/mimic/copy

	health = 100
	maxHealth = 100
	knockdown_chance = 0
	var/mob/living/creator = null // the creator
	var/destroy_objects = 0

/mob/living/simple_animal/hostile/mimic/copy/New(loc, var/obj/copy, var/mob/living/creator)
	..(loc)
	CopyObject(copy, creator)

/mob/living/simple_animal/hostile/mimic/copy/death()

	for(var/atom/movable/M in src)
		M.loc = get_turf(src)
	..()

/*
TODO - AI
/mob/living/simple_animal/hostile/mimic/copy/ListTargets()
	// Return a list of targets that isn't the creator
	. = ..()
	return . - creator
*/

/mob/living/simple_animal/hostile/mimic/copy/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((istype(O, /obj/item) || istype(O, /obj/structure)) && !is_type_in_list(O, protected_objects))
		// TODO: appearance = O
		O.loc = src
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		icon_living = icon_state

		if(istype(O, /obj/structure))
			health = (anchored * 50) + 50
			// TODO - AI - destroy_objects = 1 -> destroy_probability > 0
			if(O.density && O.anchored)
				knockdown_chance = 15
				melee_damage_lower *= 2
				melee_damage_upper *= 2
		else if(istype(O, /obj/item))
			var/obj/item/I = O
			health = 15 * I.w_class
			melee_damage_lower = 2 + I.force
			melee_damage_upper = 2 + I.force
			move_delay = 2 * I.w_class

		maxHealth = health
		if(creator)
			src.creator = creator
			faction = "\ref[creator]" // very unique
		return 1
	return
