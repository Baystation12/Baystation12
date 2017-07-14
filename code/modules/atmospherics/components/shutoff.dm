/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"

	name = "automatic shutoff valve"
	desc = "A pipe valve. There is a reset button on the side."
	var/threshold = 101.15
	var/node1_last_pressure = 0
	var/node2_last_pressure = 0
	var/safe_counter = 0
	var/override_counter = 0
	level = 1
	connect_types = CONNECT_TYPE_SCRUBBER | CONNECT_TYPE_SUPPLY | CONNECT_TYPE_REGULAR


/obj/machinery/atmospherics/valve/shutoff/update_icon()
	icon_state = "vclamp[open]"

/obj/machinery/atmospherics/valve/shutoff/New()
	GLOB.processing_objects |= src
	open()
	hide(1)
	..()

/obj/machinery/atmospherics/valve/shutoff/Destroy()
	GLOB.processing_objects -= src
	..()

/obj/machinery/atmospherics/valve/shutoff/attack_hand(mob/user as mob)
	..()
	override_counter = 3

/obj/machinery/atmospherics/valve/shutoff/hide(var/do_hide)
	if(do_hide)
		if(level == 1)
			plane = ABOVE_PLATING_PLANE
			layer = PIPE_LAYER
		else if(level == 2)
			..()
	else
		reset_plane_and_layer()

/obj/machinery/atmospherics/valve/shutoff/process()
	..()

	if(!node1 || !node2)
		return
	var/datum/gas_mixture/node1_air = node1.return_air()
	var/datum/gas_mixture/node2_air = node2.return_air()
	var/node1_pressure = node1_air.return_pressure()
	var/node2_pressure = node2_air.return_pressure()
	if(node1_last_pressure && node2_last_pressure && !override_counter)
		if(open)
			if(((node1_pressure <= threshold) || (node2_pressure <= threshold)) && (!((node1_pressure >= node1_last_pressure) && (node2_pressure >= node2_last_pressure)))) //I'm not proud of this line. /BlueNexus
				close()
				safe_counter = 0
		else
			if((node1_pressure >= node1_last_pressure) && (node2_pressure >= node2_last_pressure))
				safe_counter++
			else
				safe_counter = 0
			if(safe_counter >= 6)
				open()
				safe_counter = 0

	node1_last_pressure = node1_pressure
	node2_last_pressure = node2_pressure
	if(override_counter)
		override_counter--

	return