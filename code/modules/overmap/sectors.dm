//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	var/map_z = list()

	var/list/landing_areas	//areas where inbound exploration shuttles can land

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/known = 1		//shows up on nav computers automatically
	var/team = 0

	var/datum/fake_ship/fake_ship
	var/list/fire_controls = list()
	var/list/fire_sensors = list()
	var/fake = 0

	var/em_signature = 0
	var/thermal_signature = 0
	var/obj/machinery/space_battle/shield_generator/shielding

/obj/effect/overmap/Destroy()
	fire_controls.Cut()
	fire_controls.Cut()
	if(fake)
		qdel(fake_ship)
		fake_ship = null
	map_sectors["[z]"] = null
	if(landing_areas)
		landing_areas.Cut()
	for(var/obj/machinery/space_battle/O in world)
		if(O.z in map_z)
			O.linked = null
	map_z = null
	return ..()

/obj/effect/overmap/initialize()
	if(!config.use_overmap)
		qdel(src)
		return

	if(!using_map.overmap_z)
		build_overmap()

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

	prepare_map()

/obj/effect/overmap/proc/prepare_map()
	return 1

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = 1

/obj/effect/overmap/sector/initialize()
	..()
	for(var/obj/machinery/space_battle/computer/helm/H in machines)
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