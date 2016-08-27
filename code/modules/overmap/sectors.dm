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

/obj/effect/overmap/New(var/obj/effect/overmapinfo/data)
	tag = "sector[z]"
	if(ispath(landing_area))
		landing_area = locate(landing_area)

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = 1


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
