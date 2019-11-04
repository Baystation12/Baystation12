// Submap shuttles.
// Trichoptera - Shuttle One, Port Side
// Lepidoptera - Shuttle Two, Starboard Side
/obj/effect/overmap/visitable/ship/landable/ascent
	name = "Trichoptera"
	shuttle = "Trichoptera"
	moving_state = "ship_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/ascent/two
	name = "Lepidoptera"
	shuttle = "Lepidoptera"
	fore_dir = NORTH

/obj/machinery/computer/shuttle_control/explore/ascent
	name = "shuttle control console"
	shuttle_tag = "Trichoptera"
	icon_state = "ascent"
	icon_keyboard = "ascent_key"
	icon_screen = "ascent_screen"
	req_access = list(access_ascent)

/obj/machinery/computer/shuttle_control/explore/ascent/two
	name = "shuttle control console"
	shuttle_tag = "Lepidoptera"

/obj/effect/shuttle_landmark/ascent_seedship/start
	name = "Trichoptera Docked"
	landmark_tag = "nav_hangar_ascent_one"
	docking_controller = "ascent_port_dock"
	base_area = /area/ship/ascent/wing_port
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/ascent_seedship/start/two
	name = "Lepidoptera Docked"
	landmark_tag = "nav_hangar_ascent_two"
	docking_controller = "ascent_starboard_dock"
	base_area = /area/ship/ascent/wing_starboard

/datum/shuttle/autodock/overmap/ascent
	name = "Trichoptera"
	warmup_time = 5
	current_location = "nav_hangar_ascent_one"
	range = 2
	dock_target = "ascent_port_shuttle_dock"
	shuttle_area = /area/ship/ascent/shuttle_port
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_BASIC
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/ascent

/datum/shuttle/autodock/overmap/ascent/two
	name = "Lepidoptera"
	warmup_time = 5
	current_location = "nav_hangar_ascent_two"
	range = 2
	dock_target = "ascent_starboard"
	shuttle_area = /area/ship/ascent/shuttle_starboard
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_NONE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/ascent