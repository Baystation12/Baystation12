var/global/repository/radiation/radiation_repository = new()

/repository/radiation
	var/list/sources = list()			// all radiation source datums
	var/list/sources_assoc = list()		// Sources indexed by turf for de-duplication.
	var/list/resistance_cache = list()	// Cache of turf's radiation resistance.

// Describes a point source of radiation.  Created either in response to a pulse of radiation, or over an irradiated atom.
// Sources will decay over time, unless something is renewing their power!
/datum/radiation_source
	var/turf/source_turf		// Location of the radiation source.
	var/rad_power				// Strength of the radiation being emitted.
	var/decay = TRUE			// True for automatic decay.  False if owner promises to handle it (i.e. supermatter)
	var/respect_maint = FALSE	// True for not affecting RAD_SHIELDED areas.
	var/flat = FALSE			// True for power falloff with distance.
	var/range					// Cached maximum range, used for quick checks against mobs.

/datum/radiation_source/Destroy()
	radiation_repository.sources -= src
	if(radiation_repository.sources_assoc[src.source_turf] == src)
		radiation_repository.sources -= src.source_turf
	src.source_turf = null
	. = ..()

/datum/radiation_source/proc/update_rad_power(var/new_power = null)
	if(new_power == null || new_power == rad_power)
		return // No change
	else if(new_power <= 0)
		qdel(src) // Decayed to nothing
	else
		rad_power = new_power
		if(!flat)
			range = min(round(sqrt(rad_power / config.radiation_lower_limit)), 31)  // R = rad_power / dist**2 - Solve for dist

// Ray trace from all active radiation sources to T and return the strongest effect.
/repository/radiation/proc/get_rads_at_turf(var/turf/T)
	if(!istype(T)) return 0

	. = 0
	for(var/value in sources)
		var/datum/radiation_source/source = value
		if(source.rad_power < .)
			continue // Already being affected by a stronger source
		if(source.source_turf.z != T.z)
			continue // Radiation is not multi-z
		var/dist = get_dist(source.source_turf, T)
		if(dist > source.range)
			continue // Too far to possibly affect
		if(source.respect_maint)
			var/atom/A = T.loc
			if(A.flags & AREA_RAD_SHIELDED)
				continue // In shielded area
		if(source.flat)
			. = max(., source.rad_power)
			continue // No need to ray trace for flat  field

		// Okay, now ray trace to find resistence!
		var/turf/origin = source.source_turf
		var/working = source.rad_power
		while(origin != T)
			origin = get_step_towards(origin, T) //Raytracing
			if(!(origin in resistance_cache)) //Only get the resistance if we don't already know it.
				origin.calc_rad_resistance()
			working = max((working - (origin.cached_rad_resistance * config.radiation_resistance_multiplier)), 0)
			if(working <= .)
				break // Already affected by a stronger source (or its zero...)
		. = max((working * (1 / (dist ** 2))), .) //Butchered version of the inverse square law. Works for this purpose

// Add a radiation source instance to the repository.  It will override any existing source on the same turf.
/repository/radiation/proc/add_source(var/datum/radiation_source/S)
	if(!isturf(S.source_turf))
		return
	var/datum/radiation_source/existing = sources_assoc[S.source_turf]
	if(existing)
		qdel(existing)
	sources += S
	sources_assoc[S.source_turf] = S

// Creates a temporary radiation source that will decay
/repository/radiation/proc/radiate(source, power) //Sends out a radiation pulse, taking walls into account
	if(!(source && power)) //Sanity checking
		return
	var/datum/radiation_source/S = new()
	S.source_turf = get_turf(source)
	S.update_rad_power(power)
	add_source(S)

// Sets the radiation in a range to a constant value.
/repository/radiation/proc/flat_radiate(source, power, range, var/respect_maint = FALSE)
	if(!(source && power && range))
		return
	var/datum/radiation_source/S = new()
	S.flat = TRUE
	S.range = range
	S.respect_maint = respect_maint
	S.source_turf = get_turf(source)
	S.update_rad_power(power)
	add_source(S)

// Irradiates a full Z-level. Hacky way of doing it, but not too expensive.
/repository/radiation/proc/z_radiate(var/atom/source, power, var/respect_maint = FALSE)
	if(!(power && source))
		return
	var/turf/epicentre = locate(round(world.maxx / 2), round(world.maxy / 2), source.z)
	flat_radiate(epicentre, power, world.maxx, respect_maint)

/turf
	var/cached_rad_resistance = 0

/turf/proc/calc_rad_resistance()
	cached_rad_resistance = 0
	for(var/obj/O in src.contents)
		if(O.rad_resistance) //Override
			cached_rad_resistance += O.rad_resistance

		else if(O.density) //So open doors don't get counted
			var/material/M = O.get_material()
			if(!M)	continue
			cached_rad_resistance += M.weight
	// Looks like storing the contents length is meant to be a basic check if the cache is stale due to items enter/exiting.  Better than nothing so I'm leaving it as is. ~Leshana
	radiation_repository.resistance_cache[src] = (length(contents) + 1)

/turf/simulated/wall/calc_rad_resistance()
	radiation_repository.resistance_cache[src] = (length(contents) + 1)
	cached_rad_resistance = (density ? material.weight : 0)

/obj
	var/rad_resistance = 0  // Allow overriding rad resistance

// If people expand the system, this may be useful. Here as a placeholder until then
/atom/proc/rad_act(var/severity)
	return 1

/mob/living/rad_act(var/severity)
	if(severity)
		src.apply_effect(severity, IRRADIATE, src.getarmor(null, "rad"))
		for(var/atom/I in src)
			I.rad_act(severity)
