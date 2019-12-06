//TODO: Put this under a common parent type with freezers to cut down on the copypasta
#define HEATER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe network."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "heater_0"
	density = 1
	anchored = 1
	use_power = POWER_USE_OFF
	idle_power_usage = 5			//5 Watts for thermostat related circuitry
	base_type = /obj/machinery/atmospherics/unary/heater
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/max_temperature = T20C + 680
	var/internal_volume = 600	//L

	var/max_power_rating = 20000	//power rating when the usage is turned up to 100
	var/power_setting = 100

	var/set_temperature = T20C	//thermostat
	var/heating = 0		//mainly for icon updates

/obj/machinery/atmospherics/unary/heater/atmos_init()
	..()
	if(node)
		return

	var/node_connect = dir

	//check that there is something to connect to
	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(target.initialize_directions & get_dir(target, src))
			node = target
			break

	//copied from pipe construction code since heaters/freezers don't use fittings and weren't doing this check - this all really really needs to be refactored someday.
	//check that there are no incompatible pipes/machinery in our own location
	for(var/obj/machinery/atmospherics/M in src.loc)
		if(M != src && (M.initialize_directions & node_connect) && M.check_connect_types(M,src))	// matches at least one direction on either type of pipe & same connection type
			node = null
			break

	update_icon()


/obj/machinery/atmospherics/unary/heater/on_update_icon()
	if(node)
		if(use_power && heating)
			icon_state = "heater_1"
		else
			icon_state = "heater"
	else
		icon_state = "heater_0"
	return


/obj/machinery/atmospherics/unary/heater/Process()
	..()

	if(stat & (NOPOWER|BROKEN) || !use_power)
		heating = 0
		update_icon()
		return

	if(network && air_contents.total_moles && air_contents.temperature < set_temperature)
		air_contents.add_thermal_energy(power_rating * HEATER_PERF_MULT)
		use_power_oneoff(power_rating)

		heating = 1
		network.update = 1
	else
		heating = 0

	update_icon()

/obj/machinery/atmospherics/unary/heater/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/atmospherics/unary/heater/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["on"] = use_power ? 1 : 0
	data["gasPressure"] = round(air_contents.return_pressure())
	data["gasTemperature"] = round(air_contents.temperature)
	data["minGasTemperature"] = 0
	data["maxGasTemperature"] = round(max_temperature)
	data["targetGasTemperature"] = round(set_temperature)
	data["powerSetting"] = power_setting

	var/temp_class = "normal"
	if(air_contents.temperature > (T20C+40))
		temp_class = "bad"
	data["gasTemperatureClass"] = temp_class

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "freezer.tmpl", "Gas Heating System", 440, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/atmospherics/unary/heater/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["toggleStatus"])
		update_use_power(!use_power)
		update_icon()
	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			set_temperature = min(set_temperature + amount, max_temperature)
		else
			set_temperature = max(set_temperature + amount, 0)
	if(href_list["setPower"]) //setting power to 0 is redundant anyways
		var/new_setting = between(0, text2num(href_list["setPower"]), 100)
		set_power_level(new_setting)

	add_fingerprint(usr)

//upgrading parts
/obj/machinery/atmospherics/unary/heater/RefreshParts()
	..()
	var/cap_rating = Clamp(total_component_rating_of_type(/obj/item/weapon/stock_parts/capacitor), 1, 20)
	var/bin_rating = Clamp(total_component_rating_of_type(/obj/item/weapon/stock_parts/matter_bin), 0, 10)

	max_power_rating = initial(max_power_rating) * cap_rating / 2
	max_temperature = max(initial(max_temperature) - T20C, 0) * ((bin_rating * 4 + cap_rating) / 5) + T20C
	air_contents.volume = max(initial(internal_volume) - 200, 0) + 200 * bin_rating
	set_power_level(power_setting)

/obj/machinery/atmospherics/unary/heater/proc/set_power_level(var/new_power_setting)
	power_setting = new_power_setting
	power_rating = max_power_rating * (power_setting/100)

/obj/machinery/atmospherics/unary/heater/examine(mob/user)
	. = ..()
	if(panel_open)
		to_chat(user, "The maintenance hatch is open.")
