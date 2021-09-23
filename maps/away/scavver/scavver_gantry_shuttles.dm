/obj/effect/overmap/visitable/ship/landable/scavver_gantry
	name = "ITV The Reclaimer"
	shuttle = "ITV The Reclaimer"
	desc = "Sensor array detects a small vessel, claiming to be 'ITV The Reclaimer', an 'Armalev Industries Skyfin-E, Exoplanetary Suvival Pod'. Your sensors array describes the vessel exterior as 'irreconcilable' with the exterior of a 'Skyfin-E'"
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	moving_state = "ship_moving"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 6000
	fore_dir = SOUTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/overmap/visitable/ship/landable/scavver_gantry/two
	name = "ITV Vulcan"
	shuttle = "ITV Vulcan"
	desc = "Sensor array detects a tiny vessel, claiming to be 'ITV Vulcan', a utility pod of unknown make."
	fore_dir = NORTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_TINY
	moving_state = "ship_moving"
	max_speed = 1/(4 SECONDS)
	burn_delay = 2.5 SECONDS
	vessel_mass = 3500 //more inefficient than GUP

/obj/effect/overmap/visitable/ship/landable/scavver_gantry/three
	name = "Unmarked shuttle"
	shuttle = "ITV Spiritus"
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

/obj/machinery/computer/shuttle_control/explore/scavver_gantry/three
	name = "landing control console"
	shuttle_tag = "ITV Spiritus"

/datum/shuttle/autodock/overmap/scavver_gantry
	name = "ITV The Reclaimer"
	warmup_time = 5
	move_time = 95
	shuttle_area = list(/area/scavver/lifepod)
	current_location = "nav_hangar_gantry_one"
	landmark_transition = "nav_transit_gantry_one"
	range = 1
	fuel_consumption = 5
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE

/datum/shuttle/autodock/overmap/scavver_gantry/two
	name = "ITV Vulcan"
	warmup_time = 5
	move_time = 35
	shuttle_area = list(/area/scavver/escapepod)
	current_location = "nav_hangar_gantry_two"
	landmark_transition = "nav_transit_gantry_two"
	range = 1
	fuel_consumption = 3
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE

/datum/shuttle/autodock/overmap/scavver_gantry/three
	name = "ITV Spiritus"
	warmup_time = 5
	move_time = 35
	shuttle_area = list(/area/scavver/harvestpod)
	current_location = "nav_hangar_gantry_three"
	landmark_transition = "nav_transit_gantry_three"
	range = 1
	fuel_consumption = 5
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

/obj/effect/shuttle_landmark/scavver_gantry/three
	name = "Spiritus Dock"
	landmark_tag = "nav_hangar_gantry_three"
	base_area = /area/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/scavver_gantry/four
	name = "Fuel - Reclaimer - Spiritus Dock"
	landmark_tag = "nav_hangar_gantry_four"

/obj/effect/shuttle_landmark/scavver_gantry/five
	name = "Fuel - Yacht Upper - Spiritus Dock"
	landmark_tag = "nav_hangar_gantry_five"

/obj/effect/shuttle_landmark/scavver_gantry/six
	name = "Fuel - Yacht Lower - Spiritus Dock"
	landmark_tag = "nav_hangar_gantry_six"

/obj/effect/shuttle_landmark/scavver_gantry/torch
	name = "SEV Torch ITV The Reclaimer Dock"
	landmark_tag = "nav_hangar_gantry_torch"

/obj/effect/shuttle_landmark/scavver_gantry/torch/two
	name = "SEV Torch ITV Vulcan Dock"
	landmark_tag = "nav_hangar_gantry_torch_two"

/obj/effect/shuttle_landmark/scavver_gantry/torch/three
	name = "SEV Torch ITV Spiritus Dock"
	landmark_tag = "nav_hangar_gantry_torch_three"

/obj/effect/shuttle_landmark/transit/scavver_gantry/three
	name = "In transit"
	landmark_tag = "nav_transit_gantry_three"

/obj/effect/shuttle_landmark/scavver_gantry/generic
	name = "Dock One"
	landmark_tag = "nav_gantry_one"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/two
	name = "Dock Two"
	landmark_tag = "nav_gantry_two"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/three
	name = "Dock Three"
	landmark_tag = "nav_gantry_three"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/four
	name = "Dock Four"
	landmark_tag = "nav_gantry_four"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/five
	name = "Dock Five"
	landmark_tag = "nav_gantry_five"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/gup
	name = "GUP Dock"
	landmark_tag = "nav_gantry_gup"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/charon
	name = "Charon Dock"
	landmark_tag = "nav_gantry_charon"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/aquila
	name = "Aquila Dock"
	landmark_tag = "nav_gantry_aquila"
	base_area = /area/space

/obj/effect/shuttle_landmark/scavver_gantry/generic/desperado
	name = "Desperado Dock"
	landmark_tag = "nav_gantry_desperado"
	base_area = /area/space
//elevator

/obj/machinery/computer/shuttle_control/lift/gantry
	name = "cargo lift controls"
	shuttle_tag = "Gantry Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = FALSE

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

/decl/stock_part_preset/radio/receiver/vent_pump/vulcan
	frequency = 1431

/decl/stock_part_preset/radio/event_transmitter/vent_pump/vulcan
	frequency = 1431

/obj/machinery/atmospherics/unary/vent_pump/high_volume/vulcan
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/vulcan = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/vulcan = 1
	)

/decl/stock_part_preset/radio/receiver/vent_scrubber/vulcan
	frequency = 1431

/decl/stock_part_preset/radio/event_transmitter/vent_scrubber/vulcan
	frequency = 1431

/obj/machinery/atmospherics/unary/vent_scrubber/vulcan
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_scrubber/vulcan = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_scrubber/vulcan = 1
	)