/datum/map_template/ruin/capanaeus
	name = "SFV Capanaeus"
	id = "capanaeus"
	description = "A small, fairly modern dagger-shaped Lexington-class corvette, broadcasting SCGF codes and the designation 'SFV Capanaeus, LXC-224, Battle Group Bravo'"
	suffixes = list("maps/event/sfv_capanaeus/capanaeus.dmm")

	apc_test_exempt_areas = list(
		/area/capanaeus = NO_SCRUBBER|NO_VENT
	)

	area_usage_test_exempted_areas = list(
		/area/capanaeus
	)

/obj/overmap/visitable/sector/cap_jumpflash
	name = "Jump Drive Signature"
	desc = "Sensors readings on this sector indicate a jump pattern consistant with that of a fast moving fleet vessel."
	icon_state = "event"
	hide_from_reports = TRUE
	sensor_visibility = 10

/obj/machinery/power/apc/capanaeus
	req_access = list("ACCESS_ENGINEERING")

/obj/machinery/alarm/capanaeus
	req_access = list("ACCESS_ENGINEERING")

/obj/machinery/alarm/capanaeus/cold
	target_temperature = T0C+4

/area/capanaeus
	name = "SFV Capanaeus"
	icon = 'maps/event/sfv_capanaeus/capanaeus.dmi'
	icon_state = "cap"
	req_access = list("ACCESS_CENT_GENERAL")

	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
