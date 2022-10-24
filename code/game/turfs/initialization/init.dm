/singleton/turf_initializer/proc/InitializeTurf(turf/T)
	return

/// Type path (Types of `/singleton/turf_initializer`). If set, uses the provided singleton to modify all turfs in the area during `Initialize()`.
/area/var/turf_initializer = null

/area/Initialize()
	. = ..()
	for(var/turf/T in src)
		if(turf_initializer)
			var/singleton/turf_initializer/ti = GET_SINGLETON(turf_initializer)
			ti.InitializeTurf(T)
