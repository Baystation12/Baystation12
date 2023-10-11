/atom/proc/is_flooded(lying_mob, absolute)
	return

/**
 * Called when fluids affect the atom.
 *
 * **Parameters**:
 * - `depth` integer - The depth of the fluid effect calling this proc.
 */
/atom/proc/water_act(depth)
	clean_blood()

/**
 * Retrieves the atom's fluid effect, if present. Generally, this only returns a value for turfs, and for said turfs,
 * the fluid effect present in the turf's contents.
 *
 * Returns instance of `/obj/fluid`.
 */
/atom/proc/return_fluid()
	return null

/**
 * Determines whether the atom's current fluid depth meets the provided value or not. Generally used by turfs.
 *
 * See `/atom/proc/get_fluid_fepth()`.
 *
 * **Parameters**:
 * - `min` (integer) - The minimum fluid depth value to meet or exceed.
 *
 * Returns boolean.
 */
/atom/proc/check_fluid_depth(min)
	return 0

/**
 * Determines the atom's current fluid depth. Currently only used by turfs.
 *
 * Returns integer.
 */
/atom/proc/get_fluid_depth()
	return 0

/**
 * Whether or not fluids can pass through this atom.
 *
 * **Parameters**:
 * - `coming_from` (Bitflag/direction) - The direction the fluid is attempting to pass from.
 *
 * Returns boolean.
 */
/atom/proc/CanFluidPass(coming_from)
	return TRUE

/atom/movable/proc/is_fluid_pushable(amt)
	return simulated && !anchored

/atom/movable/is_flooded(lying_mob, absolute)
	var/turf/T = get_turf(src)
	return T.is_flooded(lying_mob)

/**
 * Whether or not the atom is considered submerged in fluid.
 *
 * **Parameters**:
 * - `depth` integer - The depth level used for the check. If not set, fetches the turf's `get_fluid_depth()`.
 *
 * Returns boolean.
 */
/atom/proc/submerged(depth)
	if(isnull(depth))
		var/turf/T = get_turf(src)
		if(!istype(T))
			return FALSE
		depth = T.get_fluid_depth()
	if(istype(loc, /mob))
		return depth >= FLUID_SHALLOW
	if(istype(loc, /turf))
		return depth >= 3
	return depth >= FLUID_OVER_MOB_HEAD

/turf/submerged(depth)
	if(isnull(depth))
		depth = get_fluid_depth()
	return depth >= FLUID_OVER_MOB_HEAD

/**
 * Handler for fluid updates. Mirrors to the atom's turf.
 */
/atom/proc/fluid_update()
	var/turf/T = get_turf(src)
	if(istype(T))
		T.fluid_update()
