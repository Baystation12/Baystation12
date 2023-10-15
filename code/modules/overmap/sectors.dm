GLOBAL_LIST_EMPTY(known_overmap_sectors)
//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/overmap/visitable
	name = "map object"
	scannable = TRUE

	var/list/map_z = list()

	var/list/initial_generic_waypoints //store landmark_tag of landmarks that should be added to the actual lists below on init.
	var/list/initial_restricted_waypoints //For use with non-automatic landmarks (automatic ones add themselves).

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles
	var/docking_codes

	var/start_x			//Coordinates for self placing
	var/start_y			//will use random values if unset

	var/sector_flags = OVERMAP_SECTOR_IN_SPACE

	var/hide_from_reports = FALSE

	var/randomize_location = TRUE

	/// null | num | list. If a num or a (num, num) list, the radius or random bounds for placing this sector near the main map's overmap icon.
	var/list/place_near_main

	var/blob_count = 0

/obj/overmap/visitable/Initialize()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	find_z_levels()     // This populates map_z and assigns z levels to the ship.
	register_z_levels() // This makes external calls to update global z level information.

	if(!GLOB.using_map.overmap_z)
		build_overmap()

	if (randomize_location)
		var/map_low = OVERMAP_EDGE
		var/map_high = GLOB.using_map.overmap_size - OVERMAP_EDGE
		var/turf/home
		if (place_near_main)
			var/obj/overmap/main = SSshuttle.ship_by_type(GLOB.using_map.overmap_entity)
			if (main)
				if (islist(place_near_main))
					place_near_main = Roundm(Frand(place_near_main[1], place_near_main[2]), 0.1)
				home = CircularRandomTurfAround(main, abs(place_near_main), map_low, map_low, map_high, map_high)
				log_debug("place_near_main moving [src] near [main] ([main.x],[main.y]) with radius [place_near_main], got ([home.x],[home.y])")
			if (!home)
				log_debug("place_near_main failed for [src] (no main site found) -placing randomly")
		if (!home)
			start_x = start_x || rand(map_low, map_high)
			start_y = start_y || rand(map_low, map_high)
			home = locate(start_x, start_y, GLOB.using_map.overmap_z)
		forceMove(home)

		for(var/obj/overmap/event/E in loc)
			qdel(E)

	if(HAS_FLAGS(sector_flags, OVERMAP_SECTOR_KNOWN))
		LAZYADD(GLOB.known_overmap_sectors, src)
		layer = ABOVE_LIGHTING_LAYER
		plane = EFFECTS_ABOVE_LIGHTING_PLANE
		for(var/obj/machinery/computer/ship/helm/H as anything in GLOB.overmap_helm_computers)
			H.add_known_sector(src)

	docking_codes = "[ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))]"

	testing("Located sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

	LAZYADD(SSshuttle.sectors_to_initialize, src) //Queued for further init. Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.
	SSshuttle.clear_init_queue()


/obj/overmap/visitable/Destroy()
	LAZYREMOVE(GLOB.known_overmap_sectors, src)
	. = ..()

//This is called later in the init order by SSshuttle to populate sector objects. Importantly for subtypes, shuttles will be created by then.
/obj/overmap/visitable/proc/populate_sector_objects()

/obj/overmap/visitable/proc/get_areas()
	return get_filtered_areas(list(/proc/area_belongs_to_zlevels = map_z))

/obj/overmap/visitable/proc/find_z_levels()
	map_z = GetConnectedZlevels(z)

/obj/overmap/visitable/proc/register_z_levels()
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	GLOB.using_map.player_levels |= map_z
	if(!HAS_FLAGS(sector_flags, OVERMAP_SECTOR_IN_SPACE))
		GLOB.using_map.sealed_levels |= map_z
	if(HAS_FLAGS(sector_flags, OVERMAP_SECTOR_BASE))
		GLOB.using_map.station_levels |= map_z
		GLOB.using_map.contact_levels |= map_z
		GLOB.using_map.map_levels |= map_z

//Helper for init.
/obj/overmap/visitable/proc/check_ownership(obj/object)
	if((object.z in map_z) && !(get_area(object) in SSshuttle.shuttle_areas))
		return 1

//If shuttle_name is false, will add to generic waypoints; otherwise will add to restricted. Does not do checks.
/obj/overmap/visitable/proc/add_landmark(obj/shuttle_landmark/landmark, shuttle_name)
	landmark.sector_set(src, shuttle_name)
	if(shuttle_name)
		LAZYADD(restricted_waypoints[shuttle_name], landmark)
	else
		generic_waypoints += landmark

/obj/overmap/visitable/proc/remove_landmark(obj/shuttle_landmark/landmark, shuttle_name)
	if(shuttle_name)
		var/list/shuttles = restricted_waypoints[shuttle_name]
		LAZYREMOVE(shuttles, landmark)
	else
		generic_waypoints -= landmark

/obj/overmap/visitable/proc/get_waypoints(shuttle_name)
	. = list()
	for(var/obj/overmap/visitable/contained in src)
		. += contained.get_waypoints(shuttle_name)
	for(var/thing in generic_waypoints)
		.[thing] = name
	if(shuttle_name in restricted_waypoints)
		for(var/thing in restricted_waypoints[shuttle_name])
			.[thing] = name

/obj/overmap/visitable/proc/generate_skybox()
	return

/obj/overmap/visitable/MouseEntered(location, control, params)
	openToolTip(user = usr, tip_src = src, params = params, title = name)
	..()

/obj/overmap/visitable/MouseDown()
	closeToolTip(usr) //No reason not to, really
	..()

/obj/overmap/visitable/MouseExited()
	closeToolTip(usr) //No reason not to, really
	..()

/obj/overmap/visitable/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	requires_contact = TRUE
	anchored = TRUE


/obj/overmap/visitable/sector/Initialize()
	. = ..()
	if(HAS_FLAGS(sector_flags, OVERMAP_SECTOR_KNOWN))
		for(var/obj/machinery/computer/ship/helm/H as anything in GLOB.overmap_helm_computers)
			update_known_connections(TRUE)


/obj/overmap/visitable/sector/update_known_connections(notify = FALSE)
	. = ..()

	for(var/obj/machinery/computer/ship/helm/H in SSmachines.machinery)
		H.add_known_sector(src, notify)


// Because of the way these are spawned, they will potentially have their invisibility adjusted by the turfs they are mapped on
// prior to being moved to the overmap. This blocks that. Use set_invisibility to adjust invisibility as needed instead.
/obj/overmap/visitable/sector/hide()

/proc/build_overmap()
	if(!GLOB.using_map.use_overmap)
		return 1

	testing("Building overmap...")
	INCREMENT_WORLD_Z_SIZE
	GLOB.using_map.overmap_z = world.maxz

	testing("Putting overmap on [GLOB.using_map.overmap_z]")
	var/area/overmap/A = new
	for (var/square in block(locate(1,1,GLOB.using_map.overmap_z), locate(GLOB.using_map.overmap_size,GLOB.using_map.overmap_size,GLOB.using_map.overmap_z)))
		var/turf/T = square
		if(T.x == GLOB.using_map.overmap_size || T.y == GLOB.using_map.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map)
		ChangeArea(T, A)

	GLOB.using_map.sealed_levels |= GLOB.using_map.overmap_z

	testing("Overmap build complete.")
	return 1
