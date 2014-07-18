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
	desc = "A pump"

	var/on = 0
	var/target_pressure = ONE_ATMOSPHERE

	//var/max_volume_transfer = 10000

	use_power = 1
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	active_power_usage = 7500	//This also doubles as a measure of how powerful the pump is, in Watts. 7500 W ~ 10 HP

	var/last_power_draw = 0			//for UI
	var/last_flow_rate = 0			//for UI
	var/max_pressure_setting = 15000	//kPa
	
	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/pump/on
	icon_state = "map_on"
	on = 1


/obj/machinery/atmospherics/binary/pump/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[on ? "on" : "off"]"

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

/obj/machinery/atmospherics/binary/pump/process()
	//reset these each iteration
	last_power_draw = 0
	last_flow_rate = 0
	
	if(stat & (NOPOWER|BROKEN))
		return
	if(!on)
		update_use_power(0)
		return 0

	var/datum/gas_mixture/source = air1
	var/datum/gas_mixture/sink = air2
	
	var/pressure_delta = target_pressure - sink.return_pressure()

	//Calculate necessary moles to transfer using PV=nRT
	if(pressure_delta > 0.01 && (source.total_moles() > 0) && (source.temperature > 0 || sink.temperature > 0))
		//Figure out how much gas to transfer
		var/air_temperature = (sink.temperature > 0)? sink.temperature : source.temperature
		var/transfer_moles = calc_transfer_amount(pressure_delta)
		
		//Calculate the amount of energy required
		var/specific_entropy = sink.specific_entropy() - source.specific_entropy()	//air2 is gaining moles, air1 is loosing
		var/specific_power = 0	// W/mol
		
		//If specific_entropy is < 0 then transfer_moles is limited by how powerful the pump is
		if (specific_entropy < 0)
			specific_power = -specific_entropy*air_temperature		//how much power we need per mole
			transfer_moles = min(transfer_moles, active_power_usage / specific_power)
		
		//Actually transfer the gas
		var/input_pressure = source.return_pressure()
		
		var/datum/gas_mixture/removed = source.remove(transfer_moles)
		if (input_pressure > 0)
			last_flow_rate = removed.total_moles()*R_IDEAL_GAS_EQUATION*removed.temperature/input_pressure
		
		sink.merge(removed)
		
		//If specific_entropy is < 0 then extra power needs to be supplied to move gas
		if (specific_entropy < 0)
			//pump draws power and heats gas according to 2nd law of thermodynamics
			var/power_draw = round(transfer_moles*specific_power)
			sink.add_thermal_energy(power_draw)
			handle_power_draw(power_draw)
		else
			handle_power_draw(idle_power_usage)

		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1
	else
		update_use_power(0)
		return 1

	return 1

/obj/machinery/atmospherics/binary/pump/proc/calc_transfer_amount(var/pressure_delta)
	var/datum/gas_mixture/source = air1
	var/datum/gas_mixture/sink = air2

	var/air_temperature = (sink.temperature > 0)? sink.temperature : source.temperature
	
	var/output_volume = sink.volume
	if (network2 && network2.air_transient)
		output_volume = network2.air_transient.volume	//use the network volume if we can get it
	
	//Return the number of moles that would have to be transfered to bring sink to the target pressure
	return pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)

//This proc handles power usages so that we only have to call use_power() when the pump is loaded but not at full load. 
/obj/machinery/atmospherics/binary/pump/proc/handle_power_draw(var/usage_amount)
	if (usage_amount > active_power_usage - 5)
		update_use_power(2)
	else
		update_use_power(1)
		
		if (usage_amount > idle_power_usage)
			use_power(round(usage_amount))	//in practice it's pretty rare that we will get here, so calling use_power() is alright.
	
	last_power_draw = usage_amount

//Radio remote control

/obj/machinery/atmospherics/binary/pump/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = on,
		"target_output" = target_pressure,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/pump/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (BROKEN|NOPOWER))
		return

	// this is the data which will be sent to the ui
	var/data[0]
	
	data = list(
		"on" = on,
		"pressure_set" = round(target_pressure*100),	//Nano UI can't handle rounded non-integers, apparently.
		"max_pressure" = max_pressure_setting,
		"last_flow_rate" = round(last_flow_rate*10),
		"last_power_draw" = round(last_power_draw),
		"max_power_draw" = active_power_usage,
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "gas_pump.tmpl", name, 470, 290)
		ui.set_initial_data(data)	// when the ui is first opened this is the data it will use
		ui.open()					// open the new ui window
		ui.set_auto_update(1)		// auto update every Master Controller tick

/obj/machinery/atmospherics/binary/pump/initialize()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["power"])
		if(text2num(signal.data["power"]))
			on = 1
		else
			on = 0

	if("power_toggle" in signal.data)
		on = !on

	if(signal.data["set_output_pressure"])
		target_pressure = between(
			0,
			text2num(signal.data["set_output_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/binary/pump/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		user << "\red Access denied."
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/pump/Topic(href,href_list)
	if(..()) return
	
	if(href_list["power"])
		on = !on
	
	switch(href_list["set_press"])
		if ("min")
			target_pressure = 0
		if ("max")
			target_pressure = max_pressure_setting
		if ("set")
			var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure control",src.target_pressure) as num
			src.target_pressure = max(0, min(max_pressure_setting, new_pressure))
	
	usr.set_machine(src)
	src.add_fingerprint(usr)
	
	src.update_icon()

/obj/machinery/atmospherics/binary/pump/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/binary/pump/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	if (!(stat & NOPOWER) && on)
		user << "\red You cannot unwrench this [src], turn it off first."
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
