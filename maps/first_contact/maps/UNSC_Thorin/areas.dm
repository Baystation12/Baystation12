/area/corvette/unscthorin
	name = "UNSC Thorin"
	has_gravity = 1
	power_environ = 1
	power_light = 1
	poweralm = 1
	requires_power = 0

/area/corvette/unscthorin/Bridge
	name = "UNSC Thorin Bridge"

/area/corvette/unscthorin/Porthallway
	name = "UNSC Thorin Deck 1 Port Hallway"

/area/corvette/unscthorin/Porthallway2
	name = "UNSC Thorin Deck 2 Port Hallway"

/area/corvette/unscthorin/Centralhallway
	name = "UNSC Thorin Deck 1 Central Hallway"

/area/corvette/unscthorin/Centralhallway2
	name = "UNSC Thorin Deck 2 Central Hallway"

/area/corvette/unscthorin/Starboardhallway
	name = "UNSC Thorin Deck 1 Starboard Hallway"

/area/corvette/unscthorin/Starboardhallway2
	name = "UNSC Thorin Deck 2 Starboard Hallway"

/area/corvette/unscthorin/Hangarbay
	name = "UNSC Thorin Deck 1 Rear Hangar Bay"

/area/corvette/unscthorin/Hangarbayport
	name = "UNSC Thorin Port Hangar Bay"

/area/corvette/unscthorin/Hangarbaystarboard
	name = "UNSC Thorin Starboard Hangar Bay"

/area/corvette/unscthorin/Portsoeiv
	name = "UNSC Thorin SOEIV Bay 1"

/area/corvette/unscthorin/starboardsoeiv
	name = "UNSC Thorin SOEIV Bay 2"

/area/corvette/unscthorin/fuelstorage
	name = "UNSC Thorin Fuel Storage"

/area/corvette/unscthorin/medicalbay
	name = "UNSC Thorin Medical Bay"

/area/corvette/unscthorin/oxystorage
	name = "UNSC Thorin Oxygen Storage"

/area/corvette/unscthorin/portengine
	name = "UNSC Thorin Port Engine"

/area/corvette/unscthorin/starboardengine
	name = "UNSC Thorin Starboard Engine"

/area/corvette/unscthorin/crewbathroom
	name = "UNSC Thorin Crew Bathrooms"

/area/corvette/unscthorin/cryodorm
	name = "UNSC Thorin Cryodorms"

/area/corvette/unscthorin/cells
	name = "UNSC Thorin Holding Cells"

/area/corvette/unscthorin/janitorial
	name = "UNSC Thorin Janitorial Closet"

/area/corvette/unscthorin/storageroom
	name = "UNSC Thorin Storage Room"

/area/corvette/unscthorin/portbatterycontrol
	name = "UNSC Thorin Port Battery Control"

/area/corvette/unscthorin/starboardbatterycontrol
	name = "UNSC Thorin Starboard Battery Control"

/area/corvette/unscthorin/portcrew
	name = "UNSC Thorin Port Crew Quarters"

/area/corvette/unscthorin/starboardcrew
	name = "UNSC Thorin Starboard Crew Quarters"

/area/corvette/unscthorin/Messhall
	name = "UNSC Thorin Mess Hall"

/area/corvette/unscthorin/captainroom
	name = "UNSC Thorin Captains Quarters"

/area/corvette/unscthorin/Armory
	name = "UNSC Thorin Armory"

/area/corvette/unscthorin/Troopbunks
	name = "UNSC Thorin Troop Bunks"

/area/corvette/unscthorin/PortGenerator
	name = "UNSC Thorin Port Generator"

/area/corvette/unscthorin/StarboardGenerator
	name = "UNSC Thorin Starboard Generator"

/area/corvette/unscthorin/odstsection
	name = "UNSC Thorin ODST Section"

/area/corvette/unscthorin/powercore
	name = "UNSC Thorin Power Core"

/area/corvette/unscthorin/powercoreaux
	name = "UNSC Thorin Auxiliary Power Core"

/area/corvette/unscthorin/portumbilical
	name = "UNSC Thorin Port Docking Umbilical"

/area/corvette/unscthorin/starboardumbilical
	name = "UNSC Thorin Starboard Docking Umbilical"

/area/corvette/unscthorin/deckacces
	name = "UNSC Thorin Deck 1 Access"

/area/corvette/unscthorin/boardingpods
	name = "UNSC Thorin Boarding Pods"

/area/corvette/unscthorin/observation
	name = "UNSC Thorin Observation Deck"

/area/corvette/unscthorin/starboardbattery
	name = "UNSC Thorin Starboard Gun Battery"

/area/corvette/unscthorin/portbattery
	name = "UNSC Thorin Port Gun Battery"

/area/corvette/unscthorin/portrockets
 	name = "UNSC Thorin Port Rocket Pods"

/area/corvette/unscthorin/starboardrockets
 	name = "UNSC Thorin Starboard Rocket Pods"

//Overmap Weapon Console Defines//


/obj/machinery/overmap_weapon_console/deck_gun_control/local/corvetteport
	deck_gun_area = /area/corvette/unscthorin/portbattery

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/corvetteport
	deck_gun_area = /area/corvette/unscthorin/portrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/corvettestarboard
	deck_gun_area = /area/corvette/unscthorin/starboardrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/corvettestarboard
	deck_gun_area = /area/corvette/unscthorin/starboardbattery

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
	area_base = /area/corvette/unscthorin

/obj/machinery/button/toggle/alarm_button/corvette/v2
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j1.ogg'
	alarm_loop_time = 4.898 SECONDS //The amount of time it takes for the alarm sound to end. Used for restarting the sound.

/obj/machinery/button/toggle/alarm_button/corvette/v3
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j2.ogg'
	alarm_loop_time = 6.535 SECONDS

/obj/machinery/button/toggle/alarm_button/corvette/v4
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j3.ogg'
	alarm_loop_time = 15.267 SECONDS