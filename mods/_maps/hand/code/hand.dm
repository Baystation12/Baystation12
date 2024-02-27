	///////////
	//OVERMAP//
	///////////

/obj/overmap/visitable/ship/hand
	name = "Salvage Vessel"
	desc = "Hyena-class salvage vessel used by countless independent prospectors and corporates alike"
	color = "#40e200"
	fore_dir = NORTH
	vessel_mass = 3000
	known_ships = list(
		/obj/overmap/visitable/ship/landable/graysontug/hand_one,
		/obj/overmap/visitable/ship/landable/graysontug/hand_two,
		/obj/overmap/visitable/ship/landable/pod_hand_one,
		/obj/overmap/visitable/ship/landable/pod_hand_two
		)
	vessel_size = SHIP_SIZE_SMALL

	initial_generic_waypoints = list(
		"nav_hand_1",
		"nav_hand_2",
		"nav_hand_3",
		"nav_hand_4"
	)

	initial_restricted_waypoints = list(
		"Hyena GM Tug-1" = list("nav_handtugone_start"),
		"Hyena GM Tug-2" = list("nav_handtugtwo_start"),
		"EE S-class 18-24-1" = list("nav_handpodone_start"),
		"EE S-class 18-24-2" = list("nav_handpodtwo_start")
	)


#define HAND_SHIP_PREFIX pick("FTU Freeman", "SFV Adrian", "NTV Calhoun", "HIV-T Tapir", "GrM Carrion", "SAV Kilo", "EE T-class 36-78")
/obj/overmap/visitable/ship/hand/New()
	name = "[HAND_SHIP_PREFIX], \a [name]"
	for(var/area/ship/hand/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	..()
#undef HAND_SHIP_PREFIX


/datum/map_template/ruin/away_site/hand
	name = "Salvage Vessel (FAV)"
	id = "awaysite_hand_ship"
	description = "Hyena-class salvage vessel."
	prefix = "mods/_maps/hand/maps/"
	suffixes = list("hand-1.dmm", "hand-2.dmm")
	spawn_cost = 0.5
	player_cost = 7
	spawn_weight = 1
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/graysontug/hand_one,
		/datum/shuttle/autodock/overmap/graysontug/hand_two,
		/datum/shuttle/autodock/overmap/pod_hand_one,
		/datum/shuttle/autodock/overmap/pod_hand_two
		)


/obj/shuttle_landmark/nav_hand/nav1
	name = "hand Ship Fore"
	landmark_tag = "nav_hand_1"

/obj/shuttle_landmark/nav_hand/nav2
	name = "hand Ship Aft"
	landmark_tag = "nav_hand_2"

/obj/shuttle_landmark/nav_hand/nav3
	name = "hand Ship Port"
	landmark_tag = "nav_hand_3"

/obj/shuttle_landmark/nav_hand/nav4
	name = "hand Ship Starboard"
	landmark_tag = "nav_hand_4"

/obj/submap_landmark/joinable_submap/hand
	name = "FA Salvage Vessel"
	archetype = /singleton/submap_archetype/away_hand
