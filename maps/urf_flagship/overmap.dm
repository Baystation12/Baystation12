/obj/effect/overmap/ship/urf_flagship
	name = "URF Liberator"
	desc = "A Mariner-class transport ship designed to operate with a small crew while carrying a large payload. Mariner-class transports are fierce, fast, sleek, and menacing."

	icon = 'mariner-class.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 4
	faction = "Insurrection"
	flagship = 1

	map_bounds = list(4,99,142,52)

	parent_area_type = /area/urf_flagship

/obj/machinery/button/toggle/alarm_button/urf_flagship_alarm
	alarm_sound = 'sound/misc/TestLoop1.ogg'
	alarm_loop_time = 7 SECONDS
	area_base = /area/urf_flagship
