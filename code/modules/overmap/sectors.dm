
//===================================================================================
//Hook for building overmap
//===================================================================================
var/global/list/map_sectors = list()

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

/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	var/map_z = list()

	var/area/shuttle/landing_area

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/known = 1		//shows up on nav computers automatically

/obj/effect/overmap/New(var/obj/effect/overmapinfo/data)
	tag = "sector[z]"
	if(ispath(landing_area))
		landing_area = locate(landing_area)

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
	icon_state = "sector"
	anchored = 1

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
