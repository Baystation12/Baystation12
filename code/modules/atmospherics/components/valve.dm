/obj/machinery/atmospherics/valve
	icon = 'icons/atmos/valve.dmi'
	icon_state = "map_valve0"

	name = "manual valve"
	desc = "A pipe valve."

	level = 1
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	layer = ABOVE_CATWALK_LAYER

	var/open = 0
	var/openDuringInit = 0


	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	connect_dir_type = SOUTH | NORTH
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR
	build_icon_state = "mvalve"

/obj/machinery/atmospherics/valve/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/on_update_icon(animation)
	if(animation)
		flick("valve[src.open][!src.open]",src)
	else
		icon_state = "valve[open]"

/obj/machinery/atmospherics/valve/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, get_dir(src, node1), node1 ? node1.icon_connect_type : "")
		add_underlay(T, node2, get_dir(src, node2), node2 ? node2.icon_connect_type : "")

/obj/machinery/atmospherics/valve/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/valve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network_node1 = new_network
		if(open)
			network_node2 = new_network
	else if(reference == node2)
		network_node2 = new_network
		if(open)
			network_node1 = new_network

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

/obj/machinery/atmospherics/valve/Destroy()
	if(node1)
		node1.disconnect(src)
		qdel(network_node1)
	if(node2)
		node2.disconnect(src)
		qdel(network_node2)

	node1 = null
	node2 = null

	. = ..()

/obj/machinery/atmospherics/valve/proc/open()
	if(open) return 0

	open = 1
	update_icon()

	if(network_node1&&network_node2)
		network_node1.merge(network_node2)
		network_node2 = network_node1

	if(network_node1)
		network_node1.update = 1
	else if(network_node2)
		network_node2.update = 1

	if (usr)
		visible_message(SPAN_WARNING("\The [usr] opens \the [src]."), range = 5)

	return 1

/obj/machinery/atmospherics/valve/proc/close()
	if(!open)
		return 0

	open = 0
	update_icon()

	if(network_node1)
		qdel(network_node1)
	if(network_node2)
		qdel(network_node2)

	build_network()

	if (usr)
		visible_message(SPAN_WARNING("\The [usr] closes \the [src]."), range = 5)

	return 1

/obj/machinery/atmospherics/valve/proc/toggle()
	return open ? close() : open()

/obj/machinery/atmospherics/valve/physical_attack_hand(mob/user)
	user_toggle()
	return TRUE

/obj/machinery/atmospherics/valve/proc/user_toggle()
	update_icon(1)
	sleep(10)
	toggle()

/obj/machinery/atmospherics/valve/Process()
	..()
	return PROCESS_KILL

/obj/machinery/atmospherics/valve/atmos_init()
	..()
	var/node1_dir
	var/node2_dir

	for(var/direction in GLOB.cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break
	for(var/obj/machinery/atmospherics/target in get_step(src,node2_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node2 = target
				break

	update_icon()
	update_underlays()

	if(openDuringInit)
		close()
		open()
		openDuringInit = 0

/obj/machinery/atmospherics/valve/build_network()
	if(!network_node1 && node1)
		network_node1 = new /datum/pipe_network()
		network_node1.normal_members += src
		network_node1.build_network(node1, src)

	if(!network_node2 && node2)
		network_node2 = new /datum/pipe_network()
		network_node2.normal_members += src
		network_node2.build_network(node2, src)

/obj/machinery/atmospherics/valve/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return network_node1

	if(reference==node2)
		return network_node2

	return null

/obj/machinery/atmospherics/valve/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network_node1 == old_network)
		network_node1 = new_network
	if(network_node2 == old_network)
		network_node2 = new_network

	return 1

/obj/machinery/atmospherics/valve/return_network_air(datum/pipe_network/reference)
	return null

/obj/machinery/atmospherics/valve/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network_node1)
		node1 = null

	else if(reference==node2)
		qdel(network_node2)
		node2 = null

	update_underlays()

	return null

/obj/machinery/atmospherics/valve/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/wrench))
		return ..()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it is too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, src)
		qdel(src)

/obj/machinery/atmospherics/valve/examine(mob/user)
	. = ..()
	to_chat(user, "It is [open ? "open" : "closed"].")

/decl/public_access/public_variable/valve_open
	expected_type = /obj/machinery/atmospherics/valve
	name = "valve open"
	desc = "Whether or not the valve is open."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/valve_open/access_var(obj/machinery/atmospherics/valve/valve)
	return valve.open

/decl/public_access/public_method/open_valve
	name = "open valve"
	desc = "Sets the valve to open."
	call_proc = /obj/machinery/atmospherics/valve/proc/open

/decl/public_access/public_method/close_valve
	name = "open valve"
	desc = "Sets the valve to open."
	call_proc = /obj/machinery/atmospherics/valve/proc/close

/decl/public_access/public_method/toggle_valve
	name = "toggle valve"
	desc = "Toggles whether the valve is open or closed."
	call_proc = /obj/machinery/atmospherics/valve/proc/toggle

/obj/machinery/atmospherics/valve/digital		// can be controlled by AI
	name = "digital valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_valve.dmi'
	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_variables = list(/decl/public_access/public_variable/valve_open)
	public_methods = list(
		/decl/public_access/public_method/open_valve,
		/decl/public_access/public_method/close_valve,
		/decl/public_access/public_method/toggle_valve
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/valve = 1)

	build_icon_state = "dvalve"

/obj/machinery/atmospherics/valve/digital/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	user_toggle()
	return TRUE

/obj/machinery/atmospherics/valve/digital/physical_attack_hand(mob/user)
	return FALSE

/obj/machinery/atmospherics/valve/digital/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/digital/on_update_icon()
	..()
	if(!powered())
		icon_state = "valve[open]nopower"

/decl/stock_part_preset/radio/receiver/valve
	frequency = FUEL_FREQ
	filter = RADIO_ATMOSIA
	receive_and_call = list(
		"valve_open" = /decl/public_access/public_method/open_valve,
		"valve_close" = /decl/public_access/public_method/close_valve,
		"valve_toggle" = /decl/public_access/public_method/toggle_valve
	)
