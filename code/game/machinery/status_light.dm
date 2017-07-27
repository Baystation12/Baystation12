/obj/machinery/status_light
	name = "combustion chamber status indicator"
	desc = "A status indicator for a combustion chamber, based on temperature."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doortimer-p"
	var/frequency = 1439
	var/id_tag
	var/alert_temperature = 8000
	var/reset_temperature = 500//Temperature below which the chamber is no longer considered "on"
	var/alert = 1
	var/ignition_ready = 0
	var/ready_percent = 5 //Percent phoron in the air before the chamber signals ready for ignition
	var/datum/radio_frequency/radio_connection

/obj/machinery/status_light/Initialize()
	. = ..()
	update_icon()
	radio_connection = register_radio(src, frequency, frequency, RADIO_ATMOSIA)


/obj/machinery/status_light/update_icon()
	if(stat & (NOPOWER|BROKEN) || ignition_ready == 0)
		icon_state = "doortimer-b"
		return
	icon_state = "doortimer[alert]"

/obj/machinery/status_light/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || !signal.data["temperature"] || !signal.data["pressure"] || !signal.data["phoron"])
		return 0

	if((signal.data["phoron"] >= ready_percent && text2num(signal.data["pressure"]) >= 10.13) || signal.data["temperature"] >= reset_temperature)
	//Either the chamber is ready to light (phoron present in the air) or temperature is such that it's already lit.  Either way, show a light.
	//Pressure check added because very low pressures can sometimes show high phoron %, presumably from 1-2 molecules in the air.
		ignition_ready = 1
	else
		ignition_ready = 0

	if(signal.data["temperature"] >= alert_temperature)
		alert = 1
	else
		alert = 2

	update_icon()
	return
