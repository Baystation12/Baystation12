


/* PLACEHOLDER */

/obj/machinery/overmap_comms/receiver
	name = "radio receiver dish"
	icon_state = "broadcast receiver"
	icon = 'code/modules/halo/comms/machines/telecomms.dmi'
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and recieve radio signals."

/obj/machinery/overmap_comms/receiver/proc/get_range_extension()
	//just return 1 for now, dont do any other checks
	return 1



/* OBSOLETE */

/obj/machinery/telecomms/relay/long_range_planetary
	name = "Planetary Signal Relay"
	desc = "A massive tower used to send signals an extreme range."
	icon = 'code/modules/halo/icons/machinery/radio_tower.dmi'
	icon_state = "tower_on"
	bounds = "96;96"

/obj/machinery/telecomms/relay/long_range_emergency
	name = "Emergency Relay"
	desc = "A high-power relay dedicated to EBAND broadcast."

/obj/machinery/telecomms/relay/ship_relay
	name = "Shipboard Signal Relay"
	desc = "A compact signal relay designed for signal range extension."

/obj/machinery/telecomms/relay/flagship_relay
	name = "Heavy Duty Long Range Relay"
	desc = "Sends signals an incredible range."