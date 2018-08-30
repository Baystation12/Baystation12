/obj/turbolift_map_holder/torch
	name = "Torch turbolift map placeholder"
	depth = 5
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/turbolift/torch_ground,
		/area/turbolift/torch_first,
		/area/turbolift/torch_second,
		/area/turbolift/torch_third,
		/area/turbolift/torch_top
		)

/obj/machinery/computer/shuttle_control/lift
	name = "cargo lift controls"
	shuttle_tag = "Cargo Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/datum/shuttle/autodock/ferry/robotics_lift
	name = "Robotics Lift"
	shuttle_area = /area/turbolift/torch_robotics_lift
	warmup_time = 3
	waypoint_station = "nav_robotics_lift_bottom"
	waypoint_offsite = "nav_robotics_lift_top"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/lift/robotics
	name = "robotics lift controls"
	shuttle_tag = "Robotics Lift"

/obj/effect/shuttle_landmark/robo_lift/top
	name = "Top Deck"
	landmark_tag = "nav_robotics_lift_top"
	autoset = 1

/obj/effect/shuttle_landmark/robo_lift/bottom
	name = "Lower Deck"
	landmark_tag = "nav_robotics_lift_bottom"
	base_area = /area/assembly/robotics
	base_turf = /turf/simulated/floor/plating
