/obj/effect/overmap/ship/odst_corvette
	name = "UNSC Bertels"
	desc = "A standard contruction-model corvette."

	icon = 'Heavycorvette.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 4
	faction = "UNSC"
	flagship = 1

	map_bounds = list(4,99,142,52)

	parent_area_type = /area/corvette/unscbertels

/obj/machinery/button/toggle/alarm_button/corvette
	area_base = /area/corvette/unscbertels

/obj/machinery/button/toggle/alarm_button/corvette/v2
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j1.ogg'
	alarm_loop_time = 4.898 SECONDS //The amount of time it takes for the alarm sound to end. Used for restarting the sound.

/obj/machinery/button/toggle/alarm_button/corvette/v3
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j2.ogg'
	alarm_loop_time = 6.535 SECONDS

/obj/machinery/button/toggle/alarm_button/corvette/v4
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j3.ogg'
	alarm_loop_time = 15.267 SECONDS

/obj/random_corvette_alarm_button
	name = "Random Corvette Alarm Button"

/obj/random_corvette_alarm_button/New()
	var/obj/to_spawn = pick(list(\
	/obj/machinery/button/toggle/alarm_button/corvette = 75,/obj/machinery/button/toggle/alarm_button/corvette/v2 = 10,\
	/obj/machinery/button/toggle/alarm_button/corvette/v2 = 10,/obj/machinery/button/toggle/alarm_button/corvette/v4 = 5
	))
	new to_spawn (loc)

/obj/random_corvette_alarm_button/Initialize()
	return INITIALIZE_HINT_QDEL
