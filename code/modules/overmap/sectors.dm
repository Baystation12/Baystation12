//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
GLOBAL_LIST_EMPTY(overmap_tiles_uncontrolled) //This is any overmap sectors that are uncontrolled by any faction

GLOBAL_LIST_EMPTY(overmap_spawn_near)
GLOBAL_LIST_EMPTY(overmap_spawn_in)

var/list/points_of_interest = list()

/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	dir = 1
	ai_access_level = 0
	var/list/map_z = list()
	var/list/map_z_data = list()
	var/list/targeting_locations = list() // Format: "location" = list(TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)
	var/weapon_miss_chance = 0

	//This is a list used by overmap projectiles to ensure they actually hit somewhere on the ship. This should be set so projectiles can narrowly miss, but not miss by much.
	var/list/map_bounds = list(1,255,255,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/base = 0		//starting sector, counts as station_levels
	var/flagship = 0
	var/known = 1		//shows up on nav computers automatically
	var/in_space = 1	//can be accessed via lucky EVA
	var/block_slipspace = 0		//for planets with gravity wells etc

	var/list/hull_segments = list()
	var/superstructure_failing = 0
	var/list/connectors = list() //Used for docking umbilical type-items.
	var/faction = "civilian" //The faction of this object, used by sectors and NPC ships (before being loaded in). Ships have an override
	var/datum/faction/my_faction
	var/slipspace_status = 0		//0: realspace, 1: slipspace but returning to system, 2: out of system

	var/datum/targeting_datum/targeting_datum = new

	var/glassed = 0
	var/nuked = 0
	var/demolished = 0

	var/last_adminwarn_attack = 0

	var/controlling_faction = null

	//this is used for when we need to iterate over an entire sector's areas
	var/parent_area_type

	var/list/overmap_spawn_near_me = list()	//type path of other overmap objects to spawn near this object
	var/list/overmap_spawn_in_me = list()	//type path of other overmap objects to spawn inside this object

	var/datum/pixel_transform/my_pixel_transform
	var/list/my_observers = list()

/obj/effect/overmap/New()
	//this should already be named with a custom name by this point
	if(name == "map object")
		name = "invalid-\ref[src]"

	if(!(src in GLOB.mobs_in_sectors))
		GLOB.mobs_in_sectors[src] = list()

	//custom tags are allowed to be set in map or elsewhere
	if(!tag)
		tag = name

	. = ..()

/obj/effect/overmap/Initialize()
	..()

	for(var/entry in overmap_spawn_near_me)
		GLOB.overmap_spawn_near[entry] = src

	for(var/entry in overmap_spawn_in_me)
		GLOB.overmap_spawn_in[entry] = src

	setup_object()
	generate_targetable_areas()

	if(flagship)
		GLOB.overmap_tiles_uncontrolled -= range(28,src)

	return INITIALIZE_HINT_LATELOAD

/obj/effect/overmap/LateInitialize()
	var/obj/effect/overmap/summoning_me = GLOB.overmap_spawn_near[src.type]
	if(summoning_me)
		var/list/spawn_locs = list()
		for(var/turf/t in orange(1,summoning_me))
			spawn_locs += t
		src.forceMove(pick(spawn_locs))
		GLOB.overmap_spawn_near -= src.type

	summoning_me = GLOB.overmap_spawn_in[src.type]
	if(summoning_me)
		src.forceMove(summoning_me)
		GLOB.overmap_spawn_in -= src.type

	if(flagship && faction)
		var/datum/faction/F = GLOB.factions_by_name[faction]
		if(F)
			F.flagship = src
			F.get_flagship_name()	//update the archived name

	if(base && faction)
		var/datum/faction/F = GLOB.factions_by_name[faction]
		if(F)
			F.base = src
			F.get_base_name()		//update the archived name

	my_faction = GLOB.factions_by_name[faction]

/obj/effect/overmap/proc/play_jump_sound(var/sound_loc_origin,var/sound)
	var/list/mobs_to_sendsound = list()
	mobs_to_sendsound += GLOB.mobs_in_sectors[src]
	for(var/obj/effect/overmap/om in range(SLIPSPACE_JUMPSOUND_RANGE,sound_loc_origin))
		mobs_to_sendsound |= GLOB.mobs_in_sectors[om]
	for(var/mob/m in mobs_to_sendsound)
		playsound(m,sound,100)

/obj/effect/overmap/proc/send_jump_alert(var/alert_origin)
	var/list/mobs_to_alert = list()
	mobs_to_alert += GLOB.mobs_in_sectors[src]
	for(var/obj/effect/overmap/om in range(SLIPSPACE_JUMP_ALERT_RANGE,alert_origin))
		mobs_to_alert |= GLOB.mobs_in_sectors[om]
	var/list/dirlist = list("north","south","n/a","east","northeast","southeast","n/a","west","northwest","southwest")
	for(var/mob/m in mobs_to_alert)
		var/dir_to_ship = get_dir(map_sectors["[m.z]"],alert_origin)
		if(dir_to_ship != 0)
			to_chat(m,"<span class = 'danger'>ALERT: Slipspace rupture detected to the [dirlist[dir_to_ship]]</span>")


/obj/effect/overmap/proc/do_slipspace_exit_effects(var/exit_loc,var/sound)
	var/obj/effect/overmap/ship/om_ship = src
	if(istype(om_ship))
		om_ship.speed = list(0,0)

	var/headingdir = dir
	var/turf/T = exit_loc
	//Below code should flip the dirs.
	T = get_step(T,headingdir)
	headingdir = get_dir(T,exit_loc)
	T = exit_loc
	for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	if(sound)
		play_jump_sound(exit_loc,sound)
	send_jump_alert(exit_loc)
	loc = T
	walk_to(src,exit_loc,0,1,0)
	spawn(SLIPSPACE_PORTAL_DIST)
		walk(src,0)

/obj/effect/overmap/proc/do_slipspace_enter_effects(var/sound)
	//BELOW CODE STOLEN FROM CAEL'S IMPLEMENTATION OF THE SLIPSPACE EFFECTS, MODIFIED.//
	var/obj/effect/overmap/ship/om_ship = src
	if(istype(om_ship))
		om_ship.speed = list(0,0)
		om_ship.break_umbilicals()
	//animate the slipspacejump
	var/headingdir = dir
	var/turf/T = loc
	for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	if(sound)
		play_jump_sound(T,sound)
	//rapidly move into the portal
	walk_to(src,T,0,1,0)
	spawn(SLIPSPACE_PORTAL_DIST)
		loc = null
		walk_to(src,null)

/obj/effect/overmap/proc/slipspace_to_location(var/turf/location,var/target_status,var/sound)
	do_slipspace_exit_effects(location,sound)
	if(!isnull(target_status))
		slipspace_status = 0

/obj/effect/overmap/proc/slipspace_to_nullspace(var/target_status,sound)
	do_slipspace_enter_effects(sound)
	if(!isnull(target_status))
		slipspace_status = target_status

/obj/effect/overmap/proc/generate_targetable_areas()
	if(isnull(parent_area_type))
		return
	var/list/areas_scanthrough = typesof(parent_area_type) - parent_area_type
	if(areas_scanthrough.len == 0)
		return
	for(var/a in areas_scanthrough)
		var/area/located_area = locate(a)
		if(isnull(located_area))
			continue
		var/low_x = 255
		var/upper_x = 0
		var/low_y = 255
		var/upper_y = 0
		for(var/turf/t in located_area.contents)
			if(t.x < low_x)
				low_x = t.x
			if(t.y < low_y)
				low_y = t.y
			if(t.x > upper_x)
				upper_x = t.x
			if(t.y > upper_y)
				upper_y = t.x
		targeting_locations["[located_area.name]"] = list(low_x,upper_y,upper_x,low_y)

/obj/effect/overmap/proc/get_superstructure_strength() //Returns a decimal percentage calculated from currstrength/maxstrength
	var/list/hull_strengths = list(0,0)
	for(var/obj/effect/hull_segment/hull_segment in hull_segments)
		if(hull_segment.is_segment_destroyed() == 0)
			hull_strengths[1] += hull_segment.segment_strength
		hull_strengths[2] += hull_segment.segment_strength

	if(hull_strengths[2] == 0)
		return null

	return (hull_strengths[1]/hull_strengths[2])

/obj/effect/overmap/proc/get_faction()
	return faction

/obj/effect/overmap/proc/setup_object()

	/*
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL
		*/

	if(!GLOB.using_map.overmap_z && GLOB.using_map.use_overmap)
		build_overmap()

	if(!isnull(loc))
		map_z |= loc.z
	//map_z = GetConnectedZlevels(z)
	//for(var/zlevel in map_z)
	map_sectors["[z]"] = src
	if(GLOB.using_map.use_overmap)
		var/turf/move_to_loc = pick(GLOB.overmap_tiles_uncontrolled)

		forceMove(move_to_loc)

		testing("Located sector \"[name]\" at [move_to_loc.x],[move_to_loc.y], containing Z [english_list(map_z)]")
	//points_of_interest += name

	/*
	GLOB.using_map.player_levels |= map_z
		*/

	/*
	if(!in_space)
		GLOB.using_map.sealed_levels |= map_z
		*/

	/*
	if(base)
		GLOB.using_map.station_levels |= map_z
		GLOB.using_map.contact_levels |= map_z
		*/

	//find shuttle waypoints
	var/list/found_waypoints = list()
	for(var/waypoint_tag in generic_waypoints)
		var/obj/effect/shuttle_landmark/WP = locate(waypoint_tag)
		if(WP)
			found_waypoints += WP
		else
			log_error("Sector \"[name]\" containing Z [english_list(map_z)] could not find waypoint with tag [waypoint_tag]!")
	generic_waypoints = found_waypoints

	for(var/shuttle_name in restricted_waypoints)
		found_waypoints = list()
		for(var/waypoint_tag in restricted_waypoints[shuttle_name])
			var/obj/effect/shuttle_landmark/WP = locate(waypoint_tag)
			if(WP)
				found_waypoints += WP
			else
				log_error("Sector \"[name]\" containing Z [english_list(map_z)] could not find waypoint with tag [waypoint_tag]!")
		restricted_waypoints[shuttle_name] = found_waypoints

/obj/effect/overmap/proc/link_zlevel(var/obj/effect/landmark/map_data/new_data)
	if(new_data)
		map_sectors["[new_data.z]"] = src
		map_z |= new_data.z

		var/obj/effect/landmark/map_data/above
		var/obj/effect/landmark/map_data/below
		for(var/obj/effect/landmark/map_data/check_data in map_z_data)

			//possible candidate for above
			if(check_data.z < new_data.z)
				//check_data is higher than new_data

				if(!above || check_data.z > above.z)
					//gottem
					above = check_data


			//possible candidate for below
			if(check_data.z > new_data.z)
				//check_data is lower than new_data

				if(!below || check_data.z < below.z)
					//gottem
					below = check_data


		//update the other linkages
		new_data.above = above
		if(above)
			above.below = new_data
		//
		new_data.below = below
		if(below)
			below.above = new_data

		//add it to our list
		map_z_data.Add(new_data)

/obj/effect/overmap/proc/get_waypoints(var/shuttle_name)
	. = generic_waypoints.Copy()
	if(shuttle_name in restricted_waypoints)
		. += restricted_waypoints[shuttle_name]

/obj/effect/overmap/proc/do_superstructure_fail()
	for(var/mob/player in GLOB.mobs_in_sectors[src])
		player.dust()
	loc = null

	message_admins("NOTICE: Overmap object [src] has been destroyed. Please wait as it is deleted.")
	log_admin("NOTICE: Overmap object [src] has been destroyed.")
	sleep(10)//To allow the previous message to actually be seen
	for(var/z_level in map_z)
		shipmap_handler.free_map(z_level)
	qdel(src)

/obj/effect/overmap/proc/pre_superstructure_failing()
	for(var/mob/player in GLOB.mobs_in_sectors[src])
		to_chat(player,"<span class = 'danger'>SHIP SUPERSTRUCTURE FAILING. ETA: [SUPERSTRUCTURE_FAIL_TIME/600] minutes.</span>")
	superstructure_failing = 1
	spawn(SUPERSTRUCTURE_FAIL_TIME)
		do_superstructure_fail()

/obj/effect/overmap/process()
	if(!isnull(targeting_datum.current_target) && !(targeting_datum.current_target in range(src,7)))
		targeting_datum.current_target = null
		targeting_datum.targeted_location = "target lost"
	if(superstructure_failing == -1)
		return
	if(superstructure_failing == 1 && (world.time % 4) == 0)
		if(hull_segments.len == 0)
			return
		var/obj/explode_at = pick(hull_segments)
		explosion(explode_at.loc,0,1,3,5, adminlog = 0)
		return
	var/list/superstructure_strength = get_superstructure_strength()
	if(isnull(superstructure_strength))
		superstructure_failing = -1
		return
	if(superstructure_strength <= SUPERSTRUCTURE_FAIL_PERCENT)
		pre_superstructure_failing()

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	layer = TURF_LAYER
	anchored = 1

/obj/effect/overmap/sector/Initialize()
	. = ..()
	GLOB.processing_objects += src
	for(var/obj/machinery/computer/helm/H in GLOB.machines)
		H.get_known_sectors()

/obj/effect/overmap/proc/adminwarn_attack(var/attacker)
	if(world.time > last_adminwarn_attack + 1 MINUTE)
		last_adminwarn_attack = world.time
		var/msg = "[src] is under attack[attacker ? " by [attacker]" : ""]"
		log_admin(msg)
		message_admins(msg)

/proc/build_overmap()
	if(!GLOB.using_map.use_overmap)
		return 1

	report_progress("Building overmap...")
	world.maxz++
	GLOB.using_map.overmap_z = world.maxz
	var/list/turfs = list()
	for (var/square in block(locate(1,1,GLOB.using_map.overmap_z), locate(GLOB.using_map.overmap_size,GLOB.using_map.overmap_size,GLOB.using_map.overmap_z)))
		var/turf/T = square
		if(T.x == GLOB.using_map.overmap_size || T.y == GLOB.using_map.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map/)
			GLOB.overmap_tiles_uncontrolled += T
		T.lighting_clear_overlay()
		turfs += T

	var/area/overmap/A = new
	A.contents.Add(turfs)

	GLOB.using_map.sealed_levels |= GLOB.using_map.overmap_z

	report_progress("Overmap build complete.")
	shipmap_handler.max_z_cached = world.maxz
	return 1


