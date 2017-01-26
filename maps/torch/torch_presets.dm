var/const/NETWORK_CALYPSO = "Calypso"

/obj/machinery/camera/network/calypso
	network = list(NETWORK_CALYPSO)

/obj/machinery/telecomms/relay/preset/shuttle
	id = "Calypso Relay"
	autolinkers = list("s_relay")

/datum/map/torch/get_network_access(var/network)
	if(network == NETWORK_CALYPSO)
		return access_calypso
	return ..()

var/const/NETWORK_AQUILA = "Aquila"

/obj/machinery/camera/network/aquila
	network = list(NETWORK_AQUILA)

/obj/machinery/telecomms/relay/preset/calypso
	id = "Calypso Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/aquila
	id = "Aquila Relay"
	autolinkers = list("s_relay")

/datum/map/torch/get_network_access(var/network)
	if(network == NETWORK_AQUILA)
		return access_aquila
	return ..()

/datum/map/torch/get_network_access(var/network)
	if(network == NETWORK_BRIDGE)
		return access_heads
	return ..()

/datum/map/torch/get_network_access(var/network)
	if(network == NETWORK_POD)
		return access_guppy
	return ..()

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
		NETWORK_PRISON,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_POWER,
		NETWORK_THUNDER,
	)
