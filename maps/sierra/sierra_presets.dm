var/global/const/NETWORK_CALYPSO     = "Charon"
var/global/const/NETWORK_EXPEDITION  = "Expedition"
var/global/const/NETWORK_POD         = "General Utility Pod"
var/global/const/NETWORK_FIRST_DECK  = "First Deck"
var/global/const/NETWORK_SECOND_DECK = "Second Deck"
var/global/const/NETWORK_THIRD_DECK  = "Third Deck"
var/global/const/NETWORK_FOURTH_DECK = "Fourth Deck"
var/global/const/NETWORK_BRIDGE_DECK = "Bridge Deck"
var/global/const/NETWORK_SUPPLY      = "Supply"
var/global/const/NETWORK_HANGAR      = "Hangar"
var/global/const/NETWORK_PETROV      = "Petrov"

//Overrides
var/global/const/NETWORK_COMMAND = "Command"
var/global/const/NETWORK_ENGINE  = "Engine"
var/global/const/NETWORK_ENGINEERING_OUTPOST = "Engineering Outpost"


/datum/map/sierra/get_network_access(network)
	switch(network)
		if(NETWORK_CALYPSO)
			return access_expedition_shuttle
		if(NETWORK_POD)
			return access_guppy
		if(NETWORK_SUPPLY)
			return access_mailsorting
		if(NETWORK_HANGAR)
			return access_hangar
		if(NETWORK_PETROV)
			return access_petrov
		if(NETWORK_EXPEDITION)
			return access_expedition_shuttle
	return get_shared_network_access(network) || ..()

/datum/map/sierra
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_FOURTH_DECK,
		NETWORK_BRIDGE_DECK,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_ENGINE,
		NETWORK_MEDICAL,
		NETWORK_RESEARCH,
		NETWORK_SECURITY,
		NETWORK_SUPPLY,
		NETWORK_MINE,
		NETWORK_EXPEDITION,
		NETWORK_HANGAR,
		NETWORK_CALYPSO,
		NETWORK_PETROV,
		NETWORK_POD,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
		NETWORK_THUNDER,
	)

	high_secure_areas = list(
		"Second Deck - AI Upload",
		"Second Deck - AI Upload Access"
	)

	secure_areas = list(
		"Second Deck - Engine - Supermatter",
		"Second Deck - Engineering - Technical Storage",
		"Second Deck - Teleporter",
		"First Deck - Telecoms - Storage",
		"First Deck - Telecoms - Monitoring",
		"First Deck - Telecoms",
		"Security - Brig",
		"Security - Prison Wing",
		"Third Deck - Hangar",
		"Third Deck - Hangar - Atmospherics Storage",
		"Third Deck - Water Cistern"
	)

//
// Cameras
//

// Networks

/obj/machinery/camera/network/exploration_shuttle
	network = list(NETWORK_CALYPSO)

/obj/machinery/camera/network/expedition
	network = list(NETWORK_EXPEDITION)

/obj/machinery/camera/network/first_deck
	network = list(NETWORK_FIRST_DECK)

/obj/machinery/camera/network/second_deck
	network = list(NETWORK_SECOND_DECK)

/obj/machinery/camera/network/third_deck
	network = list(NETWORK_THIRD_DECK)

/obj/machinery/camera/network/fourth_deck
	network = list(NETWORK_FOURTH_DECK)

/obj/machinery/camera/network/bridge_deck
	network = list(NETWORK_BRIDGE_DECK)

/obj/machinery/camera/network/pod
	network = list(NETWORK_POD)

/obj/machinery/camera/network/petrov
	network = list(NETWORK_PETROV)

/obj/machinery/camera/network/supply
	network = list(NETWORK_SUPPLY)

/obj/machinery/camera/network/hangar
	network = list(NETWORK_HANGAR)

/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/crescent
	network = list(NETWORK_CRESCENT)

/obj/machinery/camera/network/engine
	network = list(NETWORK_ENGINE)

/obj/machinery/camera/network/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

// Motion
/obj/machinery/camera/motion/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

// All Upgrades
/obj/machinery/camera/all/command
	network = list(NETWORK_COMMAND)

/datum/map/proc/get_shared_network_access(network)
	switch(network)
		if(NETWORK_COMMAND)
			return access_heads
		if(NETWORK_ENGINE, NETWORK_ENGINEERING_OUTPOST)
			return access_engine

/datum/computer_file/program/merchant

/obj/machinery/computer/shuttle_control/merchant

/turf/simulated/wall //landlubbers go home
	name = "bulkhead"

/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/singleton/flooring/tiling
	name = "deck"
