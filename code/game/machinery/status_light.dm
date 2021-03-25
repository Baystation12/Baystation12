/obj/machinery/status_light
	name = "combustion chamber status indicator"
	desc = "A status indicator for a combustion chamber, based on temperature."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doortimer-p"
	anchored = TRUE
	var/frequency = 1441
	var/alert_temperature = 10000
	var/alert = 1
	var/datum/radio_frequency/radio_connection

/obj/machinery/status_light/Initialize()
	. = ..()
	update_icon()
	radio_connection = register_radio(src, frequency, frequency, RADIO_ATMOSIA)


/obj/machinery/status_light/on_update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "doortimer-b"
		return
	icon_state = "doortimer[alert]"

/obj/machinery/status_light/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || !signal.data["temperature"])
		return 0

	if(signal.data["temperature"] >= alert_temperature)
		alert = 1
	else
		alert = 2

	update_icon()
	return
