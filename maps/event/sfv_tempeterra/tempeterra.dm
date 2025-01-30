#include "tempeterra_area.dm"

/datum/map_template/ruin/sfv_tempeterra
	name = "SFV Capanaeus"
	id = "sfv_tempeterra"
	description = "A small, fairly modern dagger-shaped Lexington-class corvette, broadcasting SCGF codes and the designation 'SFV Capanaeus, LXC-224, Battle Group Bravo'"
	suffixes = list("maps/event/sfv_tempeterra/tempeterra-2.dmm")
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/obj/overmap/visitable/sector/sfv_tempeterra_jump
	name = "Jump Drive Signature"
	desc = "Sensors readings on this sector indicate a jump pattern consistant with that of a fast moving fleet vessel."
	icon_state = "event"
	hide_from_reports = TRUE
	sensor_visibility = 10

/obj/overmap/visitable/ship/sfv_tempeterra
	name = "SFV Capanaeus"
	desc = "A small, fairly modern dagger-shaped Lexington-class corvette, broadcasting SCGF codes and the designation 'SFV Capanaeus, LXC-224, Battle Group Bravo'"
	fore_dir = WEST
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 40000

/obj/machinery/power/apc/tempeterra
	req_access = list("ACCESS_ENGINEERING")

/obj/machinery/alarm/tempeterra
	req_access = list("ACCESS_ENGINEERING")

/obj/machinery/alarm/tempeterra/cold
	target_temperature = T0C+4
