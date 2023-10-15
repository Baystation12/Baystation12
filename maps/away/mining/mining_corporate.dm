/obj/overmap/visitable/sector/corporate
	name = "Mining - NanoTrasen outpost"
	desc = "Sensors capture corporate signal: For authorized NanoTrasen personnel only."
	icon_state = "sector"
	initial_restricted_waypoints = list(
		"Guppy" = list("nav_corporate_8", "nav_corporate_hiden"),
		"Data Capsule" = list("nav_corporate_hiden")
	)
	initial_generic_waypoints = list(
		"nav_corporate_1",
		"nav_corporate_2",
		"nav_corporate_3",
		"nav_corporate_4",
		"nav_corporate_5",
		"nav_corporate_6",
		"nav_corporate_7",
		"nav_corporate_9"
	)

/obj/overmap/visitable/sector/corporate/generate_skybox()
	var/image/res = overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)
	res.blend_mode = BLEND_OVERLAY
	return res

/obj/overmap/visitable/sector/corporate/get_skybox_representation()
	var/image/res = overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)
	res.blend_mode = BLEND_OVERLAY
	res.SetTransform(scale = 0.5)
	return res

/singleton/map_template/ruin/away_site/mining_corporate
	name = "Mining - Corporate"
	id = "awaysite_mining_corporate"
	description = "A medium-sized asteroid full of minerals. Old mining facility detected at one of sides, owner - NanoTrasen."
	suffixes = list("mining/mining-corporate.dmm")
	spawn_cost = 1
	accessibility_weight = 10
	generate_mining_by_z = 1
	area_usage_test_exempted_root_areas = list(/area/mine, /area/outpost)
	area_usage_test_exempted_areas = list(/area/djstation, /area/shuttle/abadoned_data_capsule)
	apc_test_exempt_areas = list(
		/area/mine/explored = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/mine/unexplored = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/outpost/mining/solar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/outpost/mining/maints = NO_SCRUBBER|NO_VENT,
		/area/outpost/mining/atmos = NO_SCRUBBER|NO_VENT,
		/area/outpost/mining/relay = NO_SCRUBBER|NO_VENT,
		/area/shuttle/abadoned_data_capsule = NO_SCRUBBER|NO_VENT
	)
	area_coherency_test_exempt_areas =  list(/area/mine/explored, /area/mine/unexplored)

	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/data_capsule)

/obj/shuttle_landmark/corporate/nav1
	name = "Asteroid Navpoint #1"
	landmark_tag = "nav_corporate_1"

/obj/shuttle_landmark/corporate/nav2
	name = "Asteroid Navpoint #2"
	landmark_tag = "nav_corporate_2"

/obj/shuttle_landmark/corporate/nav4
	name = "Asteroid Navpoint #3"
	landmark_tag = "nav_corporate_3"

/obj/shuttle_landmark/corporate/nav6
	name = "Asteroid Navpoint #4"
	landmark_tag = "nav_corporate_4"

/obj/shuttle_landmark/corporate/nav5
	name = "Asteroid Landing zone #1"
	landmark_tag = "nav_corporate_5"
	base_area = /area/mine/explored
	base_turf = /turf/simulated/floor/asteroid

/obj/shuttle_landmark/corporate/nav7
	name = "Asteroid Landing zone #2"
	landmark_tag = "nav_corporate_6"
	base_area = /area/mine/explored
	base_turf = /turf/simulated/floor/asteroid

/obj/shuttle_landmark/corporate/nav8
	name = "Asteroid Mining Outpost Hangar"
	landmark_tag = "nav_corporate_7"
	base_area = /area/outpost/mining/hangar
	base_turf = /turf/simulated/floor/plating

/obj/shuttle_landmark/corporate/nav9
	name = "Asteroid Mining Outpost"
	landmark_tag = "nav_corporate_8"

/obj/shuttle_landmark/corporate/nav3
	name = "Mining Asteroid Center"
	landmark_tag = "nav_corporate_antag"

// PREPAINTED WALLS

/turf/simulated/wall/prepainted/mining_corporate/paint_color = COLOR_WALL_GUNMETAL

// DATA CAPSULE SHUTTLE

/obj/shuttle_landmark/corporate/nav_hiden
	name = "Mining Asteroid ???"
	landmark_tag = "nav_corporate_hiden"
	base_area = /area/mine/unexplored
	base_turf = /turf/simulated/floor/asteroid

/area/shuttle/abadoned_data_capsule
	name = "Data Capsule"
	icon_state = "shuttlegrn"
	requires_power = TRUE
	dynamic_lighting = TRUE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/datum/shuttle/autodock/overmap/data_capsule
	name = "Data Capsule"
	move_time = 30
	shuttle_area = list(/area/shuttle/abadoned_data_capsule)
	current_location = "nav_corporate_hiden"
	landmark_transition = "nav_transit_blueriver"

	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'

	range = 1
	fuel_consumption = 2
	warmup_time = 5
	defer_initialisation = TRUE
	skill_needed = SKILL_BASIC

	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/machinery/computer/shuttle_control/explore/data_capsule
	name = "data capsule control console"
	shuttle_tag = "Data Capsule"

/obj/overmap/visitable/ship/landable/data_capsule
	name = "Data Capsule"
	shuttle = "Data Capsule"
	max_speed = 1/(10 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 250
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	skill_needed = SKILL_BASIC

// AREAS

/area/outpost/mining
	name = "Mining Outpost Equipment"
	icon_state = "outpost_mine_main"
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT
	sound_env = STANDARD_STATION
	base_turf = /turf/simulated/floor/asteroid
	req_access = list(list(access_mining, access_xenoarch))

/area/outpost/mining/hangar
	name = "Mining Outpost Hangar"
	sound_env = LARGE_ENCLOSED

/area/outpost/mining/recreation
	name = "Mining Outpost Recreation Section"

/area/outpost/mining/kitchen
	name = "Mining Outpost Kitchen"

/area/outpost/mining/toilet
	name = "Mining Outpost Restroom"
	sound_env = SMALL_ENCLOSED

/area/outpost/mining/power
	name = "Mining Outpost Solar Control"

/area/outpost/mining/atmos
	name = "Mining Outpost Atmospheric"

/area/outpost/mining/voidsuits
	name = "Mining Outpost Voidsuits"

/area/outpost/mining/cenral
	name = "Mining Outpost Central"

/area/outpost/mining/maints
	name = "Mining Outpost Maintenance"

/area/outpost/mining/medical
	name = "Mining Outpost Medical Comparement"

/area/outpost/mining/relay
	name = "Mining Outpost Communication Relay"

/area/outpost/mining/solar
	name = "Mining Outpost Solar Array"
	area_flags = AREA_FLAG_EXTERNAL
	requires_power = TRUE
	always_unpowered = TRUE
	has_gravity = FALSE
	base_turf = /turf/space
	turf_initializer = null
