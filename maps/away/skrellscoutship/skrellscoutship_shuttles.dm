/obj/machinery/computer/shuttle_control/explore/skrellscoutship
	name = "SSV control console"
	req_access = list(access_skrellscoutship)
	shuttle_tag = "Skrellian Scout"

/obj/machinery/computer/shuttle_control/explore/skrellscoutshuttle
	name = "SSV Shuttle control console"
	req_access = list(access_skrellscoutship)
	shuttle_tag = "Skrellian Shuttle"

/obj/effect/overmap/visitable/ship/landable/skrellscoutship
	name = "light skrellian vessel"
	shuttle = "Skrellian Scout"
	multiz = 1
	icon_state = "ship"
	moving_state = "ship_moving"
	fore_dir = WEST
	color = "#ff00ff"
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Skrellian Shuttle" = list("nav_skrellscoutsh_dock")
	)


/obj/effect/overmap/visitable/ship/landable/skrellscoutship/New()
	name = "SSV [pick("Xilvuxix", "Zuuvixix", "Quizuu", "Vulzxixvuu","Quumzoox","Quuvuzxuu")]"
	..()

/obj/effect/overmap/visitable/ship/landable/skrellscoutshuttle
	name = "SSV-S"
	shuttle = "Skrellian Shuttle"
	fore_dir = WEST
	color = "#880088"
	vessel_mass = 750
	vessel_size = SHIP_SIZE_TINY

/datum/shuttle/autodock/overmap/skrellscoutship
	name = "Skrellian Scout"
	warmup_time = 5
	range = 1
	current_location = "nav_skrellscout_start"
	shuttle_area = list(
		/area/ship/skrellscoutship/command/bridge, /area/ship/skrellscoutship/wings/port, /area/ship/skrellscoutship/wings/starboard,
		/area/ship/skrellscoutship/brig, /area/ship/skrellscoutship/portcheckpoint, /area/ship/skrellscoutship/forestorage,
		/area/ship/skrellscoutship/externalwing/port, /area/ship/skrellscoutship/externalwing/starboard, /area/ship/skrellscoutship/corridor,
		/area/ship/skrellscoutship/crew/quarters, /area/ship/skrellscoutship/crew/medbay, /area/ship/skrellscoutship/crew/kitchen,
		/area/ship/skrellscoutship/maintenance/power, /area/ship/skrellscoutship/hangar, /area/ship/skrellscoutship/command/armory,
		/area/ship/skrellscoutship/dock, /area/ship/skrellscoutship/maintenance/atmos, /area/ship/skrellscoutship/robotics, 
		/area/ship/skrellscoutship/crew/rec 
		)
	defer_initialisation = TRUE
	knockdown = FALSE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_NONE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/skrell

/obj/effect/shuttle_landmark/skrellscoutship/start
	name = "Uncharted Space"
	landmark_tag = "nav_skrellscout_start"

/datum/shuttle/autodock/overmap/skrellscoutshuttle
	name = "Skrellian Shuttle"
	warmup_time = 5
	current_location = "nav_skrellscoutsh_dock"
	range = 2
	shuttle_area = /area/ship/skrellscoutshuttle
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_NONE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/skrell
	mothershuttle = "Skrellian Scout"

/obj/effect/shuttle_landmark/skrellscoutshuttle/start
	name = "Dock"
	landmark_tag = "nav_skrellscoutsh_dock"
	base_area = /area/ship/skrellscoutship/hangar
	base_turf = /turf/simulated/floor/tiled/skrell
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/skrellscout/dock
	name = "Skrellian Scout Docking Port"
	landmark_tag = "nav_skrellscout_dock"

/obj/effect/shuttle_landmark/skrellscoutshuttle/altdock
	name = "Docking Port"
	landmark_tag = "nav_skrellscoutsh_altdock"

/turf/simulated/floor/shuttle_ceiling/skrell
	color = COLOR_HULL

/turf/simulated/floor/shuttle_ceiling/skrell/air
	initial_gas = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)
