#define DEFAULT_PRESSURE_DELTA 10000

#define EXTERNAL_PRESSURE_BOUND ONE_ATMOSPHERE
#define INTERNAL_PRESSURE_BOUND 0
#define PRESSURE_CHECKS 1

#define PRESSURE_CHECK_EXTERNAL 1
#define PRESSURE_CHECK_INPUT 2
#define PRESSURE_CHECK_OUTPUT 4

#undefine

/obj/machinery/atmospherics/binary/dp_vent_pump
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_dp_vent"

	//node2 is output port
	//node1 is input port

	name = "Dual Port Air Vent"
	desc = "Has a valve and pump attached to it. There are two ports."

	level = 1

	use_power = 1
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	active_power_usage = 7500	//This also doubles as a measure of how powerful the pump is, in Watts. 7500 W ~ 10 HP
	var/last_power_draw = 0

	var/on = 0
	var/pump_direction = 1 //0 = siphoning, 1 = releasing

	var/external_pressure_bound = EXTERNAL_PRESSURE_BOUND
	var/input_pressure_min = INTERNAL_PRESSURE_BOUND
	var/output_pressure_max = DEFAULT_PRESSURE_DELTA

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	var/pressure_checks = PRESSURE_CHECK_EXTERNAL
	//1: Do not pass external_pressure_bound
	//2: Do not pass input_pressure_min
	//4: Do not pass output_pressure_max

/obj/machinery/atmospherics/binary/dp_vent_pump/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP
	icon = null

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume
	name = "Large Dual Port Air Vent"

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800

/obj/machinery/atmospherics/binary/dp_vent_pump/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	overlays.Cut()
	
	var/vent_icon = "vent"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(T.intact && node1 && node2 && node1.level == 1 && node2.level == 1 && istype(node1, /obj/machinery/atmospherics/pipe) && istype(node2, /obj/machinery/atmospherics/pipe))
		vent_icon += "h"
		
	if(!powered())
		vent_icon += "off"
	else
		vent_icon += "[on ? "[pump_direction ? "out" : "in"]" : "off"]"

	overlays += icon_manager.get_atmos_icon("device", , , vent_icon)

/obj/machinery/atmospherics/binary/dp_vent_pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(T.intact && node1 && node2 && node1.level == 1 && node2.level == 1 && istype(node1, /obj/machinery/atmospherics/pipe) && istype(node2, /obj/machinery/atmospherics/pipe))
			return
		else
			add_underlay(T, node1, turn(dir, -180))
			add_underlay(T, node2, dir)

/obj/machinery/atmospherics/binary/dp_vent_pump/hide(var/i)
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/binary/dp_vent_pump/process()
	..()
	
	if(stat & (NOPOWER|BROKEN) || !on)
		update_use_power(0)	//usually we get here because a player turned a pump off - definitely want to update.
		last_power_draw = 0
		last_flow_rate = 0
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1
	
	//Figure out the target pressure difference
	var/pressure_delta = get_pressure_delta(environment)

	if(pressure_delta > 0.5)
		if(pump_direction) //internal -> external	
			if (node1 && (environment.temperature || air1.temperature))
				var/output_volume = environment.volume * environment.group_multiplier
				var/air_temperature = environment.temperature? environment.temperature : air1.temperature
				var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)
				
				power_draw = pump_gas(air1, environment, transfer_moles, active_power_usage)
				
				if(network1)
					network1.update = 1
		else //external -> internal
			if (node2 && (environment.temperature || air2.temperature))
				var/output_volume = air2.volume * air2.group_multiplier
				var/air_temperature = air2.temperature? air2.temperature : environment.temperature
				var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)
				
				//limit flow rate from turfs
				transfer_moles = min(transfer_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
				
				power_draw = pump_gas(environment, air2, transfer_moles, active_power_usage)
				
				if(network2)
					network2.update = 1
	
	if (power_draw < 0)
		last_power_draw = 0
		last_flow_rate = 0
		//update_use_power(0)
		use_power = 0	//don't force update - easier on CPU
	else
		last_power_draw = handle_power_draw(power_draw)

	return 1

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/get_pressure_delta(datum/gas_mixture/environment)
	var/pressure_delta = DEFAULT_PRESSURE_DELTA
	var/environment_pressure = environment.return_pressure()
	
	if(pump_direction) //internal -> external
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, external_pressure_bound - environment_pressure) //increasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INPUT)
			pressure_delta = min(pressure_delta, air1.return_pressure() - input_pressure_min) //decreasing the pressure here
	else //external -> internal
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, environment_pressure - external_pressure_bound) //decreasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_OUTPUT)
			pressure_delta = min(pressure_delta, output_pressure_max - air2.return_pressure()) //increasing the pressure here
	
	return pressure_delta
	

//Radio remote control

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "ADVP",
		"power" = on,
		"direction" = pump_direction?("release"):("siphon"),
		"checks" = pressure_checks,
		"input" = input_pressure_min,
		"output" = output_pressure_max,
		"external" = external_pressure_bound,
		"sigtype" = "status"
	)
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/dp_vent_pump/initialize()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/dp_vent_pump/examine()
	set src in oview(1)
	..()
	usr << "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W"

/obj/machinery/atmospherics/unary/vent_pump/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/binary/dp_vent_pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0
	if(signal.data["power"])
		on = text2num(signal.data["power"])

	if(signal.data["power_toggle"])
		on = !on

	if(signal.data["direction"])
		pump_direction = text2num(signal.data["direction"])

	if(signal.data["checks"])
		pressure_checks = text2num(signal.data["checks"])

	if(signal.data["purge"])
		pressure_checks &= ~1
		pump_direction = 0

	if(signal.data["stabalize"])
		pressure_checks |= 1
		pump_direction = 1

	if(signal.data["set_input_pressure"])
		input_pressure_min = between(
			0,
			text2num(signal.data["set_input_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["set_output_pressure"])
		output_pressure_max = between(
			0,
			text2num(signal.data["set_output_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["set_external_pressure"])
		external_pressure_bound = between(
			0,
			text2num(signal.data["set_external_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()