
/obj/machinery/overmap_comms/hub
	name = "telecommunications hub"
	icon = 'code/modules/halo/comms/machines/telecomms.dmi'
	icon_state = "hub"
	icon_state_active = "hub"
	icon_state_inactive = "hub_inactive"
	desc = "A machine for controlling a network of telecommunications machinery."
	var/list/frequencies_broadcast = list()
	var/list/frequencies_dongles = list()
	var/list/dongles_ui = list()
	var/list/frequencies_broadcast_ui = list()

/obj/machinery/overmap_comms/hub/added_to_network(var/datum/overmap_comms_network/network)
	frequencies_broadcast += network.saved_freqs
	frequencies_dongles += network.saved_freqs
	dongles_ui += network.virtual_dongles

	update_ui()

/obj/machinery/overmap_comms/hub/removed_from_network(var/datum/overmap_comms_network/network)
	frequencies_broadcast = list()
	frequencies_ciphers = list()
	dongles_ui = list()

	update_ui()

/obj/machinery/overmap_comms/hub/proc/update_ui()

	//if this is a fresh startup, do some extra processing
	//this is so roundstart tcomms does not require to be setup every time
	//but it also allows players to do a reset of the network to  get the settings back to default
	if(!frequencies_broadcast_ui.len)

		//enable broadcasting and link the cipher by default
		for(var/freq_text in frequencies_broadcast)
			frequencies_broadcast[freq_text] = 1
			var/datum/encryption_cipher/cipher = GLOB.freqs_ciphers[freq_text]
			if(my_network.all_ciphers.Find(cipher))
				frequencies_ciphers[freq_text] = cipher

	//now update the nanoui data for our frequency control settings
	frequencies_broadcast_ui = list()
	for(var/freq_text in frequencies_broadcast)
		var/obj/item/device/channel_dongle/dongle = frequencies_dongles[freq_text]
		var/channel_name
		var/cipher_id = "None"
		if(dongle)
			channel_name = dongle.channel_name
			if(dongle.cipher)
				cipher_id = "[dongle.cipher.id]"
		if(!channel_name)
			channel_name = "----"
		frequencies_broadcast_ui.Add(list(list("freq_text" = freq_text, "channel" = channel_name, "cipher" = cipher_id, "status" = frequencies_broadcast[freq_text])))

	//update the nanoui data for our cipher settings
	//the way this works is thanks to some funky way byond handles lists that lets me be lazy
	var/dongle_num = 1
	for(var/obj/item/device/channel_dongle/dongle in dongles_ui)

		//this cipher in datum format means its new and needs to be processed, so remove it first
		dongles_ui -= dongle

		//give this one a temporary name
		var/dongle_name = dongle.channel_name
		if(!dongle_name)
			dongle_name = "Unnamed channel ([dongle_num++])"
			//dongle.temp_name = dongle_name

		//index it in a human readable format on the list
		dongles_ui[dongle_name] = dongle

/obj/machinery/overmap_comms/hub/proc/allow_broadcast(var/datum/signal/signal)
	if(!active)
		return 1

	world << "/obj/machinery/overmap_comms/hub/proc/allow_broadcast(var/datum/signal/signal)"

	//grab the signal frequency
	var/datum/radio_frequency/connection = signal.data["connection"]

	//0 means do not broadcast
	//1 means broadcast everything
	//2 means broadcast known ciphers only
	. = frequencies_broadcast["[connection.frequency]"]

	world << "	connection.frequency:[connection.frequency]"
	world << "	frequencies_broadcast\[connection.frequency\]: [.]"

	/*if(. == 2)
		return my_network.has_known_cipher(signal)*/

/obj/machinery/overmap_comms/hub/attack_hand(var/mob/living/user)
	if(!istype(user,/mob/living))
		return

	ui_interact(user)

/obj/machinery/overmap_comms/hub/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/data[0]
	data["frequencies_broadcast"] = frequencies_broadcast_ui
	data["active"] = active

	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "overmapcomms_hub.tmpl", "Telecommunications Hub", 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/overmap_comms/hub/Topic(href, href_list)
	if(href_list["toggle_active"])
		//activate or deactivate this machine
		var/mob/user = locate(href_list["user"])

		toggle_active(user)
		. = 1

	if(href_list["set_freq"])
		//set whether the network is broadcasting signals on a frequency or not
		var/mob/user = locate(href_list["user"])

		var/freq_text = href_list["set_freq"]
		var/old_status = frequencies_broadcast[freq_text]
		if(old_status)
			frequencies_broadcast[freq_text] = 0
		else
			frequencies_broadcast[freq_text] = 1
		update_ui()
		to_chat(user,"<span class='info>You set frequency [freq_text] to [old_status ? "stop " : ""]broadcasting.</span>")
		. = 1

	if(href_list["set_cipher"])
		//link a cipher to a frequency
		var/mob/user = locate(href_list["user"])

		var/cipher_name = input(user, "Choose which encryption cipher you would like applied to signals on this frequency","Choose cipher","Cancel") in ciphers_ui + "Cancel"
		if(cipher_name != "Cancel")
			var/datum/encryption_cipher/cipher = ciphers_ui[cipher_name]
			var/freq_text = href_list["set_cipher"]
			frequencies_ciphers[freq_text] = cipher
			update_ui()
			to_chat(user,"<span class='info>You set the cipher [cipher.id] to apply to frequency [freq_text].</span>")
			. = 1

	if(.)
		GLOB.nanomanager.update_uis(src)