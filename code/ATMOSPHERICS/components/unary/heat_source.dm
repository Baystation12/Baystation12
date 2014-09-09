/obj/machinery/atmospherics/unary/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe network"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "heater_0"
	density = 1

	anchored = 1.0

	var/set_temperature = T20C	//thermostat
	var/max_temperature = T20C + 680
	var/internal_volume = 600	//L

	var/on = 0
	use_power = 0
	idle_power_usage = 5	//5 Watts for thermostat related circuitry
	active_power_usage = 50000		//50 kW. The power rating of the heater

	var/heating = 0		//mainly for icon updates
	var/opened = 0		//for deconstruction

/obj/machinery/atmospherics/unary/heater/New()
	..()
	air_contents.volume = internal_volume
	initialize_directions = dir

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/unary_atmos/heater(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

/obj/machinery/atmospherics/unary/heater/initialize()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			node = target
			break

	update_icon()


/obj/machinery/atmospherics/unary/heater/update_icon()
	if(src.node)
		if(src.on && src.heating)
			icon_state = "heater_1"
		else
			icon_state = "heater"
	else
		icon_state = "heater_0"
	return


/obj/machinery/atmospherics/unary/heater/process()
	..()

	if(stat & (NOPOWER|BROKEN) || !on)
		heating = 0
		update_use_power(0)
		update_icon()
		return

	if (network && air_contents.total_moles && air_contents.temperature < set_temperature)
		update_use_power(2)
		air_contents.add_thermal_energy(active_power_usage)

		heating = 1
		network.update = 1
	else
		heating = 0
		update_use_power(1)

	update_icon()

/obj/machinery/atmospherics/unary/heater/attack_ai(mob/user as mob)
	src.ui_interact(user)

/obj/machinery/atmospherics/unary/heater/attack_paw(mob/user as mob)
	src.ui_interact(user)

/obj/machinery/atmospherics/unary/heater/attack_hand(mob/user as mob)
	src.ui_interact(user)

/obj/machinery/atmospherics/unary/heater/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["on"] = on ? 1 : 0
	data["gasPressure"] = round(air_contents.return_pressure())
	data["gasTemperature"] = round(air_contents.temperature)
	data["minGasTemperature"] = 0
	data["maxGasTemperature"] = round(max_temperature)
	data["targetGasTemperature"] = round(set_temperature)

	var/temp_class = "normal"
	if (air_contents.temperature > (T20C+40))
		temp_class = "bad"
	data["gasTemperatureClass"] = temp_class

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
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
	if (href_list["toggleStatus"])
		src.on = !src.on
		update_use_power(on)
		update_icon()
	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			src.set_temperature = min(src.set_temperature+amount, max_temperature)
		else
			src.set_temperature = max(src.set_temperature+amount, 0)

	src.add_fingerprint(usr)
	return 1

//upgrading parts
/obj/machinery/atmospherics/unary/heater/RefreshParts()
	..()

	var/cap_rating = 0
	var/cap_count = 0
	var/bin_rating = 0
	var/bin_count = 0
	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/capacitor))
			cap_rating += P.rating
			cap_count++
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			bin_rating += P.rating
			bin_count++
	cap_rating /= cap_count
	bin_rating /= bin_count

	active_power_usage = initial(active_power_usage)*cap_rating
	max_temperature = max(initial(max_temperature) - T20C, 0)*((bin_rating*2 + cap_rating)/3) + T20C
	air_contents.volume = max(initial(internal_volume) - 200, 0) + 200*bin_rating

//dismantling code. copied from autolathe
/obj/machinery/atmospherics/unary/heater/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/screwdriver))
		opened = !opened
		user << "You [opened ? "open" : "close"] the maintenance hatch of [src]."
		return

	if (opened && istype(O, /obj/item/weapon/crowbar))
		dismantle()
		return

	..()

/obj/machinery/atmospherics/unary/heater/examine()
	..()
	if (opened)
		usr << "The maintenance hatch is open."