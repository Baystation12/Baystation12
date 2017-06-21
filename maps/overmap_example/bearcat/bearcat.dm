#include "bearcat.dm"
#include "bearcat_areas.dm"
#include "bearcat_jobs.dm"
#include "bearcat_loadouts.dm"
#include "bearcat-1.dmm"
#include "bearcat-2.dmm"

/obj/effect/overmap/ship/bearcat
	name = "CSV Bearcat"
	color = "#00FFFF"
	start_x = 4
	start_y = 4
	base = 1

	generic_waypoints = list("nav_bearcat_below")
	restricted_waypoints = list(
		"Exploration Pod" = list("nav_bearcat_starboard_dock_pod"), //pod can only dock starboard-side, b/c there's only one door.
		"Exploration Shuttle" = list("nav_bearcat_port_dock_shuttle", "nav_bearcat_starboard_dock_shuttle"),
	)

/obj/machinery/computer/shuttle_control/explore/bearcat
	name = "exploration shuttle console"
	shuttle_tag = "Exploration Shuttle"

/datum/shuttle/autodock/overmap/exploration
	name = "Exploration Shuttle"
	shuttle_area = /area/ship/scrap/shuttle/outgoing
	dock_target = "shuttle_starboard"
	current_location = "nav_bearcat_port_dock_shuttle"

/obj/structure/closet/crate/uranium
	name = "fissibles crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

//In case multiple shuttles can dock at a location,
//subtypes can be used to hold the shuttle-specific data
/obj/effect/shuttle_landmark/docking_arm_starboard
	name = "Bearcat Starboard-side Docking Arm"
	docking_controller = "bearcat_starboard_dock"

/obj/effect/shuttle_landmark/docking_arm_starboard/shuttle
	landmark_tag = "nav_bearcat_starboard_dock_shuttle"
	special_dock_targets = list("Exploration Shuttle" = "shuttle_port")

/obj/effect/shuttle_landmark/docking_arm_starboard/pod
	landmark_tag = "nav_bearcat_starboard_dock_pod"

/obj/effect/shuttle_landmark/docking_arm_port
	name = "Bearcat Port-side Docking Arm"
	docking_controller = "bearcat_dock_port"

/obj/effect/shuttle_landmark/docking_arm_port/shuttle
	landmark_tag = "nav_bearcat_port_dock_shuttle"

//Not all waypoints need subtypes. This one is pretty generic, having no dock
/obj/effect/shuttle_landmark/below_deck
	name = "Near CSV Bearcat"
	landmark_tag = "nav_bearcat_below"

/obj/structure/closet/crate/uranium/New()
	..()
	new /obj/item/stack/material/uranium{amount=50}(src)
	new /obj/item/stack/material/uranium{amount=50}(src)