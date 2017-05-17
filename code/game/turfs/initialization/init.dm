/decl/turf_initializer/proc/initialize(var/turf/T)
	return

/area
	var/turf_initializer = null

/area/Initialize()
	. = ..()
	for(var/turf/T in src)
		T.initialize()
		if(turf_initializer)
			var/decl/turf_initializer/ti = decls_repository.get_decl(turf_initializer)
			ti.initialize(T)
