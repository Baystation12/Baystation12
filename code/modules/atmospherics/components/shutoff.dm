/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"

	name = "automatic shutoff valve"
	var/threshold = ONE_ATMOSPHERE * 0.9
	var/lower_threshold = 5
	var/node1_last_pressure = 0
	var/node2_last_pressure = 0
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

/obj/machinery/atmospherics/valve/shutoff/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	return

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
		else
			if((node1_pressure >= node1_last_pressure) && (node2_pressure >= node2_last_pressure))
				open()

	node1_last_pressure = node1_pressure
	node2_last_pressure = node2_pressure

	return