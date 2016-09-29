//Signaler:
//When triggered via direct wiring, sends out a signal.
//When it receives a signal, it activates anything it's connected to via wiring.

/obj/item/device/assembly/signaler
	name = "remote signaling device"
	desc = "Used to remotely activate devices."
	icon_state = "signaller"
	item_state = "signaler"
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 200, "waste" = 100)
	wires = WIRE_DIRECT_RECEIVE | WIRE_RADIO_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_RADIO_SEND | WIRE_MISC_ACTIVATE | WIRE_DIRECT_SEND
	wire_num = 8

	var/delay = 0
	var/airlock_wire = null
	var/datum/wires/connected = null
	var/deadman = 0

/obj/item/device/assembly/signaler/activate()
	send_radio_pulse(list("ACTIVATE"))
	return 1

/obj/item/device/assembly/signaler/get_data(var/mob/user, var/ui_key)
	var/list/data = list()
	data.Add("Frequency", format_frequency(src.frequency), "Code", code)
	return data

/obj/item/device/assembly/signaler/get_buttons(var/mob/user, var/ui_key)
	var/list/data = list()
	data.Add("Send Signal")
	return data

/obj/item/device/assembly/signaler/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["option"])
		switch(href_list["option"])
			if("Frequency")
				var/new_frequency = input(usr, "What would you like to set the frequency to?", "Frequency")
				new_frequency = text2num(new_frequency)
				if(new_frequency < 1200 || new_frequency > 1600)
					new_frequency = sanitize_frequency(new_frequency)
				set_frequency(new_frequency)
				return 1

			if("Code")
				var/new_code = input(usr, "What would you like to set the code to?", "Code")
				new_code = text2num(new_code)
				if(new_code)
					src.code = new_code
					src.code = round(src.code)
					src.code = min(100, src.code)
					src.code = max(1, src.code)
				return 1

			if("Send Signal")
				process_activation()
				return 1

/obj/item/device/assembly/signaler/receive_radio_pulse(datum/signal/signal)
	if(!signal)	return 0
	if(signal.encryption != code)	return 0
	add_debug_log("Radio pulse received \[[src]\]")
	if(!(src.active_wires & WIRE_RADIO_RECEIVE))	return 0
	if(src.active_wires & WIRE_MISC_ACTIVATE)
		misc_activate()
		return 1
	return 0


/obj/item/device/assembly/signaler/misc_activate()
	add_debug_log("Misc activation \[[src]\]")
	if(src.connected && src.active_wires & (WIRE_DIRECT_SEND))
		if(process_signals(1))
			connected.Pulse(src)
			return 1
	if(holder)
		send_pulse_to_connected()
		return 1
	else
		for(var/mob/O in hearers(1, src.loc))
			O.show_message(text("\icon[] *beep* *beep*", src), 3, "*beep* *beep*", 2)
			return 1
	return 0

/obj/item/device/assembly/signaler/process()
	if(!deadman)
		processing_objects.Remove(src)
	var/mob/M = src.loc
	if(!M || !ismob(M))
		if(prob(5))
			send_radio_pulse()
		deadman = 0
		processing_objects.Remove(src)
	else if(prob(5))
		M.visible_message("[M]'s finger twitches a bit over [src]'s signal button!")
	return

/obj/item/device/assembly/signaler/verb/deadman_it()
	set src in usr
	set name = "Threaten to push the button!"
	set desc = "BOOOOM!"
	deadman = 1
	processing_objects.Add(src)
	log_and_message_admins("is threatening to trigger a signaler deadman's switch")
	usr.visible_message("<span class='warning'>[usr] moves their finger over [src]'s signal button...</span>")

/obj/item/device/assembly/signaler/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	frequency = 0
	..()
