/atom/movable
	layer = OBJ_LAYER

	appearance_flags = TILE_BOUND
	glide_size = 8

	var/waterproof = TRUE
	var/movable_flags

	var/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/datum/thrownthing/throwing
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
	var/item_state = null // Used to specify the item state for the on-mob overlays.
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)

/atom/movable/Destroy()
	. = ..()
	for(var/atom/movable/AM in src)
		qdel(AM)

	forceMove(null)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

	if(LAZYLEN(movement_handlers) && !ispath(movement_handlers[1]))
		QDEL_NULL_LIST(movement_handlers)

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	if(virtual_mob && !ispath(virtual_mob))
		qdel(virtual_mob)
		virtual_mob = null

/atom/movable/Bump(var/atom/A, yes)
	if(!QDELETED(throwing))
		throwing.hit_atom(A)

	if (A && yes)
		A.last_bumped = world.time
		INVOKE_ASYNC(A, /atom/proc/Bumped, src) // Avoids bad actors sleeping or unexpected side effects, as the legacy behavior was to spawn here
	..()

/atom/movable/proc/forceMove(atom/destination)
	if((gc_destroyed && gc_destroyed != GC_CURRENTLY_BEING_QDELETED) && !isnull(destination))
		CRASH("Attempted to forceMove a QDELETED [src] out of nullspace!!!")
	if(loc == destination)
		return 0
	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)
	return 1

/atom/movable/forceMove(atom/dest)
	var/old_loc = loc
	. = ..()
	if (.)
		// observ
		if(!loc)
			GLOB.moved_event.raise_event(src, old_loc, null)

		// freelook
		if(opacity)
			updateVisibility(src)

		// lighting
		if (light_sources)	// Yes, I know you can for-null safely, but this is slightly faster. Hell knows why.
			for (var/datum/light_source/L in light_sources)
				L.source_atom.update_light()

/atom/movable/Move(...)
	var/old_loc = loc
	. = ..()
	if (.)
		if(!loc)
			GLOB.moved_event.raise_event(src, old_loc, null)

		// freelook
		if(opacity)
			updateVisibility(src)

		// lighting
		if (light_sources)	// Yes, I know you can for-null safely, this is slightly faster. Hell knows why.
			for (var/datum/light_source/L in light_sources)
				L.source_atom.update_light()

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/datum/thrownthing/TT)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.hitby(src,TT)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,TT)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		T.hitby(src,TT)

/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback) //If this returns FALSE then callback will not be called.
	. = TRUE
	if (!target || speed <= 0 || QDELETED(src) || (target.z != src.z))
		return FALSE

	if (pulledby)
		pulledby.stop_pulling()

	var/datum/thrownthing/TT = new(src, target, range, speed, thrower, callback)
	throwing = TT

	pixel_z = 0
	if(spin && does_spin)
		SpinAnimation(4,1)

	SSthrowing.processing[src] = TT
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = TT

//Overlays
/atom/movable/overlay
	var/atom/master = null
	var/follow_proc = /atom/movable/proc/move_to_loc_or_null
	anchored = TRUE
	simulated = FALSE

/atom/movable/overlay/Initialize()
	if(!loc)
		crash_with("[type] created in nullspace.")
		return INITIALIZE_HINT_QDEL
	master = loc
	SetName(master.name)
	set_dir(master.dir)

	if(istype(master, /atom/movable))
		GLOB.moved_event.register(master, src, follow_proc)
		SetInitLoc()

	GLOB.destroyed_event.register(master, src, /datum/proc/qdel_self)
	GLOB.dir_set_event.register(master, src, /atom/proc/recursive_dir_set)

	. = ..()

/atom/movable/overlay/proc/SetInitLoc()
	forceMove(master.loc)

/atom/movable/overlay/Destroy()
	if(istype(master, /atom/movable))
		GLOB.moved_event.unregister(master, src)
	GLOB.destroyed_event.unregister(master, src)
	GLOB.dir_set_event.unregister(master, src)
	master = null
	. = ..()

/atom/movable/overlay/attackby(obj/item/I, mob/user)
	if (master)
		return master.attackby(I, user)

/atom/movable/overlay/attack_hand(mob/user)
	if (master)
		return master.attack_hand(user)

/atom/movable/proc/touch_map_edge()
	if(!simulated)
		return

	if(!z || (z in GLOB.using_map.sealed_levels))
		return

	if(!GLOB.universe.OnTouchMapEdge(src))
		return

	if(GLOB.using_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/new_x
	var/new_y
	var/new_z = GLOB.using_map.get_transit_zlevel(z)
	if(new_z)
		if(x <= TRANSITIONEDGE)
			new_x = world.maxx - TRANSITIONEDGE - 2
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			new_x = TRANSITIONEDGE + 1
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			new_y = world.maxy - TRANSITIONEDGE -2
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			new_y = TRANSITIONEDGE + 1
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		var/turf/T = locate(new_x, new_y, new_z)
		if(T)
			forceMove(T)

/atom/movable/proc/get_bullet_impact_effect_type()
	return BULLET_IMPACT_NONE