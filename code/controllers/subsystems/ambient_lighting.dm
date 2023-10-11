SUBSYSTEM_DEF(ambient_lighting) //A simple SS that handles updating ambient lights of away sites and such places
	name = "Ambient Lighting"
	wait = 1
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_AMBIENT_LIGHT
	runlevels = RUNLEVELS_PREGAME | RUNLEVELS_GAME

	/// List of turfs queued for ambient light evaluation
	var/list/queued = list()

	/// A bitmap of free ambience group indexes.
	var/ambient_group_free_bitmap = ~0
	/// map of ambiient groups
	var/list/ambient_groups[AMBIENT_GROUP_MAX_BITS]

/datum/ambient_group
	/// Index in SSambient_lighting map
	var/global_index
	var/list/member_turfs_by_z = list()
	/// Color data, do NOT modify manually
	var/apparent_r
	var/apparent_g
	var/apparent_b
	/// Prevent modification of member turfs or colour while an operation is taking place
	var/busy = FALSE

/datum/ambient_group/New(ncolor, nmultiplier, nindex)
	. = ..()
	set_color(ncolor, nmultiplier)
	global_index = nindex

/datum/ambient_group/Destroy()
	SSambient_lighting.ambient_groups[global_index] = null
	SSambient_lighting.ambient_group_free_bitmap |= FLAG(global_index)
	return ..()

/datum/ambient_group/proc/set_color(color, multiplier)
	var/list/new_parts = rgb2num(color)
	//Calculate delta from current to desired location
	var/dr = (new_parts[1] / 255) * multiplier - apparent_r
	var/dg = (new_parts[2] / 255) * multiplier - apparent_g
	var/db = (new_parts[3] / 255) * multiplier - apparent_b

	if (round(dr/4, LIGHTING_ROUND_VALUE) == 0 && round(dg/4, LIGHTING_ROUND_VALUE) == 0 && round(db/4, LIGHTING_ROUND_VALUE) == 0)
		// no-op
		return

	busy = TRUE

	// Doing it ordered by zlev should ensure that it looks vaguely coherent mid-update regardless of turf insertion order.
	for (var/zlev in 1 to length(member_turfs_by_z))
		for (var/turf/T as anything in member_turfs_by_z[zlev])
			T.add_ambient_light_raw(dr, dg, db)
			CHECK_TICK

	apparent_r += dr
	apparent_g += dg
	apparent_b += db

	busy = FALSE

/**
 * Adds group ambient light to a turf
 *
 * **Parameters**:
 * - `T` turf - Turf to modify
 *
 */
/datum/ambient_group/proc/set_ambient_light(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	T.add_ambient_light_raw(apparent_r, apparent_g, apparent_b)

/**
 * Removes group ambient light from turf
 *
 * **Parameters**:
 * - `T` turf - Turf to modify
 *
 */
/datum/ambient_group/proc/remove_ambient_light(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	T.add_ambient_light_raw(-apparent_r, -apparent_g, -apparent_b)

/**
 * Adds turf to ambient group, will set bitflags and set current ambient light
 *
 * **Parameters**:
 * - `T` turf - Turf to add and track
 *
 */
/datum/ambient_group/proc/add_turf(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	//Already existing
	if(T.ambient_bitflag & FLAG(global_index))
		return

	if (T.z > length(member_turfs_by_z))
		member_turfs_by_z.len = T.z

	LAZYADD(member_turfs_by_z[T.z], T)
	T.ambient_bitflag |= FLAG(global_index)
	set_ambient_light(T)

/**
 * Removes turf from ambient group if it is part of it. Removes group's ambient light and flag from turf
 *
 * **Parameters**:
 * - `T` turf - Turf to remove
 *
 */
/datum/ambient_group/proc/remove_turf(turf/T)
	set waitfor = FALSE

	UNTIL(!busy)
	if(!(T.ambient_bitflag & FLAG(global_index)))
		return

	if (T.z > length(member_turfs_by_z))
		CRASH("Attempt to remove member turf with Z greater than local max -- this turf is not a member")

	remove_ambient_light(T)
	T.ambient_bitflag &= ~FLAG(global_index)
	member_turfs_by_z[T.z] -= T

/**
 * Find a valid index in the ambient group map for a new group
 *
 * Returns index or -1 if no indices are left
 */
/datum/controller/subsystem/ambient_lighting/proc/allocate_index()
	if (ambient_group_free_bitmap == 0)
		return -1 //Out of indices, no ambient light for you

	// Find the first free index in the bitmap.
	var/index = 1
	while (!(ambient_group_free_bitmap & FLAG(index)) && index < AMBIENT_GROUP_MAX_BITS)
		index += 1

	ambient_group_free_bitmap &= ~FLAG(index)

	return index
/**
 * Adds the space ambient group if it doesn't currently exist
 *
 */
/datum/controller/subsystem/ambient_lighting/proc/add_space_ambient_group()
	var/index = allocate_index() //It will always be 1, but we want to make sure bitmap is in a valid state

	ASSERT(index == SPACE_AMBIENT_GROUP)

	ambient_groups[index] = new /datum/ambient_group(SSskybox.background_color, config.starlight, index )

/**
 * Removes turf from ambient group if it is part of it. Removes group's ambient light and flag from turf
 *
 * **Parameters**:
 * - `color` color - Initial color
 * - `multiplier` float - Initial multiplier of light strength
 *
 * Returns index or -1 if no indices are left
 */
/datum/controller/subsystem/ambient_lighting/proc/create_ambient_group(color, multiplier)

	if(ambient_groups[SPACE_AMBIENT_GROUP] == null) //Something (probably a planet) wants to add an ambient group, add space first
		add_space_ambient_group()

	// Find the first free index in the bitmap.
	var/index = allocate_index()

	if(index <= 0)
		return index

	ambient_groups[index] = new /datum/ambient_group(color, multiplier, index)

	return index

/**
 * Removes turf from all ambient groups it is part of (if any)
 *
 * **Parameters**:
 * - `target` turf - Turf to remove
 */
/datum/controller/subsystem/ambient_lighting/proc/clean_turf(turf/target)
	if(target.ambient_bitflag != 0)
		for(var/datum/ambient_group/A in ambient_groups)
			if(target.ambient_bitflag & FLAG(A.global_index))
				A.remove_turf(target)
			if(!target.ambient_bitflag)
				return //Return early if flag is already clear

/datum/controller/subsystem/ambient_lighting/Initialize(start_timeofday)
	//Create space ambient group if nothing created it until now.
	if(ambient_groups[SPACE_AMBIENT_GROUP] == null)
		add_space_ambient_group()

	fire(FALSE, TRUE)
	return ..()

/// Go over turfs in queue, add them to space or planet ambient groups if valid, else remove them from all ambient groups
/datum/controller/subsystem/ambient_lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queued
	var/starlight_enabled = config.starlight

	var/needs_ambience
	while (length(curr))
		var/turf/target = curr[length(curr)]
		LIST_DEC(curr)

		if(target && target.is_outside())
			needs_ambience = TURF_IS_DYNAMICALLY_LIT_UNSAFE(target)
			if (!needs_ambience)
				for (var/turf/T in RANGE_TURFS(target, 1))
					if(TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
						needs_ambience = TRUE
						break

			if (needs_ambience)
				var/obj/overmap/visitable/sector/exoplanet/E = map_sectors["[target.z]"]
				if (istype(E))
					if(E.ambient_group_index > 0)
						var/datum/ambient_group/A = ambient_groups[E.ambient_group_index]
						A.add_turf(target)
				else
					if (starlight_enabled) //Assume we can light up exterior with space light generally
						var/datum/ambient_group/A = ambient_groups[SPACE_AMBIENT_GROUP]
						A.add_turf(target)
		else if (TURF_IS_AMBIENT_LIT_UNSAFE(target))
			//Remove from all groups
			if(target.ambient_bitflag != 0)
				for(var/datum/ambient_group/A in ambient_groups)
					A.remove_turf(target)
					if(!target.ambient_bitflag)
						break

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return
