/obj/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = POWER_USE_OFF
	construct_state = /singleton/machine_construction/default/panel_closed

	var/datum/gas_mixture/air_contents = new

	var/obj/machinery/atmospherics/portables_connector/connected_port
	var/obj/item/tank/holding

	var/volume = 0
	var/destroyed = 0

	var/start_pressure = ONE_ATMOSPHERE
	var/maximum_pressure = 90 * ONE_ATMOSPHERE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE

/obj/machinery/portable_atmospherics/New()
	..()

	air_contents.volume = volume
	air_contents.temperature = T20C

	return 1

/obj/machinery/portable_atmospherics/Destroy()
	QDEL_NULL(air_contents)
	QDEL_NULL(holding)
	. = ..()

/obj/machinery/portable_atmospherics/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/portable_atmospherics/LateInitialize(mapload)
	var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
	if(port)
		connect(port)
		update_icon()

/obj/machinery/portable_atmospherics/Process()
	if(!connected_port) //only react when pipe_network will ont it do it for you
		//Allow for reactions
		air_contents.react()
	else
		update_icon()

/obj/machinery/portable_atmospherics/proc/StandardAirMix()
	return list(
		GAS_OXYGEN = O2STANDARD * MolesForPressure(),
		GAS_NITROGEN = N2STANDARD *  MolesForPressure())

/obj/machinery/portable_atmospherics/proc/MolesForPressure(target_pressure = start_pressure)
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/machinery/portable_atmospherics/on_update_icon()
	return null

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	connected_port.on = 1 //Activate port updates

	anchored = TRUE //Prevent movement

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !network.gases.Find(air_contents))
		network.gases += air_contents
		network.update = 1

	return 1

/obj/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= air_contents

	anchored = FALSE

	connected_port.connected_device = null
	connected_port = null

	return 1

/obj/machinery/portable_atmospherics/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(src)
	if (network)
		network.update = 1

/obj/machinery/portable_atmospherics/use_tool(obj/item/W, mob/living/user, list/click_params)
	if ((istype(W, /obj/item/tank) && !destroyed))
		if (holding)
			to_chat(user, SPAN_WARNING("\The [src] already contains a tank!"))
			return
		if(!user.unEquip(W, src))
			return TRUE
		holding = W
		update_icon()
		return TRUE

	if(isWrench(W))
		if(connected_port)
			disconnect()
			to_chat(user, SPAN_NOTICE("You disconnect \the [src] from the port."))
			update_icon()
			return TRUE
		else
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector) in loc
			if(possible_port)
				if(connect(possible_port))
					to_chat(user, SPAN_NOTICE("You connect \the [src] to the port."))
					update_icon()
					return TRUE
				else
					to_chat(user, SPAN_NOTICE("\The [src] failed to connect to the port."))
					return TRUE
			else
				to_chat(user, SPAN_NOTICE("Nothing happens."))
				return TRUE

	return ..()

/obj/machinery/portable_atmospherics/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered
	uncreated_component_parts = null
	stat_immune = 0
	use_power = POWER_USE_IDLE
	var/power_rating
	var/power_losses
	var/last_power_draw = 0

/obj/machinery/portable_atmospherics/powered/power_change()
	. = ..()
	if(. && (!is_powered()))
		update_use_power(POWER_USE_IDLE)

/obj/machinery/portable_atmospherics/powered/components_are_accessible(path)
	return panel_open

/obj/machinery/portable_atmospherics/proc/log_open()
	if(length(air_contents.gas) == 0)
		return

	var/gases = ""
	for(var/gas in air_contents.gas)
		if(gases)
			gases += ", [gas]"
		else
			gases = gas
	log_and_message_admins("opened [src.name], containing [gases].")

/obj/machinery/portable_atmospherics/powered/dismantle()
	if(isturf(loc))
		playsound(loc, 'sound/effects/spray.ogg', 10, 1, -3)
		loc.assume_air(air_contents)
	. = ..()

/obj/machinery/portable_atmospherics/MouseDrop_T(mob/living/M, mob/living/user)
	do_climb(user, FALSE)

/obj/machinery/portable_atmospherics/get_warmth()
	var/datum/gas_mixture/contents = return_air()
	return contents.temperature
