/datum/shuttle/autodock/overmap/graysontug/hand_one
	name = "Hyena GM Tug-1"
	dock_target = "handtugone_shuttle"
	current_location = "nav_handtugone_start"
	range = 1
	shuttle_area = /area/ship/hand/shuttle/tug_one
	fuel_consumption = 4
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_MIN
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/datum/shuttle/autodock/overmap/graysontug/hand_two
	name = "Hyena GM Tug-2"
	dock_target = "handtugtwo_shuttle"
	current_location = "nav_handtugtwo_start"
	range = 1
	shuttle_area = /area/ship/hand/shuttle/tug_two
	fuel_consumption = 4
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_MIN
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/machinery/computer/shuttle_control/explore/graysontug/hand_one
	name = "GM Tug Shuttle control console"
	shuttle_tag = "Hyena GM Tug-1"

/obj/machinery/computer/shuttle_control/explore/graysontug/hand_two
	name = "GM Tug Shuttle control console"
	shuttle_tag = "Hyena GM Tug-2"

/obj/overmap/visitable/ship/landable/graysontug/hand_one
	name = "GM Tug"
	desc = "Grayson Manufactories Tug. Space truckin commonly seen across Frontier."
	shuttle = "Hyena GM Tug-1"
	fore_dir = NORTH
	color = "#e6f7ff"
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY
	known_ships = list(
		/obj/overmap/visitable/ship/hand,
		/obj/overmap/visitable/ship/landable/graysontug/hand_two,
		/obj/overmap/visitable/ship/landable/pod_hand_one,
		/obj/overmap/visitable/ship/landable/pod_hand_two
		)

/obj/overmap/visitable/ship/landable/graysontug/hand_two
	name = "GM Tug"
	desc = "Grayson Manufactories Tug. Space truckin commonly seen across Frontier."
	shuttle = "Hyena GM Tug-2"
	fore_dir = NORTH
	color = "#e6f7ff"
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY
	known_ships = list(
		/obj/overmap/visitable/ship/hand,
		/obj/overmap/visitable/ship/landable/graysontug/hand_one,
		/obj/overmap/visitable/ship/landable/pod_hand_one,
		/obj/overmap/visitable/ship/landable/pod_hand_two
		)

/area/ship/hand/shuttle/tug_one
	name = "\improper GM Tug"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/hand/shuttle/tug_two
	name = "\improper GM Tug"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/obj/shuttle_landmark/handtugone/start
	name = "Port Tug Dock"
	landmark_tag = "nav_handtugone_start"
	docking_controller = "handtugone_port_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/shuttle_landmark/handtugtwo/start
	name = "Starboard Tug Dock"
	landmark_tag = "nav_handtugtwo_start"
	docking_controller = "handtugtwo_port_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/datum/shuttle/autodock/overmap/pod_hand_one
	name = "EE S-class 18-24-1"
	warmup_time = 5
	current_location = "nav_handpodone_start"
	range = 2
	shuttle_area = list(/area/ship/hand/shuttle/pod_hand_one)
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_BASIC
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/datum/shuttle/autodock/overmap/pod_hand_two
	name = "EE S-class 18-24-2"
	warmup_time = 5
	current_location = "nav_handpodtwo_start"
	range = 2
	shuttle_area = list(/area/ship/hand/shuttle/pod_hand_one)
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_BASIC
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/machinery/computer/shuttle_control/explore/pod_hand_one
	name = "EE S-class 18-24 Shuttle control console"
	shuttle_tag = "EE S-class 18-24-1"

/obj/machinery/computer/shuttle_control/explore/pod_hand_two
	name = "EE S-class 18-24 Shuttle control console"
	shuttle_tag = "EE S-class 18-24-2"


/obj/overmap/visitable/ship/landable/pod_hand_one
	shuttle = "EE S-class 18-24-1"
	name = "EE S-class 18-24-1"
	desc = "Einstein Engines S-class pod. Universal takeoff and landing module."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	fore_dir = NORTH
	color = "#e6f7ff"
	vessel_mass = 500
	vessel_size = SHIP_SIZE_TINY
	known_ships = list(
		/obj/overmap/visitable/ship/landable/graysontug/hand_one,
		/obj/overmap/visitable/ship/landable/graysontug/hand_two,
		/obj/overmap/visitable/ship/landable/pod_hand_two,
		/obj/overmap/visitable/ship/hand
	)

/obj/overmap/visitable/ship/landable/pod_hand_two
	shuttle = "EE S-class 18-24-2"
	name = "EE S-class 18-24-2"
	desc = "Einstein Engines S-class pod. Universal takeoff and landing module."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	fore_dir = NORTH
	color = "#e6f7ff"
	vessel_mass = 500
	vessel_size = SHIP_SIZE_TINY
	known_ships = list(
		/obj/overmap/visitable/ship/landable/graysontug/hand_one,
		/obj/overmap/visitable/ship/landable/graysontug/hand_two,
		/obj/overmap/visitable/ship/landable/pod_hand_one,
		/obj/overmap/visitable/ship/hand
	)

/area/ship/hand/shuttle/pod_hand_one
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/hand/shuttle/pod_hand_two
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/obj/shuttle_landmark/pod_hand_one/start
	name = "Port EE S-class Dock"
	landmark_tag = "nav_handpodone_start"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/shuttle_landmark/pod_hand_two/start
	name = "Starboard EE S-class Dock"
	landmark_tag = "nav_handpodtwo_start"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
