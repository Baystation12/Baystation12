/area/corvette/unscironwill
	name = "UNSC Iron Will"
	has_gravity = 1
	power_environ = 1
	power_light = 1
	poweralm = 1
	requires_power = 1

//deck 1 areas
/area/corvette/unscironwill/Bridge
	name = "UNSC Iron Will Bridge"

/area/corvette/unscironwill/portescape
	name = "UNSC Iron Will Port Aft Escape Pod"

/area/corvette/unscironwill/portescapefore
	name = "UNSC Iron Will Port Fore Escape Pod"

/area/corvette/unscironwill/starboardescape
	name = "UNSC Iron Will Starboard Aft Escape Pod"

/area/corvette/unscironwill/starboardescapefore
	name = "UNSC Iron Will Starboard Fore Escape Pod"

//deck 2 areas
/area/corvette/unscironwill/MAC
	name = "UNSC Iron Will MAC Gun"
	requires_power = 1

/area/corvette/unscironwill/Briefingroom
	name = "UNSC Iron Will Briefing Room"

/area/corvette/unscironwill/marinearmory
	name = "UNSC Iron Will Marine Armory"

/area/corvette/unscironwill/medbay
	name = "UNSC Iron Will Port Medical Bay"

/area/corvette/unscironwill/cells
	name = "UNSC Iron Will Holding Cells"

/area/corvette/unscironwill/porthallwaycentral
	name = "UNSC Iron Will Central Port Hallway"

/area/corvette/unscironwill/starboardhallwaycentral
	name = "UNSC Iron Will Central Starboard Hallway"

/area/corvette/unscironwill/Reactorcore
	name = "UNSC Iron Will Main Reactor Core"

/area/corvette/unscironwill/portengine
	name = "UNSC Iron Will Port Engine"

/area/corvette/unscironwill/starboardengine
	name = "UNSC Iron Will Starboard Engine"

/area/corvette/unscironwill/cryodorms
	name = "UNSC Iron Will Cryodorms"

/area/corvette/unscironwill/morgue
	name = "UNSC Iron Will Morgue"

/area/corvette/unscironwill/odstarmory
	name = "UNSC Iron Will ODST Armory"

/area/corvette/unscironwill/portumbilical
	name = "UNSC Iron Will Port Docking Umbilical"

/area/corvette/unscironwill/starboardumbilical
	name = "UNSC Iron Will Starboard Docking Umbilical"

/area/corvette/unscironwill/porthangar
	name = "UNSC Iron Will Port Hangar"

/area/corvette/unscironwill/starboardhangar
	name = "UNSC Iron Will Starboard Hangar"

//ship weapon areas
/area/corvette/unscironwill/portbatterycontrol
	name = "UNSC Iron Will Port Battery Control"

/area/corvette/unscironwill/starboardbatterycontrol
	name = "UNSC Iron Will Starboard Battery Control"

/area/corvette/unscironwill/starboardbattery
	name = "UNSC Iron Will Starboard Gun Battery"

/area/corvette/unscironwill/portbattery
	name = "UNSC Iron Will Port Gun Battery"

/area/corvette/unscironwill/portrockets
 	name = "UNSC Iron Will Port Rocket Pods"

/area/corvette/unscironwill/starboardrockets
 	name = "UNSC Iron Will Starboard Rocket Pods"

//Overmap Weapon Console Defines//


/obj/machinery/overmap_weapon_console/deck_gun_control/local/unscironwillport
	deck_gun_area = /area/corvette/unscironwill/portbattery

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/unscironwillport
	deck_gun_area = /area/corvette/unscironwill/portrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/unscironwillstarboard
	deck_gun_area = /area/corvette/unscironwill/starboardrockets

/obj/machinery/overmap_weapon_console/deck_gun_control/local/unscironwillstarboard
	deck_gun_area = /area/corvette/unscironwill/starboardbattery
