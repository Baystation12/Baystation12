/obj/item/device/assembly/power_metre
	name = "power metre"
	desc = "A portable device for measuring power currents."
	icon_state = "syringe"
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION | WIRE_POWER_RECEIVE
	wire_num = 7

	var/obj/structure/cable/attached
	var/datum/powernet/PN

	var/list/send_datas = list("Voltage", "Excess Power", "Load")
	var/sent_data = "Voltage"

	var/send_type = "Data"

/obj/item/device/assembly/power_metre/get_data()
	var/list/data = list()
	if(holder)
		data.Add("Checking", sent_data)
		data.Add("Sending", send_type)
	return data

/obj/item/device/assembly/power_metre/get_nonset_data()
	var/list/data = list()
	if(!attached && active_wires & WIRE_POWER_RECEIVE)
		var/list/devices = get_holder_linked_devices()
		for(var/obj/item/device/assembly/A in devices)
			if(istype(A))
				if(A.attempt_get_power_amount(src, 1))
					data.Add("Getting power of [A.interface_name]! ([(A.get_charge())])")
					return 1
	else
		if(!PN) PN = attached.powernet
		if(!PN) return 0
		data.Add("<b>Voltage:</b> [PN.avail]", "<b>Excess Power:</b> [PN.netexcess]", "<b>Load:</b> [PN.load]")
	return data

/obj/item/device/assembly/power_metre/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Sending")
				if(send_type == "Pulse") send_type = "Data"
				else send_type = "Pulse"
			if("Checking")
				var/index = send_datas.Find(sent_data)
				if(!index || index == send_datas.len) index = 1
				else index += 1
				sent_data = send_datas[index]
	..()

/obj/item/device/assembly/power_metre/activate()
	if(!attached)
		if(active_wires & WIRE_POWER_RECEIVE)
			var/list/devices = get_holder_linked_devices()
			devices += get_holder_linked_devices_reversed()
			for(var/obj/item/device/assembly/A in devices)
				if(istype(A))
					if(A.attempt_get_power_amount(src, 1))
						var/charge = A.get_charge()
						if(send_type == "Data")
							send_data(list(charge))
						else if(charge)
							send_pulse_to_connected()
						return 1
			return 0

	PN = attached.powernet
	switch(sent_data)
		if("Voltage")
			if(PN)
				if(send_type == "Data")
					send_data(list(PN.avail))
				else if(PN.avail)
					send_pulse_to_connected()
		if("Excess Power")
			if(PN)
				if(send_type == "Data")
					send_data(list(PN.netexcess))
				else if(PN.netexcess)
					send_pulse_to_connected()
		if("Load")
			if(PN)
				if(send_type == "Data")
					send_data(list(PN.viewload))
				else if(PN.load)
					send_pulse_to_connected()

/obj/item/device/assembly/power_metre/anchored(var/on = 0)
	if(on)
		var/turf/T = get_turf(src)
		if(isturf(T))
			attached = locate() in T
	else
		attached = null
	return 1




