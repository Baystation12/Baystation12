/obj/machinery/atmospherics/binary/valve
	icon = 'icons/atmos/valve.dmi'
	icon_state = "map_valve0"

	name = "manual valve"
	desc = "A pipe valve"

	level = 1

	init_dirs = NORTH|SOUTH

	var/open = 0
	var/openDuringInit = 0

/obj/machinery/atmospherics/binary/valve/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/binary/valve/update_icon(animation)
	if(animation)
		flick("valve[src.open][!src.open]",src)
	else
		icon_state = "valve[open]"

/obj/machinery/atmospherics/binary/valve/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, get_dir(src, node1))
		add_underlay(T, node2, get_dir(src, node2))

/obj/machinery/atmospherics/binary/valve/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/valve/New()
	..()

/obj/machinery/atmospherics/binary/valve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network1 = new_network
		if(open)
			network2 = new_network
	else if(reference == node2)
		network2 = new_network
		if(open)
			network1 = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	if(open)
		if(reference == node1)
			if(node2)
				return node2.network_expand(new_network, src)
		else if(reference == node2)
			if(node1)
				return node1.network_expand(new_network, src)

	return null

/obj/machinery/atmospherics/binary/valve/Destroy()
	loc = null
/*
	if(node1)
		node1.disconnect(src)
		qdel(network1)
	if(node2)
		node2.disconnect(src)
		qdel(network2)
*/
	disconnect_all(src)
	node1 = null
	node2 = null

	..()

/obj/machinery/atmospherics/binary/valve/proc/open()
	if(open) return 0

	open = 1
	update_icon()

	if(network1&&network2)
		network1.merge(network2)
		network2 = network1

	if(network1)
		network1.update = 1
	else if(network2)
		network2.update = 1

	return 1

/obj/machinery/atmospherics/binary/valve/proc/close()
	if(!open)
		return 0

	open = 0
	update_icon()

	if(network1)
		qdel(network1)
	if(network2)
		qdel(network2)

	build_network()

	return 1


/obj/machinery/atmospherics/binary/valve/attack_ai(mob/user as mob)
	return

/obj/machinery/atmospherics/binary/valve/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if (src.open)
		src.close()
	else
		src.open()

/obj/machinery/atmospherics/binary/valve/process()
	..()
	. = PROCESS_KILL

	return

/obj/machinery/atmospherics/binary/valve/initialize()
	..()

	build_network()

	if(openDuringInit)
		close()
		open()
		openDuringInit = 0

	return 1

/obj/machinery/atmospherics/binary/valve/build_network()
	if(!network1 && node1)
		network1 = new /datum/pipe_network()
		network1.normal_members += src
		network1.build_network(node1, src)

	if(!network2 && node2)
		network2 = new /datum/pipe_network()
		network2.normal_members += src
		network2.build_network(node2, src)

/obj/machinery/atmospherics/binary/valve/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return network1

	if(reference==node2)
		return network2

	return null

/obj/machinery/atmospherics/binary/valve/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network1 == old_network)
		network1 = new_network
	if(network2 == old_network)
		network2 = new_network

	return 1

/obj/machinery/atmospherics/binary/valve/return_network_air(datum/network/reference)
	return null
/*
/obj/machinery/atmospherics/binary/valve/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network1)
		node1 = null

	else if(reference==node2)
		qdel(network2)
		node2 = null

	update_underlays()

	return null
*/
/obj/machinery/atmospherics/binary/valve/digital		// can be controlled by AI
	name = "digital valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_valve.dmi'

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/valve/digital/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/binary/valve/digital/attack_hand(mob/user as mob)
	if(!powered())
		return
	if(!src.allowed(user))
		user << "\red Access denied."
		return
	..()

/obj/machinery/atmospherics/binary/valve/digital/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/binary/valve/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/binary/valve/digital/update_icon()
	..()
	if(!powered())
		icon_state = "valve[open]nopower"

/obj/machinery/atmospherics/binary/valve/digital/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/valve/digital/initialize()
	..()
	if(frequency)
		set_frequency(frequency)
	return 1

/obj/machinery/atmospherics/binary/valve/digital/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id))
		return 0

	switch(signal.data["command"])
		if("valve_open")
			if(!open)
				open()

		if("valve_close")
			if(open)
				close()

		if("valve_toggle")
			if(open)
				close()
			else
				open()

/obj/machinery/atmospherics/binary/valve/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	if (istype(src, /obj/machinery/atmospherics/binary/valve/digital))
		user << "\red You cannot unwrench this [src], it's too complicated."
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		user << "\red You cannot unwrench this [src], it too exerted due to internal pressure."
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user << "\blue You begin to unfasten \the [src]..."
	if (do_after(user, 40))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"\blue You have unfastened \the [src].", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)

/obj/machinery/atmospherics/binary/valve/examine(mob/user)
	..()
	user << "It is [open ? "open" : "closed"]."
