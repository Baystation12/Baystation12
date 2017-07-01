/obj/item/radio/integrated
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/device/pda/hostpda = null

	var/on = 0 //Are we currently active??
	var/menu_message = ""

	New()
		..()
		if (istype(loc.loc, /obj/item/device/pda))
			hostpda = loc.loc

	proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)

//		log_debug("Post: [freq]: [key]=[value], [key2]=[value2]")

		var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

		if(!frequency) return

		var/datum/signal/signal = new()
		signal.source = src
		signal.transmission_method = 1
		signal.data[key] = value
		if(key2)
			signal.data[key2] = value2
		if(key3)
			signal.data[key3] = value3

		frequency.post_signal(src, signal, filter = s_filter)

		return

	proc/generate_menu()

/obj/item/radio/integrated/beepsky
	var/list/botlist = null		// list of bots
	var/mob/living/bot/secbot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot

	var/control_freq = BOT_FREQ

	// create a new QM cartridge, and register to receive bot control & beacon message
	New()
		..()
		spawn(5)
			if(radio_controller)
				radio_controller.add_object(src, control_freq, filter = RADIO_SECBOT)

	// receive radio signals
	// can detect bot status signals
	// create/populate list as they are recvd

	receive_signal(datum/signal/signal)
//		var/obj/item/device/pda/P = src.loc

		/*
		log_debug("recvd:[P] : [signal.source]")

		for(var/d in signal.data)
			log_debug("- [d] = [signal.data[d]]")

		*/
		if (signal.data["type"] == "secbot")
			if(!botlist)
				botlist = new()

			if(!(signal.source in botlist))
				botlist += signal.source

			if(active == signal.source)
				var/list/b = signal.data
				botstatus = b.Copy()

//		if (istype(P)) P.updateSelfDialog()

	Topic(href, href_list)
		..()
		var/obj/item/device/pda/PDA = src.hostpda

		switch(href_list["op"])

			if("control")
				active = locate(href_list["bot"])
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

			if("scanbots")		// find all bots
				botlist = null
				post_signal(control_freq, "command", "bot_status", s_filter = RADIO_SECBOT)

			if("botlist")
				active = null

			if("stop", "go")
				post_signal(control_freq, "command", href_list["op"], "active", active, s_filter = RADIO_SECBOT)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

			if("summon")
				post_signal(control_freq, "command", "summon", "active", active, "target", get_turf(PDA) , s_filter = RADIO_SECBOT)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)


/obj/item/radio/integrated/beepsky/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, control_freq)
	return ..()

/*
 *	Radio Cartridge, essentially a signaler.
 */


/obj/item/radio/integrated/signal
	var/frequency = 1457
	var/code = 30.0
	var/last_transmission
	var/datum/radio_frequency/radio_connection

	initialize()
		if(!radio_controller)
			return

		if (src.frequency < PUBLIC_LOW_FREQ || src.frequency > PUBLIC_HIGH_FREQ)
			src.frequency = sanitize_frequency(src.frequency)

		set_frequency(frequency)

	proc/set_frequency(new_frequency)
		radio_controller.remove_object(src, frequency)
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, frequency)

	proc/send_signal(message="ACTIVATE")

		if(last_transmission && world.time < (last_transmission + 5))
			return
		last_transmission = world.time

		var/time = time2text(world.realtime,"hh:mm:ss")
		var/turf/T = get_turf(src)
		lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

		var/datum/signal/signal = new
		signal.source = src
		signal.encryption = code
		signal.data["message"] = message

		radio_connection.post_signal(src, signal)

		return

/obj/item/radio/integrated/signal/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	..()
