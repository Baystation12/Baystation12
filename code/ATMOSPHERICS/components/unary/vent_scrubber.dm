/obj/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber"

	name = "Air Scrubber"
	desc = "Has a valve and pump attached to it"
	use_power = 1
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	active_power_usage = 7500	//This also doubles as a measure of how powerful the pump is, in Watts. 7500 W ~ 10 HP

	level = 1

	var/area/initial_loc
	var/id_tag = null
	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/on = 0
	var/scrubbing = 1 //0 = siphoning, 1 = scrubbing
	var/list/scrubbing_gas = list()

	var/panic = 0 //is this scrubber panicked?

	var/area_uid
	var/radio_filter_out
	var/radio_filter_in

/obj/machinery/atmospherics/unary/vent_scrubber/New()
	icon = null
	initial_loc = get_area(loc)
	if (initial_loc.master)
		initial_loc = initial_loc.master
	area_uid = initial_loc.uid
	if (!id_tag)
		assign_uid()
		id_tag = num2text(uid)
	if(ticker && ticker.current_state == 3)//if the game is running
		src.initialize()
		src.broadcast_status()
	..()

/obj/machinery/atmospherics/unary/vent_scrubber/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	overlays.Cut()

	var/scrubber_icon = "scrubber"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(!powered())
		scrubber_icon += "off"
	else
		scrubber_icon += "[on ? "[scrubbing ? "on" : "in"]" : "off"]"

	overlays += icon_manager.get_atmos_icon("device", , , scrubber_icon)

/obj/machinery/atmospherics/unary/vent_scrubber/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(T.intact && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			add_underlay(T, node, dir)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src
	signal.data = list(
		"area" = area_uid,
		"tag" = id_tag,
		"device" = "AScr",
		"timestamp" = world.time,
		"power" = on,
		"scrubbing" = scrubbing,
		"panic" = panic,
		"filter_co2" = ("carbon_dioxide" in scrubbing_gas),
		"filter_phoron" = ("phoron" in scrubbing_gas),
		"filter_n2o" = ("sleeping_agent" in scrubbing_gas),
		"sigtype" = "status"
	)
	if(!initial_loc.air_scrub_names[id_tag])
		var/new_name = "[initial_loc.name] Air Scrubber #[initial_loc.air_scrub_names.len+1]"
		initial_loc.air_scrub_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_scrub_info[id_tag] = signal.data
	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/initialize()
	..()
	radio_filter_in = frequency==initial(frequency)?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==initial(frequency)?(RADIO_TO_AIRALARM):null
	if (frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/unary/vent_scrubber/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if (!node)
		on = 0
	//broadcast_status()
	if(!on)
		update_use_power(0)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1
	if (environment.temperature > 0 || air_contents.temperature > 0)
		if(scrubbing)
			power_draw = filter_gas(environment)
		else //Just siphon all air
			power_draw = siphon_gas(environment)

	if (power_draw < 0)
		update_use_power(0)
	else if (power_draw > 0)
		//last_power_draw = power_draw
		handle_pump_power_draw(power_draw)
	else
		//last_power_draw = idle_power_usage
		handle_pump_power_draw(idle_power_usage)
	
	if(network)
		network.update = 1
	
	return 1

//filters gas from environment and returns the amount of power used, or -1 if no filtering was done
/obj/machinery/atmospherics/unary/vent_scrubber/proc/filter_gas(datum/gas_mixture/environment)
	//Filter it
	var/total_specific_power = 0		//the power required to remove one mole of filterable gas
	var/total_filterable_moles = 0
	var/list/specific_power_gas = list()
	for (var/g in scrubbing_gas)
		if (environment.gas[g] < MINUMUM_MOLES_TO_PUMP)
			continue	//don't bother
	
		var/specific_power = calculate_specific_power_gas(g, environment, air_contents)/ATMOS_FILTER_EFFICIENCY
		specific_power_gas[g] = specific_power
		total_specific_power += specific_power
		total_filterable_moles += environment.gas[g]
	
	if (total_filterable_moles < MINUMUM_MOLES_TO_PUMP)
		return -1
	
	//Figure out how much of each gas to filter
	var/total_transfer_moles = total_filterable_moles
	
	//limit flow rate from turfs
	total_transfer_moles = min(total_transfer_moles, environment.total_moles*MAX_FILTER_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
	
	//limit transfer_moles based on available power
	var/power_draw = 0
	if (total_specific_power > 0)
		total_transfer_moles = min(total_transfer_moles, active_power_usage/total_specific_power)
	
	for (var/g in scrubbing_gas)
		var/transfer_moles = environment.gas[g]
		if (specific_power_gas[g] > 0)
			//if our flow rate is being limited by available power, the proportion of the filtered gas is based on mole ratio
			transfer_moles = min(transfer_moles, total_transfer_moles*(environment.gas[g]/total_filterable_moles))
		
		environment.gas[g] -= transfer_moles
		air_contents.gas[g] += transfer_moles
		power_draw += specific_power_gas[g]*transfer_moles
	
	if (power_draw > 0)
		air_contents.add_thermal_energy(power_draw)
	
	//Remix the resulting gases
	air_contents.update_values()
	environment.update_values()
	
	return power_draw

//siphons gas from environment and returns the power used, or -1 if no siphoning was done
/obj/machinery/atmospherics/unary/vent_scrubber/proc/siphon_gas(datum/gas_mixture/environment)
	if (environment.total_moles < MINUMUM_MOLES_TO_PUMP)
		return -1	//no point doing all this processing when source is a vacuum
	
	var/transfer_moles = environment.total_moles
	
	//limit flow rate from turfs
	transfer_moles = min(transfer_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here

	//Calculate the amount of energy required and limit transfer_moles based on available power
	var/specific_power = calculate_specific_power(environment, air_contents)/ATMOS_PUMP_EFFICIENCY //this has to be calculated before we modify any gas mixtures
	if (specific_power > 0)
		transfer_moles = min(transfer_moles, active_power_usage / specific_power)
	
	if (transfer_moles < MINUMUM_MOLES_TO_PUMP)
		return -1	//don't bother

	var/power_draw = specific_power*transfer_moles
	var/datum/gas_mixture/removed = environment.remove(transfer_moles)
	if (power_draw > 0)
		removed.add_thermal_energy(power_draw)
	air_contents.merge(removed)
	
	return power_draw

/obj/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["power"] != null)
		on = text2num(signal.data["power"])
	if(signal.data["power_toggle"] != null)
		on = !on

	if(signal.data["panic_siphon"]) //must be before if("scrubbing" thing
		panic = text2num(signal.data["panic_siphon"] != null)
		if(panic)
			on = 1
			scrubbing = 0
		else
			scrubbing = 1
	if(signal.data["toggle_panic_siphon"] != null)
		panic = !panic
		if(panic)
			on = 1
			scrubbing = 0
		else
			scrubbing = 1

	if(signal.data["scrubbing"] != null)
		scrubbing = text2num(signal.data["scrubbing"])
	if(signal.data["toggle_scrubbing"])
		scrubbing = !scrubbing

	var/list/toggle = list()
	
	if(!isnull(signal.data["co2_scrub"]) && text2num(signal.data["co2_scrub"]) != ("carbon_dioxide" in scrubbing_gas))
		toggle += "carbon_dioxide"
	else if(signal.data["toggle_co2_scrub"])
		toggle += "carbon_dioxide"

	if(!isnull(signal.data["tox_scrub"]) && text2num(signal.data["tox_scrub"]) != ("phoron" in scrubbing_gas))
		toggle += "phoron"
	else if(signal.data["toggle_tox_scrub"])
		toggle += "phoron"

	if(!isnull(signal.data["n2o_scrub"]) && text2num(signal.data["n2o_scrub"]) != ("sleeping_agent" in scrubbing_gas))
		toggle += "sleeping_agent"
	else if(signal.data["toggle_n2o_scrub"])
		toggle += "sleeping_agent"

	scrubbing_gas ^= toggle

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

//			log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_scrubber/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	if (!(stat & NOPOWER) && on)
		user << "\red You cannot unwrench this [src], turn it off first."
		return 1
	var/turf/T = src.loc
	if (node && node.level==1 && isturf(T) && T.intact)
		user << "\red You must remove the plating first."
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

/obj/machinery/atmospherics/unary/vent_scrubber/Del()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	..()
	return
