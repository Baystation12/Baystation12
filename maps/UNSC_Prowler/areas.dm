/area/corvette/unscfox
	name = "UNSC Aegis"
	has_gravity = 1
	power_environ = 1
	power_light = 1
	poweralm = 1
	requires_power = 1

//deck 1 areas
/area/corvette/unscfox/deck1/Bridge
	name = "UNSC Aegis Bridge"

/area/corvette/unscfox/deck1/Crewquarters
	name = "UNSC Aegis Crew Quarters"

/area/corvette/unscfox/deck1/Crewmess
	name = "UNSC Aegis Crew Mess Hall"

/area/corvette/unscfox/deck1/crewbathroom
	name = "UNSC Aegis Crew Bathrooms"

/area/corvette/unscfox/deck1/storage
	name = "UNSC Aegis Deck 1 Storage Bay"
	requires_power = 1

/area/corvette/unscfox/deck1/hallway
	name = "UNSC Aegis Deck 1 Hallway"

/area/corvette/unscfox/deck1/Reactorcore
	name = "UNSC Aegis Deck 1 Main Reactor Core"
	requires_power = 1

/area/corvette/unscfox/deck1/medbay
	name = "UNSC Aegis Deck 1  Medical Bay"

/area/corvette/unscfox/deck1/portengine
	name = "UNSC Aegis Deck 1 Port Engine"

/area/corvette/unscfox/deck1/starboardengine
	name = "UNSC Aegis Deck 1 Starboard Engine"

/area/corvette/unscfox/deck1/janitorialcloset
	name = "UNSC Aegis Deck 1 Janitorial Closet"



//deck 2 areas
/area/corvette/unscfox/deck2/hallway
	name = "UNSC Aegis Deck 2 Hallway"
	requires_power = 1

/area/corvette/unscfox/deck2/auxpowercore
	name = "UNSC Aegis Deck 2 Auxiliary Power Core"
	requires_power = 1

/area/corvette/unscfox/deck2/cells
	name = "UNSC Aegis Deck 2 Holding Cells"
	requires_power = 1

/area/corvette/unscfox/deck2/soeivbay
	name = "UNSC Aegis Deck 2 SOEIV Bay"
	requires_power = 1

/area/corvette/unscfox/deck2/odstbunks
	name = "UNSC Aegis Deck 2 ODST Bunks"
	requires_power = 1

/area/corvette/unscfox/deck2/nuclearstorage
	name = "UNSC Aegis Deck 2 Nuclear Payload Storage"
	requires_power = 1

/area/corvette/unscfox/deck2/umbilical
	name = "UNSC Aegis Deck 2 Docking Umbilical"
	requires_power = 1

/area/corvette/unscfox/deck2/cryodorms
	name = "UNSC Aegis Deck 2 Cryodorms"
	requires_power = 1

/area/corvette/unscfox/deck2/morgue
	name = "UNSC Aegis Deck 2 Morgue"
	requires_power = 0

/area/corvette/unscfox/deck2/communications
	name = "UNSC Aegis Deck 2 Communications Hub"
	requires_power = 1

/area/corvette/unscfox/deck2/airlock
	name = "UNSC Aegis Deck 2 External Airlock"
	requires_power = 1


//ship weapon areas

/area/corvette/unscfox/portbattery
	name = "UNSC Aegis Port Gun Battery"
	requires_power = 0

/area/corvette/unscfox/starboardrockets
	name = "UNSC Aegis Starboard Rocket Pods"
	requires_power = 0

//Overmap Weapon Console Defines//


/obj/machinery/overmap_weapon_console/deck_gun_control/local/unscfoxport
	deck_gun_area = /area/corvette/unscfox/portbattery

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/unscfoxstarboard
	deck_gun_area = /area/corvette/unscfox/starboardrockets

