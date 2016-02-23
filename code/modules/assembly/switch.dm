/obj/item/device/assembly/switch_device
	name = "switch"
	desc = "A simple switch. Turns things on and off."
	icon_state = "switch"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_ACTIVATE | WIRE_MISC_CONNECTION
	wire_num = 7

	var/on = 1
	var/toggle_data = "TOGGLE"

/obj/item/device/assembly/switch_device/receive_data(var/list/data, var/obj/item/device/assembly/A)
	if(toggle_data in data)
		misc_activate()
	return 1

/obj/item/device/assembly/switch_device/misc_activate()
	if(active_wires & WIRE_MISC_ACTIVATE)
		on = !on

/obj/item/device/assembly/switch_device/activate()
	if(on)
		..()
	return 1

/obj/item/device/assembly/switch_device/get_data()
	var/list/data = list()
	data.Add("Active", on, "Toggle Data", toggle_data)
	return data

/obj/item/device/assembly/switch_device/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Active")
				on = !on
				usr << "<span class='notice'>You turn \the [src] [on ? "on" : "off"]</span>"
			if("Toggle Data")
				var/inp = input(usr, "What data would you like to search for?", "Data")
				if(inp)
					toggle_data = inp
	..()


/obj/item/device/assembly/switch_device/two_way
	name = "two-way switch"
	desc = "A switch that toggles between two outputs."
	icon_state = "twoway"
	var/alt_connected_to = 0
	var/alt_connected_to_name = "NULL"
	var/true = "TRUE"

/obj/item/device/assembly/switch_device/two_way/activate()
	if(on && alt_connected_to)
		var/obj/item/device/assembly/A = holder.connected_devices[alt_connected_to]
		if(A)
			send_direct_pulse(A)
	else
		send_pulse_to_connected()
	if(true == "TRUE")
		on = !on
	return 1

/obj/item/device/assembly/switch_device/two_way/get_data()
		var/list/data = list()
		data.Add("Active", on, "Toggle Data", toggle_data, "Alt.Connection", alt_connected_to_name, "Toggle After Activation", true)
		return data

/obj/item/device/assembly/switch_device/two_way/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Toggle After Activation")
				if(true == "TRUE") true = "FALSE"
				else true = "TRUE"
				usr << "<span class='notice'> You set \the [src]'s \"Toggle After Activate\" to \"[true]\"</span>"
			if("Alt.Connection")
				if(!holder)
					usr << "There's nothing you can connect \the [src] to!"
				else
					var/list/devices = list()
					var/list/choices = list()
					for(var/i=1,i<=holder.connected_devices.len,i++)
						var/obj/item/device/assembly/A = holder.connected_devices[i]
						if(A == src) continue
						if(i in connects_to || i == alt_connected_to) continue
						devices.Add(A)
						choices.Add(A.interface_name)
					var/inp = input(usr, "What device would you like to connect to?", "Connection") in choices
					var/obj/item/device/assembly/connect_to = devices[(choices.Find(inp))]
					var/index = find_holder_linked_devices(connect_to)
					add_debug_log("\[[src] : Got: [connect_to.name] Index: [index]\]")
					if(num2text(index) == alt_connected_to || num2text(index) in connects_to)
						usr << "<span class='warning'>\The [src] is already connected to \the [connect_to.interface_name]</span>"
					else if(index)
						if(connect_to != src)
							alt_connected_to = text2num(index)
							usr << "<span class='notice'>You set \the [src]'s alternate connection to [connect_to.interface_name]!</span>"
							alt_connected_to_name = connect_to.interface_name
						else
							usr << "<span class='warning'>You cannot connect \the [src] to itself!</span>"
	..()

/obj/item/device/assembly/switch_device/multi_way
	name = "multi-way switch"
	desc = "A switch that toggles between multiple outputs."
	icon_state = "multiway"
	var/true = "TRUE"
	var/alt_connection = 1
	var/obj/item/device/assembly/alt_connected_to

/obj/item/device/assembly/switch_device/multi_way/activate()
	if(on)
		if(alt_connection > connects_to.len)
			alt_connection = 1
		var/index = text2num(connects_to[alt_connection])
		alt_connected_to = holder.connected_devices[index]
		if(alt_connected_to)
			send_direct_pulse(alt_connected_to)
		if(true == "TRUE")
			alt_connection += 1
	return 1

/obj/item/device/assembly/switch_device/multi_way/get_data()
	var/list/data = list()
	data.Add("Active", on, "Toggle Data", toggle_data, "Change After Activation", true)
	return data

/obj/item/device/assembly/switch_device/multi_way/misc_activate()
	if(active_wires & WIRE_MISC_ACTIVATE)
		alt_connection++
		return 1

/obj/item/device/assembly/switch_device/multi_way/receive_data(var/list/data)
	if(toggle_data in data)
		on = !on
	return 1

/obj/item/device/assembly/switch_device/multi_way/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Change After Activation")
				if(true == "TRUE") true = "FALSE"
				else true = "TRUE"
				usr << "<span class='notice'>You set \the [src]'s \"Toggle After Activate\" to \"[true]\"</span>"
	..()

