/obj/machinery/atmospherics/unary/phoroncondenser
	name ="phoron condenser"
	desc = "A machine with carefully assembled surfaces designed for the rapid purification and solidificaton of phoron."
	icon = 'icons/atmos/phoroncondenser.dmi'
	icon_state = "off"
	level = 1
	density = 1
	use_power = POWER_USE_OFF
	idle_power_usage = 200		//internal circuitry, friction losses and stuff
	power_rating = 10000
	base_type = /obj/machinery/atmospherics/unary/phoroncondenser
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/target_pressure = 10*ONE_ATMOSPHERE
	var/id = null
	var/power_setting = 1 //power consumption setting, 1 through five
	var/carbon_stored = 0
	var/carbon_efficiency = 0.5
	var/intake_power_efficiency = 1
	var/const/phoron_moles_per_piece = 50 //One 12g per mole * 50 = 600 g chunk of coal
	var/phase = "filling"//"filling", "processing", "releasing"
	var/datum/gas_mixture/inner_tank = new
	var/tank_volume = 400//Litres

/obj/machinery/atmospherics/unary/phoroncondenser/RefreshParts()
	carbon_efficiency = initial(carbon_efficiency)
	carbon_efficiency += 0.25 * total_component_rating_of_type(/obj/item/weapon/stock_parts/matter_bin)
	carbon_efficiency -= 0.25 * number_of_components(/obj/item/weapon/stock_parts/matter_bin)
	carbon_efficiency = Clamp(carbon_efficiency, initial(carbon_efficiency), 5)

	intake_power_efficiency = initial(intake_power_efficiency)
	intake_power_efficiency -= 0.1 * total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator)
	intake_power_efficiency += 0.1 * number_of_components(/obj/item/weapon/stock_parts/manipulator)
	intake_power_efficiency = Clamp(intake_power_efficiency, 0.1, initial(intake_power_efficiency))

	power_rating = 1
	power_rating -= 0.05 * total_component_rating_of_type(/obj/item/weapon/stock_parts/micro_laser)
	power_rating += 0.05 * number_of_components(/obj/item/weapon/stock_parts/micro_laser)
	power_rating = Clamp(power_rating, 0.1, 1)
	power_rating *= initial(power_rating)
	..()

/obj/machinery/atmospherics/unary/phoroncondenser/examine(user)
	. = ..()

/obj/machinery/atmospherics/unary/phoroncondenser/atmos_init()
	if(node)
		return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(target.initialize_directions & get_dir(target, src))
			node = target
			break

  		// Copied from freezer code, should initialise a one direction machine as they work.
		//check that there are no incompatible pipes/machinery in our own location
	for(var/obj/machinery/atmospherics/M in src.loc)
		if(M != src && (M.initialize_directions & node_connect) && M.check_connect_types(M,src))	// matches at least one direction on either type of pipe & same connection type
			node = null
			break

		update_icon()

/obj/machinery/atmospherics/unary/phoroncondenser/Process(var/delay)
	..()
	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	last_power_draw = 0
	//TODO Add overlay with F-P-R letter to display current state
	if (phase == "filling")//filling tank
		var/pressure_delta = target_pressure - inner_tank.return_pressure()
		if (pressure_delta > 0.01 && air_contents.temperature > 0)
			var/transfer_moles = calculate_transfer_moles(air_contents, inner_tank, pressure_delta)
			power_draw = pump_gas(src, air_contents, inner_tank, transfer_moles, power_rating*power_setting) * intake_power_efficiency
			if (power_draw >= 0)
				last_power_draw = power_draw
				use_power_oneoff(power_draw)
				if(network)
					network.update = 1
		if (air_contents.return_pressure() < 0.1 * ONE_ATMOSPHERE || inner_tank.return_pressure() >= target_pressure * 0.95)//if pipe is good as empty or tank is full
			phase = "processing"

	if (phase == "processing")//processing Phoron in tank
		if (inner_tank.gas[GAS_PHORON])
			var/co2_intake = between(0, inner_tank.gas[GAS_PHORON], power_setting*delay/10)
			last_flow_rate = co2_intake
			inner_tank.adjust_gas(GAS_PHORON, -co2_intake, 1)
			carbon_stored += co2_intake * carbon_efficiency
			while (carbon_stored >= phoron_moles_per_piece)
				carbon_stored -= phoron_moles_per_piece
				var/material/M = SSmaterials.get_material_by_name(MATERIAL_PHORON)
				M.place_sheet(get_turf(src), 1, M.name)
			power_draw = power_rating * co2_intake
			last_power_draw = power_draw
			use_power_oneoff(power_draw)
		else
			phase = "filling"

/obj/machinery/atmospherics/unary/phoroncondenser/on_update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/unary/phoroncondenser/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/atmospherics/unary/phoroncondenser/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["on"] = use_power ? 1 : 0
	data["powerSetting"] = power_setting
	data["gasProcessed"] = last_flow_rate
	data["air_contentsPressure"] = round(air_contents.return_pressure())
	data["tankPressure"] = round(inner_tank.return_pressure())
	data["targetPressure"] = round(target_pressure)
	data["phase"] = phase
	if (inner_tank.total_moles > 0)
		data["phoron"] = round(100 * inner_tank.gas[GAS_PHORON]/inner_tank.total_moles)
	else
		data["phoron"] = 0
		// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "phoroncondenser.tmpl", "Phoron Crystallization System", 440, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/atmospherics/unary/phoroncondenser/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["toggleStatus"])
		update_use_power(!use_power)
		update_icon()
		return 1
	if(href_list["setPower"]) //setting power to 0 is redundant anyways
		power_setting = between(1, text2num(href_list["setPower"]), 5)
		return 1
