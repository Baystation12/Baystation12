/obj/effect/overmap/visitable/ship/landable/scavver_gantry
	name = "ITV The Reclaimer"
	shuttle = "ITV The Reclaimer"
	desc = "Sensor array detects a small vessel, broadcasting itself as 'ITV The Reclaimer'"
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	moving_state = "ship_moving"
	max_speed = 1/(10 SECONDS)
	burn_delay = 10 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/scavver_gantry/two
	name = "Unmarked shuttle"
	shuttle = "ITV Vulcan"
	desc = "Sensor array detects a tiny, unmarked vessel."
	fore_dir = NORTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/scavver_gantry
	name = "landing control console"
	shuttle_tag = "ITV The Reclaimer"

/obj/machinery/computer/shuttle_control/explore/scavver_gantry/two
	name = "landing control console"
	shuttle_tag = "ITV Vulcan"

/datum/shuttle/autodock/overmap/scavver_gantry
	name = "ITV The Reclaimer"
	move_time = 25
	shuttle_area = list(/area/scavver/lifepod)
	current_location = "nav_hangar_gantry_one"
	landmark_transition = "nav_transit_gantry_one"
	range = 1
	fuel_consumption = 7
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE

/datum/shuttle/autodock/overmap/scavver_gantry/two
	name = "ITV Vulcan"
	move_time = 25
	shuttle_area = list(/area/scavver/escapepod)
	current_location = "nav_hangar_gantry_two"
	landmark_transition = "nav_transit_gantry_two"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/scavver_gantry
	name = "The Reclaimer Dock"
	landmark_tag = "nav_hangar_gantry_one"
	base_area = /area/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/transit/scavver_gantry
	name = "In transit"
	landmark_tag = "nav_transit_gantry_one"

/obj/effect/shuttle_landmark/scavver_gantry/two
	name = "Vulcan Dock"
	landmark_tag = "nav_hangar_gantry_two"
	base_area = /area/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/transit/scavver_gantry/two
	name = "In transit"
	landmark_tag = "nav_transit_gantry_two"

/obj/effect/shuttle_landmark/scavver_gantry/generic
	name = "Unknown Vessel Dock One"
	landmark_tag = "nav_gantry_one"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/two
	name = "Unknown Vessel Dock Two"
	landmark_tag = "nav_gantry_two"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/three
	name = "Unknown Vessel Dock Three"
	landmark_tag = "nav_gantry_three"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/four
	name = "Unknown Vessel Dock Four"
	landmark_tag = "nav_gantry_four"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/five
	name = "Unknown Vessel Dock Five"
	landmark_tag = "nav_gantry_five"
	base_area = /area/space

//elevator

/obj/machinery/computer/shuttle_control/lift/gantry
	name = "cargo lift controls"
	shuttle_tag = "Gantry Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/datum/shuttle/autodock/ferry/gantry
	name = "Gantry Lift"
	shuttle_area = /area/scavver/gantry/lift
	warmup_time = 3
	waypoint_station = "nav_scavver_gantry_lift_top"
	waypoint_offsite = "nav_scavver_gantry_lift_bottom"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/lift/gantry/top
	name = "Top Deck"
	landmark_tag = "nav_scavver_gantry_lift_top"
	base_area = /area/scavver/gantry/up1
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/gantry/bottom
	name = "Lower Deck"
	landmark_tag = "nav_scavver_gantry_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/scavver/gantry/down1
	base_turf = /turf/simulated/floor/airless
