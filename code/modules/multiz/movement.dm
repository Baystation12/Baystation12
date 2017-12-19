/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		to_chat(src, "<span class='notice'>You move upwards.</span>")

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(zMove(DOWN))
		to_chat(src, "<span class='notice'>You move down.</span>")

/mob/proc/zMove(direction)
	if(eyeobj)
		return eyeobj.zMove(direction)
	if(!can_ztravel())
		to_chat(src, "<span class='warning'>You lack means of travel in that direction.</span>")
		return

	var/turf/start = loc
	if(!istype(start))
		to_chat(src, "<span class='notice'>You are unable to move from here.</span>")
		return 0

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(!destination)
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return 0

	if(!start.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>\The [start] is in the way.</span>")
		return 0
	if(!destination.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>You bump against \the [destination].</span>")
		return 0

	var/area/area = get_area(src)
	if(direction == UP && area.has_gravity() && !can_overcome_gravity())
		to_chat(src, "<span class='warning'>Gravity stops you from moving upward.</span>")
		return 0

	for(var/atom/A in destination)
		if(!A.CanPass(src, start, 1.5, 0))
			to_chat(src, "<span class='warning'>\The [A] blocks you.</span>")
			return 0
	Move(destination)
	return 1

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/carbon/human/can_overcome_gravity()
	//First do species check
	if(species && species.can_overcome_gravity(src))
		return 1
	else
		for(var/atom/a in src.loc)
			if(a.flags & OBJ_CLIMBABLE)
				return 1

		//Last check, list of items that could plausibly be used to climb but aren't climbable themselves
		var/list/objects_to_stand_on = list(
				/obj/item/weapon/stool,
				/obj/structure/bed,
			)
		for(var/type in objects_to_stand_on)
			if(locate(type) in src.loc)
				return 1
	return 0

/mob/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/observer/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/proc/can_ztravel()
	return 0

/mob/observer/can_ztravel()
	return 1

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return 0

	if(Allow_Spacemove())
		return 1

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return 1

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return 0

	if(Allow_Spacemove()) //Checks for active jetpack
		return 1

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return 1

//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall()
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN) || !below.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	var/area/area = get_area(src)
	if(!area.has_gravity())
		return

	if(throwing)
		return

	if(can_fall())
		handle_fall(below)

//For children to override
/atom/movable/proc/can_fall(var/anchor_bypass = FALSE)
	if(!simulated)
		return FALSE

	if(anchored && !anchor_bypass)
		return FALSE

	if(locate(/obj/structure/lattice, loc) || locate(/obj/structure/catwalk, loc))
		return FALSE

	// See if something prevents us from falling.
	var/turf/below = GetBelow(src)
	for(var/atom/A in below)
		if(!A.CanPass(src, src.loc))
			return FALSE

	return TRUE

/obj/can_fall()
	return ..(anchor_fall)

/obj/effect/can_fall()
	return FALSE

/obj/effect/decal/cleanable/can_fall()
	return TRUE

/obj/item/pipe/can_fall()
	var/turf/simulated/open/below = loc
	below = below.below

	. = ..()

	if(anchored)
		return FALSE

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up in below))
		return FALSE

/mob/living/carbon/human/can_fall()
	if(..())
		return species.can_fall(src)

/atom/movable/proc/handle_fall(var/turf/landing)
	Move(landing)
	if(locate(/obj/structure/stairs) in landing)
		return 1
	else
		handle_fall_effect(landing)

/atom/movable/proc/handle_fall_effect(var/turf/landing)
	if(istype(landing, /turf/simulated/open))
		visible_message("\The [src] falls from the deck above through \the [landing]!", "You hear a whoosh of displaced air.")
	else
		visible_message("\The [src] falls from the deck above and slams into \the [landing]!", "You hear something slam into the deck.")
		if(fall_damage())
			for(var/mob/living/M in landing.contents)
				visible_message("\The [src] hits \the [M.name]!")
				M.take_overall_damage(fall_damage())

/atom/movable/proc/fall_damage()
	return 0

/obj/fall_damage()
	if(w_class == ITEM_SIZE_TINY)
		return 0
	if(w_class == ITEM_SIZE_NO_CONTAINER)
		return 100
	return base_storage_cost(w_class)

/mob/living/carbon/human/handle_fall_effect(var/turf/landing)
	if(species && species.handle_fall_special(src, landing))
		return

	..()
	var/damage = 10
	apply_damage(rand(0, damage), BRUTE, BP_HEAD)
	apply_damage(rand(0, damage), BRUTE, BP_CHEST)
	apply_damage(rand(0, damage), BRUTE, BP_L_LEG)
	apply_damage(rand(0, damage), BRUTE, BP_R_LEG)
	apply_damage(rand(0, damage), BRUTE, BP_L_ARM)
	apply_damage(rand(0, damage), BRUTE, BP_R_ARM)
	weakened = max(weakened,2)
	updatehealth()