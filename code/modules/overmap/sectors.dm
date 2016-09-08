<<<<<<< HEAD

//===================================================================================
//Hook for building overmap
//===================================================================================
var/global/list/map_sectors = list()

/hook/startup/proc/build_map()
	if(!config.use_overmap)
		return 1
	testing("Building overmap...")
	var/obj/effect/mapinfo/data
	for(var/level in 1 to world.maxz)
		data = locate("sector[level]")
		if (data)
			var/obj/effect/map/M = new data.obj_type(data)
			testing("Located sector \"[data.name]\" at [data.mapx],[data.mapy], containing z [english_list(M.map_z)]")
			for(var/zlevel in M.map_z)
				map_sectors["[zlevel]"] = M
	return 1

//===================================================================================
//Metaobject for storing information about sector this zlevel is representing.
//Should be placed only once on every zlevel.
//===================================================================================
/obj/effect/mapinfo/
	name = "map info metaobject"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	invisibility = 101
	var/obj_type		//type of overmap object it spawns
	var/landing_area 	//type of area used as inbound shuttle landing, null if no shuttle landing area
	var/zlevel
	var/mapx			//coordinates on the
	var/mapy			//overmap zlevel
	var/known = 1

/obj/effect/mapinfo/New()
	tag = "sector[z]"
	testing("tag: sector[z]")
	zlevel = z
	loc = null

/obj/effect/mapinfo/sector
	name = "generic sector"
	obj_type = /obj/effect/map/sector

/obj/effect/mapinfo/ship
	name = "generic ship"
	obj_type = /obj/effect/map/ship


=======
>>>>>>> c9a8e118133bb0b368e33256d8255e3d310a5553
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

<<<<<<< HEAD
/obj/effect/overmap/New()
	tag = "sector[z]"
=======
/obj/effect/overmap/initialize()
	if(!config.use_overmap)
		qdel(src)
		return

	if(!using_map.overmap_z)
		build_overmap()

>>>>>>> c2114477b4decf684d3386c4ae2aa3f265370f38
	if(ispath(landing_area))
		landing_area = locate(landing_area)

	map_z = GetConnectedZlevels(z)
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	if(!start_x)
		start_x = rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)
	if(!start_y)
		start_y = rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)

	forceMove(locate(start_x, start_y, using_map.overmap_z))
	testing("Located sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

	for(var/obj/machinery/computer/shuttle_control/explore/console in machines)
		if(console.z in map_z)
			console.home = src

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
	if(!config.use_overmap)
		return 1

	testing("Building overmap...")
	world.maxz++
	using_map.overmap_z = world.maxz
	var/list/turfs = list()
	for (var/square in block(locate(1,1,using_map.overmap_z), locate(OVERMAP_SIZE,OVERMAP_SIZE,using_map.overmap_z)))
		var/turf/T = square
		if(T.x == OVERMAP_SIZE || T.y == OVERMAP_SIZE)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map/)
		T.lighting_clear_overlays()
		turfs += T

	var/area/overmap/A = new
	A.contents.Add(turfs)
	testing("Overmap created at Z[using_map.overmap_z].")
	return 1