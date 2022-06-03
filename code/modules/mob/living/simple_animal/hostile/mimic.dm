//
// Abstract Class
//

var/global/list/protected_objects = list(/obj/machinery,
										 /obj/structure/table,
										 /obj/structure/cable,
										 /obj/structure/window,
										 /obj/structure/wall_frame,
										 /obj/structure/grille,
										 /obj/structure/catwalk,
										 /obj/structure/ladder,
										 /obj/structure/stairs,
										 /obj/structure/sign,
										 /obj/structure/railing,
										 /obj/item/modular_computer,
										 /obj/item/projectile/animate)

/mob/living/simple_animal/hostile/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/closets/bases/crate.dmi'
	icon_state = "base"
	icon_living = "base"

	meat_type = /obj/item/reagent_containers/food/snacks/fish/unknown
	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"
	speed = 4
	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite

	min_gas = null
	max_gas = null
	minbodytemp = 0

	faction = "mimic"
	move_to_delay = 8

	var/weakref/copy_of
	var/weakref/creator // the creator
	var/destroy_objects = 0
	var/knockdown_people = 0
	pass_flags = PASS_FLAG_TABLE

/datum/ai_holder/simple_animal/melee/mimic

/datum/ai_holder/simple_animal/melee/mimic/find_target(list/possible_targets, has_targets_list)
	. = ..()

	if(.)
		var/mob/living/simple_animal/hostile/mimic/M = holder
		M.audible_emote("growls at [.]")

/datum/ai_holder/simple_animal/melee/mimic/list_targets()
	// Return a list of targets that isn't the creator
	. = ..()
	var/mob/living/simple_animal/hostile/mimic/M = holder
	if(M.creator)
		return . - M.creator.resolve()


/mob/living/simple_animal/hostile/mimic/New(newloc, var/obj/o, var/mob/living/creator)
	..()
	if(o)
		if(ispath(o))
			o = new o(newloc)
		CopyObject(o,creator)

/mob/living/simple_animal/hostile/mimic/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((istype(O, /obj/item) || istype(O, /obj/structure)) && !is_type_in_list(O, protected_objects))
		O.forceMove(src)
		copy_of = weakref(O)
		appearance = O
		icon_living = icon_state

		var/obj/item/W = get_natural_weapon()
		if(istype(O, /obj/structure))
			health = (anchored * 50) + 50
			destroy_objects = 1
			if(O.density && O.anchored)
				knockdown_people = 1
				W.force = 2 * initial(W.force)
		else if(istype(O, /obj/item))
			var/obj/item/I = O
			health = 15 * I.w_class
			W.force = 2 + initial(I.force)
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

		if(istype(C,/obj/item/storage))
			var/obj/item/storage/S = C
			for(var/atom/movable/M in src)
				if(S.can_be_inserted(M,null,1))
					S.handle_item_insertion(M)
				else
					M.forceMove(src.loc)

		for(var/atom/movable/M in src)
			M.dropInto(loc)
		qdel(src)

/datum/ai_holder/simple_animal/melee/mimic/destroy_surroundings(direction, violent)
	. = ..()
	var/mob/living/simple_animal/hostile/mimic/M = holder
	if(M.destroy_objects)
		..()

/datum/ai_holder/simple_animal/melee/mimic/engage_target()
	. = ..()
	var/mob/living/simple_animal/hostile/mimic/M = holder
	if(M.knockdown_people)
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
	var/awake = 0

/mob/living/simple_animal/hostile/mimic/sleeping/Initialize()
	. = ..()
	set_AI_busy(TRUE)

/datum/ai_holder/simple_animal/melee/mimic/sleeping/list_targets()
	. = ..()
	var/mob/living/simple_animal/hostile/mimic/sleeping/M = holder
	if(!M.awake)
		return null
	return ..()

/mob/living/simple_animal/hostile/mimic/sleeping/proc/trigger()
	if(!awake)
		src.visible_message("<b>\The [src]</b> starts to move!")
		set_AI_busy(FALSE)
		awake = 1

/mob/living/simple_animal/hostile/mimic/sleeping/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple_animal/hostile/mimic/sleeping/attack_hand()
	trigger()
	..()

/datum/ai_holder/simple_animal/melee/mimic/sleeping/destroy_surroundings(direction, violent)
	var/mob/living/simple_animal/hostile/mimic/sleeping/M = holder
	if(M.awake)
		..()