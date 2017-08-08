var/const/NETWORK_AQUILA      = "Aquila"
var/const/NETWORK_BRIDGE      = "Bridge"
var/const/NETWORK_CALYPSO     = "Calypso"
var/const/NETWORK_EXPEDITION  = "Expedition"
var/const/NETWORK_FIFTH_DECK  = "Fifth Deck"
var/const/NETWORK_FIRST_DECK  = "First Deck"
var/const/NETWORK_FOURTH_DECK = "Fourth Deck"
var/const/NETWORK_POD         = "General Utility Pod"
var/const/NETWORK_SECOND_DECK = "Second Deck"
var/const/NETWORK_SUPPLY      = "Supply"
var/const/NETWORK_THIRD_DECK  = "Third Deck"

/datum/map/torch/get_network_access(var/network)
	switch(network)
		if(NETWORK_AQUILA)
			return access_aquila
		if(NETWORK_BRIDGE)
			return access_heads
		if(NETWORK_CALYPSO)
			return access_calypso
		if(NETWORK_POD)
			return access_guppy
		if(NETWORK_SUPPLY)
			return access_mailsorting
	return get_shared_network_access(network) || ..()

/datum/map/torch
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_AQUILA,
		NETWORK_BRIDGE,
		NETWORK_CALYPSO,
		NETWORK_ENGINE,
		NETWORK_EXPEDITION,
		NETWORK_FIFTH_DECK,
		NETWORK_FIRST_DECK,
		NETWORK_FOURTH_DECK,
		NETWORK_ROBOTS,
		NETWORK_POD,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_SUPPLY,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_RESEARCH,
		NETWORK_SECURITY,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
		NETWORK_THUNDER,
	)

//
// Cameras
//

// Networks
/obj/machinery/camera/network/aquila
	network = list(NETWORK_AQUILA)

/obj/machinery/camera/network/bridge
	network = list(NETWORK_BRIDGE)

/obj/machinery/camera/network/calypso
	network = list(NETWORK_CALYPSO)

/obj/machinery/camera/network/expedition
	network = list(NETWORK_EXPEDITION)

/obj/machinery/camera/network/fifth_deck
	network = list(NETWORK_FIFTH_DECK)

/obj/machinery/camera/network/first_deck
	network = list(NETWORK_FIRST_DECK)

/obj/machinery/camera/network/fourth_deck
	network = list(NETWORK_FOURTH_DECK)

/obj/machinery/camera/network/pod
	network = list(NETWORK_POD)

/obj/machinery/camera/network/second_deck
	network = list(NETWORK_SECOND_DECK)

/obj/machinery/camera/network/supply
	network = list(NETWORK_SUPPLY)

/obj/machinery/camera/network/third_deck
	network = list(NETWORK_THIRD_DECK)

//
// T-Coms
//

/obj/machinery/telecomms/relay/preset/shuttle
	id = "Calypso Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/calypso
	id = "Calypso Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/aquila
	id = "Aquila Relay"
	autolinkers = list("s_relay")

//
// SMES units
//

// Substation SMES
/obj/machinery/power/smes/buildable/preset/torch/substation/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil(src)
	component_parts += new /obj/item/weapon/smes_coil(src)
	_input_maxed = TRUE
	_output_maxed = TRUE

// Substation SMES (charged and with full I/O setting)
/obj/machinery/power/smes/buildable/preset/torch/substation_full/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil(src)
	component_parts += new /obj/item/weapon/smes_coil(src)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Main Engine output SMES
/obj/machinery/power/smes/buildable/preset/torch/engine_main/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	component_parts += new /obj/item/weapon/smes_coil/super_capacity(src)
	component_parts += new /obj/item/weapon/smes_coil/super_capacity(src)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Shuttle SMES
/obj/machinery/power/smes/buildable/preset/torch/shuttle/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Hangar SMES. Charges the shuttles so needs a pretty big throughput.
/obj/machinery/power/smes/buildable/preset/torch/hangar/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE