/obj/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"

	icon = 'icons/obj/atmos.dmi'
	icon_state = "psiphon:0"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL
	base_type = /obj/machinery/portable_atmospherics/powered/pump

	var/direction_out = 0 //0 = siphoning, 1 = releasing
	var/target_pressure = ONE_ATMOSPHERE

	var/pressuremin = 0
	var/pressuremax = 10 * ONE_ATMOSPHERE

	volume = 1000

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

	machine_name = "portable pump"
	machine_desc = "Used to equalize the pressure of the atmosphere in a surrounding area with its own contents, or to draw in air from the area around it. Runs on a battery backup; can be connected to atmospherics networks."

/obj/machinery/portable_atmospherics/powered/pump/filled
	start_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/powered/pump/New()
	..()

	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi(GAS_OXYGEN, air_mix[GAS_OXYGEN], GAS_NITROGEN, air_mix[GAS_NITROGEN])

/obj/machinery/portable_atmospherics/powered/pump/on_update_icon()
	overlays.Cut()

	if((use_power == POWER_USE_ACTIVE) && !(stat & NOPOWER))
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(holding)
		overlays += "siphon-open"

	if(connected_port)
		overlays += "siphon-connector"

/obj/machinery/portable_atmospherics/powered/pump/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		update_use_power(use_power == POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)

	if(prob(100/severity))
		direction_out = !direction_out

	target_pressure = rand(0, 10 * ONE_ATMOSPHERE)
	update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/pump/Process()
	..()
	var/power_draw = -1

	if((use_power == POWER_USE_ACTIVE) && !(stat & NOPOWER))
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/pressure_delta
		var/output_volume
		var/air_temperature
		if(direction_out)
			pressure_delta = target_pressure - environment.return_pressure()
			output_volume = environment.volume * environment.group_multiplier
			air_temperature = environment.temperature? environment.temperature : air_contents.temperature
		else
			pressure_delta = environment.return_pressure() - target_pressure
			output_volume = air_contents.volume * air_contents.group_multiplier
			air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature

		var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)

		if (pressure_delta > 0.01)
			if (direction_out)
				power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
			else
				power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)
			if(holding)
				holding.queue_icon_update()

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		if(abs(power_draw - last_power_draw) > 0.1 * last_power_draw)
			change_power_consumption(power_draw, POWER_USE_ACTIVE)
			last_power_draw = power_draw

		update_connected_network()

	src.updateDialog()

/obj/machinery/portable_atmospherics/powered/pump/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/portable_atmospherics/powered/pump/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1)
	var/list/data[0]
	var/obj/item/cell/cell = get_cell()
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["targetpressure"] = round(target_pressure)
	data["pump_dir"] = direction_out
	data["minpressure"] = round(pressuremin)
	data["maxpressure"] = round(pressuremax)
	data["powerDraw"] = round(last_power_draw)
	data["cellCharge"] = cell ? cell.charge : 0
	data["cellMaxCharge"] = cell ? cell.maxcharge : 1
	data["on"] = (use_power == POWER_USE_ACTIVE) ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "portpump.tmpl", "Portable Pump", 480, 410, state = GLOB.physical_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/powered/pump/OnTopic(user, href_list)
	if(href_list["power"])
		update_use_power(use_power == POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
		. = TOPIC_REFRESH
	if(href_list["direction"])
		direction_out = !direction_out
		. = TOPIC_REFRESH
	if (href_list["remove_tank"])
		if(holding)
			holding.dropInto(loc)
			holding = null
		. = TOPIC_REFRESH
	if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		target_pressure = min(10*ONE_ATMOSPHERE, max(0, target_pressure+diff))
		. = TOPIC_REFRESH

	if(.)
		update_icon()
