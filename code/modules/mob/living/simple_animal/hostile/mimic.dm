//
// Abstract Class
//

var/global/list/protected_objects = list(/obj/structure/table, /obj/structure/cable, /obj/structure/window, /obj/structure/disposalpipe, /obj/item/projectile/animate)

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
	speed = 4
	maxHealth = 100
	health = 100

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
	move_to_delay = 8

	var/weakref/copy_of
	var/weakref/creator // the creator
	var/destroy_objects = 0
	var/knockdown_people = 0

/mob/living/simple_animal/hostile/mimic/New(newloc, var/obj/o, var/mob/living/creator)
	..()
	if(o)
		if(ispath(o))
			o = new o(newloc)
		CopyObject(o,creator)

/mob/living/simple_animal/hostile/mimic/FindTarget()
	. = ..()
	if(.)
		audible_emote("growls at [.]")

/mob/living/simple_animal/hostile/mimic/ListTargets()
	// Return a list of targets that isn't the creator
	. = ..()
	if(creator)
		return . - creator.resolve()

/mob/living/simple_animal/hostile/mimic/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((istype(O, /obj/item) || istype(O, /obj/structure)) && !is_type_in_list(O, protected_objects))
		O.forceMove(src)
		copy_of = weakref(O)
		appearance = O
		icon_living = icon_state

		if(istype(O, /obj/structure))
			health = (anchored * 50) + 50
			destroy_objects = 1
			if(O.density && O.anchored)
				knockdown_people = 1
				melee_damage_lower *= 2
				melee_damage_upper *= 2
		else if(istype(O, /obj/item))
			var/obj/item/I = O
			health = 15 * I.w_class
			melee_damage_lower = 2 + I.force
			melee_damage_upper = 2 + I.force
			move_to_delay = 2 * I.w_class

		maxHealth = health
		if(creator)
			src.creator = weakref(creator)
			faction = "\ref[creator]" // very unique
		return 1
	return

/mob/living/simple_animal/hostile/mimic/death()
	if(!copy_of)
		return
	var/atom/movable/C = copy_of.resolve()
	..(null, "dies!")
	if(C)
		C.forceMove(src.loc)

		if(istype(C,/obj/structure/closet))
			for(var/atom/movable/M in src)
				M.forceMove(C)

		if(istype(C,/obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = C
			for(var/atom/movable/M in src)
				if(S.can_be_inserted(M,null,1))
					S.handle_item_insertion(M)
				else
					M.forceMove(src.loc)

		for(var/atom/movable/M in src)
			M.forceMove(get_turf(src))
		qdel(src)


/mob/living/simple_animal/hostile/mimic/DestroySurroundings()
	if(destroy_objects)
		..()

/mob/living/simple_animal/hostile/mimic/AttackingTarget()
	. =..()
	if(knockdown_people)
		var/mob/living/L = .
		if(istype(L))
			if(prob(15))
				L.Weaken(1)
				L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/mimic/Destroy()
	copy_of = null
	creator = null
	..()

/mob/living/simple_animal/hostile/mimic/sleeping
	wander = 0
	stop_automated_movement = 1

	var/awake = 0

/mob/living/simple_animal/hostile/mimic/sleeping/ListTargets()
	if(!awake)
		return null
	return ..()

/mob/living/simple_animal/hostile/mimic/sleeping/proc/trigger()
	if(!awake)
		src.visible_message("<b>\The [src]</b> starts to move!")
		awake = 1

/mob/living/simple_animal/hostile/mimic/sleeping/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple_animal/hostile/mimic/sleeping/attack_hand()
	trigger()
	..()

/mob/living/simple_animal/hostile/mimic/sleeping/DestroySurroundings()
	if(awake)
		..()
