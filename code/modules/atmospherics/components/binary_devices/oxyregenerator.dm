/obj/machinery/atmospherics/binary/oxyregenerator
	name ="oxygen regenerator"
	desc = "A machine for breaking bonds in carbon dioxide and releasing pure oxygen."
	icon = 'icons/atmos/oxyregenerator.dmi'
	icon_state = "off"
	level = 1
	density = 1
	use_power = POWER_USE_OFF
	idle_power_usage = 200		//internal circuitry, friction losses and stuff
	power_rating = 10000
	base_type = /obj/machinery/atmospherics/binary/oxyregenerator
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/target_pressure = 10*ONE_ATMOSPHERE
	var/id = null
	var/power_setting = 1 //power consumption setting, 1 through five
	var/carbon_stored = 0
	var/carbon_efficiency = 0.5
	var/intake_power_efficiency = 1
	var/const/carbon_moles_per_piece = 50 //One 12g per mole * 50 = 600 g chunk of coal
	var/phase = "filling"//"filling", "processing", "releasing"
	var/datum/gas_mixture/inner_tank = new
	var/tank_volume = 400//Litres

/obj/machinery/atmospherics/binary/oxyregenerator/RefreshParts()
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

/obj/machinery/atmospherics/binary/oxyregenerator/examine(user)
	. = ..()
	to_chat(user,"Its outlet port is to the [dir2text(dir)]")

/obj/machinery/atmospherics/binary/oxyregenerator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(component_attackby(O, user))
		return TRUE
	if(isWrench(O))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")

		if(anchored)
			if(dir & (NORTH|SOUTH))
				initialize_directions = NORTH|SOUTH
			else if(dir & (EAST|WEST))
				initialize_directions = EAST|WEST

			atmos_init()
			build_network()
			if (node1)
				node1.atmos_init()
				node1.build_network()
			if (node2)
				node2.atmos_init()
				node2.build_network()
		else
			if(node1)
				node1.disconnect(src)
				qdel(network1)
			if(node2)
				node2.disconnect(src)
				qdel(network2)

			node1 = null
			node2 = null

/obj/machinery/atmospherics/binary/oxyregenerator/verb/rotate_clockwise()
	set category = "Object"
	set name = "Rotate  (Clockwise)"
	set src in view(1)

	if (usr.incapacitated() || anchored)
		return

	src.set_dir(turn(src.dir, -90))

/obj/machinery/atmospherics/binary/oxyregenerator/verb/rotate_anticlockwise()
	set category = "Object"
	set name = "Rotate (Counterclockwise)"
	set src in view(1)

	if (usr.incapacitated() || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/atmospherics/binary/oxyregenerator/Process(var/delay)
	..()
	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	last_power_draw = 0
	//TODO Add overlay with F-P-R letter to display current state
	if (phase == "filling")//filling tank
		var/pressure_delta = target_pressure - inner_tank.return_pressure()
		if (pressure_delta > 0.01 && air1.temperature > 0)
			var/transfer_moles = calculate_transfer_moles(air1, inner_tank, pressure_delta)
			power_draw = pump_gas(src, air1, inner_tank, transfer_moles, power_rating*power_setting) * intake_power_efficiency
			if (power_draw >= 0)
				last_power_draw = power_draw
				use_power_oneoff(power_draw)
				if(network1)
					network1.update = 1
		if (air1.return_pressure() < 0.1 * ONE_ATMOSPHERE || inner_tank.return_pressure() >= target_pressure * 0.95)//if pipe is good as empty or tank is full
			phase = "processing"

	if (phase == "processing")//processing CO2 in tank
		if (inner_tank.gas[GAS_CO2])
			var/co2_intake = between(0, inner_tank.gas[GAS_CO2], power_setting*delay/10)
			last_flow_rate = co2_intake
			inner_tank.adjust_gas(GAS_CO2, -co2_intake, 1)
			var/datum/gas_mixture/new_oxygen = new
			new_oxygen.adjust_gas(GAS_OXYGEN,  co2_intake)
			new_oxygen.temperature = T20C+30 //it's sort of hot after molecular bond breaking
			inner_tank.merge(new_oxygen)
			carbon_stored += co2_intake * carbon_efficiency
			while (carbon_stored >= carbon_moles_per_piece)
				carbon_stored -= carbon_moles_per_piece
				var/material/M = SSmaterials.get_material_by_name(MATERIAL_GRAPHITE)
				M.place_sheet(get_turf(src), 1, M.name)
			power_draw = power_rating * co2_intake
			last_power_draw = power_draw
			use_power_oneoff(power_draw)
		else
			phase = "releasing"

	if (phase == "releasing")//releasing processed gas mix
		power_draw = -1
		var/pressure_delta = target_pressure - air2.return_pressure()
		if (pressure_delta > 0.01 && inner_tank.temperature > 0)
			var/transfer_moles = calculate_transfer_moles(inner_tank, air2, pressure_delta, (network2)? network2.volume : 0)
			power_draw = pump_gas(src, inner_tank, air2, transfer_moles, power_rating*power_setting)
			if (power_draw >= 0)
				last_power_draw = power_draw
				use_power_oneoff(power_draw)
				if(network2)
					network2.update = 1
		else//can't push outside harder than target pressure. Device is not intended to be used as a pump after all
			phase = "filling"
		if (inner_tank.return_pressure() <= 0.1)
			phase = "filling"

/obj/machinery/atmospherics/binary/oxyregenerator/on_update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/binary/oxyregenerator/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/atmospherics/binary/oxyregenerator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["on"] = use_power ? 1 : 0
	data["powerSetting"] = power_setting
	data["gasProcessed"] = last_flow_rate
	data["air1Pressure"] = round(air1.return_pressure())
	data["air2Pressure"] = round(air2.return_pressure())
	data["tankPressure"] = round(inner_tank.return_pressure())
	data["targetPressure"] = round(target_pressure)
	data["phase"] = phase
	if (inner_tank.total_moles > 0)
		data["co2"] = round(100 * inner_tank.gas[GAS_CO2]/inner_tank.total_moles)
		data["o2"] = round(100 * inner_tank.gas[GAS_OXYGEN]/inner_tank.total_moles)
	else
		data["co2"] = 0
		data["o2"] = 0
		// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "oxyregenerator.tmpl", "Oxygen Regeneration System", 440, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/atmospherics/binary/oxyregenerator/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["toggleStatus"])
		update_use_power(!use_power)
		update_icon()
		return 1
	if(href_list["setPower"]) //setting power to 0 is redundant anyways
		power_setting = between(1, text2num(href_list["setPower"]), 5)
		return 1
