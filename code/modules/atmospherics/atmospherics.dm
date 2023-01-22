/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
/obj/machinery/atmospherics
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON

	var/nodealert = 0
	var/power_rating //the maximum amount of power the machine can use to do work, affects how powerful the machine is, in Watts

	layer = EXPOSED_PIPE_LAYER

	var/connect_types = CONNECT_TYPE_REGULAR
	var/connect_dir_type = SOUTH // Assume your dir is SOUTH. What dirs should you connect to?
	var/icon_connect_type = "" //"-supply" or "-scrubbers"

	var/initialize_directions = 0
	var/pipe_color

	var/static/datum/pipe_icon_manager/icon_manager
	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2

	var/atmos_initalized = FALSE
	var/build_icon = 'icons/obj/pipe-item.dmi'
	var/build_icon_state = "buildpipe"
	var/colorable = FALSE

	var/pipe_class = PIPE_CLASS_OTHER //If somehow something isn't set properly, handle it as something with zero connections. This will prevent runtimes.
	var/rotate_class = PIPE_ROTATE_STANDARD

/obj/machinery/atmospherics/Initialize()
	if(!icon_manager)
		icon_manager = new()

	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null

	set_dir(dir) // Does full dir init.
	. = ..()

/obj/machinery/atmospherics/proc/atmos_init()
	atmos_initalized = TRUE

/obj/machinery/atmospherics/hide(var/do_hide)
	if(do_hide && level == 1)
		layer = PIPE_LAYER
	else
		reset_plane_and_layer()

/obj/machinery/atmospherics/attackby(atom/A, mob/user as mob)
	if(istype(A, /obj/item/device/scanner/gas))
		return
	..()

/obj/machinery/atmospherics/proc/add_underlay(var/turf/T, var/obj/machinery/atmospherics/node, var/direction, var/icon_connect_type)
	if(node)
		if(!T.is_plating() && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "exposed" + icon_connect_type)

/obj/machinery/atmospherics/proc/update_underlays()
	if(check_icon_cache())
		return 1
	else
		return 0

/obj/machinery/atmospherics/proc/check_connect_types(obj/machinery/atmospherics/atmos1, obj/machinery/atmospherics/atmos2)
	return (atmos1.connect_types & atmos2.connect_types)

/obj/machinery/atmospherics/proc/check_connect_types_construction(obj/machinery/atmospherics/atmos1, obj/item/pipe/pipe2)
	return (atmos1.connect_types & pipe2.connect_types)

/obj/machinery/atmospherics/proc/check_icon_cache(var/safety = 0)
	if(!istype(icon_manager))
		if(!safety) //to prevent infinite loops
			icon_manager = new()
			check_icon_cache(1)
		return 0

	return 1

/obj/machinery/atmospherics/proc/color_cache_name(var/obj/machinery/atmospherics/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color

/obj/machinery/atmospherics/Process()
	last_flow_rate = 0
	last_power_draw = 0

	build_network()

/obj/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	// Check to see if should be added to network. Add self if so and adjust variables appropriately.
	// Note don't forget to have neighbors look as well!

	return null

/obj/machinery/atmospherics/proc/build_network()
	// Called to build a network from this node

	return null

/obj/machinery/atmospherics/proc/return_network(obj/machinery/atmospherics/reference)
	// Returns pipe_network associated with connection to reference
	// Notes: should create network if necessary
	// Should never return null

	return null

/obj/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	// Used when two pipe_networks are combining

/obj/machinery/atmospherics/proc/return_network_air(datum/pipe_network/reference)
	// Return a list of gas_mixture(s) in the object
	//		associated with reference pipe_network for use in rebuilding the networks gases list
	// Is permitted to return null

/obj/machinery/atmospherics/proc/disconnect(obj/machinery/atmospherics/reference)

/obj/machinery/atmospherics/on_update_icon()
	return null

// returns all pipe's endpoints. You can override, but you may then need to use a custom /item/pipe constructor.
/obj/machinery/atmospherics/proc/get_initialze_directions()
	return base_pipe_initialize_directions(dir, connect_dir_type)

/proc/base_pipe_initialize_directions(dir, connect_dir_type)
	if(!dir)
		return 0
	if(!(dir in GLOB.cardinal))
		return dir // You're on your own. Used for bent pipes.
	. = 0

	if(connect_dir_type & SOUTH)
		. |= dir
	if(connect_dir_type & NORTH)
		. |= turn(dir, 180)
	if(connect_dir_type & WEST)
		. |= turn(dir, -90)
	if(connect_dir_type & EAST)
		. |= turn(dir, 90)

/obj/machinery/atmospherics/set_dir(new_dir)
	. = ..()
	initialize_directions = get_initialze_directions()

/// Used by constructors. Shouldn't generally be called from elsewhere.
/obj/machinery/proc/set_initial_level()
	var/turf/T = get_turf(src)
	if(T)
		level = (!T.is_plating() ? 2 : 1)
