/datum/shuttle/autodock/overmap/swordfish
	name = "Swordfish"
	warmup_time = 5
	dock_target = "bearcat_dock_port"
	current_location = "nav_hangar_bearcat_one"
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_BASIC
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	shuttle_area = list(/area/ship/scrap/broken_shuttle/cargo, /area/ship/scrap/broken_shuttle/cockpit, /area/ship/scrap/broken_shuttle/airlock, /area/ship/scrap/broken_shuttle/power)

/obj/effect/overmap/ship/landable/swordfish
	name = "Swordfish"
	desc = "A small-sized docking shuttle used for transporting small amounts of people or goods."
	shuttle = "Swordfish"
	vessel_mass = 17500
	max_speed = 1/(1 SECONDS)
	burn_delay = 0.5 SECONDS //spammable, but expensive
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/shuttle_landmark/scrap/swordfish/start
	name = "Swordfish Docked"
	landmark_tag = "nav_hangar_bearcat_one"
	docking_controller = "bearcat_dock_port"
	base_area = /area/ship/scrap/crew/hallway/port
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/machinery/computer/shuttle_control/explore/swordfish
	name = "swordfish control console"
	shuttle_tag = "Swordfish"