/obj/machinery/air_sensor
	icon = 'icons/obj/structures/airfilter.dmi'
	icon_state = "gsensor1"
	name = "gas sensor"

	anchored = TRUE

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/transmitter/basic,
		/obj/item/stock_parts/power/apc
	)
	public_variables = list(
		/singleton/public_access/public_variable/gas,
		/singleton/public_access/public_variable/pressure,
		/singleton/public_access/public_variable/temperature
	)
	stock_part_presets = list(/singleton/stock_part_preset/radio/basic_transmitter/air_sensor = 1)
	use_power = POWER_USE_IDLE

	frame_type = /obj/item/machine_chassis/air_sensor
	construct_state = /singleton/machine_construction/default/item_chassis
	base_type = /obj/machinery/air_sensor

/obj/machinery/air_sensor/on_update_icon()
	if(!powered())
		icon_state = "gsensor0"
	else
		icon_state = "gsensor[use_power]"

/singleton/public_access/public_variable/gas
	expected_type = /obj/machinery
	name = "gas data"
	desc = "A list of gas data from the sensor location; the list entries are two-entry lists with \"symbol\" and \"percent\" fields."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_LIST

/singleton/public_access/public_variable/gas/access_var(obj/machinery/sensor)
	var/datum/gas_mixture/air_sample = sensor.return_air()
	if(!air_sample)
		return
	var/total_moles = air_sample.total_moles
	if(total_moles <= 0)
		return

	. = list()
	for(var/gas in air_sample.gas)
		var/gaspercent = round(air_sample.gas["[gas]"]*100/total_moles,0.01)
		var/gas_list = list("symbol" = gas_data.symbol_html["[gas]"], "percent" = gaspercent)
		. += list(gas_list)

/singleton/public_access/public_variable/pressure
	expected_type = /obj/machinery
	name = "pressure data"
	desc = "The pressure of the gas at the sensor."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_STRING

/singleton/public_access/public_variable/pressure/access_var(obj/machinery/sensor)
	var/datum/gas_mixture/air_sample = sensor.return_air()
	return air_sample && num2text(round(air_sample.return_pressure(),0.1))

/singleton/public_access/public_variable/temperature
	expected_type = /obj/machinery
	name = "temperature data"
	desc = "The temperature of the gas at the sensor."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_NUMBER

/singleton/public_access/public_variable/temperature/access_var(obj/machinery/sensor)
	var/datum/gas_mixture/air_sample = sensor.return_air()
	return air_sample && round(air_sample.temperature,0.1)

/singleton/stock_part_preset/radio/basic_transmitter/air_sensor
	transmit_on_tick = list(
		"gas" = /singleton/public_access/public_variable/gas,
		"pressure" = /singleton/public_access/public_variable/pressure,
		"temperature" = /singleton/public_access/public_variable/temperature
	)
	frequency = ATMOS_TANK_FREQ

/obj/machinery/air_sensor/engine
	stock_part_presets = list(/singleton/stock_part_preset/radio/basic_transmitter/air_sensor/engine = 1)

/singleton/stock_part_preset/radio/basic_transmitter/air_sensor/engine
	frequency = ATMOS_ENGINE_FREQ

/obj/machinery/air_sensor/dist
	stock_part_presets = list(/singleton/stock_part_preset/radio/basic_transmitter/air_sensor/engine = 1)

/singleton/stock_part_preset/radio/basic_transmitter/air_sensor/engine
	frequency = ATMOS_DIST_FREQ
