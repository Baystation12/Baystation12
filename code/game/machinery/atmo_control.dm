/obj/machinery/computer/air_control
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "tank"

	name = "Atmospherics Control Console"
	machine_name = "atmosphere monitoring console"
	machine_desc = "Allows for the monitoring of the gases in an area by using a connected gas sensor, as well as controlling injection and output."

	var/frequency = 1441
	var/datum/radio_frequency/radio_connection

	var/pressure_setting = ONE_ATMOSPHERE * 45
	var/input_flow_setting = 200
	var/list/input_info = list()
	var/list/output_info = list()
	var/list/sensor_info = list()
	var/input_tag
	var/output_tag
	var/sensor_tag
	var/sensor_name
	var/refreshing_input = FALSE
	var/refreshing_output = FALSE
	var/refreshing_sensor = FALSE

	//switch output pressure mode from internal (0) to external (1)
	var/out_pressure_mode = 0

	var/automation = -1 //Disables section for anything not using automation. Currently only applies to fuel injection control subtype.

	var/list/data = list("screen" = 1)

/obj/machinery/computer/air_control/Initialize()
	. = ..()
	set_frequency(frequency)

obj/machinery/computer/air_control/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	..()

/obj/machinery/computer/air_control/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/air_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	data["systemname"] = name
	get_console_data()
	if(!ui)
		ui = new(user, src, ui_key, "atmosconsole.tmpl", data["systemname"], 800, 800)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/air_control/proc/get_console_data()
	if(sensor_info)
		var/list/temp = list()
		if(input_tag || output_tag)
			data["control"] = 1
		else
			data["control"] = 0

		if(!sensor_name && sensor_tag)
			temp += list("long_name" = sensor_tag)
		else
			temp += list("long_name" = sensor_name)
		if(sensor_info["pressure"])
			temp += list("pressure" = sensor_info["pressure"])
		if(sensor_info["temperature"])
			temp += list("temperature" = sensor_info["temperature"])

		data["gasses"] = list()

		if(sensor_info["gas"])
			data["gasses"] = sensor_info["gas"]

		data["sensors"] = list(temp)
		refreshing_sensor = FALSE
	else if(!refreshing_sensor)
		data["sensors"] = list()

	if(frequency%10)
		data["frequency"] = frequency/10
	else
		data["frequency"] = "[frequency/10].0"
	data["input_tag"] = input_tag
	data["output_tag"] = output_tag
	data["sensor_tag"] = sensor_tag

	if(input_info)
		data["input_present"] = TRUE
		data["in_power"] = input_info["power"]
		data["atmos_volume"] =  ATMOS_DEFAULT_VOLUME_PUMP+500
		data["input_flow_setting"] = round(input_flow_setting, 0.1)
		refreshing_input = FALSE
	else if(!refreshing_input)
		data["input_present"] = FALSE

	if(output_info)
		data["output_present"] = TRUE
		data["out_power"] = output_info["power"]
		data["max_pump_pressure"] = MAX_PUMP_PRESSURE
		data["out_pressure_setting"] = pressure_setting
		data["external_pressure"] = output_info["external"]
		refreshing_output = FALSE
	else if(!refreshing_output)
		data["output_present"] = FALSE

	data["out_pressure_mode"] = out_pressure_mode

	data["automation"] = automation

/obj/machinery/computer/air_control/Process()
	..()

/obj/machinery/computer/air_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption)
		return

	var/id_tag = signal.data["tag"]
	if(sensor_tag == id_tag)
		sensor_info = signal.data
	else if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/air_control/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/computer/air_control/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(..())
		return TOPIC_HANDLED

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	if(href_list["in_refresh_status"])
		input_info = null
		refreshing_input = TRUE
		signal.data = list ("tag" = input_tag, "status" = 1)
		. = 1

	if(href_list["in_toggle_injector"])
		input_info = null
		refreshing_input = TRUE
		signal.data = list ("tag" = input_tag, "power_toggle" = 1)
		. = 1

	if(href_list["in_set_flowrate"])
		input_info = null
		refreshing_input = TRUE
		input_flow_setting = input("What would you like to set the rate limit to?", "Set Volume", input_flow_setting) as num|null
		input_flow_setting = clamp(input_flow_setting, 0, ATMOS_DEFAULT_VOLUME_PUMP+500)
		signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
		. = 1

	if(href_list["in_set_max"])
		input_info = null
		refreshing_input = TRUE
		input_flow_setting = ATMOS_DEFAULT_VOLUME_PUMP+500
		signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
		. = 1

	if(href_list["out_refresh_status"])
		output_info = null
		refreshing_output = TRUE
		signal.data = list ("tag" = output_tag, "status" = 1)
		. = 1

	if(href_list["out_toggle_power"])
		output_info = null
		refreshing_output = TRUE
		signal.data = list ("tag" = output_tag, "power_toggle" = 1, "status" = 1)
		. = 1

	if(href_list["out_set_pressure"])
		output_info = null
		refreshing_output = TRUE
		pressure_setting = input("How much pressure would you like to output?", "Set Pressure", pressure_setting) as num|null
		pressure_setting = clamp(pressure_setting, 0, MAX_PUMP_PRESSURE)
		signal.data = list ("tag" = output_tag, "set_internal_pressure" = pressure_setting, "status" = 1)
		. = 1

	if(href_list["s_out_set_pressure"])
		output_info = null
		refreshing_output = TRUE
		pressure_setting = input("How much pressure would you like to maintain inside the core?", "Set Core Pressure", pressure_setting) as num|null
		pressure_setting = clamp(pressure_setting, 0, MAX_PUMP_PRESSURE)
		signal.data = list ("tag" = output_tag, "set_external_pressure" = pressure_setting, "checks" = 1, "status" = 1)
		. = 1

	if(href_list["s_set_default"])
		output_info = null
		refreshing_output = TRUE
		signal.data = list("tag" = output_tag, "set_external_pressure" = pressure_setting, "checks" = 1, "status" = 1)
		. = 1

	if(href_list["out_set_max"])
		output_info = null
		refreshing_output = TRUE
		pressure_setting = MAX_PUMP_PRESSURE
		signal.data = list ("tag" = output_tag, "set_internal_pressure" = pressure_setting, "status" = 1)
		. = 1

	if(href_list["set_frequency"])
		var/F = input("What frequency would you like to set this to? (Decimal is added automatically)", "Adjust Frequency", frequency) as num|null
		if(F)
			frequency = F
			set_frequency(F)
		return TOPIC_REFRESH

	if(href_list["set_input_tag"])
		var/t = sanitizeSafe(input(usr, "Enter the input ID tag.", src.name, src.input_tag), MAX_NAME_LEN)
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.input_tag = t
		return TOPIC_REFRESH

	if(href_list["set_output_tag"])
		var/t = sanitizeSafe(input(usr, "Enter the output ID tag.", src.name, src.output_tag), MAX_NAME_LEN)
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.output_tag = t
		return TOPIC_REFRESH

	if(href_list["set_sensor_tag"])
		var/t = sanitizeSafe(input(usr, "Enter the sensor ID tag.", src.name, src.sensor_tag))
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.sensor_tag = t
		return TOPIC_REFRESH

	if(href_list["set_sensor_name"])
		var/t = sanitizeSafe(input(usr, "Enter the sensor name.", src.name, src.sensor_name))
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.sensor_name = t
		return TOPIC_REFRESH

	if(href_list["toggle_pressure_mode"])
		out_pressure_mode = !out_pressure_mode
		return TOPIC_REFRESH

	if(href_list["set_screen"])
		data["screen"] = text2num(href_list["set_screen"])
		return TOPIC_REFRESH

	if(!radio_connection)
		return TOPIC_HANDLED

	signal.data["sigtype"] = "command"
	signal.data["status"] = TRUE
	radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

/obj/machinery/computer/air_control/fuel_injection
	icon = 'icons/obj/computer.dmi'
	icon_screen = "alert:0"
	machine_name = "injector control"
	machine_desc = "An atmosphere monitoring console, modified specifically for controlling gas injectors."

	var/device_tag
	var/list/device_info = list()

	automation = 0

	var/cutoff_temperature = 2000
	var/on_temperature = 1200

/obj/machinery/computer/air_control/fuel_injection/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(device_tag == id_tag)
		device_info = signal.data
	else
		..(signal)

/obj/machinery/computer/air_control/fuel_injection/Topic(href, href_list)
	if((. = ..()))
		return

	if(href_list["toggle_automation"])
		automation = !automation

		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.source = src
		signal.data = list(
			"tag" = device_tag,
			"power_toggle" = 1,
			"sigtype" = "command"
		)
		..()

/obj/machinery/computer/air_control/fuel_injection/Process()
	if(automation)
		if(!radio_connection)
			return 0

		var/injecting = 0
		if(sensor_info)
			if(sensor_info["temperature"])
				if(sensor_info["temperature"] >= cutoff_temperature)
					injecting = 0
				else if(sensor_info["temperature"] <= on_temperature)
					injecting = 1

		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.source = src

		signal.data = list(
			"tag" = device_tag,
			"set_power" = injecting,
			"sigtype" = "command"
		)

		radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

	..()

/obj/machinery/computer/air_control/supermatter_core
	icon = 'icons/obj/computer.dmi'
	frequency = 1438
	out_pressure_mode = 1
	machine_name = "core control"
	machine_desc = "An atmosphere monitoring console, modified for use in a supermatter engine."
