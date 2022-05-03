// Uncomment this define to check for possible lengthy processing of emp_act()s.
// If emp_act() takes more than defined deciseconds (1/10 seconds) an admin message and log is created.
// I do not recommend having this uncommented on main server, it probably causes a bit more lag, espicially with larger EMPs.

// #define EMPDEBUG 10

/**
 * Generates an EMP pulse on the turf of the provided origin point, for the given range as a radius value. Calls
 *   `emp_act()` on every atom within range.
 *
 * Parameters:
 * - `origin` - The atom to originate the EMP from. Will be converted to `get_turf()` if not already a turf.
 * - `heavy_range` - The radius in tiles to use `EMP_ACT_HEAVY` in the `emp_act()` call.
 * - `light_range` - The radius in tiles to use `EMP_ACT_LIGHT` in the `emp_act()` call. NOTE: This is the _total_ range of the EMP, not added to `heavy_range`. This should be equal to or greater than `heavy_range` to avoid weirdness.
 * - `log` - If `TRUE`, generates an admin log detailing the EMP's size and origin area.
 *
 * Returns `FALSE` if the emp failed to generate, `TRUE` otherwise.
 **/
/proc/empulse(atom/origin, heavy_range, light_range, log = FALSE)
	if (!origin)
		return FALSE
	var/turf/epicenter
	if (istype(origin, /turf))
		epicenter = origin
	else
		epicenter = get_turf(origin)
	if (!istype(epicenter))
		return FALSE

	if (log)
		log_and_message_admins(append_admin_tools("EMP with size ([heavy_range], [light_range]) in area [get_area(origin)]", location = epicenter))

	if (heavy_range > 1)
		new /obj/effect/overlay/self_deleting/emppulse(epicenter)

	if (heavy_range > light_range)
		light_range = heavy_range

	for (var/mob/M in range(heavy_range, epicenter))
		sound_to(M, 'sound/effects/EMPulse.ogg')

	for (var/atom/T in range(light_range, epicenter))
		#ifdef EMPDEBUG
		var/time = world.timeofday
		#endif
		var/distance = get_dist(epicenter, T)
		if (distance < 0)
			distance = 0
		if (distance < heavy_range)
			T.emp_act(EMP_ACT_HEAVY)
		else if (distance == heavy_range)
			if (prob(50))
				T.emp_act(EMP_ACT_HEAVY)
			else
				T.emp_act(EMP_ACT_LIGHT)
		else if (distance <= light_range)
			T.emp_act(EMP_ACT_LIGHT)
		#ifdef EMPDEBUG
		if ((world.timeofday - time) >= EMPDEBUG)
			log_and_message_admins("EMPDEBUG: [T.name] - [T.type] - took [world.timeofday - time]ds to process emp_act()!")
		#endif
	return TRUE
