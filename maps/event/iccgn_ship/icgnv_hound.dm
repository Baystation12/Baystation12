#include "icgnv_hound_shuttle.dm"

/datum/map_template/ruin/icgnv_hound
	name = "ICGNV Hound"
	id = "icgnv_hound"
	description = "A standard ALFA-pattern, armed ICCGN transport shuttle. The transponder reads on open channels as ICCG and is broadcasting the designation 'ICGNV Hound' in Zurich Accord Common."
	suffixes = list("maps/event/iccgn_ship/icgnv_hound.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/icgnv_hound)

/obj/overmap/visitable/sector/icgnv_hound_space
	name = "Sensor Anomaly"
	desc = "Sensors readings are confused and inaccurate on this grid sector."
	icon_state = "event"
	hide_from_reports = TRUE
	sensor_visibility = 10

/obj/overmap/visitable/ship/landable/icgnv_hound
	name = "ICGNV Hound"
	desc = "A standard ALFA-pattern, armed ICCGN transport shuttle. The transponder reads on open channels as ICCG and is broadcasting the designation 'ICGNV Hound' in Zurich Accord Common."
	shuttle = "ICGNV Hound"
	icon_state = "ship"
	moving_state = "ship_moving"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 1000

	initial_generic_waypoints = list(
		"nav_icgnv_hound_1",
		"nav_icgnv_hound_2",
		"nav_icgnv_hound_3",
		"nav_icgnv_hound_4",
		"nav_icgnv_hound_antag"
	)

/obj/shuttle_landmark/icgnv_hound/dock
	name = "4th Deck, Port Airlock (ICGNV Hound)"
	landmark_tag = "nav_hound_dock"

//Areas

/area/map_template/icgnv_hound
	name = "\improper ICGNV Hound"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)
