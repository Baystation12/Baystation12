
/datum/light_source/ambient
	var/list/turfs_to_update_lum = list()
	var/turfs_per_tick = 3000
	var/update_gen = 1

/datum/light_source/ambient/apply_lum()
	applied = 1

	// Keep track of the last applied lum values so that the lighting can be reversed
	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

	GLOB.processing_objects |= src
	turfs_to_update_lum = block(locate(1, 1, source_turf.z), locate(world.maxx, world.maxy, source_turf.z))

	update_gen++

/datum/light_source/ambient/proc/process()
	if(turfs_to_update_lum.len)
		apply_lum_delayedtick()
	else
		GLOB.processing_objects.Remove(src)

#define APPLY_CORNER_AMBIENT(C)      \
	. = 1;                           \
                                     \
	. *= light_power/2;              \
                                     \
	effect_str[C] = .;               \
                                     \
	C.update_lumcount                \
	(                                \
		. * applied_lum_r,           \
		. * applied_lum_g,           \
		. * applied_lum_b            \
	);

#define REMOVE_CORNER(C)             \
	. = -effect_str[C];              \
	C.update_lumcount                \
	(                                \
		. * applied_lum_r,           \
		. * applied_lum_g,           \
		. * applied_lum_b            \
	);

/*
/datum/light_source/proc/remove_lum()
	applied = FALSE

	for(var/turf/T in affecting_turfs)
		if(!T.affecting_lights)
			T.affecting_lights = list()
		else
			T.affecting_lights -= src

	affecting_turfs.Cut()

	for(var/datum/lighting_corner/C in effect_str)
		REMOVE_CORNER(C)

		C.affecting -= src

	effect_str.Cut()

*/
/datum/light_source/ambient/proc/apply_lum_delayedtick()
	set background = 1

	var/processed_num = 0
	for(var/turf/T in turfs_to_update_lum)
		if(processed_num > turfs_per_tick)
			break

		if(!T.lighting_corners_initialised)
			T.generate_missing_corners()

		if(!T.affecting_lights)
			T.affecting_lights = list()
		else
			T.affecting_lights -= src

		for(var/datum/lighting_corner/C in T.get_corners())
			if(C.update_gen == update_gen)
				continue

			REMOVE_CORNER(C)
			C.affecting -= src

			C.update_gen = update_gen

			processed_num++

			if(!C.active || !light_power)
				effect_str[C] = 0
				continue

			C.affecting += src
			APPLY_CORNER_AMBIENT(C)



		if(!T.affecting_lights)
			T.affecting_lights = list()

		if(light_power)
			T.affecting_lights += src
			affecting_turfs    += T

		var/turf/simulated/open/O = T
		if(istype(O) && O.below)
			// Consider the turf below us as well. (Z-lights)
			//Do subprocessing for open turfs
			for(T = O.below; !isnull(T); T = process_the_turf(T,update_gen));

		turfs_to_update_lum -= T

/*
/datum/light_source/ambient/check()
	. = 1
	*/

/datum/light_source/ambient/process_the_turf(var/turf/T, update_gen)

	if(!T.lighting_corners_initialised)
		T.generate_missing_corners()

	for(var/datum/lighting_corner/C in T.get_corners())
		if(C.update_gen == update_gen)
			continue

		C.update_gen = update_gen
		C.affecting += src

		if(!C.active)
			effect_str[C] = 0
			continue

		APPLY_CORNER_AMBIENT(C)

	if(!T.affecting_lights)
		T.affecting_lights = list()

	T.affecting_lights += src
	affecting_turfs    += T

	var/turf/simulated/open/O = T
	if(istype(O) && O.below)
		return O.below
	return null

#undef APPLY_CORNER_AMBIENT
