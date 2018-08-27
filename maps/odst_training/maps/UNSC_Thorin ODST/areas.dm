/area/corvette/unscbertels
	name = "UNSC Bertels"
	has_gravity = 1
	power_environ = 1
	power_light = 1
	poweralm = 1
	requires_power = 0

/area/corvette/unscbertels/deck1/Bridge
	name = "UNSC Bertels Bridge"

/area/corvette/unscbertels/deck1/Crewquarters
	name = "UNSC Bertels Crew Quarters"

/area/corvette/unscbertels/deck1/Crewmess
	name = "UNSC Bertels Crew Mess Hall"

/area/corvette/unscbertels/deck1/crewbathroom
	name = "UNSC Bertels Crew Bathrooms"

/area/corvette/unscbertels/deck1/Officermess
	name = "UNSC Bertels Officers Mess "

/area/corvette/unscbertels/deck1/captainroom
	name = "UNSC Bertels Captains Quarters"

/area/corvette/unscbertels/deck1/officerquarters
	name = "UNSC Bertels Officers Quarters"

/area/corvette/unscbertels/deck1/portescape
	name = "UNSC Bertels Port Bridge Escape Pod"

/area/corvette/unscbertels/deck1/starboardescape
	name = "UNSC Bertels Starboard Bridge Escape Pod"

/area/corvette/unscbertels/deck1/porthallway
	name = "UNSC Bertels Deck 1 Port Hallway"

/area/corvette/unscbertels/deck1/starboardhallway
	name = "UNSC Bertels Deck 1 Starboard Hallway"

/area/corvette/unscbertels/portbatterycontrol
	name = "UNSC Bertels Port Battery Control"

/area/corvette/unscbertels/starboardbatterycontrol
	name = "UNSC Bertels Starboard Battery Control"

/area/corvette/unscbertels/starboardbattery
	name = "UNSC Bertels Starboard Gun Battery"

/area/corvette/unscbertels/portbattery
	name = "UNSC Bertels Port Gun Battery"

/area/corvette/unscbertels/portrockets
 	name = "UNSC Bertels Port Rocket Pods"

/area/corvette/unscbertels/starboardrockets
 	name = "UNSC Bertels Starboard Rocket Pods"

//Overmap Weapon Console Defines//


/obj/machinery/overmap_weapon_console/deck_gun_control/local/unscbertelsport
	deck_gun_area = /area/corvette/unscbertels/portbattery

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/unscbertelsport
	deck_gun_area = /area/corvette/unscbertels/portrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/unscbertelsstarboard
	deck_gun_area = /area/corvette/unscbertels/starboardrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/unscbertelsstarboard
	deck_gun_area = /area/corvette/unscbertels/starboardbattery

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