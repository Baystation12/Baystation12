#include "sfv_arbiter_shuttle.dm"

/singleton/map_template/ruin/sfv_arbiter
	name = "SFV Arbiter"
	id = "arbiter"
	description = "A fairly standard armed transport shuttle belonging to the Sol Fleet. It's transponder reads 'SFV Arbiter'."
	suffixes = list("maps/event/sfv_arbiter/sfv_arbiter.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/sfv_arbiter)

/obj/overmap/visitable/sector/sfv_arbiter_space
	name = "Sensor Anomaly"
	desc = "Sensors readings are confused and inaccurate on this grid sector."
	icon_state = "event"
	hide_from_reports = TRUE
	sensor_visibility = 10

/obj/overmap/visitable/ship/landable/sfv_arbiter
	name = "SFV Arbiter"
	desc = "A standard, armed transport shuttle belonging to the Sol Fleet. It's transponder reads 'SFV Arbiter'."
	shuttle = "SFV Arbiter"
	icon_state = "ship"
	moving_state = "ship_moving"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 1000

	initial_generic_waypoints = list(
		"nav_sfv_arbiter_1",
		"nav_sfv_arbiter_2",
		"nav_sfv_arbiter_3",
		"nav_sfv_arbiter_4"
	)

//Areas

/area/map_template/sfv_arbiter
	name = "\improper SFV Arbiter"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)
