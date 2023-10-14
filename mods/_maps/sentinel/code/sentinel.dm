
	///////////
	//OVERMAP//
	///////////

/obj/overmap/visitable/ship/patrol
	name = "SCGF Patrol Craft"
	desc = "SCGF Cobra-class Patrol Craft. Seconded to Battlegroup Bravo of Fifth Fleet "
	color = "#990000"
	fore_dir = WEST
	vessel_mass = 1000
	known_ships = list(/obj/overmap/visitable/ship/landable/reaper)
	vessel_size = SHIP_SIZE_SMALL
	start_x = 1
	start_y = 1

	initial_generic_waypoints = list(
		"nav_patrol_1",
		"nav_patrol_2",
		"nav_patrol_3",
		"nav_patrol_4",
		"nav_hangar_reaper"
	)

	initial_restricted_waypoints = list(
		"Reaper" = list("nav_hangar_reaper")
	)


#define PATROL_SHIP_PREFIX pick("Sentinel","Cavalry","Scarabaeus","Heretic","Apocalypse","Calamatious","Terror","Pandemonium","Anubis","Hound","Stalker","Avatar","Ultimatum","Goliath","Tyrant","Nemesis","Hydra","Stormhawk","Manticore","Basilisk")
/obj/overmap/visitable/ship/patrol/New()
	name = "SFV [PATROL_SHIP_PREFIX], \a [name]"
	for(var/area/ship/patrol/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	..()
#undef PATROL_SHIP_PREFIX


/datum/map_template/ruin/away_site/patrol
	name = "Sol Patrol Craft (SFV)"
	id = "awaysite_patrol_ship"
	description = "Cobra-class Patrol Craft."
	prefix = "mods/_maps/sentinel/maps/"
	suffixes = list("sentinel-1.dmm", "sentinel-2.dmm")
	spawn_cost = 0.5
	player_cost = 7
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/reaper)

	area_usage_test_exempted_areas = list(
		/area/turbolift/sentinel_first,
		/area/turbolift/sentinel_second
	)

/obj/shuttle_landmark/nav_patrol/nav1
	name = "Patrol Ship Fore"
	landmark_tag = "nav_patrol_1"

/obj/shuttle_landmark/nav_patrol/nav2
	name = "Patrol Ship Aft"
	landmark_tag = "nav_patrol_2"

/obj/shuttle_landmark/nav_patrol/nav3
	name = "Patrol Ship Port"
	landmark_tag = "nav_patrol_3"

/obj/shuttle_landmark/nav_patrol/nav4
	name = "Patrol Ship Starboard"
	landmark_tag = "nav_patrol_4"

/obj/submap_landmark/joinable_submap/patrol
	name = "Sol Patrol Ship"
	archetype = /singleton/submap_archetype/away_scg_patrol

/* TCOMMS
 * ======
 */

/obj/machinery/telecomms/allinone/away_scg_patrol
	listening_freqs = list(SFV_FREQ)
	channel_color = COMMS_COLOR_CENTCOMM
	channel_name = "SCG Patrol"
	circuitboard = /obj/item/stock_parts/circuitboard/telecomms/allinone/away_scg_patrol

/obj/item/stock_parts/circuitboard/telecomms/allinone/away_scg_patrol
	build_path = /obj/machinery/telecomms/allinone/away_scg_patrol

/obj/item/device/radio/headset/away_scg_patrol
	name = "SCG Patrol headset"
	icon_state = "nt_headset"
	ks1type = /obj/item/device/encryptionkey/away_scg_patrol

/obj/item/device/radio/headset/away_scg_patrol/Initialize()
	. = ..()
	set_frequency(SFV_FREQ)	//Not going to be random or just set to the common frequency, but can be set later.

/obj/item/device/encryptionkey/away_scg_patrol
	name = "SCG Patrol radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("SCG Patrol" = 1)
