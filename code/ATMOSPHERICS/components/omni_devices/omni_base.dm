//--------------------------------------------
// Base omni device
//--------------------------------------------
/obj/machinery/atmospherics/omni
	icon_state = ""
	dir = SOUTH
	use_power = 1
	initialize_directions = 0

	var/on = 0
	var/configuring = 0
	var/target_pressure = ONE_ATMOSPHERE

	var/icon/icon_on
	var/icon/icon_off
	var/icon/icon_error

	var/config_error = 0

	var/tag_north = ATM_NONE
	var/tag_south = ATM_NONE
	var/tag_east = ATM_NONE
	var/tag_west = ATM_NONE

	var/overlays_on[8]
	var/overlays_off[8]
	var/overlays_error[2]
	var/underlays_current[8]

	var/list/ports = new()

/obj/machinery/atmospherics/omni/New()
	..()
	
	ports = new()

	for(var/d in cardinal)
		var/datum/omni_port/new_port = new(src, d)
		switch(d)
			if(NORTH)
				new_port.mode = tag_north
			if(SOUTH)
				new_port.mode = tag_south
			if(EAST)
				new_port.mode = tag_east
			if(WEST)
				new_port.mode = tag_west
		if(new_port.mode > 0)
			initialize_directions |= d
		ports += new_port
	
	build_icons()

/obj/machinery/atmospherics/omni/mixer/update_icon()
	if(stat & NOPOWER)
		overlays = overlays_off
	else if(config_error)
		overlays = overlays_error
		on = 0
	else if(inputs.len > 0 && output)
		overlays = on ? (overlays_on) : (overlays_off)
	else
		overlays = overlays_off
		on = 0

	underlays = underlays_current

	return

/obj/machinery/atmospherics/omni/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/omni/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/device/pipe_painter))	//for updating the color of connected pipe ends
		for(var/datum/omni_port/P in ports)
			P.update = 1
		update_ports()
		return

	if(!istype(W, /obj/item/weapon/wrench))
		return ..()
	var/turf/T = src.loc
	if(level==1 && isturf(T) && T.intact)
		user << "\red You must remove the plating first."
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		user << "\red You cannot unwrench this [src], it too exerted due to internal pressure."
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user << "\blue You begin to unfasten \the [src]..."
	if(do_after(user, 40))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"\blue You have unfastened \the [src].", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		del(src)

/obj/machinery/atmospherics/omni/attack_hand(user as mob)
	if(..())
		return

	src.add_fingerprint(usr)
	ui_interact(user)
	return

/obj/machinery/atmospherics/omni/proc/build_icons()
	if(!omni_icons)
		gen_omni_icons()

	var/core_icon = null
	if(istype(src, /obj/machinery/atmospherics/omni/mixer))
		core_icon = "mixer"
	else if(istype(src, /obj/machinery/atmospherics/omni/filter))
		core_icon = "filter"
	else
		return

	//directional icons are layers 1,2,4,8, so the core icon is layer 3
	if(core_icon)
		overlays_off[3] = omni_icons[core_icon]
		overlays_on[3] = omni_icons[core_icon + "_glow"]

		overlays_error[1] = omni_icons[core_icon]
		overlays_error[2] = omni_icons["error"]

	update_icon()

/obj/machinery/atmospherics/omni/proc/update_port_icons()
	for(var/datum/omni_port/P in ports)
		if(P.update)
			var/list/port_icons = select_port_icons(P)
			if(port_icons)
				if(P.node)
					underlays_current[P.dir] = omni_icons[port_icons["pipe_icon"]]
				else
					underlays_current[P.dir] = null
				overlays_off[P.dir] = omni_icons[port_icons["off_icon"]]
				overlays_on[P.dir] = omni_icons[port_icons["on_icon"]]
			else
				underlays_current[P.dir] = null
				overlays_off[P.dir] = null
				overlays_on[P.dir] = null

	update_icon()

/obj/machinery/atmospherics/omni/proc/select_port_icons(var/datum/omni_port/P)
	if(!istype(P))
		return

	if(P.mode > 0)
		var/ic_dir = null
		switch(P.dir)
			if(NORTH)
				ic_dir = "north"
			if(SOUTH)
				ic_dir = "south"
			if(EAST)
				ic_dir = "east"
			if(WEST)
				ic_dir = "west"

		var/ic_on = null
		var/ic_off = null
		switch(P.mode)
			if(ATM_INPUT)
				ic_on = "_in_glow"
				ic_off = "_in"
			if(ATM_OUTPUT)
				ic_on = "_out_glow"
				ic_off = "_out"
			if(ATM_O2 to ATM_N2O)
				ic_on = "_filter"
				ic_off = "_out"

		var/pipe_state = ic_dir + "_pipe"
		if(P.node)
			if(P.node.color)
				pipe_state += "_[P.node.color]"
		
		return list("on_icon" = ic_dir + ic_on, "off_icon" = ic_dir + ic_off, "pipe_icon" = pipe_state)

/obj/machinery/atmospherics/omni/proc/update_ports()
	sort_ports()
	update_port_icons()
	for(var/datum/omni_port/P in ports)
		P.update = 0

/obj/machinery/atmospherics/omni/proc/sort_ports()
	return


// Housekeeping and pipe network stuff below

/obj/machinery/atmospherics/omni/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	for(var/datum/omni_port/P in ports)
		if(reference == P.node)
			P.network = new_network
			break

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/omni/Del()
	loc = null

	for(var/datum/omni_port/P in ports)
		if(P.node)
			P.node.disconnect(src)
			del(P.network)
			P.node = null

	..()

/obj/machinery/atmospherics/omni/initialize()
	for(var/datum/omni_port/P in ports)
		if(P.node || P.mode == 0)
			continue
		for(var/obj/machinery/atmospherics/target in get_step(src, P.dir))
			if(target.initialize_directions & get_dir(target,src))
				P.node = target
				break

	for(var/datum/omni_port/P in ports)
		P.update = 1

	update_ports()

/obj/machinery/atmospherics/omni/build_network()
	for(var/datum/omni_port/P in ports)
		if(!P.network && P.node)
			P.network = new /datum/pipe_network()
			P.network.normal_members += src
			P.network.build_network(P.node, src)

/obj/machinery/atmospherics/omni/return_network(obj/machinery/atmospherics/reference)
	build_network()

	for(var/datum/omni_port/P in ports)
		if(reference == P.node)
			return P.network

	return null

/obj/machinery/atmospherics/omni/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	for(var/datum/omni_port/P in ports)
		if(P.network == old_network)
			P.network = new_network

	return 1

/obj/machinery/atmospherics/omni/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	for(var/datum/omni_port/P in ports)
		if(P.network == reference)
			results += P.air

	return results

/obj/machinery/atmospherics/omni/disconnect(obj/machinery/atmospherics/reference)
	for(var/datum/omni_port/P in ports)
		if(reference == P.node)
			del(P.network)
			P.node = null
			P.update = 1
			break
	
	update_ports()

	return null