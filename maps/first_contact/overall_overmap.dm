/obj/effect/overmap/ship/CCV_comet
	name = "Civilian Vessel"
	desc = "A Civilian vessel with a traditional cargo-hauler design."

	icon = 'maps/first_contact/freighter.dmi'
	icon_state = "ship"
	fore_dir = WEST

	map_bounds = list(102,160,154,117)

/obj/effect/overmap/ship/CCV_star
	name = "Civilian Vessel"
	desc = "A Civilian vessel with a traditional cargo-hauler design."

	icon = 'maps/first_contact/freighter.dmi'
	icon_state = "ship"
	fore_dir = WEST

	map_bounds = list(102,160,154,117) //Aah standardised designs.

/obj/effect/overmap/ship/CCV_sbs
	name = "CCV Slow But Steady"
	desc = "A cargo freighter with a safer, isolated design."

	icon = 'maps/first_contact/slowbutsteady.dmi'
	icon_state = "ship"
	fore_dir = WEST

	map_bounds = list(7,49,73,27)

/obj/effect/overmap/ship/unsc_corvette
	name = "UNSC Thorin"
	desc = "A standard contruction-model corvette."

	icon = 'maps/first_contact/corvette.dmi'
	icon_state = "ship"
	fore_dir = WEST

	map_bounds = list(7,70,53,31)

//Overmap Weapon Console Defines//
/obj/machinery/overmap_weapon_console/deck_gun_control/local/corvetteport
	deck_gun_area = /area/om_ships/unscpatrol/portbattery

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/corvetteport
	deck_gun_area = /area/om_ships/unscpatrol/portrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/corvettestarboard
	deck_gun_area = /area/om_ships/unscpatrol/starboardrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/corvettestarboard
	deck_gun_area = /area/om_ships/unscpatrol/starboardbattery

/obj/machinery/overmap_weapon_console/deck_gun_control/local/comet
	deck_gun_area = /area/om_ships/comet

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/comet
	deck_gun_area = /area/om_ships/comet/cometrockets

//Misc Stuff//
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

/obj/machinery/button/toggle/alarm_button/corvette
	area_base = /area/om_ships/unscpatrol

/obj/machinery/button/toggle/alarm_button/corvette/v2
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j1.ogg'
	alarm_loop_time = 4.898 SECONDS //The amount of time it takes for the alarm sound to end. Used for restarting the sound.

/obj/machinery/button/toggle/alarm_button/corvette/v3
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j2.ogg'
	alarm_loop_time = 6.535 SECONDS

/obj/machinery/button/toggle/alarm_button/corvette/v4
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j3.ogg'
	alarm_loop_time = 15.267 SECONDS
