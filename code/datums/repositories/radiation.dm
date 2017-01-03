//#define RADDBG

var/repository/radiation/radiation_repository = new()

var/list/to_process = list()

/repository/radiation
	var/list/sources = list() //All the radiation sources we know about
	var/list/irradiated_turfs = list()
	var/list/irradiated_mobs = list()
	var/list/resistance_cache = list()

/repository/radiation/proc/report_rads(var/turf/T as turf)
	return irradiated_turfs[T]

/repository/radiation/proc/radiate(source, power) //Sends out a radiation pulse, taking walls into account
	if(!(source && power)) //Sanity checking
		return

	var/range = min(round(sqrt(power / config.radiation_lower_limit)), 31)
	var/turf/epicentre = get_turf(source)
	to_process = list()

	range = min(epicentre.x, world.maxx - epicentre.x, epicentre.y, world.maxy - epicentre.y, range)

	to_process = trange(range, epicentre)
	to_process[epicentre] = power

	for(var/turf/spot in to_process)
		var/turf/origin = get_turf(epicentre)
		var/working = power
		while(origin != spot)
			origin = get_step_towards(origin, spot) //Raytracing
			if(!(origin in resistance_cache)) //Only get the resistance if we don't already know it.
				origin.calc_rad_resistance()
			working = max((working - (origin.rad_resistance * config.radiation_resistance_multiplier)), 0)
			if(!working)
				break //Don't bother continuing to trace
			if(!to_process[origin])
				to_process[origin] = working

			else
				to_process[origin] = max(to_process[origin], working)

	for(var/turf/spot in to_process)
		irradiated_turfs[spot] = max(((to_process[spot]) * (1 / (get_dist(epicentre, spot) ** 2))), irradiated_turfs[spot]) //Butchered version of the inverse square law. Works for this purpose
		#ifdef RADDBG
		var/x = Clamp( irradiated_turfs[spot], 0, 255)
		spot.color = rgb(5,x,5)
		#endif

/repository/radiation/proc/flat_radiate(source, power, range, var/respect_maint=0) //Sets the radiation in a range to a constant value.
	if(!(source && power && range))
		return
	var/turf/epicentre = get_turf(source)
	range = min(epicentre.x, world.maxx - epicentre.x, epicentre.y, world.maxy - epicentre.y, range)
	if(!respect_maint)
		for(var/turf/T in trange(range, epicentre))
			irradiated_turfs[T] = max(power, irradiated_turfs[T])
	else
		for(var/turf/T in trange(range, epicentre))
			var/area/A = T.loc
			if(A.flags & RAD_SHIELDED)
				continue
			irradiated_turfs[T] = max(power, irradiated_turfs[T])

/repository/radiation/proc/z_radiate(var/atom/source, power, var/respect_maint=0) //Irradiates a full Z-level. Hacky way of doing it, but not too expensive.
	if(!(power && source))
		return
	var/turf/epicentre = locate(round(world.maxx / 2), round(world.maxy / 2), source.z)
	flat_radiate(epicentre, power, world.maxx, respect_maint)

/turf/proc/calc_rad_resistance()
	rad_resistance = 0
	for(var/obj/O in src.contents)
		if(O.rad_resistance) //Override
			rad_resistance += O.rad_resistance

		else if(O.density) //So doors don't get counted
			var/material/M = O.get_material()
			if(!M)	continue
			rad_resistance += M.weight
	radiation_repository.resistance_cache[src] = (length(contents) + 1)

/turf/simulated/wall/calc_rad_resistance()
	radiation_repository.resistance_cache[src] = (length(contents) + 1)
	rad_resistance = (density ? material.weight : 0)

/atom
	var/rad_power = 0
	var/rad_resistance = 0

/atom/Destroy()
	if(rad_power)
		radiation_repository.sources.Remove(src)
	. = ..()

/atom/proc/update_radiation() //For VV'ing something to make it radioactive at runtime
	if((rad_power) && (!(src in radiation_repository.sources)))
		radiation_repository.sources.Add(src)
	else if((!rad_power) && (src in radiation_repository.sources))
		radiation_repository.sources.Remove(src)

/atom/proc/rad_act(var/severity) //If people expand the system, this may be useful. Here as a placeholder until then
	return 1

/mob/living/rad_act(var/severity)
	if(severity)
		src.apply_effect(severity, IRRADIATE, src.getarmor(null, "rad"))
		for(var/obj/I in src)
			I.rad_act(severity)


//#undef RADDBG