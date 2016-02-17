/obj/item/device/assembly/data_buffer
	name = "data buffer"
	desc = "A storage for data."
	icon_state = "logic"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

	var/check_interval = 25
	var/check_progress = 0
	var/pass_data = 0 // Pasta data
	var/list/stored_data = list()

	get_data(var/mob/user, var/ui_key)
		var/list/data = list()
		data.Add("Data Pass Method", pass_data)
		return data

	get_buttons()
		var/list/data = list()
		data.Add("Clear Data")
		return data

	receive_data(var/list/data, var/obj/item/device/assembly/sender)
		for(var/i=1,i<=data.len,i++)
			if(stored_data.len < 20)
				stored_data.Add(sender, data[i])
			else
				stored_data.Cut(1, 2)
				stored_data.Add(sender, data[i])

	process()
		check_progress++
		if(check_progress == check_interval)
			check_interval = min(100, rand(initial(check_interval) / 1.5, check_interval * 2)) // Should make for large variations in time.
			check_progress = 0
			activate()
		else return 1




	activate()
		var/list/devices = get_holder_linked_devices_reversed()
		if(devices.len)
			if(!(active_wires & WIRE_PROCESS_ACTIVATE & WIRE_DIRECT_SEND & WIRE_PROCESS_SEND & WIRE_MISC_CONNECTION)) return 0
			for(var/i=1,i<=stored_data.len,i++)
				if(i%2)
					if(stored_data[i])
						var/obj/item/device/assembly/sender = stored_data[i]
						if(!istype(sender)) return
						var/data = stored_data[(i+1)]
						if(pass_data)
							for(var/obj/item/device/assembly/A in get_holder_linked_devices())
								if(istype(A))
									send_data(data)
						else if(!pass_data || pass_data == 2)
							sender.send_data(data)
					stored_data.Cut(i, i+1)
					break
		else if(stored_data.len)
			add_debug_log("Removing excess data \[[src]\]")
			stored_data.Cut()

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Data Pass Method")
					if(pass_data == 1)
						usr << "<span class='notice'>\The [src] will now return any data packets for resending aswell as sending it to connected devices!</span>"
						pass_data = 2
					else if(pass_data == 2)
						usr << "<span class='notice'>\The [src] will now return any data packets for resending.</span>"
						pass_data = 0
					else if(pass_data == 0)
						usr << "<span class='notice'>\The [src] will now send any data packets to any connected devices!</span>"
						pass_data = 1
				if("Clear Data")
					stored_data.Cut()
		..()

