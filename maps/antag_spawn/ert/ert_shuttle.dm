/datum/shuttle/autodock/multi/antag/ert
	name = "SFV Rook"
	defer_initialisation = TRUE
	knockdown = FALSE
	warmup_time = 5
	move_time = 30
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/ert

	dock_target = "ert_shuttle"
	current_location = "nav_ert_start"
	landmark_transition = "nav_ert_transit"
	home_waypoint = "nav_ert_start"

	destination_tags = list(
		"nav_ert_bridge",
		"nav_ert_bridge_2",
		"nav_ert_deck1",
		"nav_ert_deck2",
		"nav_ert_deck3",
		"nav_ert_dock_2",
		"nav_ert_dock",
		"nav_ert_start",
		"nav_merc_4",
		"nav_away_4",
		"nav_derelict_4",
		"nav_cluster_4",
		"nav_lost_supply_base_antag",
		"nav_marooned_antag",
		"nav_smugglers_antag",
		"nav_magshield_antag",
		"nav_casino_antag",
		"nav_yacht_antag",
		"nav_slavers_base_antag"
		)

/datum/shuttle/autodock/multi/antag/ert/New()
	shuttle_area = subtypesof(/area/map_template/ert/shuttle)
	..()
	// QoL: Sets the shuttle's docking code to the using_map default docking code
	if(dock_target && GLOB.using_map.use_overmap)
		var/obj/shuttle_landmark/L = SSshuttle.get_landmark("nav_ert_dock")
		if(L)
			var/obj/overmap/visitable/loc = map_sectors["[L.z]"]
			if(loc?.docking_codes)
				set_docking_codes(loc.docking_codes)

/datum/shuttle/autodock/multi/antag/ert/launch()
	..()
	GLOB.ert.arrive()

/datum/shuttle/autodock/multi/antag/ert/announce_arrival()
	..()
	message_admins("The ERT shuttle is enroute.")

// Shuttle Stuff

/turf/simulated/floor/shuttle_ceiling/ert
	color = COLOR_DARK_BLUE_GRAY

/obj/machinery/computer/shuttle_control/multi/ert
	name = "\improper SFV Rook control console"
	req_access = list(access_ert_responder)
	shuttle_tag = "SFV Rook"

/obj/machinery/computer/shuttle_control/multi/ert/emag_act(remaining_charges, mob/user)
	to_chat(user, SPAN_WARNING("\The [src] is protected. It seems that you are unable to do anything with it."))
	return NO_EMAG_ACT

// Landmarks
// These are map specific for the ERT spawn ship, other landmarks for ERT can be found in map specific files

/obj/shuttle_landmark/ert/start
	name =  "SFV Trident, Hangar Bay"
	landmark_tag = "nav_ert_start"
	base_turf = /turf/simulated/floor/tiled/techfloor

/obj/shuttle_landmark/ert/transit
	name = "In Flight"
	landmark_tag = "nav_ert_transit"

// Areas

/area/map_template/ert/shuttle
	name = "SFV Rook"
	icon_state = "shuttlered"
	dynamic_lighting = TRUE
	requires_power = TRUE
	req_access = list(access_cent_specops)
	base_turf = /turf/simulated/floor/tiled/techfloor

	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

/area/map_template/ert/shuttle/cockpit
	req_access = list(access_ert_responder)

/area/map_template/ert/shuttle/engines
	name = "SFV Rook - Engineering Compartment"

/area/map_template/ert/shuttle/medbay
	name = "SFV Rook - Medical Compartment"
	req_access = list(access_cent_medical)

/area/map_template/ert/shuttle/armory
	name = "SFV Rook - Armory"
	req_access = list(access_ert_responder)

/area/map_template/ert/shuttle/storage
	name = "SFV Rook - Storage"

/area/map_template/ert/shuttle/central
	name = "SFV Rook - Crew Compartment"

/area/map_template/ert/shuttle/airlock
	name = "SFV Rook - Aft Crew Compartment"
