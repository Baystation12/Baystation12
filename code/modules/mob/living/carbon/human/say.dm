/mob/living/carbon/human/say(var/message, var/datum/language/speaking = null, whispering)
	if(name != GetVoice())
		if(get_id_name("Unknown") == GetVoice())
			SetName(get_id_name("Unknown"))

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
		if (speaking)
			message = copytext(message, 2+length(speaking.key))
		else
			speaking = get_any_good_language(set_default=TRUE)
			if (!speaking)
				to_chat(src, SPAN_WARNING("You don't know a language and cannot speak."))
				emote("custom", AUDIBLE_MESSAGE, "[pick("grunts", "babbles", "gibbers", "jabbers", "burbles")] aimlessly.")
				return

	if(has_chem_effect(CE_VOICELOSS, 1))
		whispering = TRUE

	message = sanitize(message)
	var/obj/item/organ/internal/voicebox/vox = locate() in internal_organs
	var/snowflake_speak = (speaking && (speaking.flags & (NONVERBAL|SIGNLANG))) || (vox && vox.is_usable() && vox.assists_languages[speaking])
	if(!isSynthetic() && need_breathe() && failed_last_breath && !snowflake_speak)
		var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species.breathing_organ]
		if(!L || L.breath_fail_ratio > 0.9)
			if(L && world.time < L.last_successful_breath + 2 MINUTES) //if we're in grace suffocation period, give it up for last words
				to_chat(src, "<span class='warning'>You use your remaining air to say something!</span>")
				L.last_successful_breath = world.time - 2 MINUTES
				return ..(message, speaking = speaking)

			to_chat(src, "<span class='warning'>You don't have enough air[L ? " in [L]" : ""] to make a sound!</span>")
			return
		else if(L.breath_fail_ratio > 0.7)
			whisper_say(length(message) > 5 ? stars(message) : message, speaking)
		else if(L.breath_fail_ratio > 0.4 && length(message) > 10)
			whisper_say(message, speaking)
	else
		return ..(message, speaking = speaking, whispering = whispering)


/mob/living/carbon/human/proc/forcesay(list/append)
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//case sensitive means
				var/main_key = get_prefix_key(/decl/prefix/radio_main_channel)
				temp = replacetext(temp, main_key, "")	//general radio

				var/channel_key = get_prefix_key(/decl/prefix/radio_channel_selection)
				if(findtext(trim_left(temp), channel_key, 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), channel_key, 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)

				var/custom_emote_key = get_prefix_key(/decl/prefix/custom_emote)
				if(findtext(temp, custom_emote_key, 1, 2))	//emotes
					return
				temp = copytext(trim_left(temp), 1, rand(5,8))

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=[null]")

/mob/living/carbon/human/say_understands(var/mob/other,var/datum/language/speaking = null)

	if(has_brain_worms()) //Brain worms translate everything. Even mice and alien speak.
		return 1

	if(species.can_understand(other))
		return 1

	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (istype(other, /mob/living/carbon/alien/diona))
			if(other.languages.len >= 2) //They've sucked down some blood and can speak common now.
				return 1
		if (istype(other, /mob/living/silicon))
			return 1
		if (istype(other, /mob/living/carbon/brain))
			return 1
		if (istype(other, /mob/living/carbon/slime))
			return 1

	//This is already covered by mob/say_understands()
	//if (istype(other, /mob/living/simple_animal))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()

/mob/living/carbon/human/GetVoice()

	var/voice_sub
	if(istype(back,/obj/item/rig))
		var/obj/item/rig/rig = back
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice)
			voice_sub = rig.speech.voice_holder.voice

	if(!voice_sub)

		var/list/check_gear = list(wear_mask, head)
		if(wearing_rig)
			var/datum/extension/armor/rig/armor_datum = get_extension(wearing_rig, /datum/extension/armor)
			if(istype(armor_datum) && armor_datum.sealed && wearing_rig.helmet == head)
				check_gear |= wearing_rig

		for(var/obj/item/gear in check_gear)
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice)
				voice_sub = changer.voice

	if(voice_sub)
		return voice_sub
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	return real_name

/mob/living/carbon/human/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "говорит" //INF, WAS var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending == "!")
			verb = pick("восклицает","выкрикивает") //INF, WAS verb=pick("exclaims","shouts","yells")
		else if(ending == "?")
			verb = "спрашивает" //INF, WAS verb="asks
	return verb

/mob/living/carbon/human/handle_speech_problems(var/list/message_data)
	if(silent || (sdisabilities & MUTED))
		message_data[1] = ""
		. = 1

	else if(istype(wear_mask, /obj/item/clothing/mask))
		var/obj/item/clothing/mask/M = wear_mask
		if(M.voicechange)
			message_data[1] = pick(M.say_messages)
			message_data[2] = pick(M.say_verbs)
			. = 1

	else
		. = ..(message_data)

/mob/living/carbon/human/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	switch(message_mode)
		if("intercom")
			if(!src.restrained())
				for(var/obj/item/device/radio/I in view(1))
					if(I.intercom_handling)
						I.talk_into(src, message, null, verb, speaking)
						I.add_fingerprint(src)
						used_radios += I
		if("headset")
			if(l_ear && istype(l_ear,/obj/item/device/radio))
				var/obj/item/device/radio/R = l_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += l_ear
			else if(r_ear && istype(r_ear,/obj/item/device/radio))
				var/obj/item/device/radio/R = r_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += r_ear
		if("right ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(r_ear && istype(r_ear,/obj/item/device/radio))
				R = r_ear
				has_radio = 1
			if(r_hand && istype(r_hand, /obj/item/device/radio))
				R = r_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R
		if("left ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(l_ear && istype(l_ear,/obj/item/device/radio))
				R = l_ear
				has_radio = 1
			if(l_hand && istype(l_hand,/obj/item/device/radio))
				R = l_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R
		if("whisper") //It's going to get sanitized again immediately, so decode.
			whisper_say(html_decode(message), speaking, alt_name)
			return 1
		else
			if(message_mode)
				if(l_ear && istype(l_ear,/obj/item/device/radio))
					l_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += l_ear
				else if(r_ear && istype(r_ear,/obj/item/device/radio))
					r_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += r_ear

/mob/living/carbon/human/handle_speech_sound()
	if(species.name == SPECIES_HUMAN) // infinity. needed for gender check
		species.speech_sounds = GLOB.human_clearing_throat[gender]
	if(species.speech_sounds && prob(species.speech_chance))
		var/list/returns[2]
		returns[1] = sound(pick(species.speech_sounds))
		returns[2] = 50
		return returns
	return ..()

/mob/living/carbon/human/can_speak(datum/language/speaking)
	if(species && speaking && (speaking.name in species.assisted_langs))
		for(var/obj/item/organ/internal/voicebox/I in src.internal_organs)
			if(I.is_usable() && I.assists_languages[speaking])
				return TRUE
		return FALSE
	. = ..()

/mob/living/carbon/human/parse_language(var/message)
	var/prefix = copytext(message,1,2)
	if(length(message) >= 1 && prefix == get_prefix_key(/decl/prefix/audible_emote))
		return all_languages["Noise"]

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = lowertext(copytext(message, 2 ,3))
		var/datum/language/L = language_keys[language_prefix]
		if (can_speak(L))
			return L

	return null
