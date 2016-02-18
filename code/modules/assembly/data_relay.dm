/obj/item/device/assembly/data_relay
	name = "relays circuit"
	desc = "Relays data between devices."
	icon_state = "logic"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

	var/alt_connected_to = -1
	var/alt_connected_to_name = "NULL"
	var/alt_data_send = "NULL"

/obj/item/device/assembly/data_relay/receive_data(var/list/data, var/obj/item/device/assembly/sender)
	var/broken_connection = 0
	if(process_signals(1))
		for(var/obj/item/device/assembly/A in get_holder_linked_devices())
			if(!(A.receive_data(data, sender)))
				broken_connection = 1
				break
	else broken_connection = 1
	if(broken_connection)
		var/obj/item/device/assembly/A = holder.connected_devices[alt_connected_to]
		if(A)
			if(alt_data_send == "\[input\]")
				A.receive_data(list(data), src) // Skips some wire checking.
			else
				A.process_receive_data(list(alt_data_send), src)

/obj/item/device/assembly/data_relay/get_data(var/mob/user, ui_key) // UI data...
	var/list/data = list()
	data.Add("Alt.Data", alt_data_send)
	data.Add("Alt.Connection", alt_connected_to_name)
	return data

/obj/item/device/assembly/data_relay/get_buttons(user, ui_key)
	var/list/buttons = list()
	buttons.Add("Send Alt.Data", "Reset Data")
	return buttons

/obj/item/device/assembly/data_relay/get_help_info()
	var/T = "This is data relay device. It is a one-way device used to send data \
			 to any devices in the assembly. The benefit of the relay is that if \
			 it fails to send any data, it'll send out a message to alternate connections. \
			 This can be used in tandum with a security system or failsafe. \
			 Additionally, you can type \[input\] into the alternate data \
			 and it will send the failed data to it's alternate connections, \
			 which can be used for buffering."
	return T


/obj/item/device/assembly/data_relay/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Alt.Connection")
				if(!holder || !(active_wires & WIRE_MISC_CONNECTION))
					usr << "<span class='warning'>There's nothing to connect \the [src] too!</span>"
				else
					if(holder.connected_devices.len > 1)
						var/list/choices = list()
						for(var/obj/item/device/assembly/A in holder.connected_devices)
							if(A)
								choices.Add(A.interface_name)
						var/choice = input(usr, "What would you like to connect to?", "Data") in choices
						for(var/i=1,i<=holder.connected_devices.len,i++)
							var/obj/item/device/assembly/A = holder.connected_devices[i]
							if(A.interface_name == choice)
								alt_connected_to = holder.get_index(A)
								alt_connected_to_name = A.interface_name
			if("Alt.Data")
				var/data = input(usr, "What data would you like sent?", "Data")
				if(data)
					alt_data_send = data
					usr << "<span class='notice'>You've set the data to [data]!</span>"
			if("Reset Data")
				alt_connected_to = initial(alt_connected_to)
				alt_connected_to_name = "NULL"
				alt_data_send = "NULL"
				usr << "<span class='notice'>You reset \the [src]'s data!</span>"
			if("Send Alt.Data")
				if(!holder) return 0
				var/obj/item/device/assembly/A = holder.connected_devices[alt_connected_to]
				if(A)
					A.process_receive_data(list(alt_data_send))

	..()