/mob/proc/hear_say(message, verb = "says", datum/language/language, alt_name, italics, mob/speaker, sound/speech_sound, sound_vol)
	if (!client)
		return

	var/is_ghost = isghost(src)
	var/in_view = (speaker in view(src))

	if (is_ghost)
		if (!in_view && !speaker?.client)
			return

	var/pressure = 0
	var/turf/turf = get_turf(src)

	if (turf)
		var/datum/gas_mixture/air = turf.return_air()
		if (air)
			pressure = air.return_pressure()

	var/distance = get_dist(speaker, turf)

	if (pressure < ONE_ATMOSPHERE * 0.5)
		if (pressure < SOUND_MINIMUM_PRESSURE)
			if (distance > 1 && !is_ghost)
				return
			speech_sound = null
		else
			sound_vol *= 0.5
		italics = TRUE

	var/non_verbal = language?.flags & (NONVERBAL | SIGNLANG)
	var/do_stars

	var/display_name = "Unknown"
	if (ishuman(speaker))
		var/mob/living/carbon/human/human = speaker
		display_name = human.GetVoice()
	else if (speaker)
		display_name = speaker.name

	if (non_verbal)
		if (!speaker || (sdisabilities & BLINDED) || blinded || !in_view)
			do_stars = TRUE
		speech_sound = null
	else if (is_deaf() || get_sound_volume_multiplier() < 0.2)
		if (!(language?.flags & INNATE))
			if (speaker == src)
				to_chat(src, SPAN_WARNING("You cannot hear yourself speak!"))
			else if (!is_blind())
				to_chat(src, {"<span class="name">[display_name]</span>[alt_name] says something you cannot hear."})
			return
		speech_sound = null

	if (speech_sound && in_view)
		var/turf/sound_turf = speaker ? get_turf(speaker) : turf
		if (sound_turf)
			playsound_local(sound_turf, speech_sound, sound_vol, TRUE)

	var/display_message = message

	if (!(language?.flags & INNATE) && !say_understands(speaker, language))
		if (!istype(speaker, /mob/living/simple_animal))
			if (language)
				display_message = language.scramble(display_message, languages)
			else
				do_stars = TRUE

	if (do_stars)
		display_message = stars(display_message)

	if ((sleeping || stat == UNCONSCIOUS) && !non_verbal)
		hear_sleep(display_message)
		return

	if (italics)
		display_message = "<i>[display_message]</i>"

	var/display_controls
	if (is_ghost)
		if (display_name != speaker.real_name && speaker.real_name)
			display_name = "[speaker.real_name] ([display_name])"
		if (in_view && get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
			display_message = "<b>[display_message]</b>"
		var/control_preference = get_preference_value(/datum/client_preference/ghost_follow_link_length)
		switch (control_preference)
			if (GLOB.PREF_SHORT)
				display_controls = "([ghost_follow_link(speaker, src)])"
			if (GLOB.PREF_LONG)
				display_controls = "([ghost_follow_link(speaker, src, short_links = FALSE)])"

	var/accent_tag = ""
	if (speaker.accent)
		var/decl/accent/accent = decls_repository.get_decl(speaker.accent)
		if (accent)
			accent_tag = accent.GetTag(client)

	var/display_verb = verb
	if (!language)
		display_message = {"[display_verb], <span class="message"><span class="body">"[display_message]"</span></span>"}
	else
		var/hint_preference = get_preference_value(/datum/client_preference/language_display)
		if (is_ghost)
			if (hint_preference != GLOB.PREF_OFF)
				if (get_preference_value(/datum/client_preference/ghost_language_hide) == GLOB.PREF_YES)
					hint_preference = GLOB.PREF_OFF
		else if (say_understands(speaker, language) && isliving(src))
			var/mob/living/living = src
			if (living.default_language == language)
				hint_preference = GLOB.PREF_OFF
		switch (hint_preference)
			if (GLOB.PREF_FULL)
				display_verb = "[verb] in [language.name]"
			if (GLOB.PREF_SHORTHAND)
				display_verb = "[verb] ([language.shorthand])"
		display_message = language.format_message(display_message, display_verb)

	on_hear_say({"[accent_tag] <span class="game say">[display_controls]<span class="name">[display_name]</span>[alt_name] [display_message]</span>"})


/mob/proc/on_hear_say(var/message)
	to_chat(src, message)

/mob/living/silicon/on_hear_say(var/message)
	var/time = say_timestamp()
	to_chat(src, "[time] [message]")

/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")

	if(!client)
		return

	if(sleeping || stat==1) //If unconscious or sleeping
		hear_sleep(message)
		return

	var/track = null

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLINDED || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!(language && (language.flags & INNATE))) // skip understanding checks for INNATE languages
		if(!say_understands(speaker,language))
			if(istype(speaker,/mob/living/simple_animal))
				var/mob/living/M = speaker
				var/datum/say_list/S = M.say_list
				if(S && S.speak && S.speak.len)
					message = pick(S.speak)
				else
					return
			else
				if(language)
					message = language.scramble(message, languages)
				else
					message = stars(message)

		if(hard_to_hear)
			if(hard_to_hear <= 5)
				message = stars(message)
			else // Used for compression
				message = RadioChat(null, message, 80, 1+(hard_to_hear/10))

	var/speaker_name = vname ? vname : speaker.name

	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(hard_to_hear)
		speaker_name = "unknown"

	var/changed_voice

	if(istype(src, /mob/living/silicon/ai) && !hard_to_hear)
		var/jobname // the mob's "job"
		var/mob/living/carbon/human/impersonating //The crew member being impersonated, if any.

		if (ishuman(speaker))
			var/mob/living/carbon/human/H = speaker

			if(H.wear_mask && istype(H.wear_mask,/obj/item/clothing/mask/chameleon/voice))
				changed_voice = 1
				var/list/impersonated = new()
				var/mob/living/carbon/human/I = impersonated[speaker_name]

				if(!I)
					for(var/mob/living/carbon/human/M in SSmobs.mob_list)
						if(M.real_name == speaker_name)
							I = M
							impersonated[speaker_name] = I
							break

				// If I's display name is currently different from the voice name and using an agent ID then don't impersonate
				// as this would allow the AI to track I and realize the mismatch.
				if(I && !(I.name != speaker_name && I.wear_id && istype(I.wear_id,/obj/item/card/id/syndicate)))
					impersonating = I
					jobname = impersonating.get_assignment()
				else
					jobname = "Unknown"
			else
				jobname = H.get_assignment()

		else if (iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
		else if (isAI(speaker))
			jobname = "AI"
		else if (isrobot(speaker))
			jobname = "Robot"
		else if (istype(speaker, /mob/living/silicon/pai))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		if(changed_voice)
			if(impersonating)
				track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[impersonating]'>[speaker_name] ([jobname])</a>"
			else
				track = "[speaker_name] ([jobname])"
		else
			track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(isghost(src))
		if(speaker) //speaker is null when the arrivals annoucement plays
			if(speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
				speaker_name = "[speaker.real_name] ([speaker_name])"
			track = "([ghost_follow_link(speaker, src)]) [speaker_name]"
		else
			track = "[speaker_name]"

	var/formatted
	if (language)
		var/nverb = verb
		if (say_understands(speaker, language))
			var/skip = FALSE
			if (isliving(src))
				var/mob/living/L = src
				skip = L.default_language == language
			if (!skip)
				switch(src.get_preference_value(/datum/client_preference/language_display))
					if (GLOB.PREF_FULL)
						nverb = "[verb] in [language.name]"
					if(GLOB.PREF_SHORTHAND)
						nverb = "[verb] ([language.shorthand])"
					if(GLOB.PREF_OFF)
						nverb = verb
		formatted = language.format_message_radio(message, nverb)
	else
		formatted = "[verb], <span class=\"body\">\"[message]\"</span>"
	if(sdisabilities & DEAFENED || ear_deaf)
		var/mob/living/carbon/human/H = src
		if(istype(H) && H.has_headset_in_ears() && prob(20))
			to_chat(src, SPAN_WARNING("You feel your headset vibrate but can hear nothing from it!"))
	else
		on_hear_radio(part_a, speaker_name, track, part_b, part_c, formatted)

/proc/say_timestamp()
	return "<span class='say_quote'>\[[stationtime2text()]\]</span>"

/mob/proc/on_hear_radio(part_a, speaker_name, track, part_b, part_c, formatted)
	to_chat(src, "[part_a][speaker_name][part_b][formatted][part_c]")

/mob/observer/ghost/on_hear_radio(part_a, speaker_name, track, part_b, part_c, formatted)
	to_chat(src, "[part_a][track][part_b][formatted][part_c]")

/mob/living/silicon/on_hear_radio(part_a, speaker_name, track, part_b, part_c, formatted)
	var/time = say_timestamp()
	to_chat(src, "[time][part_a][speaker_name][part_b][formatted][part_c]")

/mob/living/silicon/ai/on_hear_radio(part_a, speaker_name, track, part_b, part_c, formatted)
	var/time = say_timestamp()
	to_chat(src, "[time][part_a][track][part_b][formatted][part_c]")

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/datum/language/language, var/mob/speaker = null)
	if(!client)
		return

	if(sleeping || stat == UNCONSCIOUS)
		return 0

	if(say_understands(speaker, language))
		var/nverb = null
		switch(src.get_preference_value(/datum/client_preference/language_display))
			if(GLOB.PREF_FULL) // Full language name
				nverb = "[verb] in [language.name]"
			if(GLOB.PREF_SHORTHAND) //Shorthand codes
				nverb = "[verb] ([language.shorthand])"
			if(GLOB.PREF_OFF)//Regular output
				nverb = verb
		message = "<B>[speaker]</B> [nverb], \"[message]\""
	else
		var/adverb
		var/length = length(message) * pick(0.8, 0.9, 1.0, 1.1, 1.2)	//Inserts a little fuzziness.
		switch(length)
			if(0 to 12) 	adverb = " briefly"
			if(12 to 30)	adverb = " a short message"
			if(30 to 48)	adverb = " a message"
			if(48 to 90)	adverb = " a lengthy message"
			else        	adverb = " a very lengthy message"
		message = "<B>[speaker]</B> [verb][adverb]."

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

/mob/proc/hear_sleep(var/message)
	if (is_deaf())
		return
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext_char(heardword,1, 1) in punctuation)
			heardword = copytext_char(heardword,2)
		if(copytext_char(heardword,-1) in punctuation)
			heardword = copytext_char(heardword,1,length(heardword))
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	to_chat(src, heard)
