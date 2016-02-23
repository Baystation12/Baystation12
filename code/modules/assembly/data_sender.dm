/obj/item/device/assembly/data_sender
	name = "data sender"
	desc = "Sends data. Duh."
	icon_state = "logic"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

	var/mode = 0
	var/data_to_transform = "ACTIVATE"
	var/data_secondary = "NULL"
	var/obj/item/device/assembly/data_source
	var/data_source_var
	var/fetched_data = "NULL"
	var/change = 1
	var/pulse = 1

	New()
		..()
		processing_objects.Add(src)

	get_help_info()
		return "This is a data sending device. It is a device \
			    that can do one of two things: Convert electrical \
			    pulses to the data signal of your choice, or check \
			    the parameters of a device connected to it to retrieve \
			    a specified variable, and with that variable, it can \
			    either pass it to connected devices when pulsed, or it \
			    can pass on the variable when it changes. "


	Destroy()
		processing_objects.Remove(src)
		..()

	activate()
		if(!mode)
			send_data(list(data_to_transform, data_secondary))
		else if(fetched_data)
			var/list/L = fetched_data
			if(data_secondary && data_secondary != "NULL")
				L += data_secondary
			send_data(list(L))
		if(pulse)
			spawn(1)
				..() // Carries the pulse.

	get_data(var/mob/user, var/ui_key)
		var/list/data = list()
		if(!mode)
			data.Add("Sent Data", data_to_transform)
		data.Add("Sent Data Secondary", data_secondary)
		if(mode)
			data.Add("Data Source", (data_source ? data_source.name : "NULL"))
			data.Add("Send Data on Source Change", (change ? "Yes" : "No"))
		data.Add("Mode", (mode ? "Fetch" : "Convert"))
		data.Add("Carry on pulse", (pulse ? "Yes" : "No"))
		return data

	get_nonset_data()
		var/list/data = list()
		data.Add("Fetched Data: [fetched_data]")
		return data

	get_buttons(var/mob/user, var/ui_key)
		var/list/data = list()
		data.Add("Send Signal", "Reset Data")
		return data

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Carry on pulse")
					pulse = !pulse
				if("Send Data on Source Change")
					change = !change
				if("Sent Data")
					var/new_data = input(usr, "What would you like the device to send?", "Data")
					if(new_data)
						data_to_transform = new_data
					else data_to_transform = "NULL"
				if("Sent Data Secondary")
					var/new_data = input(usr, "What would you like the device to send?", "Data")
					if(new_data)
						data_secondary = new_data
					else data_secondary = "NULL"
				if("Send Signal")
					send_data(list(data_to_transform, data_secondary))
				if("Reset Data")
					usr << "<span class='notice'>You reset \the [src]'s data!</span>"
					data_to_transform = "ACTIVATE"
					data_secondary = "NULL"
					data_source = null
					data_source_var = null
				if("Data Source")
					if(!holder || !(active_wires & WIRE_MISC_CONNECTION))
						usr << "<span class='warning'> There's nothing to connect \the [src] too!</span>"
					else
						var/list/devices = get_holder_linked_devices_reversed()
						if(!devices.len)
							usr << "<span class='warning'>There's nothing to connect \the [src] too!</span>"
						else
							var/list/choices = list()
							for(var/i=1,i<=devices.len,i++)
								var/obj/item/device/assembly/A = devices[i]
								if(A)
									choices.Add(A.interface_name)
							var/choice = input(usr, "What device would you like to fetch data from?", "Data") in choices
							for(var/i=1,i<=devices.len,i++)
								var/obj/item/device/assembly/A = devices[i]
								if(A.interface_name == choice)
									data_source = A
							if(istype(data_source))
								var/list/data_source_vars = list()
								for(var/V in data_source.vars)
									if(isnum(V) || istext(V))
										data_source_vars += V
								if(data_source_vars.len)
									data_source_var = input(usr, "What data would you like to use?", "Data") in data_source_vars
									fetched_data = data_source.vars[data_source_var]
								else
									usr << "<span class='warning'>There is no applicable data to fetch!</span>"
							else
								usr << "<span class='warning'>Cannot find applicable devices!</span>"
				if("Mode")
					mode = !mode
		..()

	process()
		if(data_source && data_source_var)
			var/V = data_source.vars[data_source_var]
			if(active_wires & WIRE_MISC_CONNECTION)
				if(V != fetched_data && change)
					send_data(list(V))
					if(pulse)
						spawn(1)
							send_pulse_to_connected()
				fetched_data = V
		return 1
