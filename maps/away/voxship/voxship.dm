#define WEBHOOK_SUBMAP_LOADED_VOX "webhook_submap_vox"

#include "voxship_areas.dm"
#include "voxship_jobs.dm"
#include "voxship_radio.dm"
#include "voxship_machines.dm"
#include "voxship_antagonism.dm"

/datum/map_template/ruin/away_site/scavship
	name = "Vox Scavenger Ship"
	id = "awaysite_voxship2"
	description = "Vox Scavenger Ship."
	suffixes = list("voxship/voxship-2.dmm")
	spawn_cost = 0.5
	player_cost = 4
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/vox_ship, /datum/shuttle/autodock/overmap/vox_lander)
	area_usage_test_exempted_root_areas = list(/area/voxship)
	spawn_weight = 0.67

/obj/effect/overmap/visitable/sector/vox_scav_ship
	name = "small asteroid cluster"
	desc = "Sensor array detects a small asteroid cluster."
	in_space = TRUE
	icon_state = "meteor4"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_voxbase_1"
	)

	initial_restricted_waypoints = list(
		"Vox Scavenger Ship" = list("nav_hangar_voxship")
	)

/datum/shuttle/autodock/overmap/vox_ship
	name = "Vox Scavenger Ship"
	move_time = 10
	shuttle_area = list(
		/area/voxship/engineering,
		/area/voxship/thrusters,
		/area/voxship/fore,
		/area/voxship/scavship
	)
	dock_target = "vox_ship"
	current_location = "nav_hangar_voxship"
	landmark_transition = "nav_transit_voxship"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/vox_base/hangar/vox_ship
	name = "Vox Ship Docked"
	landmark_tag = "nav_hangar_voxship"

/obj/machinery/computer/shuttle_control/explore/vox_ship
	name = "landing control console"
	shuttle_tag = "Vox Scavenger Ship"
	req_access = list(access_voxship)

/obj/effect/overmap/visitable/ship/landable/vox_ship
	name = "Alien Vessel"
	shuttle = "Vox Scavenger Ship"
	desc = "Sensor array detects a medium-sized vessel of irregular shape. Unknown origin."
	color = "#233012"
	icon_state = "ship"
	moving_state = "ship_moving"
	fore_dir = WEST
	vessel_size = SHIP_SIZE_SMALL

//Ship's little lander defined here
/datum/shuttle/autodock/overmap/vox_lander
	name = "Vox Scavenger Shuttle"
	move_time = 10
	shuttle_area = list(/area/voxship/shuttle)
	dock_target = "vox_scavshuttle"
	current_location = "nav_hangar_scavshuttle"
	landmark_transition = "nav_transit_scavshuttle"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	defer_initialisation = TRUE
	mothershuttle = "Vox Scavenger Ship"

/obj/effect/shuttle_landmark/vox_base/hangar/vox_scavshuttle
	name = "Dock"
	landmark_tag = "nav_hangar_scavshuttle"
	base_area = /area/voxship/scavship
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/machinery/computer/shuttle_control/explore/vox_lander
	name = "landing control console"
	shuttle_tag = "Vox Scavenger Shuttle"
	req_access = list(access_voxship)

/obj/effect/overmap/visitable/ship/landable/vox_scavshuttle
	name = "Unmarked shuttle"
	shuttle = "Vox Scavenger Shuttle"
	desc = "Sensor array detects a small, unmarked vessel."
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY

/obj/effect/submap_landmark/joinable_submap/voxship/scavship
	archetype = /decl/submap_archetype/derelict/voxship
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

//shuttle APC terminal kept being deleted by z level changes
/obj/machinery/power/apc/debug/vox
	cell_type = /obj/item/cell/infinite
	req_access = list(access_voxship)

/obj/effect/submap_landmark/joinable_submap/voxship/scavship/New()
	var/datum/language/vox/pidgin = all_languages[LANGUAGE_VOX]
	name = "[pidgin.get_random_name()]-[pidgin.get_random_name()]"
	..()

/decl/webhook/submap_loaded/vox
	id = WEBHOOK_SUBMAP_LOADED_VOX

/decl/submap_archetype/derelict/voxship
	descriptor = "Shoal Scavenger Vessel"
	map = "Vox Scavenger Ship"
	crew_jobs = list(
		/datum/job/submap/voxship_vox,
		/datum/job/submap/voxship_vox/doc,
		/datum/job/submap/voxship_vox/engineer,
		/datum/job/submap/voxship_vox/quill
	)
	whitelisted_species = list(SPECIES_VOX)
	blacklisted_species = null
	call_webhook = WEBHOOK_SUBMAP_LOADED_VOX

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~site 2 code end~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/turf/simulated/floor/plating/vox
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD*1.25)

/turf/simulated/floor/reinforced/vox
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD*1.25)

/turf/simulated/floor/tiled/techmaint/vox
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD*1.25)

/obj/machinery/alarm/vox
	req_access = list()

/obj/machinery/alarm/vox/Initialize()
	.=..()
	TLV[GAS_OXYGEN] =	list(-1, -1, 0.1, 0.1) // Partial pressure, kpa
	TLV[GAS_NITROGEN] = list(16, 19, 135, 140) // Partial pressure, kpa

/obj/machinery/power/smes/buildable/preset/voxship/ship
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil/super_capacity = 1,
		/obj/item/stock_parts/smes_coil/super_io = 1
	)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

#undef WEBHOOK_SUBMAP_LOADED_VOX
