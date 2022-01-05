/datum/map_template/ruin/antag_spawn/vox_raider
	name = "Vox Raider"
	suffixes = list("vox/vox_raider.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/vox_raider)

/obj/effect/overmap/visitable/sector/vox_start
	name = "Empty Space"
	desc = "A seemingly empty sector of space. Sensor scans reveal nothing but background emissions."
	in_space = TRUE
	known = FALSE
	icon_state = "event"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_vox_raider_start"
	)

/obj/effect/overmap/visitable/ship/landable/vox_raider
	name = "Unknown Shuttle"
	desc = "A spacecraft with irregular sensor readings. All identification codes are scrubbed off or unresponsive."
	shuttle = "Alien Interceptor"
	fore_dir = WEST
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 2500

/datum/shuttle/autodock/overmap/vox_raider
	name = "Alien Interceptor"
	shuttle_area = list(
		/area/map_template/vox_raider/bridge,
		/area/map_template/vox_raider/med,
		/area/map_template/vox_raider/engineering,
		/area/map_template/vox_raider/storage,
		/area/map_template/vox_raider/armory
	)
	dock_target = "vox_raider"
	current_location = "nav_vox_raider_start"
	defer_initialisation = TRUE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/vox
	warmup_time = 5
	range = 2
	fuel_consumption = 2
	skill_needed = SKILL_NONE
	knockdown = FALSE

/turf/simulated/floor/tiled/techmaint/vox_raider
	initial_gas = list(GAS_NITROGEN = 100)

/turf/simulated/floor/plating/vox_raiders
	initial_gas = list(GAS_NITROGEN = 100)

/turf/simulated/floor/shuttle_ceiling/vox
	color = COLOR_DARK_GUNMETAL

/obj/machinery/computer/shuttle_control/explore/vox_raider
	name = "shuttle control console"
	shuttle_tag = "Alien Interceptor"

/obj/effect/shuttle_landmark/vox_raider
	landmark_tag = "nav_vox_raider_start"
	name = "Echo Source"

/obj/machinery/alarm/vox_raider
	req_access = list()

/obj/machinery/alarm/vox_raider/Initialize()
	.=..()
	TLV[GAS_OXYGEN] =	list(-1, -1, 0.1, 0.5) // Partial pressure, kpa
	TLV[GAS_NITROGEN] = list(16, 19, 135, 140) // Partial pressure, kpa

/area/map_template/vox_raider
	icon = 'voxship.dmi'
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)

/area/map_template/vox_raider/bridge
	name = "\improper Unknown Shuttle - Bridge"
	icon_state = "bridge"

/area/map_template/vox_raider/med
	name = "\improper Unknown Shuttle - Medbay"
	icon_state = "med"

/area/map_template/vox_raider/engineering
	name = "\improper Unknown Shuttle - Engineering"
	icon_state = "engineering"

/area/map_template/vox_raider/storage
	name = "\improper Unknown Shuttle - Storage"
	icon_state = "storage"

/area/map_template/vox_raider/armory
	name = "\improper Alien Interceptor - Armory"
	icon_state = "armory"
