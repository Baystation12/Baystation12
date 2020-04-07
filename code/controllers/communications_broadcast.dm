
/datum/radio_frequency/proc/broadcast_radio_chat(var/datum/signal/signal, var/list/radios = list(), var/list/radios_out_of_range = list(), var/list/radios_garbled = list(), var/list/radios_encrypted = list())

	var/mob/M = signal.data["mob"]

  /* ###### Prepare the radio connection ###### */

	var/list/receive = get_mobs_in_radio_ranges(radios)

  /* ###### Organize the receivers into categories for displaying the message ###### */

  	// Understood the message:
	var/list/heard_normal = list()			// normal message
	var/list/heard_nocipher = list()		//an unencrypted message where ciphers dont match

	// Did not understand the message:
	var/list/heard_voice 		= list()	// voice message (ie "chimpers")
	var/list/heard_garbled		= list()	// garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_out_of_range	= list()	// completely screwed over message (ie "F%! (O*# *#!<>&**%!")
	var/list/heard_encrypted	= list()	// dont have the encryption cipher for this signal

	for (var/mob/R in receive)

	  /* --- Loop through the receivers and categorize them --- */
		if(istype(R, /mob/new_player)) // we don't want new players to hear messages. rare but generates runtimes.
			continue

		// Ghosts hearing all radio chat don't want to hear syndicate intercepts, they're duplicates
		if(isghost(R) && !R.is_preference_enabled(/datum/client_preference/ghost_radio))
			continue

		// --- Can understand the speech ---
		if (R.say_understands(M, signal.data["language"]))

			// - Human and not wearing voice mask -
			var/obj/item/device/radio/radio = receive[R]
			if(signal.data["cipher"] && !radio.has_cipher(signal.data["cipher"]))
				heard_nocipher += R
			else
				heard_normal += R

		// --- Can't understand the speech ---

		else
			if(!signal.data["language"])
				var/error_text = "RADIO ERROR: radio message \'[signal.data["message"]]\' \
					from client (usr:[usr] | \
					usr.type:[usr ? usr.type : "null type"] | \
					usr.key:[usr ? usr.key : "null key"]) \
					via radio ([signal.data["radio"]]| [signal.data["radio"].type]) has null language"
				log_debug(error_text)
				message_admins(error_text)

			// - The speaker has a prespecified "voice message" to display if not understood -
			heard_voice += R

	//get mobs hearing radio signals that are interfered with somehow
	//we can assume there is no overlap with the other radios
	heard_garbled = get_mobs_in_radio_ranges(radios_garbled, 1)
	heard_out_of_range = get_mobs_in_radio_ranges(radios_out_of_range, 1)
	heard_encrypted = get_mobs_in_radio_ranges(radios_encrypted, 1)

  /* ###### Begin formatting and sending the message ###### */

	if (length(heard_normal) || length(heard_nocipher) || length(heard_voice) || length(heard_garbled) || length(heard_out_of_range))

	  /* --- Some miscellaneous variables to send to the mob --- */
		var/message = signal.data["message"]
		var/rank_text = "[signal.data["job"]]"
		var/datum/channel_cipher/cipher = signal.data["cipher"]
		var/channel_text
		var/chat_span_class
		if(cipher)
			channel_text = cipher.channel_name
			chat_span_class = cipher.chat_span_class
		else
			channel_text = "[signal.frequency]"
			chat_span_class = "radio"

		// --- Filter the message; place it in quotes apply a verb ---

		var/verbage = signal.data["speaking_verb"]
		var/speaking = signal.data["language"]

	 /* ###### Send the message ###### */


		/* --- Process all the mobs that heard the voice normally (understood) --- */

		if (length(heard_normal))
			for (var/mob/R in heard_normal)
				R.hear_radio(message, verbage, speaking, rank_text, channel_text, chat_span_class, signal.data["mob"], 0, signal.data["name"], heard_normal[R])

		/* --- Process all the mobs that heard the voice normally (understood) but do not have the cipher to provide formatting --- */

		if (length(heard_nocipher))
			for (var/mob/R in heard_nocipher)
				R.hear_radio(message, verbage, speaking, null, "[signal.frequency]", "radio", signal.data["mob"], 0, signal.data["name"], heard_normal[R])

		/* --- Process all the mobs that heard the voice normally (did not understand) --- */

		if (length(heard_voice))
			for (var/mob/R in heard_voice)
				R.hear_radio(message, verbage, speaking, rank_text, channel_text, chat_span_class, signal.data["mob"], 0, signal.data["vname"], heard_voice[R])

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")

		if (length(heard_garbled))
			for (var/mob/R in heard_garbled)
				R.hear_radio(message, verbage, speaking, rank_text, channel_text, chat_span_class, signal.data["mob"], 100, "Unknown", heard_garbled[R])


		/* --- There will be some distortion but some of the message is understandable --- */

		if (length(heard_out_of_range))
			for (var/mob/R in heard_out_of_range)
				R.hear_radio(message, verbage, speaking, null, channel_text, chat_span_class, signal.data["mob"], 15, "Unknown", heard_out_of_range[R])

		if (length(heard_encrypted))
			for (var/mob/R in heard_encrypted)
				to_chat(R, "<span class='radio'><span class='prefix'>\[[signal.frequency]\]</span><span class='name'>(encrypted)</span>*****_*****_*****_*****</span>")
	return 1
