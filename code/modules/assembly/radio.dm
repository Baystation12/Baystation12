/obj/item/device/assembly/speaker/radio
	name = "modified speaker"
	desc = "Uses the latest voice synthesis technology to broadcast radio"
	icon_state = "speaker"
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "waste" = 100)
	var/obj/item/device/radio/radio_device
	var/list/channels = list("Common")
	var/current_channel = "Common"

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_RADIO_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

/obj/item/device/assembly/speaker/radio/New()
	..()
	radio_device = new /obj/item/device/radio{channels=list("Common")}(src)
	reliability = rand(50, 100)

/obj/item/device/assembly/speaker/radio/activate()
	if(active_wires & WIRE_RADIO_SEND)
		if(process_signals(1))
			radio_device.autosay(RadioChat(strip_html_properly(message), 100, (1+((100-reliability)*0.05))), voice, current_channel)
		return 1
	return 0

/obj/item/device/assembly/speaker/radio/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/device/assembly/data_sender))
		user << "<span class='notice'>\The [src] cannot fit another [O]!</span>"
		return
	..()
	if(istype(O, /obj/item/device/encryptionkey))
		var/obj/item/device/encryptionkey/newkey = O
		var/used = 0
		for(var/i=1,i<=newkey.channels.len,i++)
			if(!(newkey.channels[i] in channels))
				channels.Add(newkey.channels[i])
				radio_device.channels.Add(newkey.channels[i])
				used = 1
		if(used)
			O.loc = src
			qdel(O)
		else
			user << "<span class='notice'>\The [O] does not have any new channels!</span>"

/obj/item/device/assembly/speaker/radio/receive_data(var/list/data, var/sender)
	var/used = 0
	for(var/D in data)
		if(D in channels)
			current_channel = D
			used = 1
	if(!used)
		..(data, sender)
	return 1


/obj/item/device/assembly/speaker/radio/get_data()
	var/list/data = list()
	data.Add("Voice", voice, "Message", message, "Channel", current_channel)
	return data

/obj/item/device/assembly/speaker/radio/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Channel")
				if(channels.len > 1)
					for(var/i=1,i<=channels.len,i++)
						if(channels[i] == current_channel)
							var/index = i
							if(i == channels.len) index = 1
							current_channel = channels[index]
							usr << "<span class='notice'>You set \the [src]'s channel to: [current_channel]</span>"
	..()

/obj/item/device/assembly/speaker/radio/process_signals(var/sent = 0)
	add_debug_log("Processing signals\[[src]\]")
	if(sent && active_wires & (WIRE_PROCESS_SEND))
		return 1
	else if(!sent && active_wires & (WIRE_PROCESS_RECEIVE))
		return 1
	else
		radio_device.autosay(RadioChat(message, 75, 2), voice, current_channel) // The message is processed badly.
	add_debug_log("Signal failure! \[[src]:[sent?"(sending)":"(receiving)"]\]")
	return 0


