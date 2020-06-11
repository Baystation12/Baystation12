GLOBAL_LIST_EMPTY(all_radios)

/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "shortwave radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

	var/on = 1 // 0 for off
	//var/last_transmission
	var/frequency = PUB_FREQ //common chat
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/datum/wires/radio/wires = null
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	//var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	//var/subspace_transmission = 0
	var/syndie = 0//Holder to see if it's a syndicate encrypted radio
	var/radio_desc = ""
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL

	matter = list("glass" = 25,DEFAULT_WALL_MATERIAL = 75)
	//var/const/FREQ_LISTENING = 1
	//var/list/internal_channels

	var/datum/radio_frequency/radio_connection
	//var/list/datum/radio_frequency/secure_radio_connections = new

	var/list/ciphers_dongles = list()
	var/list/dongles_connections = list()
	var/list/hotkeys_dongles = list()
	var/list/channels_dongles = list()
	var/list/dongles = list()

	var/list/ui_channels = list()

	var/long_range = 0

/obj/item/device/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/device/radio/proc/create_channel_dongle(var/new_channel, var/no_redundant = 1)

	if(no_redundant && channels_dongles[new_channel])
		return 1

	var/obj/item/device/channel_dongle/dongle = new (src, new_channel)
	. = insert_dongle(null, dongle)
	if(!.)
		qdel(dongle)

/obj/item/device/radio/proc/insert_dongle(var/mob/user, var/obj/item/device/channel_dongle/dongle, update_ui = 1)

	if(!dongle.cipher)
		to_chat(user,"<span class='warning'>[dongle] is invalid, it cannot be installed in [src].</span>")
		return

	hotkeys_dongles[dongle.cipher.hotkey] = dongle
	ciphers_dongles[dongle.cipher] = dongle
	channels_dongles[dongle.cipher.channel_name] = dongle

	//start listening on this frequency
	if(dongle.listening)
		dongles_connections[dongle] = radio_controller.add_object(src, dongle.cipher.frequency,  RADIO_CHAT)
		//secure_radio_connections[dongle.channel_name] = radio_controller.add_object(src, dongle.frequency,  RADIO_CHAT)

	if(user)
		to_chat(user, "<span class='info'>You insert \icon[dongle] [dongle] into \icon[src] [src].</span>")
		user.drop_item()
	dongle.loc = src

	if(update_ui)
		update_ui_channels()
	return 1

/obj/item/device/radio/proc/remove_dongles(var/destroy_all = 0)
	. = 0
	for(var/datum/channel_cipher/cipher in ciphers_dongles)
		var/obj/item/device/channel_dongle/dongle = ciphers_dongles[cipher]
		radio_controller.remove_object(src, cipher.frequency)
		if(destroy_all)
			qdel(dongle)
		else
			dongle.loc = get_turf(src)
		. = 1

	ciphers_dongles = list()
	dongles_connections = list()
	hotkeys_dongles = list()
	channels_dongles = list()
	dongles = list()
	update_ui_channels()

/obj/item/device/radio/Destroy()
	QDEL_NULL(wires)
	GLOB.listening_objects -= src
	GLOB.all_radios -= src
	GLOB.emp_candidates -= src
	if(radio_controller)
		radio_controller.remove_object(src, frequency)

		remove_dongles(1)

	return ..()

/obj/item/device/radio/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/device/radio/LateInitialize()
	. = ..()
	wires = new(src)
	GLOB.listening_objects += src
	GLOB.all_radios.Add(src)
	GLOB.emp_candidates.Add(src)

	if(frequency < RADIO_LOW_FREQ || frequency > RADIO_HIGH_FREQ)
		frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
	set_frequency(frequency)

	//setup the preset channels
	for(var/dongle_type in dongles)
		dongles -= dongle_type
		insert_dongle(null, new dongle_type(src), 0)
	update_ui_channels()

	setupRadioDescription()

/obj/item/device/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/device/radio/interact(mob/user)
	if(!user)
		return 0

	if(b_stat)
		wires.Interact(user)

	return ui_interact(user)

/obj/item/device/radio/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["rawfreq"] = num2text(frequency)

	data["mic_cut"] = (wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))
	data["spk_cut"] = (wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

	data["chan_list"] = ui_channels
	data["chan_list_len"] = ui_channels.len

	if(syndie)
		data["useSyndMode"] = 1

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/radio/proc/update_ui_channels()
	ui_channels = list()
	for(var/datum/channel_cipher/cipher in ciphers_dongles)
		var/obj/item/device/channel_dongle/dongle = ciphers_dongles[cipher]
		ui_channels.Add(list(list("channel_name" = cipher.channel_name, "channel_freq" = "[cipher.frequency]", "listening" = dongle.listening, "chan_span" = cipher.chat_span_class)))

	//return list_internal_channels(user)

/mob/proc/has_internal_radio_channel_access(var/list/req_one_accesses)
	var/obj/item/weapon/card/id/I = GetIdCard()
	return has_access(list(), req_one_accesses, I ? I.GetAccess() : list())

/mob/observer/ghost/has_internal_radio_channel_access(var/list/req_one_accesses)
	return can_admin_interact()

/obj/item/device/radio/proc/text_wires()
	if (b_stat)
		return wires.GetInteractWindow()
	return

/*
/obj/item/device/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
			"}
			*/

/obj/item/device/radio/proc/ToggleBroadcast()
	broadcasting = !broadcasting && !(wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/device/radio/proc/ToggleReception()
	listening = !listening && !(wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/device/radio/CanUseTopic()
	if(!on)
		return STATUS_CLOSE
	return ..()

/obj/item/device/radio/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	if (href_list["track"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		. = 1
	else if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if ((new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		set_frequency(new_frequency)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				usr << browse(null, "window=radio")
		. = 1
	else if (href_list["talk"])
		ToggleBroadcast()
		. = 1
	else if (href_list["toggle_channel"])
		var/chan_name = href_list["toggle_channel"]
		if (!chan_name)
			ToggleReception()
		else
			var/obj/item/device/channel_dongle/dongle = channels_dongles[chan_name]
			dongle.listening = !dongle.listening
			if(dongle.listening)
				dongles_connections[dongle] = radio_controller.add_object(src, dongle.cipher.frequency,  RADIO_CHAT)
			else
				dongles_connections -= dongle
				radio_controller.remove_object(src, dongle.cipher.frequency,  RADIO_CHAT)
			update_ui_channels()
		. = 1
	/*else if(href_list["spec_freq"])
		var freq = href_list["spec_freq"]
		if(has_channel_access(usr, freq))
			set_frequency(text2num(freq))*/
		. = 1
	if(href_list["nowindow"]) // here for pAIs, maybe others will want it, idk
		return 1

	if(.)
		GLOB.nanomanager.update_uis(src)

/obj/item/device/radio/proc/autosay(var/message, var/from, var/channel, var/language_name)

	/*var/datum/channel_cipher/cipher = GLOB.channels_ciphers[channel]
	if(!cipher)
		return*/

	var/obj/item/device/channel_dongle/dongle = channels_dongles[channel]
	if(!dongle)
		return 0

	var/datum/radio_frequency/connection = dongles_connections[dongle]

	return autosay_connection(message, from, connection, language_name, dongle.cipher)

/obj/item/device/radio/proc/autosay_connection(var/message, var/from, var/datum/radio_frequency/connection, var/language_name, var/cipher)
	var/mob/living/silicon/ai/A = new /mob/living/silicon/ai(src, null, null, 1)
	A.fully_replace_character_name(from)
	post_signal(A, message, connection, "says", all_languages[language_name], cipher)
	A.loc = null
	qdel(A)

	return 1

/obj/item/device/radio/proc/autosay_freq(var/message, var/from, var/custom_freq, var/language_name)
	if(isnum(custom_freq))
		set_frequency(custom_freq)
		return autosay_connection(message, from, radio_connection, language_name)

/obj/item/device/radio/talk_into(mob/living/M as mob, message, var/hotkey, var/speaking_verb = "says", var/datum/language/speaking = null)
	if(!on)
		return 0 // the device has to be on

	if(!M || !message)
		return 0

	if(speaking && (speaking.flags & (NONVERBAL|SIGNLANG))) return 0

	if(istype(M)) M.trigger_aiming(TARGET_CAN_RADIO)

	if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return 0

	if(!radio_connection)
		set_frequency(frequency)

	/*
	See code/controller/communications.dm for the meat and potatoes of the radio code
	Quick summary:
	1. Mob works out what radio hotkey the player is using
	2. Radio grabs a corresponding radio key for the hotkey
	3. A radio chat signal is constructed for the matching radio key and sent to the frequency
	4. The frequency datum gets a list of hearing players (on the overmap), then sends the message to their chat logs
	*/

	//#### Grab the connection datum ####//
	var/datum/radio_frequency/connection// = secure_radio_connections[channel]

	//the dongle may be necessary to identify the connection
	var/obj/item/device/channel_dongle/active_dongle

	//mob code has already sent he chat message to the correct ear
	if(hotkey in list(HOTKEY_HEADSET, HOTKEY_RIGHTEAR, HOTKEY_LEFTEAR))
		//loop over radio connections and find the first active one
		for(var/obj/item/device/channel_dongle/dongle in dongles_connections)
			if(dongle.listening)
				active_dongle = dongle
				break
	else
		//hotkey for a specific radio channel, if it's active
		active_dongle = hotkeys_dongles[hotkey]
		if(active_dongle && !active_dongle.listening)
			active_dongle = null

	//are we trying to reach a connection via a specific dongle?
	if(active_dongle && active_dongle.listening)
		connection = dongles_connections[active_dongle]

	//if we don't have a valid cipher then grab the common radio
	if(!active_dongle && hotkey == HOTKEY_RADIO)
		connection = radio_connection

	//guess this isn't a valid hotkey
	if (!istype(connection))
		return 0

	post_signal(M, message, connection, speaking_verb, speaking, active_dongle ? active_dongle.cipher : null)

/obj/item/device/radio/proc/post_signal(mob/living/M as mob, message, var/datum/radio_frequency/connection, var/speaking_verb = "says", var/datum/language/speaking = null, var/datum/channel_cipher/cipher)
	//#### Tagging the signal with all appropriate identity values ####//

	// ||-- The mob's name identity --||
	var/displayname = M.real_name	// grab the display name (name you get when you hover over someone's icon)

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
		jobname = "Cyborg"

	// --- Personal AI (pAI) ---
	else if (istype(M, /mob/living/silicon/pai))
		jobname = "Personal AI"

	else if (istype(M, /mob/living/simple_animal/npc))
		var/mob/living/simple_animal/npc/npc = M
		jobname = npc.npc_job_title

	// --- Unidentifiable mob ---
	else
		jobname = "Unknown"

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new
	signal.transmission_method = 2 // 2 would be a subspace transmission.
								   // transmission_method could probably be enumerated through #define. Would be neater.

	// --- Finally, tag the actual signal with the appropriate values ---
	signal.data = list(
	  // Identity-associated tags:
		"mob" = M, // store a reference to the mob
		"name" = displayname,	// the mob's display name
		"job" = jobname,		// the mob's job
		"vmessage" = pick(M.speak_emote), // the message to display if the voice wasn't understood
		"vname" = M.voice_name, // the name to display if the voice wasn't understood

		// We store things that would otherwise be kept in the actual mob
		// so that they can be logged even AFTER the mob is deleted or something

	  // Other tags:
		"message" = message, // the actual sent message
		"connection" = connection, // the radio connection to use
		"radio" = src, // stores the radio used for transmission
		"language" = speaking,
		"speaking_verb" = speaking_verb,
		"long_range" = 0	//broadcast over a powerful system
	)
	signal.data["cipher"] = cipher
	signal.frequency = connection.frequency // Quick frequency set

	//#### Sending the signal to all subspace receivers ####//
	connection.post_signal(src, signal, RADIO_CHAT, long_range)

/obj/item/device/radio/hear_talk(mob/M as mob, msg, var/verb = "says", var/datum/language/speaking = null)

	if (broadcasting)
		if(get_dist(src, M) <= canhear_range)
			talk_into(M, msg,null,verb,speaking)

/*
/obj/item/device/radio/proc/accept_rad(obj/item/device/radio/R as obj, message)

	if ((R.frequency == frequency && message))
		return 1
	else if

	else
		return null
	return
*/

/obj/item/device/radio/proc/has_cipher(var/datum/channel_cipher/cipher)
	if(ciphers_dongles.Find(cipher))
		return 1

/obj/item/device/radio/proc/setupRadioDescription()
	var/list/keys_channels = list()
	for(var/datum/channel_cipher/cipher in ciphers_dongles)
		keys_channels += "[cipher.hotkey] - [cipher.channel_name]"
	radio_desc = list2text(keys_channels, ", ")

/obj/item/device/radio/examine(mob/user)
	. = ..()
	if ((in_range(src, user) || loc == user))
		if (b_stat)
			user.show_message("<span class='notice'>\The [src] can be attached and modified!</span>")
		else
			user.show_message("<span class='notice'>\The [src] can not be modified or attached!</span>")

	to_chat(user, "The following channels are available:")

	to_chat(user, radio_desc)

/obj/item/device/radio/attackby(obj/item/weapon/W as obj, mob/user as mob)
	. = ..()
	user.set_machine(src)
	if(istype(W, /obj/item/device/channel_dongle))
		insert_dongle(user, W)
		return

	if(istype(W, /obj/item/device/encryptionkey))
		to_chat(user, "<span class='warning'>[src] cannot accept [W] as they are obsolete with newer model radios and headsets. This device accepts channel dongles instead.</span>")
		return

	if (!( istype(W, /obj/item/weapon/screwdriver) ))
		return

	//remove any channel dongles from the radio
	if(remove_dongles())
		to_chat(user, "<span class='info'>You pop out the channel dongles out of the headset!</span>")

	//get the radio ready to modify the wires or attach it to an assembly
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/device/radio/beacon))
		if (b_stat)
			user.show_message("<span class='notice'>\The [src] can now be attached and modified!</span>")
		else
			user.show_message("<span class='notice'>\The [src] can no longer be modified or attached!</span>")
		updateDialog()
		add_fingerprint(user)

/obj/item/device/radio/emp_act(severity)

	var/image/I = image('icons/effects/effects.dmi', src, "empdisable")
	overlays += I
	show_image(src.loc, I)
	spawn(10)
		overlays -= I
		qdel(I)

	broadcasting = 0
	listening = 0
	for(var/obj/item/device/channel_dongle/dongle in dongles_connections)
		dongle.listening = 0
	. = ..()
/*
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
	*/

/obj/item/device/radio/off
	listening = 0

/obj/item/device/radio/phone
	broadcasting = 0
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	randpixel = 0
	listening = 1
	name = "phone"

/obj/item/device/radio/phone/medbay
	frequency = MED_I_FREQ

/obj/item/device/radio/CouldUseTopic(var/mob/user)
	..()
	if(istype(user, /mob/living/carbon))
		playsound(src, "button", 10)
