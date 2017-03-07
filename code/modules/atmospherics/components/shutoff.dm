/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"

	name = "automatic shutoff valve"
	desc = "A pipe valve. There is a reset button on the side."
	var/threshold = 101.15
	var/node1_last_pressure = 0
	var/node2_last_pressure = 0
	var/safe_counter = 0
	connect_types = CONNECT_TYPE_SCRUBBER | CONNECT_TYPE_SUPPLY | CONNECT_TYPE_REGULAR

/obj/machinery/atmospherics/valve/shutoff/update_icon()
	icon_state = "vclamp[open]"

/obj/machinery/atmospherics/valve/shutoff/New()
	processing_objects |= src
	open()
	..()

/obj/machinery/atmospherics/valve/shutoff/Destroy()
	processing_objects -= src
	..()

/obj/machinery/atmospherics/valve/shutoff/process()
	..()
	var/datum/gas_mixture/node1_air = node1.return_air()
	var/datum/gas_mixture/node2_air = node2.return_air()
	var/node1_pressure = node1_air.return_pressure()
	var/node2_pressure = node2_air.return_pressure()
	if(node1_last_pressure && node2_last_pressure)
		if(open)
			if(((node1_pressure <= threshold) || (node2_pressure <= threshold)) && (!((node1_pressure >= node1_last_pressure) && (node2_pressure >= node2_last_pressure)))) //I'm not proud of this line. /BlueNexus
				close()
				safe_counter = 0
		else
			if((node1_pressure >= node1_last_pressure) && (node2_pressure >= node2_last_pressure))
				safe_counter++
			else
				safe_counter = 0
			if(safe_counter >= 3)
				open()
				safe_counter = 0

	node1_last_pressure = node1_pressure
	node2_last_pressure = node2_pressure

	return