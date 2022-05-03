/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "shortwave radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = PUB_FREQ //common chat
	var/default_frequency
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/datum/wires/radio/wires = null
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	var/subspace_transmission = 0
	var/syndie = 0//Holder to see if it's a syndicate encrypted radio
	var/intercept = 0 //can intercept other channels
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL

	matter = list(MATERIAL_GLASS = 25, MATERIAL_ALUMINIUM = 75)
	var/const/FREQ_LISTENING = 1
	var/list/internal_channels

	var/obj/item/cell/device/cell = /obj/item/cell/device/standard
	var/power_usage = 11 // about an hour, give or take 10 minutes.

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = new

	var/last_radio_sound = -INFINITY

	var/intercom_handling = FALSE

/obj/item/device/radio/hailing
	name = "shortwave radio (Hailing)"
	frequency = HAIL_FREQ

/obj/item/device/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/device/radio/Initialize()
	. = ..()
	wires = new(src)
	if(ispath(cell))
		cell = new cell(src)
		on = FALSE // start powered off
	internal_channels = GLOB.using_map.default_internal_channels()
	GLOB.listening_objects += src

	if(frequency < RADIO_LOW_FREQ || frequency > RADIO_HIGH_FREQ)
		frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
	set_frequency(frequency)
	if (!default_frequency)
		default_frequency = frequency

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

/obj/item/device/radio/Process()
	if(power_usage && on) //radio will use power and is on
		var/obj/item/cell/has_cell = get_cell()
		if(!has_cell) // No cell
			on = FALSE
			STOP_PROCESSING(SSobj, src)
			return FALSE
		if(!has_cell.checked_use(power_usage * CELLRATE)) // Use power and display if we run out.
			on = FALSE
			STOP_PROCESSING(SSobj, src)
			visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src] lets out a quiet click as it powers down."), SPAN_WARNING("You hear \a [src] let out a quiet click."))
			return FALSE



/obj/item/device/radio/Destroy()
	QDEL_NULL(wires)
	GLOB.listening_objects -= src
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
		for (var/ch_name in channels)
			radio_controller.remove_object(src, radiochannels[ch_name])
	if(get_cell())
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/device/radio/interact(mob/user)
	if(!user)
		return 0

	if(b_stat)
		wires.Interact(user)

	else
		ui_interact(user)

/obj/item/device/radio/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, datum/nanoui/master_ui = null, datum/topic_state/state = GLOB.default_state)
	var/data[0]

	data["power"] = on
	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["default_freq"] = format_frequency(default_frequency)
	data["rawfreq"] = num2text(frequency)
	var/obj/item/cell/has_cell = get_cell()
	if(has_cell)
		var/charge = round(has_cell.percent())
		data["charge"] = charge ? "[charge]%" : "NONE"
	data["mic_cut"] = (wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))
	data["spk_cut"] = (wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	if(syndie)
		data["useSyndMode"] = 1

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430, state = state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/device/radio/proc/list_secure_channels(var/mob/user)
	var/dat[0]

	for(var/ch_name in channels)
		var/chan_stat = channels[ch_name]
		var/listening = !!(chan_stat & FREQ_LISTENING) != 0

		dat.Add(list(list("chan" = ch_name, "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = !listening, "chan_span" = frequency_span_class(radiochannels[ch_name]))))

	return dat

/obj/item/device/radio/proc/list_internal_channels(var/mob/user)
	var/dat[0]
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = internal_chan, "display_name" = get_frequency_default_name(text2num(internal_chan)), "chan_span" = frequency_span_class(text2num(internal_chan)))))

	return dat

/obj/item/device/radio/proc/has_channel_access(var/mob/user, var/freq)
	if(!user)
		return 0

	if(!(freq in internal_channels))
		return 0

	return user.has_internal_radio_channel_access(internal_channels[freq])

/mob/proc/has_internal_radio_channel_access(var/list/req_one_accesses)
	var/obj/item/card/id/I = GetIdCard()
	if (!length(req_one_accesses))
		return TRUE // No access flags means all access
	else
		return has_access(list(req_one_accesses), I ? I.GetAccess() : list()) // Double list does an OR check instead of the usual AND.

/mob/observer/ghost/has_internal_radio_channel_access(var/list/req_one_accesses)
	return can_admin_interact()

/obj/item/device/radio/get_cell()
	return cell

/obj/item/device/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
			"}

/obj/item/device/radio/proc/reset_frequency()
	if (default_frequency)
		frequency = default_frequency

/obj/item/device/radio/proc/ToggleBroadcast()
	broadcasting = !broadcasting && !(wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/device/radio/proc/ToggleReception()
	listening = !listening && !(wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/device/radio/proc/TogglePower()
	if(!power_usage)
		return FALSE //Can't toggle power if there's no power to use
	var/obj/item/cell/has_cell = get_cell()
	if(!has_cell || !has_cell.check_charge(power_usage * CELLRATE)) // No cell or not enough power to turn on
		return FALSE

	//We're good to toggle state
	on = !on
	if(on)
		if(ismob(src.loc))
			playsound(src.loc, 'sound/effects/walkieon.ogg', 40, 0, -1)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/device/radio/CanUseTopic()
	if(!on && !get_cell()) // We need to still be able to use the topic if we use power
		return STATUS_CLOSE
	return ..()

/obj/item/device/radio/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)
	if (href_list["track"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		. = TRUE

	else if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if ((new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		set_frequency(new_frequency)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				close_browser(usr, "window=radio")
		. = TRUE
	else if (href_list["default_freq"])
		reset_frequency()
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				close_browser(usr, "window=radio")
		. = TRUE
	else if (href_list["power"])
		TogglePower()
		. = TRUE
	else if (href_list["talk"])
		ToggleBroadcast()
		. = TRUE
	else if (href_list["listen"])
		var/chan_name = href_list["ch_name"]
		if (!chan_name)
			ToggleReception()
		else
			if (channels[chan_name] & FREQ_LISTENING)
				channels[chan_name] &= ~FREQ_LISTENING
			else
				channels[chan_name] |= FREQ_LISTENING
		. = TRUE
	else if(href_list["spec_freq"])
		var freq = href_list["spec_freq"]
		if(has_channel_access(usr, freq))
			set_frequency(text2num(freq))
		. = TRUE
	if(href_list["nowindow"]) // here for pAIs, maybe others will want it, idk
		return TRUE

	if(href_list["remove_cell"])
		if(cell && b_stat)
			var/mob/user = usr
			user.put_in_hands(cell)
			to_chat(user, "<span class='notice'>You remove [cell] from \the [src].</span>")
			cell = null
		return TRUE

	if(.)
		SSnano.update_uis(src)

/obj/item/device/radio/proc/autosay(var/message, var/from, var/channel) //BS12 EDIT
	var/datum/radio_frequency/connection = null
	if(channel && channels && channels.len > 0)
		if (channel == "department")
			channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null
	if (!istype(connection))
		return
	var/mob/living/silicon/ai/A = new /mob/living/silicon/ai(src, null, null, 1)
	A.fully_replace_character_name(from)
	talk_into(A, message, channel,"states")
	qdel(A)

// Interprets the message mode when talking into a radio, possibly returning a connection datum
/obj/item/device/radio/proc/handle_message_mode(mob/living/M as mob, message, message_mode)
	// If a channel isn't specified, send to common.
	if(!message_mode || message_mode == "headset")
		return radio_connection

	// Otherwise, if a channel is specified, look for it.
	if(channels && channels.len > 0)
		if (message_mode == "department") // Department radio shortcut
			message_mode = channels[1]

		if (channels[message_mode]) // only broadcast if the channel is set on
			return secure_radio_connections[message_mode]

	// If we were to send to a channel we don't have, drop it.
	return null

/obj/item/device/radio/talk_into(mob/living/M, message, channel, var/verb = "says", var/datum/language/speaking = null)
	if(!on) return 0 // the device has to be on
	//  Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message) return 0

	if(speaking && (speaking.flags & (NONVERBAL|SIGNLANG))) return 0

	if (!broadcasting)
		// Sedation chemical effect should prevent radio use (Chloral and Soporific)
		var/mob/living/carbon/C = M
		if ((istype(C)) && (C.chem_effects[CE_SEDATE] || C.incapacitated(INCAPACITATION_DISRUPTED)))
			to_chat(M, SPAN_WARNING("You're unable to reach \the [src]."))
			return 0

		if((istype(C)) && C.radio_interrupt_cooldown > world.time)
			to_chat(M, SPAN_WARNING("You're disrupted as you reach for \the [src]."))
			return 0

		if(istype(M)) M.trigger_aiming(TARGET_CAN_RADIO)

	//  Uncommenting this. To the above comment:
	// 	The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just making radio wires useless. -Giacom
	if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return 0

	if(!radio_connection)
		set_frequency(frequency)

	if(loc == M)
		playsound(loc, 'sound/effects/walkietalkie.ogg', 20, 0, -1)


	/* Quick introduction:
		This new radio system uses a very robust FTL signaling technology unoriginally
		dubbed "subspace" which is somewhat similar to 'blue-space' but can't
		actually transmit large mass. Headsets are the only radio devices capable
		of sending subspace transmissions to the Communications Satellite.

		A headset sends a signal to a subspace listener/reciever elsewhere in space,
		the signal gets processed and logged, and an audible transmission gets sent
		to each individual headset.
	*/

	//#### Grab the connection datum ####//
	var/datum/radio_frequency/connection = handle_message_mode(M, message, channel)
	if (!istype(connection))
		return 0

	var/turf/position = get_turf(src)

	//#### Tagging the signal with all appropriate identity values ####//

	// ||-- The mob's name identity --||
	var/displayname = M.name	// grab the display name (name you get when you hover over someone's icon)
	var/real_name = M.real_name // mob's real name
	var/mobkey = "none" // player key associated with mob
	var/voicemask = 0 // the speaker is wearing a voice mask
	if(M.client)
		mobkey = M.key // assign the mob's key


	var/jobname // the mob's "job"

	// --- Human: use their actual job ---
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		jobname = H.get_assignment()

	// --- Carbon Nonhuman ---
	else if (iscarbon(M)) // Nonhuman carbon mob
		jobname = "No id"

	// --- AI ---
	else if (isAI(M))
		jobname = "AI"

	// --- Cyborg ---
	else if (isrobot(M))
		jobname = "Robot"

	// --- Personal AI (pAI) ---
	else if (istype(M, /mob/living/silicon/pai))
		jobname = "Personal AI"

	// --- Unidentifiable mob ---
	else
		jobname = "Unknown"


	// --- Modifications to the mob's identity ---

	// The mob is disguising their identity:
	if (ishuman(M) && M.GetVoice() != real_name)
		displayname = M.GetVoice()
		jobname = "Unknown"
		voicemask = 1



  /* ###### Radio headsets can only broadcast through subspace ###### */
	if(subspace_transmission)
		// First, we want to generate a new radio signal
		var/datum/signal/signal = new
		signal.transmission_method = 2 // 2 would be a subspace transmission.
									   // transmission_method could probably be enumerated through #define. Would be neater.

		// --- Finally, tag the actual signal with the appropriate values ---
		signal.data = list(
		  // Identity-associated tags:
			"mob" = M, // store a reference to the mob
			"mobtype" = M.type, 	// the mob's type
			"realname" = real_name, // the mob's real name
			"name" = displayname,	// the mob's display name
			"job" = jobname,		// the mob's job
			"key" = mobkey,			// the mob's key
			"vmessage" = pick(M.speak_emote), // the message to display if the voice wasn't understood
			"vname" = M.voice_name, // the name to display if the voice wasn't understood
			"vmask" = voicemask,	// 1 if the mob is using a voice gas mask

			// We store things that would otherwise be kept in the actual mob
			// so that they can be logged even AFTER the mob is deleted or something

		  // Other tags:
			"compression" = rand(45,50), // compressed radio signal
			"message" = message, // the actual sent message
			"connection" = connection, // the radio connection to use
			"radio" = src, // stores the radio used for transmission
			"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
			"traffic" = 0, // dictates the total traffic sum that the signal went through
			"type" = 0, // determines what type of radio input it is: normal broadcast
			"server" = null, // the last server to log this signal
			"reject" = 0,	// if nonzero, the signal will not be accepted by any broadcasting machinery
			"level" = position.z, // The source's z level
			"channel_tag" = "[connection.frequency]", // channel tag for the message
			"channel_color" = channel_color_presets["Menacing Maroon"], // radio message color
			"language" = speaking,
			"verb" = verb
		)
		signal.frequency = connection.frequency // Quick frequency set

	  //#### Sending the signal to all subspace receivers ####//

		for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in telecomms_list)
			R.receive_signal(signal)

		// Receiving code can be located in Telecommunications.dm
		if(signal.data["done"] && (position.z in signal.data["level"]))
			return TRUE //Huzzah, sent via subspace

		else //Less huzzah, we have to fallback
			for(var/obj/item/device/radio/R in loc)
				if(!R.subspace_transmission)
					return R.talk_into(M, message, channel, verb, speaking)
			return FALSE

  /* ###### Intercoms and station-bounced radios ###### */

	var/filter_type = 2

	/* --- Intercoms can only broadcast to other intercoms, but bounced radios can broadcast to bounced radios and intercoms --- */
	if(istype(src, /obj/item/device/radio/intercom))
		filter_type = 1


	var/datum/signal/signal = new
	signal.transmission_method = 2


	/* --- Try to send a normal subspace broadcast first */

	signal.data = list(

		"mob" = M, // store a reference to the mob
		"mobtype" = M.type, 	// the mob's type
		"realname" = real_name, // the mob's real name
		"name" = displayname,	// the mob's display name
		"job" = jobname,		// the mob's job
		"key" = mobkey,			// the mob's key
		"vmessage" = pick(M.speak_emote), // the message to display if the voice wasn't understood
		"vname" = M.voice_name, // the name to display if the voice wasn't understood
		"vmask" = voicemask,	// 1 if the mob is using a voice gas mas

		"compression" = 0, // uncompressed radio signal
		"message" = message, // the actual sent message
		"connection" = connection, // the radio connection to use
		"radio" = src, // stores the radio used for transmission
		"slow" = 0,
		"traffic" = 0,
		"type" = 0,
		"server" = null,
		"reject" = 0,
		"level" = position.z,
		"channel_tag" = "#unkn",
		"channel_color" = channel_color_presets["Menacing Maroon"],
		"language" = speaking,
		"verb" = verb
	)
	signal.frequency = connection.frequency // Quick frequency set
	var/obj/item/cell/has_cell = get_cell()
	if(has_cell && has_cell.percent() < 20)
		signal.data["compression"] = max(0, 80 - has_cell.percent()*3)
	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)

	sleep(rand(10,25)) // wait a little...

	if(signal.data["done"] && (position.z in signal.data["level"]))
		// we're done here.
		return 1

	// Oh my god; the comms are down or something because the signal hasn't been broadcasted yet in our level.
	// Send a mundane broadcast with limited targets:

	//THIS IS TEMPORARY. YEAH RIGHT
	if(!connection)	return 0	//~Carn
	return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
					  src, message, displayname, jobname, real_name, M.voice_name,
					  filter_type, signal.data["compression"], GetConnectedZlevels(position.z), connection.frequency, verb, speaking,
					  "[connection.frequency]", channel_color_presets["Menacing Maroon"])


/obj/item/device/radio/hear_talk(mob/M as mob, msg, var/verb = "says", var/datum/language/speaking = null)

	if (broadcasting)
		if(get_dist(src, M) <= canhear_range)
			talk_into(M, msg,null,verb,speaking)


/obj/item/device/radio/proc/receive_range(freq, level)
	// check if this radio can receive on the given frequency, and if so,
	// what the range is in which mobs will hear the radio
	// returns: -1 if can't receive, range otherwise
	if (!wires)
		return -1
	if (wires.IsIndexCut(WIRE_RECEIVE))
		return -1
	if(!listening)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(!position || !(position.z in level))
			return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -1
	if (!on)
		return -1
	if (!freq) //recieved on main frequency
		if (!listening)
			return -1
	else
		var/accept = (freq==frequency && listening)
		if (!accept)
			for (var/ch_name in channels)
				var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
				if (RF && RF.frequency==freq && (channels[ch_name]&FREQ_LISTENING))
					accept = 1
					break
		if (!accept)
			return -1
	return canhear_range

/obj/item/device/radio/proc/send_hear(freq, level)

	var/range = receive_range(freq, level)
	if(range > -1)
		return get_mobs_or_objects_in_view(canhear_range, src)


/obj/item/device/radio/examine(mob/user, distance)
	. = ..()
	if (distance <= 1 || loc == user)
		if (b_stat)
			to_chat(user, "<span class='notice'>\The [src] can be attached and modified!</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] can not be modified or attached!</span>")
		if (power_usage && cell)
			to_chat(user, "<span class='notice'>\The [src] charge meter reads [round(cell.percent(), 0.1)]%.</span>")

/obj/item/device/radio/attackby(obj/item/W as obj, mob/user as mob)
	..()
	user.set_machine(src)
	if(isScrewdriver(W))
		b_stat = !b_stat
		if (b_stat)
			user.show_message("<span class='notice'>\The [src] can now be attached and modified!</span>")
		else
			user.show_message("<span class='notice'>\The [src] can no longer be modified or attached!</span>")
		updateDialog()
		return
	if(!cell && power_usage && istype(W, /obj/item/cell/device) && user.unEquip(W, target = src))
		to_chat(user, "<span class='notice'>You put [W] in \the [src].</span>")
		cell = W
		return

/obj/item/device/radio/emp_act(severity)
	broadcasting = prob(50)
	listening = prob(50)
	for (var/ch_name in channels)
		channels[ch_name] = prob(50)
	if(cell)
		cell.emp_act(severity)
	..()

/obj/item/device/radio/proc/recalculateChannels()
	return

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/device/radio/borg
	var/mob/living/silicon/robot/myborg = null // Cyborg which owns this radio. Used for power checks
	var/obj/item/device/encryptionkey/keyslot = null//Borg radios can handle a single encryption key
	var/shut_up = 1
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	subspace_transmission = 1
	cell = null
	power_usage = 0

/obj/item/device/radio/borg/ert
	keyslot = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/borg/syndicate
	keyslot = /obj/item/device/encryptionkey/syndicate

/obj/item/device/radio/borg/New(var/mob/living/silicon/robot/loc)
	if(!istype(loc))
		CRASH("Invalid spawn location: [log_info_line(loc)]")
	..()
	if(keyslot)
		keyslot = new keyslot(src)
	myborg = loc

/obj/item/device/radio/borg/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/device/radio/born/LateInitialize()
	. = ..()
	recalculateChannels()

/obj/item/device/radio/borg/Destroy()
	QDEL_NULL(keyslot)
	myborg = null
	return ..()

/obj/item/device/radio/borg/list_channels(var/mob/user)
	return list_secure_channels(user)

/obj/item/device/radio/borg/talk_into()
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/device/radio/borg/attackby(obj/item/W as obj, mob/user as mob)
//	..()
	user.set_machine(src)
	if (!( isScrewdriver(W) || (istype(W, /obj/item/device/encryptionkey/ ))))
		return

	if(isScrewdriver(W))
		if(keyslot)
			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null

			if(keyslot)
				keyslot.dropInto(user.loc)

			recalculateChannels()
			to_chat(user, "You pop out the encryption key in the radio!")

		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(W, /obj/item/device/encryptionkey))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			if(!user.unEquip(W, src))
				return
			keyslot = W

		recalculateChannels()

/obj/item/device/radio/borg/recalculateChannels()
	src.channels = list()
	src.syndie = 0

	var/mob/living/silicon/robot/D = src.loc
	if(istype(D.module))
		for(var/ch_name in D.module.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += D.module.channels[ch_name]
	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += keyslot.channels[ch_name]

		if(keyslot.syndie)
			src.syndie = 1

	for (var/ch_name in src.channels)
		if(!radio_controller)
			src.SetName("broken radio")
			return

		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

/obj/item/device/radio/borg/Topic(href, href_list)
	if(..())
		return 1
	if (href_list["mode"])
		var/enable_subspace_transmission = text2num(href_list["mode"])
		if(enable_subspace_transmission != subspace_transmission)
			subspace_transmission = !subspace_transmission
			if(subspace_transmission)
				to_chat(usr, "<span class='notice'>Subspace Transmission is enabled</span>")
			else
				to_chat(usr, "<span class='notice'>Subspace Transmission is disabled</span>")

			if(subspace_transmission == 0)//Simple as fuck, clears the channel list to prevent talking/listening over them if subspace transmission is disabled
				channels = list()
			else
				recalculateChannels()
		. = 1
	if (href_list["shutup"]) // Toggle loudspeaker mode, AKA everyone around you hearing your radio.
		var/do_shut_up = text2num(href_list["shutup"])
		if(do_shut_up != shut_up)
			shut_up = !shut_up
			if(shut_up)
				canhear_range = 0
				to_chat(usr, "<span class='notice'>Loadspeaker disabled.</span>")
			else
				canhear_range = 3
				to_chat(usr, "<span class='notice'>Loadspeaker enabled.</span>")
		. = 1

	if(.)
		SSnano.update_uis(src)

/obj/item/device/radio/borg/interact(mob/user as mob)
	if(!on)
		return

	. = ..()

/obj/item/device/radio/borg/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["rawfreq"] = num2text(frequency)

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	if(syndie)
		data["useSyndMode"] = 1

	data["has_loudspeaker"] = 1
	data["loudspeaker"] = !shut_up
	data["has_subspace"] = 1
	data["subspace"] = subspace_transmission

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/radio/proc/config(op)
	if(radio_controller)
		for (var/ch_name in channels)
			radio_controller.remove_object(src, radiochannels[ch_name])
	secure_radio_connections = new
	channels = op
	if(radio_controller)
		for (var/ch_name in op)
			secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
	return

/obj/item/device/radio/map_preset
	var/preset_name
	var/use_common = FALSE
	channels = list()

/obj/item/device/radio/map_preset/Initialize()
	if (!preset_name)
		return ..()

	name = "[name] ([preset_name])"
	frequency = assign_away_freq(preset_name)
	channels += list(
		preset_name = 1,
		"Hailing" = 1
	)
	if (use_common)
		channels += list("Common" = 1)

	. = ..()

	internal_channels = list(
		num2text(frequency) = list(),
		num2text(HAIL_FREQ) = list(),
	)
	if (use_common)
		internal_channels += list(num2text(PUB_FREQ) = list())

/obj/item/device/radio/off
	listening = 0

/obj/item/device/radio/announcer
	invisibility = 101
	listening = 0
	canhear_range = 0
	anchored = TRUE
	simulated = FALSE
	power_usage = 0
	channels=list("Engineering" = 1, "Security" = 1, "Medical" = 1, "Command" = 1, "Common" = 1, "Science" = 1, "Supply" = 1, "Service" = 1, "Exploration" = 1)
	cell = null

/obj/item/device/radio/announcer/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	crash_with("attempt to delete a [src.type] detected, and prevented.")
	return QDEL_HINT_LETMELIVE

/obj/item/device/radio/announcer/Initialize()
	. = ..()
	forceMove(locate(1,1,GLOB.using_map.contact_levels.len ? GLOB.using_map.contact_levels[1] : 1))

/obj/item/device/radio/announcer/subspace
	subspace_transmission = 1

/obj/item/device/radio/phone
	broadcasting = 0
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	randpixel = 0
	listening = 1
	name = "phone"

/obj/item/device/radio/phone/medbay
	frequency = MED_I_FREQ

/obj/item/device/radio/phone/medbay/New()
	..()
	internal_channels = GLOB.default_medbay_channels.Copy()

/obj/item/device/radio/CouldUseTopic(var/mob/user)
	..()
	if(istype(user, /mob/living/carbon))
		playsound(src, "button", 10)

/obj/item/device/radio/intercept
	name = "bulky radio"
	desc = "A large radio fitted with several military-grade communication interception circuits."
	icon_state = "radio"
	intercept = 1
	w_class = ITEM_SIZE_NORMAL


//The exosuit  radio subtype. It allows pilots to interact and consumes exosuit power

/obj/item/device/radio/exosuit
	name = "exosuit radio"
	cell = null
	intercom_handling = TRUE

/obj/item/device/radio/exosuit/get_cell()
	. = ..()
	if(!.)
		var/mob/living/exosuit/E = loc
		if(istype(E))
			return E.get_cell()

/obj/item/device/radio/exosuit/nano_host()
	var/mob/living/exosuit/E = loc
	if(istype(E))
		return E
	return null

/obj/item/device/radio/exosuit/attack_self(var/mob/user)
	var/mob/living/exosuit/exosuit = loc
	if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
		user.set_machine(src)
		interact(user)
	else
		to_chat(user, SPAN_WARNING("The radio is too damaged to function."))

/obj/item/device/radio/exosuit/CanUseTopic()
	. = ..()
	if(.)
		var/mob/living/exosuit/exosuit = loc
		if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
			return ..()

/obj/item/device/radio/exosuit/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, datum/nanoui/master_ui = null, var/datum/topic_state/state = GLOB.mech_state)
	. = ..()
