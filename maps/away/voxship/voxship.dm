#define WEBHOOK_SUBMAP_LOADED_VOX "webhook_submap_vox"

#include "voxship_areas.dm"
#include "voxship_jobs.dm"

/datum/map_template/ruin/away_site/voxship
	name = "Vox Ship"
	id = "awaysite_voxship"
	description = "Vox ship."
	suffixes = list("voxship/voxship.dmm")
	cost = 0.5
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/vox_shuttle)
	area_usage_test_exempted_root_areas = list(/area/voxship)

/obj/effect/overmap/visitable/ship/voxship
	name = "Abnormal Asteroid"
	desc = "Sensors detect asteroid formation, rich in minerals. Non-geological formations present.\
	Organic signature detected."
	vessel_mass = 15000 //Rather heavy due to all the rocks surrounding it, and the sheer size
	fore_dir = WEST
	burn_delay = 5 SECONDS //Not very manoeuvrable due to the large mass
	icon_state = "meteor4"
	moving_state = "meteor4_moving"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_vox_northwest",
		"nav_vox_south"
	)
	initial_restricted_waypoints = list(
		"Vox Shuttle" = list("nav_vox_dock")
	)


/datum/shuttle/autodock/overmap/vox_shuttle
	name = "Vox Shuttle"
	move_time = 10
	shuttle_area = list(/area/voxship/shuttle)
	dock_target = "vox_shuttle"
	current_location = "nav_vox_dock"
	landmark_transition = "nav_vox_transit"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/
	skill_needed = SKILL_NONE
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/vox_ship/vox_shuttle
	name = "Vox Ship Dock"
	landmark_tag = "nav_vox_dock"
	base_area = /area/voxship/dock
	base_turf = /turf/simulated/floor/plating/vox

/obj/effect/shuttle_landmark/transit/vox_base/vox_shuttle
	name = "In transit"
	landmark_tag = "nav_vox_transit"

/obj/machinery/computer/shuttle_control/explore/vox_shuttle
	name = "shuttle control console"
	shuttle_tag = "Vox Shuttle"

/obj/effect/overmap/visitable/ship/landable/vox
	name = "Unknown Signature"
	shuttle = "Vox Shuttle"
	fore_dir = WEST
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/shuttle_landmark/vox_ship/nav_northwest
	name = "Northwest of Abnormal Asteroid"
	landmark_tag = "nav_vox_northwest"

/obj/effect/shuttle_landmark/vox_ship/nav_south
	name = "South of Abnormal Asteroid"
	landmark_tag = "nav_vox_south"

/obj/effect/submap_landmark/joinable_submap/voxship
	archetype = /decl/submap_archetype/derelict/voxship

/obj/effect/submap_landmark/joinable_submap/voxship/New()
	var/datum/language/vox/pidgin = all_languages[LANGUAGE_VOX]
	name = "[pidgin.get_random_name()]-[pidgin.get_random_name()]"
	..()

/decl/webhook/submap_loaded/vox
	id = WEBHOOK_SUBMAP_LOADED_VOX

/decl/submap_archetype/derelict/voxship
	descriptor = "Shoal forward base"
	map = "Vox Ship"
	crew_jobs = list(
		/datum/job/submap/voxship_vox,
		/datum/job/submap/voxship_vox/doc,
		/datum/job/submap/voxship_vox/engineer,
		/datum/job/submap/voxship_vox/quill
	)
	whitelisted_species = list(SPECIES_VOX)
	blacklisted_species = null
	call_webhook = WEBHOOK_SUBMAP_LOADED_VOX

/turf/simulated/floor/plating/vox
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD*1.25)

/turf/simulated/floor/reinforced/vox
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD*1.25)

/turf/simulated/floor/tiled/techmaint/vox
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD*1.25)

/obj/machinery/alarm/vox
	req_access = newlist()

/obj/machinery/alarm/vox/Initialize()
	.=..()
	TLV[GAS_OXYGEN] =	list(-1, -1, 0.1, 0.1) // Partial pressure, kpa
	TLV[GAS_NITROGEN] = list(16, 19, 135, 140) // Partial pressure, kpa

/obj/machinery/power/smes/buildable/preset/voxship/ship
	uncreated_component_parts = list(/obj/item/weapon/stock_parts/smes_coil/super_capacity = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

#undef WEBHOOK_SUBMAP_LOADED_VOX