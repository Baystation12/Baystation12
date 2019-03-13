/obj/machinery/computer/shuttle_control/explore/skrellscoutship
	name = "SSV control console"
	req_access = list(access_skrellscoutship)
	shuttle_tag = "Skrellian Scout"

/obj/machinery/computer/shuttle_control/explore/skrellscoutshuttle
	name = "SSV Shuttle control console"
	req_access = list(access_skrellscoutship)
	shuttle_tag = "Skrellian Shuttle"

/obj/effect/overmap/ship/landable/skrellscoutship
	name = "light skrellian vessel"
	shuttle = "Skrellian Scout"
	multiz = 1
	icon_state = "ship"
	moving_state = "ship_moving"
	fore_dir = WEST
	color = "#ff00ff"
	vessel_mass = 1000
	initial_restricted_waypoints = list(
		"Skrellian Shuttle" = list("nav_skrellscoutsh_dock")
	)


/obj/effect/overmap/ship/landable/skrellscoutship/New()
	name = "SSV [pick("Xilvuxix", "Zuuvixix", "Quizuu", "Vulzxixvuu","Quumzoox","Quuvuzxuu")]"
	..()
	
/obj/effect/overmap/ship/landable/skrellscoutshuttle
	name = "SSV-S"
	shuttle = "Skrellian Shuttle"
	fore_dir = WEST
	color = "#880088"
	vessel_mass = 750

/datum/shuttle/autodock/overmap/skrellscoutship
	name = "Skrellian Scout"
	warmup_time = 5
	multiz = 1
	range = 1
	current_location = "nav_skrellscout_start"
	current_dock_target = "xil_dock"
	shuttle_area = list(
		/area/ship/skrellscoutship/solars, /area/ship/skrellscoutship/crew/quarters, /area/ship/skrellscoutship/crew/hallway/d1,
		/area/ship/skrellscoutship/crew/hallway/d2, /area/ship/skrellscoutship/crew/kitchen, /area/ship/skrellscoutship/crew/rec,
		/area/ship/skrellscoutship/crew/toilets, /area/ship/skrellscoutship/crew/medbay, /area/ship/skrellscoutship/dock,
		/area/ship/skrellscoutship/dock/alt, /area/ship/skrellscoutship/hangar, /area/ship/skrellscoutship/robotics, 
		/area/ship/skrellscoutship/maintenance/atmos, /area/ship/skrellscoutship/maintenance/power, /area/ship/skrellscoutship/command/bridge,
		/area/ship/skrellscoutship/crew/fit, /area/ship/skrellscoutship/command/armory
		)
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_NONE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/torch
	
/obj/effect/shuttle_landmark/skrellscoutship/start
	name = "Uncharted Space"
	landmark_tag = "nav_skrellscout_start"
	
/datum/shuttle/autodock/overmap/skrellscoutshuttle
	name = "Skrellian Shuttle"
	warmup_time = 5
	current_location = "nav_skrellscoutsh_dock"
	range = 2
	current_dock_target = "xil_shuttle"
	shuttle_area = /area/ship/skrellscoutshuttle
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_NONE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/torch
	mothershuttle = "Skrellian Scout"
	
/obj/effect/shuttle_landmark/skrellscoutshuttle/start
	name = "Dock"
	landmark_tag = "nav_skrellscoutsh_dock"
	base_area = /area/ship/skrellscoutship/hangar
	base_turf = /turf/simulated/floor/tiled/skrell
	flags = SLANDMARK_FLAG_MOBILE
	
/obj/effect/shuttle_landmark/skrellscoutshuttle/altdock
	name = "Docking Port"
	landmark_tag = "nav_skrellscoutsh_altdock"