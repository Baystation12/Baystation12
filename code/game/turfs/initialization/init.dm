/decl/turf_initializer/proc/Initialize(var/turf/T)
	return

/area
	var/turf_initializer = null

/area/Initialize()
	. = ..()
	for(var/turf/T in src)
		if(turf_initializer)
			var/decl/turf_initializer/ti = GLOB.decl_repository.get_decl(turf_initializer)
			ti.Initialize(T)
