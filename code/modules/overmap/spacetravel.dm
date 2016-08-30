//list used to cache empty zlevels to avoid nedless map bloat
var/list/cached_space = list()

//Space stragglers go here

/obj/effect/overmap/sector/temporary
	name = "Deep Space"
	icon_state = ""
	known = 0

/obj/effect/overmap/sector/temporary/New(var/nx, var/ny, var/nz)
	loc = locate(nx, ny, overmap_z)
	map_z += nz
	map_sectors["[map_z]"] = src
	testing("Temporary sector at [x],[y] was created, corresponding zlevel is [map_z[1]].")

/obj/effect/overmap/sector/temporary/Destroy()
	map_sectors["[map_z]"] = null
	testing("Temporary sector at [x],[y] was deleted.")
	if (can_die())
		testing("Associated zlevel disappeared.")
		world.maxz--

/obj/effect/overmap/sector/temporary/proc/can_die(var/mob/observer)
	testing("Checking if sector at [map_z[1]] can die.")
	for(var/mob/M in player_list)
		if(M != observer && M.z in map_z)
			testing("There are people on it.")
			return 0
	return 1

proc/overmap_spacetravel(var/turf/space/T, var/atom/movable/A)
	return	//a plug until issues with thrown objects spawning endless space levels are resolved

	var/obj/effect/overmap/M = map_sectors["[T.z]"]
	if (!M)
		return
	var/mapx = M.x
	var/mapy = M.y
	var/nx = 1
	var/ny = 1
	var/nz = M.map_z

	if(T.x <= TRANSITIONEDGE)
		nx = world.maxx - TRANSITIONEDGE - 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)
		mapx = max(1, mapx-1)

	else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
		nx = TRANSITIONEDGE + 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)
		mapx = min(world.maxx, mapx+1)

	else if (T.y <= TRANSITIONEDGE)
		ny = world.maxy - TRANSITIONEDGE -2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)
		mapy = max(1, mapy-1)

	else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
		ny = TRANSITIONEDGE + 2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)
		mapy = min(world.maxy, mapy+1)

	testing("[A] moving from [M] ([M.x], [M.y]) to ([mapx],[mapy]).")

	var/turf/map = locate(mapx,mapy,overmap_z)
	var/obj/effect/overmap/TM = locate() in map
	if(TM)
		nz = TM.map_z
		testing("Destination: [TM]")
	else
		if(cached_space.len)
			var/obj/effect/overmap/sector/temporary/cache = cached_space[cached_space.len]
			cached_space -= cache
			nz = cache.map_z
			cache.x = mapx
			cache.y = mapy
			testing("Destination: *cached* [TM]")
		else
			world.maxz++
			nz = world.maxz
			TM = new /obj/effect/overmap/sector/temporary(mapx, mapy, nz)
			testing("Destination: *new* [TM]")

	var/turf/dest = locate(nx,ny,nz)
	if(dest)
		A.loc = dest

	if(istype(M, /obj/effect/overmap/sector/temporary))
		var/obj/effect/overmap/sector/temporary/source = M
		if (source.can_die())
			testing("Catching [M] for future use")
			source.loc = null
			cached_space += source
