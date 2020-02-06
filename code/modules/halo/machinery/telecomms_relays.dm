/obj/machinery/telecomms/relay/long_range_planetary
	name = "Planetary Signal Relay"
	desc = "A massive tower used to send signals an extreme range."
	icon = 'code/modules/halo/icons/machinery/radio_tower.dmi'
	icon_state = "tower_on"
	bounds = "96;96"
	signal_range = 42//6 screens worth of overmap-range.

/obj/machinery/telecomms/relay/long_range_emergency
	name = "Emergency Relay"
	desc = "A high-power relay dedicated to EBAND broadcast."
	signal_range = 28 // 4 screens of range, EBAND only.

/obj/machinery/telecomms/relay/long_range_emergency/Initialize()
	. = ..()
	freq_listening = list(halo_frequencies.frequencies_human["EBAND"])

/obj/machinery/telecomms/relay/ship_relay
	name = "Shipboard Signal Relay"
	desc = "A compact signal relay designed for signal range extension."
	signal_range = 14 //Two screens of range.

/obj/machinery/telecomms/relay/flagship_relay
	name = "Heavy Duty Long Range Relay"
	desc = "Sends signals an incredible range."
	signal_range = 999 //INFINITRANSMIT
