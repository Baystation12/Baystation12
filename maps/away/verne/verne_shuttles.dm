
/obj/machinery/computer/shuttle_control/explore/verne
	name = "shuttle control console"
	shuttle_tag = "SRV Venerable Catfish"
	req_access = list(access_verne)

/obj/effect/overmap/visitable/ship/landable/verne
	name = "SRV Venerable Catfish"
	shuttle = "SRV Venerable Catfish"
	desc = "An SSE-U17 long range shuttle, broadcasting SCGRV codes and the callsign \"SRV Verne-1 Venerable Catfish\"."
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	moving_state = "ship_moving"
	max_speed = 1/(2 SECONDS) //same stats as charon
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	skill_needed = SKILL_BASIC

/datum/shuttle/autodock/overmap/verne
	name = "SRV Venerable Catfish"
	move_time = 90
	shuttle_area = list(
		/area/verne/catfish,
		/area/verne/catfish/engineering,
	)
	dock_target = "catfish_shuttle"
	current_location = "nav_hangar_verne"
	landmark_transition = "nav_transit_verne"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/verne/dock
	name = "SRV Venerable Catfish Hangar"
	landmark_tag = "nav_hangar_verne"
	base_area = /area/verne/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/nav_verne/nav1
	name = "CTI Research Vessel Deck 1 Port"
	landmark_tag = "nav_verne_1"

/obj/effect/shuttle_landmark/nav_verne/nav2
	name = "CTI Research Vessel Deck 2 Starboard"
	landmark_tag = "nav_verne_2"

/obj/effect/shuttle_landmark/nav_verne/nav3
	name = "CTI Research Vessel Deck 3 Port"
	landmark_tag = "nav_verne_3"

/obj/effect/shuttle_landmark/nav_verne/nav4
	name = "CTI Research Vessel Deck 3 Under Hangar"
	landmark_tag = "nav_verne_4"

/obj/effect/shuttle_landmark/nav_verne/torch
	name = "SEV Torch Venerable Catfish Dock"
	landmark_tag = "nav_verne_5"

/obj/effect/shuttle_landmark/transit/verne
	name = "In transit"
	landmark_tag = "nav_transit_verne"

//elevator

/obj/machinery/computer/shuttle_control/lift/verne
	name = "cargo lift controls"
	shuttle_tag = "Verne Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = FALSE

/datum/shuttle/autodock/ferry/verne
	name = "Verne Lift"
	shuttle_area = /area/verne/lift
	warmup_time = 3
	waypoint_station = "nav_verne_lift_top"
	waypoint_offsite = "nav_verne_lift_bottom"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/lift/verne/top
	name = "Top Deck"
	landmark_tag = "nav_verne_lift_top"
	base_area = /area/verne/engineering/smresearch/access
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/verne/bottom
	name = "Lower Deck"
	landmark_tag = "nav_verne_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/verne/engineering/smresearch/access/lower
	base_turf = /turf/simulated/floor/plating
