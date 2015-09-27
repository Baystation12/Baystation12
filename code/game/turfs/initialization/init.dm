/datum/turf_initializer/proc/initialize(var/turf/T)
	return

/area
	var/datum/turf_initializer/turf_initializer = null

/area/initialize()
	..()
	if(turf_initializer)
		for(var/turf/simulated/T in src)
			turf_initializer.initialize(T)
