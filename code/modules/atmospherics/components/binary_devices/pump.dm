/*
Every cycle, the pump uses the air in air_in to try and make air_out the perfect pressure.

node1, air1, network1 correspond to input
node2, air2, network2 correspond to output

Thus, the two variables affect pump operation are set in New():
	air1.volume
		This is the volume of gas available to the pump that may be transfered to the output
	air2.volume
		Higher quantities of this cause more air to be perfected later
			but overall network volume is also increased as this increases...
*/

/obj/machinery/atmospherics/binary/pump
	icon = 'icons/atmos/pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "gas pump"
	desc = "A pump."

	var/target_pressure = ONE_ATMOSPHERE

	//var/max_volume_transfer = 10000

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000			// 30000 W ~ 40 HP
	identifier = "AGP"

	var/max_pressure_setting = MAX_PUMP_PRESSURE

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "pump"

	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/power/apc
	)
	public_variables = list(
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/identifier,
		/decl/public_access/public_variable/use_power,
		/decl/public_access/public_variable/pump_target_output
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_power,
		/decl/public_access/public_method/refresh	
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/pump = 1,
		/decl/stock_part_preset/radio/event_transmitter/pump = 1
	)

	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/item_chassis
	base_type = /obj/machinery/atmospherics/binary/pump

/obj/machinery/atmospherics/binary/pump/Initialize()
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP

/obj/machinery/atmospherics/binary/pump/AltClick()
	Topic(src, list("power" = "1"))

/obj/machinery/atmospherics/binary/pump/on
	icon_state = "map_on"
	use_power = POWER_USE_IDLE


/obj/machinery/atmospherics/binary/pump/on_update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/binary/pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, -180))
		add_underlay(T, node2, dir)

/obj/machinery/atmospherics/binary/pump/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/pump/Process()
	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/pressure_delta = target_pressure - air2.return_pressure()

	if(pressure_delta > 0.01 && air1.temperature > 0)
		//Figure out how much gas to transfer to meet the target pressure.
		var/transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0)
		power_draw = pump_gas(src, air1, air2, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	return 1

/obj/machinery/atmospherics/binary/pump/return_air()
	if(air1.return_pressure() > air2.return_pressure())
		return air1
	else
		return air2

/obj/machinery/atmospherics/binary/pump/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (BROKEN|NOPOWER))
		return

	// this is the data which will be sent to the ui
	var/data[0]

	data = list(
		"on" = use_power,
		"pressure_set" = round(target_pressure*100),	//Nano UI can't handle rounded non-integers, apparently.
		"max_pressure" = max_pressure_setting,
		"last_flow_rate" = round(last_flow_rate*10),
		"last_power_draw" = round(last_power_draw),
		"max_power_draw" = power_rating,
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "gas_pump.tmpl", name, 470, 290)
		ui.set_initial_data(data)	// when the ui is first opened this is the data it will use
		ui.open()					// open the new ui window
		ui.set_auto_update(1)		// auto update every Master Controller tick

/obj/machinery/atmospherics/binary/pump/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/atmospherics/binary/pump/Topic(href,href_list)
	if((. = ..())) return

	if(href_list["power"])
		update_use_power(!use_power)
		. = 1

	switch(href_list["set_press"])
		if ("min")
			target_pressure = 0
			. = 1
		if ("max")
			target_pressure = max_pressure_setting
			. = 1
		if ("set")
			var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure control",src.target_pressure) as num
			src.target_pressure = between(0, new_pressure, max_pressure_setting)
			. = 1

	if(.)
		src.update_icon()

/obj/machinery/atmospherics/binary/pump/cannot_transition_to(state_path, mob/user)
	if(state_path == /decl/machine_construction/default/deconstructed)
		if (!(stat & NOPOWER) && use_power)
			return SPAN_WARNING("You cannot take this [src] apart, turn it off first.")
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			return SPAN_WARNING("You cannot take this [src] apart, it too exerted due to internal pressure.")
	return ..()

/decl/public_access/public_variable/pump_target_output
	expected_type = /obj/machinery/atmospherics/binary/pump
	name = "output pressure"
	desc = "The output pressure of the pump."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_NUMBER

/decl/public_access/public_variable/pump_target_output/access_var(obj/machinery/atmospherics/binary/pump/machine)
	return machine.target_pressure

/decl/public_access/public_variable/pump_target_output/write_var(obj/machinery/atmospherics/binary/pump/machine, new_value)
	new_value = Clamp(new_value, 0, machine.max_pressure_setting)
	. = ..()
	if(.)
		machine.target_pressure = new_value

/decl/stock_part_preset/radio/event_transmitter/pump
	frequency = PUMP_FREQ
	filter = RADIO_ATMOSIA
	event = /decl/public_access/public_variable/input_toggle
	transmit_on_event = list(
		"device" = /decl/public_access/public_variable/identifier,
		"power" = /decl/public_access/public_variable/use_power,
		"target_output" = /decl/public_access/public_variable/pump_target_output
	)

/decl/stock_part_preset/radio/receiver/pump
	frequency = PUMP_FREQ
	filter = RADIO_ATMOSIA
	receive_and_call = list(
		"power_toggle" = /decl/public_access/public_method/toggle_power,
		"status" = /decl/public_access/public_method/refresh
	)
	receive_and_write = list(
		"set_power" = /decl/public_access/public_variable/use_power,
		"set_output_pressure" = /decl/public_access/public_variable/pump_target_output
	)