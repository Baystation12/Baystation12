/obj/item/device/assembly/data_wireless
	name = "wireless device"
	desc = "A device for sending data wirelessly."
	icon_state = "logic"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	weight = 2

	wires = WIRE_DIRECT_RECEIVE | WIRE_RADIO_RECEIVE |  WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_RADIO_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 7

	radio = 1

	var/send_data = "NULL"
	var/parameter = "NULL"
	var/key = "NULL"

/obj/item/device/assembly/data_wireless/receive_radio_pulse(var/datum/signal/signal)
	add_debug_log("Radio pulse received \[[src]\]")
	if(!(active_wires & WIRE_RADIO_RECEIVE)) return 0
	if(!signal || !istype(signal) || signal.source == src) // Just in case
		return 0
	if(signal.encryption == code)
		if(process_signals(0))
			if(signal.data.len)
				if(send_data(signal.data))
					return 1
	return 0

/obj/item/device/assembly/data_wireless/receive_data(var/list/data)
	if(!..()) return 0
	if(!send_radio_pulse(data))
		return 0
	return 1

/obj/item/device/assembly/data_wireless/activate()
	if(!send_radio_pulse(list(send_data, parameter)))
		return 0
	return 1

/obj/item/device/assembly/data_wireless/get_data()
	var/list/data = list()
	data.Add("Sending Data", send_data)
	data.Add("Frequency", format_frequency(src.frequency), "Code", code, "Additional Parameter", parameter)
	if(parameter && parameter != "NULL")
		data.Add("Additional Parameter Key", key)
	return data

/obj/item/device/assembly/data_wirelss/get_buttons()
	var/list/data = list()
	data.Add("Send Signal")
	return data

/obj/item/device/assembly/data_wireless/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Sending Data")
				var/inp = input(usr, "What data would you like to send?", "Data")
				if(istext(inp))
					send_data = inp
				else send_data = "NULL"
			if("Frequency")
				var/new_frequency = input(usr, "What would you like to set the frequency to?", "Frequency")
				new_frequency = text2num(new_frequency)
				if(new_frequency < 1200 || new_frequency > 1600)
					new_frequency = sanitize_frequency(new_frequency)
				set_frequency(new_frequency)

			if("Code")
				var/new_code = input(usr, "What would you like to set the code to?", "Code")
				if(new_code)
					code = new_code
				new_code = "NULL"

			if("Additional Parameter")
				var/new_parameter = input(usr, "What would you like to set the parameter to?", "Parameter")
				if(new_parameter)
					parameter = new_parameter
				else parameter = "NULL"

			if("Additional Parameter Key")
				var/new_key = input(usr, "What would you like to set the paramater key to?", "Key")
				if(new_key)
					key = new_key
				else key = "NULL"

			if("Send Signal")
				activate()
	..()

