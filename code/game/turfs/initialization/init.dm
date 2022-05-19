/decl/turf_initializer/proc/InitializeTurf(var/turf/T)
	return

/// Type path (Types of `/decl/turf_initializer`). If set, uses the provided decl to modify all turfs in the area during `Initialize()`.
/area/var/turf_initializer = null

/area/Initialize()
	. = ..()
	for(var/turf/T in src)
		if(turf_initializer)
			var/decl/turf_initializer/ti = decls_repository.get_decl(turf_initializer)
			ti.InitializeTurf(T)
