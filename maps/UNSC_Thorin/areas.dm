/area/corvette/unscthorin
	name = "URFS Thorn"
	has_gravity = 1
	power_environ = 1
	power_light = 1
	poweralm = 1
	requires_power = 1

/area/corvette/unscthorin/Bridge
	name = "URFS Thorn Bridge"

/area/corvette/unscthorin/Porthallway
	name = "URFS Thorn Deck 1 Port Hallway"

/area/corvette/unscthorin/Porthallway2
	name = "URFS Thorn Deck 2 Port Hallway"

/area/corvette/unscthorin/Centralhallway
	name = "URFS Thorn Deck 1 Central Hallway"

/area/corvette/unscthorin/Centralhallway2
	name = "URFS Thorn Deck 2 Central Hallway"

/area/corvette/unscthorin/Starboardhallway
	name = "URFS Thorn Deck 1 Starboard Hallway"

/area/corvette/unscthorin/Starboardhallway2
	name = "URFS Thorn Deck 2 Starboard Hallway"

/area/corvette/unscthorin/Hangarbay
	name = "URFS Thorn Deck 1 Rear Hangar Bay"

/area/corvette/unscthorin/Hangarbayport
	name = "URFS Thorn Port Hangar Bay"

/area/corvette/unscthorin/Hangarbaystarboard
	name = "URFS Thorn Starboard Hangar Bay"

/area/corvette/unscthorin/fuelstorage
	name = "URFS Thorn Fuel Storage"

/area/corvette/unscthorin/medicalbay
	name = "URFS Thorn Medical Bay"

/area/corvette/unscthorin/oxystorage
	name = "URFS Thorn Oxygen Storage"

/area/corvette/unscthorin/portengine
	name = "URFS Thorn Port Engine"

/area/corvette/unscthorin/starboardengine
	name = "URFS Thorn Starboard Engine"

/area/corvette/unscthorin/crewbathroom
	name = "URFS Thorn Crew Bathrooms"

/area/corvette/unscthorin/cryodorm
	name = "URFS Thorn Cryodorms"

/area/corvette/unscthorin/cells
	name = "URFS Thorn Holding Cells"

/area/corvette/unscthorin/janitorial
	name = "URFS Thorn Janitorial Closet"

/area/corvette/unscthorin/storageroom
	name = "URFS Thorn Deck 1 Storage Room"

/area/corvette/unscthorin/storageroom2
	name = "URFS Thorn Deck 2 Storage Room"


/area/corvette/unscthorin/portbatterycontrol
	name = "URFS Thorn Port Battery Control"

/area/corvette/unscthorin/starboardbatterycontrol
	name = "URFS Thorn Starboard Battery Control"

/area/corvette/unscthorin/portcrew
	name = "URFS Thorn Port Crew Quarters"

/area/corvette/unscthorin/starboardcrew
	name = "URFS Thorn Starboard Crew Quarters"

/area/corvette/unscthorin/Messhall
	name = "URFS Thorn Mess Hall"

/area/corvette/unscthorin/captainroom
	name = "URFS Thorn Captains Quarters"

/area/corvette/unscthorin/Armory
	name = "URFS Thorn Armory"

/area/corvette/unscthorin/Troopbunks
	name = "URFS Thorn Troop Bunks"

/area/corvette/unscthorin/PortGenerator
	name = "URFS Thorn Port Generator"

/area/corvette/unscthorin/StarboardGenerator
	name = "URFS Thorn Starboard Generator"

/area/corvette/unscthorin/powercore
	name = "URFS Thorn Power Core"

/area/corvette/unscthorin/powercoreaux
	name = "URFS Thorn Auxiliary Power Core"

/area/corvette/unscthorin/portumbilical
	name = "URFS Thorn Port Docking Umbilical"

/area/corvette/unscthorin/starboardumbilical
	name = "URFS Thorn Starboard Docking Umbilical"

/area/corvette/unscthorin/deckacces
	name = "URFS Thorn Deck 1 Access"

/area/corvette/unscthorin/boardingpods
	name = "URFS Thorn Boarding Pods"

/area/corvette/unscthorin/observation
	name = "URFS Thorn Observation Deck"

/area/corvette/unscthorin/starboardbattery
	name = "URFS Thorn Starboard Gun Battery"

/area/corvette/unscthorin/portbattery
	name = "URFS Thorn Port Gun Battery"

/area/corvette/unscthorin/portrockets
 	name = "URFS Thorn Port Rocket Pods"

/area/corvette/unscthorin/starboardrockets
 	name = "URFS Thorn Starboard Rocket Pods"

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
/obj/random_corvette_alarm_buttonthorin
	name = "Random Corvette Alarm Button"

/obj/random_corvette_alarm_buttonthorin/New()
	var/obj/to_spawn = pick(list(\
	/obj/machinery/button/toggle/alarm_button/corvettethorin = 75,/obj/machinery/button/toggle/alarm_button/corvettethorin/v2 = 10,\
	/obj/machinery/button/toggle/alarm_button/corvettethorin/v2 = 10,/obj/machinery/button/toggle/alarm_button/corvettethorin/v4 = 5
	))
	new to_spawn (loc)

/obj/random_corvette_alarm_buttonthorin/Initialize()
	return INITIALIZE_HINT_QDEL

/obj/machinery/button/toggle/alarm_button/corvettethorin
	area_base = /area/corvette/unscthorin

/obj/machinery/button/toggle/alarm_button/corvettethorin/v2
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j1.ogg'
	alarm_loop_time = 4.898 SECONDS //The amount of time it takes for the alarm sound to end. Used for restarting the sound.

/obj/machinery/button/toggle/alarm_button/corvettethorin/v3
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j2.ogg'
	alarm_loop_time = 6.535 SECONDS

/obj/machinery/button/toggle/alarm_button/corvettethorin/v4
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j3.ogg'
	alarm_loop_time = 15.267 SECONDS