//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
var/list/points_of_interest = list()

/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	var/map_z = list()

	var/list/landing_areas	//areas where inbound exploration shuttles can land

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/base = 0		//starting sector, counts as station_levels
	var/known = 1		//shows up on nav computers automatically
	var/in_space = 1	//can be accessed via lucky EVA

/obj/effect/overmap/initialize()
	if(!using_map.use_overmap)
		qdel(src)
		return

	if(!using_map.overmap_z)
		build_overmap()
	using_map.sealed_levels |= using_map.overmap_z

	map_z = GetConnectedZlevels(z)
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	start_x = start_x || rand(OVERMAP_EDGE, using_map.overmap_size - OVERMAP_EDGE)
	start_y = start_y || rand(OVERMAP_EDGE, using_map.overmap_size - OVERMAP_EDGE)

	forceMove(locate(start_x, start_y, using_map.overmap_z))
	testing("Located sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

	using_map.player_levels |= map_z

	if(!in_space)
		using_map.sealed_levels |= map_z

	if(base)
		using_map.station_levels |= map_z
		using_map.contact_levels |= map_z

	for(var/obj/machinery/computer/shuttle_control/explore/console in machines)
		if(console.z in map_z)
			if(!landing_areas)
				landing_areas = list()
			landing_areas |= console.shuttle_area

	points_of_interest += name

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = 1

/obj/effect/overmap/sector/initialize()
	..()
	for(var/obj/machinery/computer/helm/H in machines)
		H.get_known_sectors()

/proc/build_overmap()
	if(!using_map.use_overmap)
		return 1

	testing("Building overmap...")
	world.maxz++
	using_map.overmap_z = world.maxz
	var/list/turfs = list()
	for (var/square in block(locate(1,1,using_map.overmap_z), locate(using_map.overmap_size,using_map.overmap_size,using_map.overmap_z)))
		var/turf/T = square
		if(T.x == using_map.overmap_size || T.y == using_map.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map/)
		T.lighting_clear_overlays()
		turfs += T

	var/area/overmap/A = new
	A.contents.Add(turfs)

	testing("Overmap build complete.")
	return 1
