/obj/machinery/atmospherics/portables_connector
	icon = 'icons/atmos/connector.dmi'
	icon_state = "map_connector"

	name = "Connector Port"
	desc = "For connecting portables devices related to atmospherics control."

	dir = SOUTH
	initialize_directions = SOUTH

	var/obj/machinery/portable_atmospherics/connected_device

	var/obj/machinery/atmospherics/node

	var/datum/pipe_network/network

	var/on = 0
	use_power = 0
	level = 1


/obj/machinery/atmospherics/portables_connector/New()
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/portables_connector/update_icon()
	icon_state = "connector"

/obj/machinery/atmospherics/portables_connector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/portables_connector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/portables_connector/process()
	..()
	if(!on)
		return
	if(!connected_device)
		on = 0
		return
	if(network)
		network.update = 1
	return 1

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/portables_connector/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node)
		network = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/portables_connector/Del()
	loc = null

	if(connected_device)
		connected_device.disconnect()

	if(node)
		node.disconnect(src)
		del(network)

	node = null

	..()

/obj/machinery/atmospherics/portables_connector/initialize()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node = target
				break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/portables_connector/build_network()
	if(!network && node)
		network = new /datum/pipe_network()
		network.normal_members += src
		network.build_network(node, src)


/obj/machinery/atmospherics/portables_connector/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node)
		return network

	if(reference==connected_device)
		return network

	return null

/obj/machinery/atmospherics/portables_connector/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/machinery/atmospherics/portables_connector/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(connected_device)
		results += connected_device.air_contents

	return results

/obj/machinery/atmospherics/portables_connector/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node)
		del(network)
		node = null

	update_underlays()

	return null


/obj/machinery/atmospherics/portables_connector/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	if (connected_device)
		user << "\red You cannot unwrench this [src], dettach [connected_device] first."
		return 1
	if (locate(/obj/machinery/portable_atmospherics, src.loc))
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
		del(src)
