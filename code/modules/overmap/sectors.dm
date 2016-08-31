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

/obj/effect/overmap/New()
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
