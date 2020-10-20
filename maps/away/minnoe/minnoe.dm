/datum/map_template/ruin/away_site/minnoe
	name = "Minnoe"
	id = "minnoe"
	description = "A trade vessel of dubious origin."
	suffixes = list("minnoe/minnoe.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/minnoe)
	spawn_weight = 0 //this should stop spawning
	accessibility_weight = 0 //stop cross-z drifting to it

/obj/effect/overmap/visitable/sector/minnoedock
	name = "Empty Sector"
	desc = "Slight traces of a cloaking device are present. Unable to determine exact location."
	in_space = 1
	icon_state = "event"
	hide_from_reports = TRUE

/area/ship/minnoe
	name = "\improper ITV Minnoe"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	base_turf = /turf/simulated/floor/plating
	req_access = list(access_cent_general)

/obj/machinery/computer/shuttle_control/explore/minnoe
	name = "shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "minnoe"

/obj/effect/overmap/visitable/ship/landable/minnoe
	name = "Minnoe"
	shuttle = "minnoe"
	icon_state = "ship"
	moving_state = "ship_moving"
	fore_dir = SOUTH
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Minnoe Dock" = list("nav_minnoe_dock")
	)

/datum/shuttle/autodock/overmap/minnoe
	name = "Minnoe"
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