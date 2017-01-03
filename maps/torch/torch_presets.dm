var/const/NETWORK_CALYPSO = "Calypso"

/obj/machinery/camera/network/calypso
	network = list(NETWORK_CALYPSO)

/obj/machinery/telecomms/relay/preset/shuttle
	id = "Calypso Relay"
	autolinkers = list("s_relay")

/datum/map/torch/get_network_access(var/network)
	if(network == NETWORK_CALYPSO)
		return access_mailsorting
	return ..()

/datum/map/torch
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_CALYPSO,
		NETWORK_ENGINE,
		NETWORK_EXPEDITION,
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
