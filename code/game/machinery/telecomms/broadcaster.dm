//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
	The broadcaster sends processed messages to all radio devices in the game. They
	do not have to be headsets; intercoms and station-bounced radios suffice.

	They receive their message from a server after the message has been logged.
*/

var/global/list/recentmessages = list() // global list of recent messages broadcasted : used to circumvent massive radio spam
var/global/message_delay = 0 // To make sure restarting the recentmessages list is kept in sync

/obj/machinery/telecomms/broadcaster
	name = "Subspace Broadcaster"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals."
	density = TRUE
	anchored = TRUE
	idle_power_usage = 25
	machinetype = 5
	produces_heat = 0
	delay = 7
	circuitboard = /obj/item/stock_parts/circuitboard/telecomms/broadcaster
	base_type = /obj/machinery/telecomms/broadcaster
	outage_probability = 10
	machine_name = "subspace broadcaster"
	machine_desc = "A high-powered broadcaster that sends subspace signals to all connected radio devices in the area. Part of a telecommunications network."

/obj/machinery/telecomms/broadcaster/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	// Don't broadcast rejected signals
	if(signal.data["reject"])
		return

	if(signal.data["message"])

		// Prevents massive radio spam
		signal.data["done"] = 1 // mark the signal as being broadcasted
		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1
			original.data["compression"] = signal.data["compression"]
			original.data["level"] = signal.data["level"]

		var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
		if(signal_message in recentmessages)
			return
		recentmessages.Add(signal_message)

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary

		signal.data["level"] |= listening_levels

	   /** #### - Normal Broadcast - #### **/

		if(signal.data["type"] == 0)

			/* ###### Broadcast a message using signal.data ###### */
			Broadcast_Message(signal.data["connection"], signal.data["mob"],
							  signal.data["vmask"], signal.data["vmessage"],
							  signal.data["radio"], signal.data["message"],
							  signal.data["name"], signal.data["job"],
							  signal.data["realname"], signal.data["vname"],,
							  signal.data["compression"], signal.data["level"], signal.frequency,
							  signal.data["verb"], signal.data["language"], signal.data["channel_tag"], signal.data["channel_color"])


	   /** #### - Simple Broadcast - #### **/

		if(signal.data["type"] == 1)

			/* ###### Broadcast a message using signal.data ###### */
			Broadcast_SimpleMessage(signal.data["name"], signal.frequency,
								  signal.data["message"],null, null,
								  signal.data["compression"], listening_levels, signal.data["channel_tag"], signal.data["channel_color"])


	   /** #### - Artificial Broadcast - #### **/
	   			// (Imitates a mob)

		if(signal.data["type"] == 2)

			/* ###### Broadcast a message using signal.data ###### */
				// Parameter "data" as 4: AI can't track this person/mob

			Broadcast_Message(signal.data["connection"], signal.data["mob"],
							  signal.data["vmask"], signal.data["vmessage"],
							  signal.data["radio"], signal.data["message"],
							  signal.data["name"], signal.data["job"],
							  signal.data["realname"], signal.data["vname"], 4, signal.data["compression"], signal.data["level"], signal.frequency,
							  signal.data["verb"], signal.data["language"], signal.data["channel_tag"], signal.data["channel_color"])

		if(!message_delay)
			message_delay = 1
			spawn(10)
				message_delay = 0
				recentmessages = list()

		/* --- Do a snazzy animation! --- */
		flick("broadcaster_send", src)

/obj/machinery/telecomms/broadcaster/Destroy()
	// In case message_delay is left on 1, otherwise it won't reset the list and people can't say the same thing twice anymore.
	if(message_delay)
		message_delay = 0
	..()


/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "Telecommunications Mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	machinetype = 6
	produces_heat = 0
	circuitboard = /obj/item/stock_parts/circuitboard/telecomms/allinone
	construct_state = /decl/machine_construction/tcomms/panel_closed/cannot_print
	machine_name = "telecommunications mainframe"
	machine_desc = "An awkward, clunky machine that serves as an all-in-one telecommunications hub. Provides peer-to-peer communication, and not much else."
	var/listening_freqs
	var/channel_color
	var/channel_name
	var/intercept = 0 // if nonzero, broadcasts all messages to syndicate channel

/obj/machinery/telecomms/allinone/Initialize()
	if(!listening_freqs)
		listening_freqs = ANTAG_FREQS	//Covers any updates to ANTAG_FREQS
	return ..()

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/signal)

	if(!on) // has to be on to receive messages
		return

	if(is_freq_listening(signal)) // detect subspace signals

		if(freq_listening.len) //If we are actively listening to this frequency, go ahead and use the real signal
			signal.data["done"] = 1 // mark the signal as being broadcasted
			signal.data["compression"] = 0

			// Search for the original signal and mark it as done as well
			var/datum/signal/original = signal.data["original"]
			if(original)
				original.data["done"] = 1

			if(signal.data["slow"] > 0)
				sleep(signal.data["slow"]) // simulate the network lag if necessary

			/* ###### Broadcast a message using signal.data ###### */

			var/datum/radio_frequency/connection = signal.data["connection"]

			if(connection.frequency in listening_freqs) // if antag broadcast, just
				Broadcast_Message(signal.data["connection"], signal.data["mob"],
								signal.data["vmask"], signal.data["vmessage"],
								signal.data["radio"], signal.data["message"],
								signal.data["name"], signal.data["job"],
								signal.data["realname"], signal.data["vname"],, signal.data["compression"], list(0), connection.frequency,
								signal.data["verb"], signal.data["language"], channel_name ? channel_name : signal.data["channel_tag"], channel_color ? channel_color : signal.data["channel_color"])
			else
				if(intercept)
					Broadcast_Message(signal.data["connection"], signal.data["mob"],
								signal.data["vmask"], signal.data["vmessage"],
								signal.data["radio"], signal.data["message"],
								signal.data["name"], signal.data["job"],
								signal.data["realname"], signal.data["vname"], 3, signal.data["compression"], list(0), connection.frequency,
								signal.data["verb"], signal.data["language"], signal.data["channel_tag"], signal.data["channel_color"])

		else //If we are not actively listening and just pulling from every frequency, use a copy so that other telecomms networks aren't affected
			var/datum/signal/copy = new
			copy.transmission_method = 2
			copy.frequency = signal.frequency
			copy.data = signal.data.Copy()

			copy.data["done"] = 1 // mark the signal as being broadcasted
			copy.data["compression"] = 0

			if(copy.data["slow"] > 0)
				sleep(copy.data["slow"]) // simulate the network lag if necessary

			/* ###### Broadcast a message using signal.data ###### */

			var/datum/radio_frequency/connection = copy.data["connection"]

			if(connection.frequency in listening_freqs) // if antag broadcast, just
				Broadcast_Message(copy.data["connection"], copy.data["mob"],
								copy.data["vmask"], copy.data["vmessage"],
								copy.data["radio"], copy.data["message"],
								copy.data["name"], copy.data["job"],
								copy.data["realname"], copy.data["vname"],, copy.data["compression"], list(0), connection.frequency,
								copy.data["verb"], copy.data["language"], channel_name ? channel_name : copy.data["channel_tag"], channel_color ? channel_color : copy.data["channel_color"])
			else
				if(intercept)
					Broadcast_Message(copy.data["connection"], copy.data["mob"],
								copy.data["vmask"], copy.data["vmessage"],
								copy.data["radio"], copy.data["message"],
								copy.data["name"], copy.data["job"],
								copy.data["realname"], copy.data["vname"], 3, copy.data["compression"], list(0), connection.frequency,
								copy.data["verb"], copy.data["language"], copy.data["channel_tag"], copy.data["channel_color"])


/**

	Here is the big, bad function that broadcasts a message given the appropriate
	parameters.

	@param connection:
		The datum generated in radio.dm, stored in signal.data["connection"].

	@param M:
		Reference to the mob/speaker, stored in signal.data["mob"]

	@param vmask:
		Boolean value if the mob is "hiding" its identity via voice mask, stored in
		signal.data["vmask"]

	@param vmessage:
		If specified, will display this as the message; such as "chimpering"
		for monkies if the mob is not understood. Stored in signal.data["vmessage"].

	@param radio:
		Reference to the radio broadcasting the message, stored in signal.data["radio"]

	@param message:
		The actual string message to display to mobs who understood mob M. Stored in
		signal.data["message"]

	@param name:
		The name to display when a mob receives the message. signal.data["name"]

	@param job:
		The name job to display for the AI when it receives the message. signal.data["job"]

	@param realname:
		The "real" name associated with the mob. signal.data["realname"]

	@param vname:
		If specified, will use this name when mob M is not understood. signal.data["vname"]

	@param data:
		If specified:
				1 -- Will only broadcast to intercoms
				2 -- Will only broadcast to intercoms and station-bounced radios
				3 -- Broadcast to syndicate frequency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual mob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal may be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param freq
		The frequency of the signal

	@param channel_tag
		The "name" of the frequency. Displayed in brackets before the message

	@param channel_color
		Color of the radio message

**/

/proc/Broadcast_Message(var/datum/radio_frequency/connection, var/mob/M,
						var/vmask, var/vmessage, var/obj/item/device/radio/radio,
						var/message, var/name, var/job, var/realname, var/vname,
						var/data, var/compression, var/list/level, var/freq, var/verbage = "says", var/datum/language/speaking = null,
						var/channel_tag, var/channel_color)


  /* ###### Prepare the radio connection ###### */

	var/display_freq = freq

	var/list/obj/item/device/radio/radios = list()

	// --- Broadcast only to intercom devices ---

	if(data == 1)

		for (var/obj/item/device/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			if(R.receive_range(display_freq, level) > -1)
				radios += R

	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == 2)

		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])

			if(istype(R, /obj/item/device/radio/headset))
				continue

			if(R.receive_range(display_freq, level) > -1)
				radios += R

	// --- Broadcast to antag radios! ---

	else if(data == 3)
		for(var/antag_freq in ANTAG_FREQS)
			var/datum/radio_frequency/antag_connection = radio_controller.return_frequency(antag_freq)
			for (var/obj/item/device/radio/R in antag_connection.devices["[RADIO_CHAT]"])
				if(R.intercept && R.receive_range(antag_freq, level) > -1)
					radios += R

	// --- Broadcast to ALL radio devices ---
	else

		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])
			if(R.receive_range(display_freq, level) > -1)
				radios += R

	for(var/obj/item/device/radio/R in radios)
		if((R.last_radio_sound + 1 SECOND) < world.time && R != radio)
			playsound(R.loc, 'sound/effects/radio_chatter.ogg', 10, 0, -6)
			R.last_radio_sound = world.time

	// Get a list of mobs who can hear from the radios we collected.
	var/list/receive = get_mobs_in_radio_ranges(radios)

  /* ###### Organize the receivers into categories for displaying the message ###### */

  	// Understood the message:
	var/list/heard_masked 	= list() // masked name or no real name
	var/list/heard_normal 	= list() // normal message

	// Did not understand the message:
	var/list/heard_voice 	= list() // voice message	(ie "chimpers")
	var/list/heard_garbled	= list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	for (var/mob/R in receive)

	  /* --- Loop through the receivers and categorize them --- */
		if(istype(R, /mob/new_player)) // we don't want new players to hear messages. rare but generates runtimes.
			continue

		// Ghosts hearing all radio chat don't want to hear syndicate intercepts, they're duplicates
		if(data == 3 && isghost(R) && R.get_preference_value(/datum/client_preference/ghost_radio) == GLOB.PREF_ALL_CHATTER)
			continue

		// --- Check for compression ---
		if(compression > 0)
			heard_gibberish += R
			continue

		// --- Can understand the speech ---

		if (!M || R.say_understands(M))

			// - Not human or wearing a voice mask -
			if (!M || !ishuman(M) || vmask)
				heard_masked += R

			// - Human and not wearing voice mask -
			else
				heard_normal += R

		// --- Can't understand the speech ---

		else
			// - The speaker has a prespecified "voice message" to display if not understood -
			if (vmessage)
				heard_voice += R

			// - Just display a garbled message -
			else
				heard_garbled += R


  /* ###### Begin formatting and sending the message ###### */
	if (length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled) || length(heard_gibberish))

	  /* --- Some miscellaneous variables to format the string output --- */
		var/freq_text = format_frequency(display_freq)
		if(channel_tag)
			freq_text = channel_tag

		// Default to commons channel green
		if(!channel_color)
			channel_color = channel_color_presets["Global Green"]

		var/part_b_extra = ""
		if(data == 3) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"
		var/part_a = "<span style='color: [channel_color]'><b>\[[freq_text]\][part_b_extra]</b> <span class='name'>" // goes in the actual output

		// --- Some more pre-message formatting ---
		var/part_b = "</span> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"


		 /* ###### Send the message ###### */

	  	/* --- Process all the mobs that heard a masked voice (understood) --- */

		if (length(heard_masked))
			for (var/mob/R in heard_masked)
				R.hear_radio(message,verbage, speaking, part_a, part_b, part_c, M, 0, name)

		/* --- Process all the mobs that heard the voice normally (understood) --- */

		if (length(heard_normal))
			for (var/mob/R in heard_normal)
				R.hear_radio(message, verbage, speaking, part_a, part_b, part_c, M, 0, realname)

		/* --- Process all the mobs that heard the voice normally (did not understand) --- */

		if (length(heard_voice))
			for (var/mob/R in heard_voice)
				R.hear_radio(message,verbage, speaking, part_a, part_b, part_c, M,0, vname)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")

		if (length(heard_garbled))
			for (var/mob/R in heard_garbled)
				R.hear_radio(message, verbage, speaking, part_a, part_b, part_c, M, 1, vname)


		/* --- Complete gibberish. Usually happens when there's a compressed message --- */

		if (length(heard_gibberish))
			for (var/mob/R in heard_gibberish)
				R.hear_radio(message, verbage, speaking, part_a, part_b, part_c, M, compression)

	return 1

/proc/Broadcast_SimpleMessage(var/source, var/frequency, var/text, var/data, var/mob/M, var/compression, var/level, var/channel_tag, var/channel_color)

  /* ###### Prepare the radio connection ###### */

	if(!M)
		var/mob/living/carbon/human/H = new
		M = H

	var/datum/radio_frequency/connection = radio_controller.return_frequency(frequency)

	var/display_freq = connection.frequency

	var/list/receive = list()


	// --- Broadcast only to intercom devices ---

	if(data == 1)
		for (var/obj/item/device/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq, level)


	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == 2)
		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])

			if(istype(R, /obj/item/device/radio/headset))
				continue
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq)


	// --- Broadcast to antag radios! ---

	else if(data == 3)
		for(var/freq in ANTAG_FREQS)
			var/datum/radio_frequency/antag_connection = radio_controller.return_frequency(freq)
			for (var/obj/item/device/radio/R in antag_connection.devices["[RADIO_CHAT]"])
				var/turf/position = get_turf(R)
				if(position && position.z == level)
					receive |= R.send_hear(freq)


	// --- Broadcast to ALL radio devices ---

	else
		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq)


  /* ###### Organize the receivers into categories for displaying the message ###### */

	// Understood the message:
	var/list/heard_normal 	= list() // normal message

	// Did not understand the message:
	var/list/heard_garbled	= list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	for (var/mob/R in receive)

	  /* --- Loop through the receivers and categorize them --- */
		// --- Check for compression ---
		if(compression > 0)

			heard_gibberish += R
			continue

		// --- Can understand the speech ---

		if (R.say_understands(M))

			heard_normal += R

		// --- Can't understand the speech ---

		else
			// - Just display a garbled message -

			heard_garbled += R


  /* ###### Begin formatting and sending the message ###### */
	if (length(heard_normal) || length(heard_garbled) || length(heard_gibberish))

	  /* --- Some miscellaneous variables to format the string output --- */
		var/freq_text = format_frequency(display_freq)
		if(channel_tag)
			freq_text = channel_tag

		if(!channel_color)
			channel_color = channel_color_presets["Global Green"]

		var/part_a = "<span style='color: [channel_color]'><span class='name'>" // goes in the actual output

		// --- Some more pre-message formatting ---

		var/part_b_extra = ""
		if(data == 3) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"

		var/part_b = "</span><b> \[[freq_text]\][part_b_extra]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"

		//End of research and feedback code.

	 /* ###### Send the message ###### */

		/* --- Process all the mobs that heard the voice normally (understood) --- */

		if (length(heard_normal))
			var/rendered = "[part_a][source][part_b]\"[text]\"[part_c]"

			for (var/mob/R in heard_normal)
				R.show_message(rendered, 2)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")

		if (length(heard_garbled))
			var/quotedmsg = "\"[stars(text)]\""
			var/rendered = "[part_a][source][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_garbled)
				R.show_message(rendered, 2)


		/* --- Complete gibberish. Usually happens when there's a compressed message --- */

		if (length(heard_gibberish))
			var/quotedmsg = "\"[Gibberish(text, compression + 50)]\""
			var/rendered = "[part_a][Gibberish(source, compression + 50)][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_gibberish)
				R.show_message(rendered, 2)

//Use this to test if an obj can communicate with a Telecommunications Network

/atom/proc/test_telecomms()
	var/datum/signal/signal = src.telecomms_process()
	var/turf/position = get_turf(src)
	return (position.z in signal.data["level"] && signal.data["done"])

/atom/proc/telecomms_process(var/do_sleep = 1)

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new
	signal.transmission_method = 2 // 2 would be a subspace transmission.
	var/turf/pos = get_turf(src)

	// --- Finally, tag the actual signal with the appropriate values ---
	signal.data = list(
		"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
		"message" = "TEST",
		"compression" = rand(45, 50), // If the signal is compressed, compress our message too.
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = 4, // determines what type of radio input it is: test broadcast
		"reject" = 0,
		"done" = 0,
		"level" = pos ? pos.z : 0 // The level it is being broadcasted at.
	)
	signal.frequency = PUB_FREQ// Common channel

  //#### Sending the signal to all subspace receivers ####//
	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)

	if(do_sleep)
		sleep(rand(10,25))

	//to_world_log("Level: [signal.data["level"]] - Done: [signal.data["done"]]")

	return signal

