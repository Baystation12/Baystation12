/atom/movable
	layer = OBJ_LAYER

	glide_size = 4

	animate_movement = SLIDE_STEPS

	/// Boolean. Whether or not the atom is affected by being submerged in water. If set to `FALSE`, `water_act()` is called when in contact with fluids.
	var/waterproof = TRUE
	/// Bitflag (Any of `MOVABLE_FLAG_*`). Bitflags for movable atoms. See `code\__defines\flags.dm`.
	var/movable_flags = EMPTY_BITFIELD

	/// Bitflag (Directionals). Direction of the last movement. Generally passed to `step()` as the `dir` parameter. Set during `Move()`.
	var/last_move = EMPTY_BITFIELD
	/// Boolean. Whether or not the atom is considered anchored.
	var/anchored = FALSE
	/// Integer. The atom's current movement speed, calculated as the difference between `world.time` and `l_move_time`. Set during `Move()`.
	var/move_speed = 10
	/// Integer. The `world.time` of the last movement. Set during `Move()`.
	var/l_move_time = 1
	/// Instance. Current thrown thing datum linked to this atom. Set during `throw_at()`.
	var/datum/thrownthing/throwing
	/// Integer. The speed at which the atom moves when thrown. Used when calling `throw_at()`, and in `momentum_power()` and `momentum_do()`.
	var/throw_speed = 2
	/// Integer. Maximum range, in tiles, this atom can be thrown.
	var/throw_range = 7
	/// Boolean. Whether or not this atom has recently (Within the past 50 ticks) been force moved by `/obj/item/device/radio/electropack/receive_signal()`.
	var/moved_recently = FALSE
	/// Instance. The mob currently pulling the atom.
	var/mob/pulledby = null
	/// String (Icon state). Used to specify the item state for the on-mob overlays. Primarily only used in `/obj/item/get_icon_state()`. Generally, you should only be updating this in `on_update_icon()`.
	var/item_state = null // TODO: Move this to `/obj/item`?
	/// Boolean. Does the atom spin when thrown (of course it does :P)
	var/does_spin = TRUE

	/// Integer. The icon width this movable expects to have by default.
	var/icon_width = 32

	/// Integer. The icon height this movable expects to have by default.
	var/icon_height = 32

	/// Integer (One of `EMISSIVE_BLOCK_*`). Whether this atom blocks emissive overlays, and what method is used for blocking. See `code\__defines\emissives.dm`.
	var/blocks_emissive = EMISSIVE_BLOCK_NONE
	/// Instance. Internal holder for emissive blocker object, DO NOT USE DIRECTLY. Use blocks_emissive
	var/mutable_appearance/em_block

	/// Bitflag (Directional). Direction the atom is currently travelling for space drift. Set by `space_drift()` and `Bump()`. Used by `momentum_do()` and the `spacedrift` subsystem.
	var/inertia_dir = EMPTY_BITFIELD
	/// Instance. The atoms `loc` value during the last space movement. Set by `space_drift()` and the `spacedrift` subsystem.
	var/atom/inertia_last_loc
	/// Boolean. Whether or not the atom is currently being moved by space drift inertia. Set by the `spacedrift` subsystem and checked during `Move()`.
	var/inertia_moving = FALSE
	/// Integer. `world.time` that the next space drift movement should occur. Set by `Move()` and the `spacedrift` subsystem. Used by the `spacedrift` subsystem.
	var/inertia_next_move = 0
	/// Integer. Number of ticks to add to the current `world.time` when updating `inertia_next_move`. Used by `Move()` and the `spacedrift` subsystem.
	var/inertia_move_delay = 5
	/// Instance. Atom that should be ignored by `/mob/get_spacemove_backup()`. Updated and used by various movement related procs.
	var/atom/movable/inertia_ignore


/**
 * Initializes space drifting for the atom and adds it to the `spacedrift` subsystem.
 *
 * **Parameters**:
 * - `direction` (Bitflag - Directional) - The direction to start drifting.
 *
 * Returns boolean. If `TRUE`, the atom is now drifting. If `FALSE`, the atom was blocked from drifting.
 */
/atom/movable/proc/space_drift(direction)//move this down
	if(!loc || direction & (UP|DOWN) || Process_Spacemove())
		inertia_dir = 0
		inertia_ignore = null
		return 0

	inertia_dir = direction
	if(!direction)
		return 1
	inertia_last_loc = loc
	SSspacedrift.processing[src] = src
	return 1

/**
 * Whether or not the atom is able to start drifting. Includes various relevant checks such as gravity, anchored, whether the atom's movement is already being controlled by something else, etc.
 *
 * **Parameters**:
 * - `allow_movement` (Boolean) - Whether or not this check should allow for manual mob movement.
 *
 * Returns boolean. Whether or not space drifting should be blocked/stopped.
 */
/atom/movable/proc/Process_Spacemove(allow_movement = FALSE)
	if(!simulated)
		return TRUE

	if(has_gravity())
		return TRUE

	if(pulledby)
		return TRUE

	if(throwing)
		return TRUE

	if(anchored)
		return TRUE

	if(!isturf(loc))
		return TRUE

	if(locate(/obj/structure/lattice) in range(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return TRUE

	return FALSE

/atom/movable/hitby(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	process_momentum(AM,TT)


/**
 *
 */
/atom/movable/proc/process_momentum(atom/movable/AM, datum/thrownthing/TT)//physic isn't an exact science
	. = momentum_power(AM,TT)

	if(.)
		momentum_do(.,TT,AM)


/**
 * Calculates the amount of momentum force this atom receives when impacted by another atom.
 *
 * Called by `process_momentum` as part of the `hitby` chain.
 *
 * **Parameters**:
 * - `AM` - The atom colliding with `src`.
 * - `TT` - The `/datum/thrownthing` instance handling `AM`.
 *
 * Returns float.
 */
/atom/movable/proc/momentum_power(atom/movable/AM, datum/thrownthing/TT)
	if(anchored)
		return 0

	. = (AM.get_mass()*TT.speed)/(get_mass()*min(AM.throw_speed,2))
	if(has_gravity())
		. *= 0.5


/**
 * Handled momentum logic when impacted by another atom. Typically this means sending this atom flying.
 *
 * Called by `process_momentum` as part of the `hitby` chain.
 *
 * **Parameters**:
 * - `power` (Positive float) - The amount of momentum force as calculated by `/atom/movable/proc/momentum_power()`.
 * - `TT` - The `/datum/thrownthing` instance handling the atom that hit `src`.
 *
 * Has no return value.
 */
/atom/movable/proc/momentum_do(power, datum/thrownthing/TT)
	var/direction = TT.init_dir
	switch(power)
		if(0.75 to INFINITY)		//blown backward, also calls being pinned to walls
			throw_at(get_edge_target_turf(src, direction), min((TT.maxrange - TT.dist_travelled) * power, 10), throw_speed * min(power, 1.5))

		if(0.5 to 0.75)	//knocks them back and changes their direction
			step(src, direction)

		if(0.25 to 0.5)	//glancing change in direction
			var/drift_dir
			if(direction & (NORTH|SOUTH))
				if(inertia_dir & (NORTH|SOUTH))
					drift_dir |= (direction & (NORTH|SOUTH)) & (inertia_dir & (NORTH|SOUTH))
				else
					drift_dir |= direction & (NORTH|SOUTH)
			else
				drift_dir |= inertia_dir & (NORTH|SOUTH)
			if(direction & (EAST|WEST))
				if(inertia_dir & (EAST|WEST))
					drift_dir |= (direction & (EAST|WEST)) & (inertia_dir & (EAST|WEST))
				else
					drift_dir |= direction & (EAST|WEST)
			else
				drift_dir |= inertia_dir & (EAST|WEST)
			space_drift(drift_dir)

/**
 * The effective mass of this atom.
 *
 * Called by `/atom/movable/proc/momentum_power()` as part of the `hitby()` chain.
 *
 * Returns positive float.
 */
/atom/movable/proc/get_mass()
	return 1.5


/atom/movable/Initialize()
	. = ..()
	update_emissive_blocker()
	if (em_block)
		AddOverlays(em_block)


/atom/movable/Destroy()
	if(!(atom_flags & ATOM_FLAG_INITIALIZED))
		crash_with("\A [src] was deleted before initalization")
	walk(src, 0)
	for(var/A in src)
		qdel(A)
	forceMove(null)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null
	if (LAZYLEN(movement_handlers) && !ispath(movement_handlers[1]))
		QDEL_NULL_LIST(movement_handlers)
	if (bound_overlay)
		QDEL_NULL(bound_overlay)
	if (virtual_mob && !ispath(virtual_mob))
		qdel(virtual_mob)
		virtual_mob = null
	if (em_block)
		QDEL_NULL(em_block)
	if (particles)
		particles = null
	return ..()


/// Called should be true when calling this in code.
/atom/movable/Bump(atom/A, called)
	if (!QDELETED(throwing))
		throwing.hit_atom(A)
	if (inertia_dir)
		inertia_dir = 0
	if (A && called)
		A.last_bumped = world.time
		invoke_async(A, TYPE_PROC_REF(/atom, Bumped), src) // Avoids bad actors sleeping or unexpected side effects, as the legacy behavior was to spawn here
	..()


/**
 * Attempts to move the atom to the destination's contents.
 *
 * Calls `Entered()` and `Exited()` on the destination and origin, respectively.
 *
 * Calls `Entered()` and `Exited()` on the destination and origin's areas, respectively, if the areas are different.
 *
 * Calls `Crossed()` and `Uncrossed()` on atoms that are in the destination and origin, respectively, if `destination` is a turf.
 *
 * **Paratemers**:
 * - `destination` - The atom to move `src` into.
 *
 * Returns boolean.
 */
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
		if (light_source_solo)
			light_source_solo.source_atom.update_light()
		else if (light_source_multi)
			var/datum/light_source/L
			var/thing
			for (thing in light_source_multi)
				L = thing
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
		if (light_source_solo)
			light_source_solo.source_atom.update_light()
		else if (light_source_multi)
			var/datum/light_source/L
			var/thing
			for (thing in light_source_multi)
				L = thing
				L.source_atom.update_light()

/**
 * Handles impacting an atom.
 *
 * Called by `/datum/thrownthing/proc/finalize()`.
 *
 * **Parameters**:
 * - `hit_atom` - The atom being impacted. `hitby()` is typically called on this by this proc.
 * - `TT` - The `/datum/thrownthing` instance calling this proc.
 *
 * Has no return value.
 */
/atom/movable/proc/throw_impact(atom/hit_atom, datum/thrownthing/TT)
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

/**
 * Throws the atom at a given target.
 *
 * Initializes a `/datum/thrownthing` handling this atom and adds it to `SSthrowing`.
 *
 * **Parameters**:
 * - `target` - The atom to throw this at.
 * - `range` (Positive integer) - How far this atom is allowed to go before stopping, in tiles.
 * - `speed` (Positive integer) - How fast the atom should move.
 * - `thrower` - The mob throwing this atom, if any.
 * - `spin` (Boolean, default `TRUE`) - If set, the atom spins while flying through the air.
 * - `callback` - A callback to be invoked once the atom has finished its flight. Not called if this proc returns `FALSE`.
 *
 * Returns boolean.
 */
/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
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


/**
 * Updates the atom's emissive blocker image and assigns it to `em_block`. If no image is generated, `em_block` is left as it was.
 *
 * What this does exactly depends on the value of `blocks_emissive`.
 *
 * Returns `/mutable_appearance`. The value of `em_block`.
 */
/atom/movable/proc/update_emissive_blocker()
	switch (blocks_emissive)
		if (EMISSIVE_BLOCK_GENERIC)
			em_block = fast_emissive_blocker(src)
		if (EMISSIVE_BLOCK_UNIQUE)
			if (!em_block && !QDELING(src))
				appearance_flags |= KEEP_TOGETHER
				render_target = ref(src)
				em_block = emissive_blocker(
					icon = icon,
					appearance_flags = appearance_flags,
					source = render_target
				)
	return em_block


/atom/movable/update_icon()
	..()
	if (em_block)
		CutOverlays(em_block)
	update_emissive_blocker()
	if (em_block)
		AddOverlays(em_block)


//Overlays
/atom/movable/fake_overlay
	var/atom/master = null
	var/follow_proc = TYPE_PROC_REF(/atom/movable, move_to_loc_or_null)
	anchored = TRUE
	simulated = FALSE

/atom/movable/fake_overlay/Initialize()
	if(!loc)
		crash_with("[type] created in nullspace.")
		return INITIALIZE_HINT_QDEL
	master = loc
	SetName(master.name)
	set_dir(master.dir)

	if(ismovable(master))
		GLOB.moved_event.register(master, src, follow_proc)
		SetInitLoc()

	GLOB.destroyed_event.register(master, src, TYPE_PROC_REF(/datum, qdel_self))
	GLOB.dir_set_event.register(master, src, PROC_REF(recursive_dir_set))

	. = ..()

/atom/movable/fake_overlay/proc/SetInitLoc()
	forceMove(master.loc)

/atom/movable/fake_overlay/Destroy()
	if(ismovable(master))
		GLOB.moved_event.unregister(master, src)
	GLOB.destroyed_event.unregister(master, src)
	GLOB.dir_set_event.unregister(master, src)
	master = null
	. = ..()

/atom/movable/fake_overlay/use_grab(obj/item/grab/grab, list/click_params)
	if (master)
		return master.use_grab(grab, click_params)
	return FALSE

/atom/movable/fake_overlay/use_weapon(obj/item/weapon, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	if (master)
		return master.use_weapon(weapon, user, click_params)
	return FALSE

/atom/movable/fake_overlay/use_tool(obj/item/tool, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	if (master)
		return master.use_tool(tool, user, click_params)
	return FALSE

/atom/movable/fake_overlay/use_tool(obj/item/tool, mob/user, list/click_params)
	if (master)
		return master.use_tool(tool, user)
	return ..()

/atom/movable/fake_overlay/attack_hand(mob/user)
	if (master)
		return master.attack_hand(user)

/**
 * Handler for when this atom touches the edge of a map or z-level.
 *
 * Generally, this handles transitioning to a new z-level if there's a valid connection.
 *
 * Has no return value.
 */
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

/**
 * Determines the type of bullet impact effect this atom should use when hit.
 *
 * **Parameters**:
 * - `def_zone` - The body zone the impact effect should be based on. Only used for `/mob` overrides.
 *
 * Returns string (One of `BULLET_IMPACT_*`).
 */
/atom/movable/proc/get_bullet_impact_effect_type(def_zone)
	return BULLET_IMPACT_NONE


/**
 * Whether or not user is capable of using this atom based on dexterity. Usually this equates to "Are you a human or silicon mob?"
 *
 * **Parameters**:
 * - `user` - The mob attempting to use the atom.
 *
 * Returns boolean.
 */
/atom/movable/proc/CheckDexterity(mob/living/user)
	return TRUE
