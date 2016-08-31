//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	var/map_z = list()

	var/area/shuttle/landing_area	//area where inbound exploration shuttles will go to

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/known = 1		//shows up on nav computers automatically

/obj/effect/overmap/New()
	tag = "sector[z]"
	if(ispath(landing_area))
		landing_area = locate(landing_area)
	prepare_map()

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = 1

/obj/effect/overmap/proc/prepare_map()
	return 1


//===================================================================================
//Hook for building overmap
//===================================================================================

/hook/startup/proc/build_overmap()
	if(!config.use_overmap)
		return 1

	testing("Building overmap...")
	world.maxz++
	overmap_z = world.maxz
	var/list/turfs = list()
	for (var/square in block(locate(1,1,overmap_z), locate(OVERMAP_SIZE,OVERMAP_SIZE,overmap_z)))
		var/turf/T = square
		if(T.x == OVERMAP_SIZE || T.y == OVERMAP_SIZE)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map/)
		T.lighting_clear_overlays()
		turfs += T

	var/area/overmap/A = new
	A.contents.Add(turfs)
	testing("Overmap created at Z[overmap_z].")

	testing("Populating overmap...")
	var/obj/effect/overmap/data
	for(var/level in 1 to world.maxz)
		data = locate("sector[level]")
		if (data)
			var/new_x = data.start_x ? data.start_x : rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)
			var/new_y = data.start_y ? data.start_y : rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)
			data.forceMove(locate(new_x, new_y, overmap_z))

			data.map_z = GetConnectedZlevels(level)
			for(var/zlevel in data.map_z)
				map_sectors["[zlevel]"] = data

			testing("Located sector \"[data.name]\" at [data.x],[data.y], containing Z [english_list(data.map_z)]")
	return 1


//===================================================================================
//Overmap object representing zlevel
//===================================================================================
/*
/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-plasteel"
	var/map_z = 0
	var/area/shuttle/shuttle_landing
	var/always_known = 1

/obj/effect/overmap/New(var/obj/effect/overmapinfo/data)
	map_z = GetConnectedZlevels(data.zlevel)
	name = data.name
	always_known = data.known
	if (data.icon != 'icons/mob/screen1.dmi')
		icon = data.icon
		icon_state = data.icon_state
	if(data.desc)
		desc = data.desc
	var/new_x = data.mapx ? data.mapx : rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)
	var/new_y = data.mapy ? data.mapy : rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)
	loc = locate(new_x, new_y, OVERMAP_ZLEVEL)

	if(data.landing_area)
		shuttle_landing = locate(data.landing_area)


/obj/effect/overmap/CanPass(atom/movable/A)
	testing("[A] attempts to enter sector\"[name]\"")
	return 1

/obj/effect/overmap/Crossed(atom/movable/A)
	testing("[A] has entered sector\"[name]\"")
	if (istype(A,/obj/effect/overmap/ship))
		var/obj/effect/overmap/ship/S = A
		S.current_sector = src

/obj/effect/overmap/Uncrossed(atom/movable/A)
	testing("[A] has left sector\"[name]\"")
	if (istype(A,/obj/effect/overmap/ship))
		var/obj/effect/overmap/ship/S = A
		S.current_sector = null

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	anchored = 1
*/
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
