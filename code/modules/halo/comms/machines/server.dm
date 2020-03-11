
/obj/machinery/overmap_comms/server
	name = "telecommunications server"
	icon_state = "comm_server"
	icon_state_active = "comm_server"
	icon_state_inactive = "comm_server_off"
	desc = "A backup of the radio signals recieved."
	var/list/saved_frequencies = list()	//numbers stored as text indexing a text ID for a cipher
	var/list/virtual_dongles = list()

/obj/machinery/overmap_comms/server/added_to_network(var/datum/overmap_comms_network/network)
	network.server_connected(src)

/obj/machinery/overmap_comms/server/removed_from_network(var/datum/overmap_comms_network/network)
	network.server_disconnected(src)

/obj/machinery/overmap_comms/server/proc/has_cipher(var/datum/encryption_cipher/cipher)
	if(my_ciphers.Find(cipher))
		return 1

	return 0






//PRESETS
/*
#define HUMAN_RADIO "System"
#define EBAND_RADIO "EBAND"
#define INNIE_RADIO "INNIE"
#define URFC_RADIO "URFC"
#define SEC_RADIO "GCPD"
#define SQUAD_RADIO "SQUAD"
#define MARINE_RADIO "TEAM1"
#define ODST_RADIO "TEAM2"
#define ONI_RADIO "TEAM3"
#define SPARTAN_RADIO "TEAM4"
#define FLEET_RADIO "FLEET"
#define SHIP_RADIO "SHIP"
#define COV_RADIO "Battlenet"
*/
/obj/machinery/overmap_comms/server/unsc
	machine_type = /obj/machinery/overmap_comms/server

/obj/machinery/overmap_comms/server/unsc/Initialize()

	for(var/channel_name in list(HUMAN_RADIO, EBAND_RADIO, SQUAD_RADIO, MARINE_RADIO, ODST_RADIO, ONI_RADIO, SPARTAN_RADIO, FLEET_RADIO, SHIP_RADIO))
		var/obj/item/device/channel_dongle/dongle = GLOB.channels_dongles[channel_name]
		var/obj/item/device/channel_dongle/ourdongle = new dongle.type(src)
		virtual_dongles.Add(ourdongle)
		saved_frequencies["[ourdongle.frequency]"] = ourdongle

	. = ..()
