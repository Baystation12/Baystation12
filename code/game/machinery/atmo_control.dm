#define SENSOR_PRESSURE		1
#define SENSOR_TEMPERATURE	2
#define SENSOR_O2_COMP		4
#define SENSOR_PH_COMP		8
#define SENSOR_N2_COMP		16
#define SENSOR_CO2_COMP		32
#define SENSOR_H2_COMP		64
#define SENSOR_N2O_COMP		128
#define SENSOR_KR_COMP		256

/obj/machinery/air_sensor
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	name = "Gas Sensor"

	anchored = 1
	var/state = 0

	var/id_tag
	var/frequency = 1439

	var/on = 1
	var/output = 3

	var/datum/radio_frequency/radio_connection

/obj/machinery/air_sensor/update_icon()
	icon_state = "gsensor[on]"

/obj/machinery/air_sensor/Process()
	if(on)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		var/datum/gas_mixture/air_sample = return_air()


		if(output&1)
			signal.data["pressure"] = num2text(round(air_sample.return_pressure(),0.1),)
		if(output&2)
			signal.data["temperature"] = round(air_sample.temperature,0.1)
		if(output>4)
			var/total_moles = air_sample.total_moles
			if(total_moles > 0)
				if(output&4)
					signal.data["oxygen"] = round(100*air_sample.gas["oxygen"]/total_moles,0.1)
				if(output&8)
					signal.data["phoron"] = round(100*air_sample.gas["phoron"]/total_moles,0.1)
				if(output&16)
					signal.data["nitrogen"] = round(100*air_sample.gas["nitrogen"]/total_moles,0.1)
				if(output&32)
					signal.data["carbon_dioxide"] = round(100*air_sample.gas["carbon_dioxide"]/total_moles,0.1)
				if(output&64)
					signal.data["hydrogen"] = round(100*air_sample.gas["hydrogen"]/total_moles,0.1)
			else
				signal.data["oxygen"] = 0
				signal.data["phoron"] = 0
				signal.data["nitrogen"] = 0
				signal.data["carbon_dioxide"] = 0
				signal.data["hydrogen"] = 0

		signal.data["sigtype"]="status"
		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)


/obj/machinery/air_sensor/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Initialize()
	set_frequency(frequency)
	. = ..()

obj/machinery/air_sensor/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	. = ..()

/obj/machinery/air_sensor/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(isMultitool(O))
		var/t = sanitizeSafe(input(user, "Enter the ID for the sensor.", src.name, id_tag), MAX_NAME_LEN)
		if(!CanPhysicallyInteract(user))
			return
		if (user.get_active_hand() != O)
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.id_tag = t
			to_chat(user, "<span class='notice'>The new ID of the sensor is [id_tag]</span>")
	else if(isWrench(O))
		var/obj/item/air_sensor/sensor = new /obj/item/air_sensor(src.loc)
		sensor.frequency = frequency
		sensor.output = output
		sensor.id_tag = id_tag
		qdel(src)
	else if(isScrewdriver(O))
		var/F = input("What frequency would you like to set this to?", "Adjust Frequency", frequency) as num|null
		if(user.incapacitated() && !user.Adjacent(src))
			return
		if(user.get_active_hand() != O)
			return
		if(!in_range(src, user) && src.loc != user)
			return
		if(F)
			frequency = F
			set_frequency(F)
			to_chat(user, "<span class='notice'>The frequency of the sensor is now [frequency]</span>")

/obj/machinery/computer/general_air_control
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "tank"

	name = "Atmospherics Control Console"

	var/frequency = 1439
	var/list/sensors = list()

	var/list/sensor_information = list()
	var/datum/radio_frequency/radio_connection
	circuit = /obj/item/weapon/circuitboard/air_management

obj/machinery/computer/general_air_control/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	..()

/obj/machinery/computer/general_air_control/attack_hand(mob/user)
	if(..(user))
		return
	//WIP code. Commented out to resume original functions.
	var/datum/browser/popup = new (user, "[name]", "[src] Control Panel")
	popup.set_content(jointext(get_console_data(),"<br>"))
	popup.open()
	//user << browse(return_text(),"window=computer")
	//user.set_machine(src)
	//onclose(user, "computer")

	//WIP code. Commented out to resume original functions.
/obj/machinery/computer/general_air_control/proc/get_console_data()
	var/sensor_data
	var/output
	. = list()
	output += "<br>"
	if(sensors.len)
		for(var/id_tag in sensors)
			var/long_name = sensors[id_tag]
			var/list/data = sensor_information[id_tag]
			var/sensor_part = "<B>[long_name]</B>:<BR>"

			if(data)
				if(data["pressure"])
					sensor_part += "   <B>Pressure:</B> [data["pressure"]] kPa<BR>"
				if(data["temperature"])
					sensor_part += "   <B>Temperature:</B> [data["temperature"]] K<BR>"
				if(data["oxygen"]||data["phoron"]||data["nitrogen"]||data["carbon_dioxide"]||data["hydrogen"])
					sensor_part += "   <B>Gas Composition :</B>"
					if(data["oxygen"])
						sensor_part += "[data["oxygen"]]% O2; "
					if(data["nitrogen"])
						sensor_part += "[data["nitrogen"]]% N; "
					if(data["carbon_dioxide"])
						sensor_part += "[data["carbon_dioxide"]]% CO2; "
					if(data["hydrogen"])
						sensor_part += "[data["hydrogen"]]% H2; "
					if(data["phoron"])
						sensor_part += "[data["phoron"]]% PH; "
				sensor_part += "<HR>"

			else
				sensor_part = "<FONT color='red'>[long_name] can not be found!</FONT><BR>"

			sensor_data += sensor_part

	else
		sensor_data = "No sensors connected."

	output += {"<B>[name]</B><HR>
		<B>Sensor Data:</B><HR>[sensor_data]"}
	. = output
	. = JOINTEXT(.)
	return output

/obj/machinery/computer/general_air_control/Process()
	..()
	src.updateUsrDialog()

/obj/machinery/computer/general_air_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]
	if(!id_tag || !sensors.Find(id_tag)) return

	sensor_information[id_tag] = signal.data

/obj/machinery/computer/general_air_control/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/Initialize()
	set_frequency(frequency)
	. = ..()

/obj/machinery/computer/general_air_control/large_tank_control
	icon = 'icons/obj/computer.dmi'

	frequency = 1441
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/input_flow_setting = 200
	var/pressure_setting = ONE_ATMOSPHERE * 45
	circuit = /obj/item/weapon/circuitboard/air_management/tank_control

/obj/machinery/computer/general_air_control/large_tank_control/Initialize()
	. = ..()

/obj/machinery/computer/general_air_control/large_tank_control/get_console_data()
	var/output = ..()
	. = list()
	output += "<B>Tank Control System</B><BR><BR>"
	if(input_info)
		var/power = (input_info["power"])
		output += "<B>Input</B>: [power?("<font color = 'green'>Injecting</font>"):("<font color = 'red'>On Hold</font>")] <A href='?src=\ref[src];in_refresh_status=1'>Refresh</A><BR>Flow Rate Limit: [ATMOS_DEFAULT_VOLUME_PUMP+500] L/s<BR>"
	else
		output += "<FONT color='red'>ERROR: Can not find input port</FONT> <A href='?src=\ref[src];in_refresh_status=1'>Search</A><BR>"

	output += "Flow Rate: [round(input_flow_setting, 0.1)] L/s<BR>"
	output += "Command: <A href='?src=\ref[src];in_toggle_injector=1'>Toggle Power</A><A href='?src=\ref[src];in_set_flowrate=1'>Set Flow Rate</A><A href='?src=\ref[src];in_set_max=1'>Max Flow</a><BR>"
	output += "<BR>"

	if(output_info)
		var/power = (output_info["power"])
		output += {"<B>Output</B>: [power?("<font color = 'green'>Open</font>"):("<font color = 'red'>On Hold</font>")] <A href='?src=\ref[src];out_refresh_status=1'>Refresh</A><BR>Max Output Pressure: [MAX_PUMP_PRESSURE] kPa<BR>"}

	else
		output += "<FONT color='red'>ERROR: Can not find output port</FONT> <A href='?src=\ref[src];out_refresh_status=1'>Search</A><BR>"
	output += "Output Pressure: [pressure_setting] kPa<BR>"
	output += "Command: <A href='?src=\ref[src];out_toggle_power=1'>Toggle Power</A><A href='?src=\ref[src];out_set_pressure=1'>Set Pressure</A><A href='?src=\ref[src];out_set_max=1'>Max Pressure</a><BR>"
	. = output
	. = JOINTEXT(.)
	return output

/obj/machinery/computer/general_air_control/large_tank_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/large_tank_control/Topic(href, href_list)
	if(..())
		return 1
	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src
	if(href_list["in_refresh_status"])
		input_info = null
		signal.data = list ("tag" = input_tag, "status" = 1)
		. = 1

	if(href_list["in_toggle_injector"])
		input_info = null
		signal.data = list ("tag" = input_tag, "power_toggle" = 1)
		. = 1

	if(href_list["in_set_flowrate"])
		input_info = null
		input_flow_setting = input("What would you like to set the rate limit to?", "Set Volume", input_flow_setting) as num|null
		input_flow_setting = between(0, input_flow_setting, ATMOS_DEFAULT_VOLUME_PUMP+500)
		signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
		. = 1
	if(href_list["in_set_max"])
		input_info = null
		input_flow_setting = ATMOS_DEFAULT_VOLUME_PUMP+500
		signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
		. = 1
	if(href_list["out_refresh_status"])
		output_info = null
		signal.data = list ("tag" = output_tag, "status" = 1)
		. = 1

	if(href_list["out_toggle_power"])
		output_info = null
		signal.data = list ("tag" = output_tag, "power_toggle" = 1)
		. = 1

	if(href_list["out_set_pressure"])
		output_info = null
		pressure_setting = input("How much pressure would you like to output?", "Set Pressure", pressure_setting) as num|null
		pressure_setting = between(0, pressure_setting, MAX_PUMP_PRESSURE)
		signal.data = list ("tag" = output_tag, "set_internal_pressure" = "[pressure_setting]")
		. = 1

	if(href_list["out_set_max"])
		output_info = null
		pressure_setting = MAX_PUMP_PRESSURE
		signal.data = list ("tag" = output_tag, "set_internal_pressure" = "[pressure_setting]")
		. = 1

	if(href_list["set_frequency"])
		var/F = input("What frequency would you like to set this to?", "Adjust Frequency", frequency) as num|null
		if(F)
			frequency = F
			set_frequency(F)
		return 1
	if(href_list["set_input_tag"])
		var/t = sanitizeSafe(input(usr, "Enter the input ID tag.", src.name, src.input_tag), MAX_NAME_LEN)
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.input_tag = t
		return 1
	if(href_list["set_output_tag"])
		var/t = sanitizeSafe(input(usr, "Enter the output ID tag.", src.name, src.output_tag), MAX_NAME_LEN)
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.output_tag = t
		return 1
	if(!radio_connection)
		return 0

	signal.data["sigtype"]="command"
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	spawn(5)
		src.updateUsrDialog()

/obj/machinery/computer/general_air_control/large_tank_control/supermatter_core
	icon = 'icons/obj/computer.dmi'

	frequency = 1438

	circuit = /obj/item/weapon/circuitboard/air_management/supermatter_core


/obj/machinery/computer/general_air_control/large_tank_control/supermatter_core/get_console_data()
	var/output
	. = list()
	//if(signal.data)
	//	input_info = signal.data // Attempting to fix intake control -- TLE

	output += "<B>Core Cooling Control System</B><BR><BR>"
	if(input_info)
		var/power = (input_info["power"])
		output += "<B>Coolant Input</B>: [power?("<font color = 'green'>Injecting</font>"):("<font color = 'red'><strong>On Hold</strong></font>")] <A href='?src=\ref[src];in_refresh_status=1'>Refresh</A><BR>Flow Rate Limit: [ATMOS_DEFAULT_VOLUME_PUMP+500] L/s<BR>"
		output += "Command: <A href='?src=\ref[src];in_toggle_injector=1'>Toggle Power</A> <A href='?src=\ref[src];in_set_flowrate=1'>Set Flow Rate</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find input port</FONT> <A href='?src=\ref[src];in_refresh_status=1'>Search</A><BR>"

	output += "Flow Rate: [round(input_flow_setting, 0.1)] L/s<BR>"
	output += "Command: <A href='?src=\ref[src];in_toggle_injector=1'>Toggle Power</A> <A href='?src=\ref[src];in_set_flowrate=1'>Set Flow Rate</A><a href='?src=\ref[src].in_set_max=1'>Max Flow</a><BR>"
	output += "<BR>"

	if(output_info)
		var/power = (output_info["power"])
		output += "<B>Core Output</B>: [power?("<font color = 'green'>Open</font>"):("<font color = 'red'><strong>On Hold</strong></font>")] <A href='?src=\ref[src];out_refresh_status=1'>Refresh</A><BR>Max Output Pressure: [MAX_PUMP_PRESSURE] kPa<BR>"
		output += "Command: <A href='?src=\ref[src];out_toggle_power=1'>Toggle Power</A> <A href='?src=\ref[src];out_set_pressure=1'>Set Pressure</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find output port</FONT> <A href='?src=\ref[src];out_refresh_status=1'>Search</A><BR>"

	output += "Min Core Pressure Set: [pressure_setting] kPa<BR>"
	output += "Command: <A href='?src=\ref[src];out_toggle_power=1'>Toggle Power</A> <A href='?src=\ref[src];out_set_pressure=1'>Set Pressure</A><a href='?src=\ref[src].out_set_max=1'>Max Pressure</a><BR>"
	. = output
	. = JOINTEXT(.)

	return output

/obj/machinery/computer/general_air_control/large_tank_control/supermatter_core/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/fuel_injection
	icon = 'icons/obj/computer.dmi'
	icon_screen = "alert:0"

	var/device_tag
	var/list/device_info

	var/automation = 0

	var/cutoff_temperature = 2000
	var/on_temperature = 1200
	circuit = /obj/item/weapon/circuitboard/air_management/injector_control

/obj/machinery/computer/general_air_control/fuel_injection/Process()
	if(automation)
		if(!radio_connection)
			return 0

		var/injecting = 0
		for(var/id_tag in sensor_information)
			var/list/data = sensor_information[id_tag]
			if(data["temperature"])
				if(data["temperature"] >= cutoff_temperature)
					injecting = 0
					break
				if(data["temperature"] <= on_temperature)
					injecting = 1

		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.source = src

		signal.data = list(
			"tag" = device_tag,
			"power" = injecting,
			"sigtype"="command"
		)

		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	..()

/obj/machinery/computer/general_air_control/fuel_injection/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(device_tag == id_tag)
		device_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/fuel_injection/Topic(href, href_list)
	if((. = ..()))
		return

	if(href_list["refresh_status"])
		device_info = null
		if(!radio_connection)
			return 0

		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.source = src
		signal.data = list(
			"tag" = device_tag,
			"status" = 1,
			"sigtype"="command"
		)
		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	if(href_list["toggle_automation"])
		automation = !automation

	if(href_list["toggle_injector"])
		device_info = null
		if(!radio_connection)
			return 0

		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.source = src
		signal.data = list(
			"tag" = device_tag,
			"power_toggle" = 1,
			"sigtype"="command"
		)

		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	if(href_list["injection"])
		if(!radio_connection)
			return 0

		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.source = src
		signal.data = list(
			"tag" = device_tag,
			"inject" = 1,
			"sigtype"="command"
		)

		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)