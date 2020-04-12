/proc/create_all_lighting_overlays()
	for(var/zlevel = 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)

/proc/create_lighting_overlays_zlevel(var/zlevel)
	ASSERT(zlevel)

	for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue

		var/area/A = T.loc
		if(!A.dynamic_lighting)
			continue
		if(locate(/atom/movable/lighting_overlay) in T) //If one already exists, don't try to create one.
			continue

		new /atom/movable/lighting_overlay(T, TRUE)
