/obj/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"

	name = "Air Scrubber"
	desc = "Has a valve and pump attached to it."
	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000			// 30000 W ~ 40 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes
	identifier = "AScr"

	level = ATOM_LEVEL_UNDER_TILE

	var/hibernate = 0 //Do we even process?
	var/scrubbing = SCRUBBER_EXCHANGE
	var/list/scrubbing_gas

	var/panic = 0 //is this scrubber panicked?

	var/welded = 0
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER
	build_icon_state = "scrubber"

	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/radio/transmitter/on_event,
	)
	public_variables = list(
		/singleton/public_access/public_variable/input_toggle,
		/singleton/public_access/public_variable/area_uid,
		/singleton/public_access/public_variable/identifier,
		/singleton/public_access/public_variable/use_power,
		/singleton/public_access/public_variable/name,
		/singleton/public_access/public_variable/scrubbing,
		/singleton/public_access/public_variable/panic,
		/singleton/public_access/public_variable/scrubbing_gas
	)
	public_methods = list(
		/singleton/public_access/public_method/toggle_power,
		/singleton/public_access/public_method/refresh,
		/singleton/public_access/public_method/toggle_panic_siphon,
		/singleton/public_access/public_method/set_scrub_gas
	)
	stock_part_presets = list(
		/singleton/stock_part_preset/radio/receiver/vent_scrubber = 1,
		/singleton/stock_part_preset/radio/event_transmitter/vent_scrubber = 1
	)

	frame_type = /obj/item/pipe
	construct_state = /singleton/machine_construction/default/item_chassis
	base_type = /obj/machinery/atmospherics/unary/vent_scrubber

/obj/machinery/atmospherics/unary/vent_scrubber/on
	use_power = POWER_USE_IDLE
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/unary/vent_scrubber/Initialize()
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_FILTER
	icon = null

/obj/machinery/atmospherics/unary/vent_scrubber/on_update_icon(safety = 0)
	if(!check_icon_cache())
		return

	ClearOverlays()


	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	var/scrubber_icon = "scrubber"
	if(welded)
		scrubber_icon += "weld"
	else if (!powered() || !use_power)
		scrubber_icon += "off"
	else if(scrubbing == SCRUBBER_SIPHON)
		scrubber_icon += "in"
	else
		scrubber_icon += "on"

	AddOverlays(icon_manager.get_atmos_icon("device", , , scrubber_icon))

/obj/machinery/atmospherics/unary/vent_scrubber/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == ATOM_LEVEL_UNDER_TILE && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/machinery/atmospherics/unary/vent_scrubber/Initialize()
	if (!id_tag)
		id_tag = num2text(sequential_id("obj/machinery"))
	if(!scrubbing_gas)
		reset_scrubbing()
	var/area/A = get_area(src)
	if(A && !A.air_scrub_names[id_tag])
		var/new_name = "[A.name] Vent Scrubber #[length(A.air_scrub_names)+1]"
		A.air_scrub_names[id_tag] = new_name
		SetName(new_name)
	. = ..()


/obj/machinery/atmospherics/unary/vent_scrubber/proc/reset_scrubbing()
	if (initial(scrubbing_gas))
		scrubbing_gas = initial(scrubbing_gas)
	else
		scrubbing_gas = list()
		for(var/g in gas_data.gases)
			if(g != GAS_OXYGEN && g != GAS_NITROGEN)
				add_to_scrubbing(g)


/obj/machinery/atmospherics/unary/vent_scrubber/proc/add_to_scrubbing(new_gas)
	scrubbing_gas |= new_gas


/obj/machinery/atmospherics/unary/vent_scrubber/proc/remove_from_scrubbing(old_gas)
	if (old_gas in scrubbing_gas)
		scrubbing_gas -= old_gas


/obj/machinery/atmospherics/unary/vent_scrubber/RefreshParts()
	. = ..()
	toggle_input_toggle()

/obj/machinery/atmospherics/unary/vent_scrubber/Process()
	..()

	if (hibernate > world.time)
		return 1

	if (!node)
		update_use_power(POWER_USE_OFF)
	//broadcast_status()
	if(!use_power || (inoperable()))
		return 0
	if(welded)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1
	var/transfer_moles = 0
	if(scrubbing == SCRUBBER_SIPHON) //Just siphon all air
		//limit flow rate from turfs
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
		power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)
	else //limit flow rate from turfs
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

	if(scrubbing != SCRUBBER_SIPHON && power_draw <= 0)	//99% of all scrubbers
		//Fucking hibernate because you ain't doing shit.
		hibernate = world.time + (rand(100,200))
	else if(scrubbing == SCRUBBER_EXCHANGE) // after sleep check so it only does an exchange if there are bad gasses that have been scrubbed
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)
		power_draw += pump_gas(src, environment, air_contents, transfer_moles / 4, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	if(network)
		network.update = 1

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/hide(i) //to make the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_scrubber/proc/toggle_panic()
	var/singleton/public_access/public_variable/panic/panic = GET_SINGLETON(/singleton/public_access/public_variable/panic)
	panic.write_var(src, !panic)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/set_scrub_gas(list/gases)
	for(var/gas_id in gases)
		if((gas_id in scrubbing_gas) ^ gases[gas_id])
			scrubbing_gas ^= gas_id

/obj/machinery/atmospherics/unary/vent_scrubber/cannot_transition_to(state_path, mob/user)
	if(state_path == /singleton/machine_construction/default/deconstructed)
		if (is_powered() && use_power)
			return SPAN_WARNING("You cannot take this [src] apart, turn it off first.")
		var/turf/T = get_turf(src)
		if (node && node.level==ATOM_LEVEL_UNDER_TILE && isturf(T) && !T.is_plating())
			return SPAN_WARNING("You must remove the plating first.")
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			return SPAN_WARNING("You cannot take this [src] apart, it too exerted due to internal pressure.")
	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isWelder(W))
		var/obj/item/weldingtool/WT = W


		if(!WT.can_use(1,user))
			return TRUE

		to_chat(user, SPAN_NOTICE("Now welding \the [src]."))
		playsound(src, 'sound/items/Welder.ogg', 50, 1)

		if(!do_after(user, (W.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
			return TRUE

		if(!src || !WT.remove_fuel(1, user))
			return TRUE

		welded = !welded
		update_icon()
		playsound(src, 'sound/items/Welder2.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] [welded ? "welds \the [src] shut" : "unwelds \the [src]"]."), \
			SPAN_NOTICE("You [welded ? "weld \the [src] shut" : "unweld \the [src]"]."), \
			"You hear welding.")
		return TRUE

	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W")
	else
		to_chat(user, "You are too far away to read the gauge.")
	if(welded)
		to_chat(user, "It seems welded shut.")

/obj/machinery/atmospherics/unary/vent_scrubber/refresh()
	..()
	hibernate = FALSE
	toggle_input_toggle()

/obj/machinery/atmospherics/unary/vent_scrubber/on/sauna/reset_scrubbing()
	..()
	remove_from_scrubbing(GAS_STEAM)

/singleton/public_access/public_variable/scrubbing
	expected_type = /obj/machinery/atmospherics/unary/vent_scrubber
	name = "scrubbing mode"
	desc = "The scrubbing mode code, which identifies what the scrubber is doing."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_STRING

/singleton/public_access/public_variable/scrubbing/access_var(obj/machinery/atmospherics/unary/vent_scrubber/machine)
	return machine.scrubbing

/singleton/public_access/public_variable/scrubbing/write_var(obj/machinery/atmospherics/unary/vent_scrubber/machine, new_value)
	if(!(new_value in list(SCRUBBER_EXCHANGE, SCRUBBER_SCRUB, SCRUBBER_SIPHON)))
		return FALSE
	. = ..()
	if(.)
		machine.scrubbing = new_value
		if(new_value != SCRUBBER_SIPHON)
			machine.panic = FALSE

/singleton/public_access/public_variable/panic
	expected_type = /obj/machinery/atmospherics/unary/vent_scrubber
	name = "panic state"
	desc = "Whether or not the scrubber is in panic mode."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_BOOLEAN

/singleton/public_access/public_variable/panic/access_var(obj/machinery/atmospherics/unary/vent_scrubber/machine)
	return machine.panic

/singleton/public_access/public_variable/panic/write_var(obj/machinery/atmospherics/unary/vent_scrubber/machine, new_value)
	if(!(new_value in list(TRUE, FALSE)))
		return FALSE
	. = ..()
	if(.)
		machine.panic = new_value
		if(machine.panic)
			machine.update_use_power(POWER_USE_IDLE)
			machine.scrubbing = SCRUBBER_SIPHON
		else
			machine.scrubbing = SCRUBBER_EXCHANGE

/singleton/public_access/public_variable/scrubbing_gas
	expected_type = /obj/machinery/atmospherics/unary/vent_scrubber
	name = "gasses scrubbing"
	desc = "A list of gases that this scrubber is scrubbing."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_LIST

/singleton/public_access/public_variable/scrubbing_gas/access_var(obj/machinery/atmospherics/unary/vent_scrubber/machine)
	return machine.scrubbing_gas.Copy()

/singleton/public_access/public_method/toggle_panic_siphon
	name = "toggle panic siphon"
	desc = "Toggles the panic siphon function."
	call_proc = /obj/machinery/atmospherics/unary/vent_scrubber/proc/toggle_panic

/singleton/public_access/public_method/set_scrub_gas
	name = "set filter gases"
	desc = "Given a list of gases, sets whether the gas is being scrubbed to the value of the gas in the list."
	forward_args = TRUE
	call_proc = /obj/machinery/atmospherics/unary/vent_scrubber/proc/set_scrub_gas

/singleton/stock_part_preset/radio/event_transmitter/vent_scrubber
	frequency = PUMP_FREQ
	filter = RADIO_TO_AIRALARM
	event = /singleton/public_access/public_variable/input_toggle
	transmit_on_event = list(
		"area" = /singleton/public_access/public_variable/area_uid,
		"device" = /singleton/public_access/public_variable/identifier,
		"power" = /singleton/public_access/public_variable/use_power,
		"panic" = /singleton/public_access/public_variable/panic,
		"scrubbing" = /singleton/public_access/public_variable/scrubbing,
		"scrubbing_gas" = /singleton/public_access/public_variable/scrubbing_gas
	)

/singleton/stock_part_preset/radio/receiver/vent_scrubber
	frequency = PUMP_FREQ
	filter = RADIO_FROM_AIRALARM
	receive_and_call = list(
		"power_toggle" = /singleton/public_access/public_method/toggle_power,
		"toggle_panic_siphon" = /singleton/public_access/public_method/toggle_panic_siphon,
		"set_scrub_gas" = /singleton/public_access/public_method/set_scrub_gas,
		"status" = /singleton/public_access/public_method/refresh
	)
	receive_and_write = list(
		"set_power" = /singleton/public_access/public_variable/use_power,
		"panic_siphon" = /singleton/public_access/public_variable/panic,
		"set_scrubbing" = /singleton/public_access/public_variable/scrubbing,
		"init" = /singleton/public_access/public_variable/name
	)

/singleton/stock_part_preset/radio/receiver/vent_scrubber/shuttle
	frequency = SHUTTLE_AIR_FREQ

/singleton/stock_part_preset/radio/event_transmitter/vent_scrubber/shuttle
	frequency = SHUTTLE_AIR_FREQ

// Similar to the vent of the same name, for hybrid airlock-rooms
/obj/machinery/atmospherics/unary/vent_scrubber/on/shuttle_auxiliary
	stock_part_presets = list(
		/singleton/stock_part_preset/radio/receiver/vent_scrubber/shuttle = 1,
		/singleton/stock_part_preset/radio/event_transmitter/vent_scrubber/shuttle = 1
	)
