/obj/structure/diona_gestalt/relaymove(var/mob/user, var/direction)
	if(nymphs[user]) step(src, direction) // ANARCHY! DEMOCRACY! ANARCHY! DEMOCRACY!

// Naaaa na na na na naa naa https://www.youtube.com/watch?v=iMH49ieL4es
/obj/structure/diona_gestalt/Bump(var/atom/movable/AM, var/yes) // what a useful argname, thanks oldcoders
	. = ..()
	if(AM && can_roll_up_atom(AM) && AM.Adjacent(src))
		var/turf/stepping = AM.loc
		roll_up_atom(AM)
		if(stepping)
			step_towards(src, stepping)

		
	else if(istype(AM, /obj/structure/diona_gestalt) && AM != src) // Combine!?
		var/obj/structure/diona_gestalt/gestalt = AM
		if(LAZYLEN(gestalt.nymphs))
			for(var/nimp in gestalt.nymphs)
				roll_up_atom(nimp, silent = TRUE)
			gestalt.nymphs.Cut()
		var/gestalt_loc = gestalt.loc
		qdel(gestalt)
		visible_message("<span class='notice'>The nascent gestalts combine together!</span>") // Combine!
		step_towards(src, gestalt_loc)

/obj/structure/diona_gestalt/Bumped(var/atom/A)
	. = ..()
	if(istype(A, /mob/living/carbon/alien/diona) && A.Adjacent(src)) // Combine...
		roll_up_atom(A)

/obj/structure/diona_gestalt/Move() 
	. = ..()
	if(.)
		for(var/atom/movable/AM in loc)
			if(can_roll_up_atom(AM))
				AM.forceMove(src)

/obj/structure/diona_gestalt/proc/can_roll_up_atom(var/atom/movable/thing)
	if(!istype(thing) || thing.anchored || !thing.simulated)
		return FALSE
	if(valid_things_to_roll_up[thing.type])
		return TRUE
	if(istype(thing, /obj))
		var/obj/rolling_up = thing
		return rolling_up.w_class <= get_max_item_rollup_size()
	if(istype(thing, /mob))
		var/mob/rolling_up = thing
		return rolling_up.mob_size <= get_max_mob_rollup_size()

/obj/structure/diona_gestalt/proc/get_max_item_rollup_size()
	if(nymphs.len > 9)
		return ITEM_SIZE_GARGANTUAN
	if(nymphs.len > 6)
		return ITEM_SIZE_HUGE
	if(nymphs.len > 4)
		return ITEM_SIZE_LARGE
	if(nymphs.len > 2)
		return ITEM_SIZE_NORMAL
	return ITEM_SIZE_SMALL

/obj/structure/diona_gestalt/proc/get_max_mob_rollup_size()
	if(nymphs.len >= 20)
		return MOB_MEDIUM
	return MOB_SMALL
