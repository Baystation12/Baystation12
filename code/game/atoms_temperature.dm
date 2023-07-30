#define MIN_TEMPERATURE_COEFFICIENT 1
#define MAX_TEMPERATURE_COEFFICIENT 10

/// Float. The atom's current temperature.
/atom/var/temperature = T20C
/// Float. Multiplier used to determine how much temperature can change/transfer to this atom when a temperature change proc is called. See `ProcessAtomTemperature()` and `/obj/proc/HandleObjectHeating()`. Should be a value between `MIN_TEMPERATURE_COEFFICIENT` and `MAX_TEMPERATURE_COEFFICIENT`.
/atom/var/temperature_coefficient = MAX_TEMPERATURE_COEFFICIENT

/atom/movable/Entered(atom/movable/atom, atom/old_loc)
	. = ..()
	QUEUE_TEMPERATURE_ATOMS(atom)

/obj/temperature_coefficient = null

/mob/temperature_coefficient = null

/turf/temperature_coefficient = MIN_TEMPERATURE_COEFFICIENT

/obj/Initialize()
	. = ..()
	temperature_coefficient = isnull(temperature_coefficient) ? clamp(MAX_TEMPERATURE_COEFFICIENT - w_class, MIN_TEMPERATURE_COEFFICIENT, MAX_TEMPERATURE_COEFFICIENT) : temperature_coefficient

/obj/proc/HandleObjectHeating(obj/item/heated_by, mob/user, adjust_temp)
	if (ATOM_IS_TEMPERATURE_SENSITIVE(src))
		visible_message(SPAN_NOTICE("\The [user] carefully heats \the [src] with \the [heated_by]."))
		var/diff_temp = (adjust_temp - temperature)
		if (diff_temp >= 0)
			var/altered_temp = max(temperature + (ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT * temperature_coefficient * diff_temp), 0)
			ADJUST_ATOM_TEMPERATURE(src, min(adjust_temp, altered_temp))

/mob/Initialize()
	. = ..()
	temperature_coefficient = isnull(temperature_coefficient) ? clamp(MAX_TEMPERATURE_COEFFICIENT - floor(mob_size/4), MIN_TEMPERATURE_COEFFICIENT, MAX_TEMPERATURE_COEFFICIENT) : temperature_coefficient

/**
 * Temperature subsystem process.
 *
 * Returns void or `PROCESS_KILL`.
 */
/atom/proc/ProcessAtomTemperature()

	// Get our location temperature if possible.
	// Nullspace is room temperature, clearly.
	var/adjust_temp
	if (loc)
		if (!istype(loc, /turf/simulated))
			adjust_temp = loc.temperature
		else
			var/turf/simulated/T = loc
			if (T.zone && T.zone.air)
				adjust_temp = T.zone.air.temperature
			else
				adjust_temp = T20C
	else
		adjust_temp = T20C

	var/diff_temp = adjust_temp - temperature
	if (abs(diff_temp) >= ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD)
		var/altered_temp = max(temperature + (ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT * temperature_coefficient * diff_temp), 0)
		ADJUST_ATOM_TEMPERATURE(src, (diff_temp > 0) ? min(adjust_temp, altered_temp) : max(adjust_temp, altered_temp))
	else
		temperature = adjust_temp
		return PROCESS_KILL

#undef MIN_TEMPERATURE_COEFFICIENT
#undef MAX_TEMPERATURE_COEFFICIENT
