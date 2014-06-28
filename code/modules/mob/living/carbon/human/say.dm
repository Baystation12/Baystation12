/mob/living/carbon/human/say(var/message)
	var/verb = "says"
	var/alt_name = ""
	var/message_range = world.view
	var/italics = 0

	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (Muted)."
			return

	message =  trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(stat == 2)
		return say_dead(message)

	if (istype(wear_mask, /obj/item/clothing/mask/muzzle))  //Todo:  Add this to speech_problem_flag checks.
		return

	if(copytext(message,1,2) == "*")
		return emote(copytext(message,2))

	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"
	
	//parse the radio code and consume it
	var/message_mode = parse_message_mode(message, "headset")
	if (message_mode)
		if (message_mode == "headset")
			message = copytext(message,2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext(message,3)
	
	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if (speaking)
		verb = speaking.speech_verb
		message = copytext(message,3)
	
	message = capitalize(trim(message))

	if(speech_problem_flag)
		var/list/handle_r = handle_speech_problems(message)
		message = handle_r[1]
		verb = handle_r[2]
		speech_problem_flag = handle_r[3]

	if(!message || stat)
		return

	if (!speaking)
		var/ending = copytext(message, length(message))
		if(ending=="!")
			verb=pick("exclaims","shouts","yells")
		if(ending=="?")
			verb="asks"

	var/list/obj/item/used_radios = new

	switch (message_mode)
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

		if("intercom")
			for(var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, message, verb, speaking)
				used_radios += I
		if("whisper")
			whisper_say(message, speaking, alt_name)
			return
		if("binary")
			if(robot_talk_understand || binarycheck())
				robot_talk(message)
			return
		if("changeling")
			if(mind && mind.changeling)
				for(var/mob/Changeling in mob_list)
					if((Changeling.mind && Changeling.mind.changeling) || istype(Changeling, /mob/dead/observer))
						Changeling << "<i><font color=#800080><b>[mind.changeling.changelingID]:</b> [message]</font></i>"
			return
		else
			if(message_mode)
				if(message_mode in (radiochannels | "department"))
					if(l_ear && istype(l_ear,/obj/item/device/radio))
						l_ear.talk_into(src,message, message_mode, verb, speaking)
						used_radios += l_ear
					else if(r_ear && istype(r_ear,/obj/item/device/radio))
						r_ear.talk_into(src,message, message_mode, verb, speaking)
						used_radios += r_ear
	
	var/sound/speech_sound
	var/sound_vol
	if((species.name == "Vox" || species.name == "Vox Armalis") && prob(20))
		speech_sound = sound('sound/voice/shriek1.ogg')
		sound_vol = 50
	
	..(message, speaking, verb, alt_name, italics, message_range, used_radios, speech_sound, sound_vol)	//ohgod we should really be passing a datum here.

/mob/living/carbon/human/say_understands(var/mob/other,var/datum/language/speaking = null)

	if(has_brain_worms()) //Brain worms translate everything. Even mice and alien speak.
		return 1

	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (istype(other, /mob/living/carbon/monkey/diona))
			if(other.languages.len >= 2)			//They've sucked down some blood and can speak common now.
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
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = src.wear_mask
		if(V.vchange)
			return V.voice
		else
			return name
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice


/* 
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/living/carbon/human/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))
	if(ending=="!")
		verb=pick("exclaims","shouts","yells")
	else if(ending=="?")
		verb="asks"

	return verb

	


/mob/living/carbon/human/proc/handle_speech_problems(var/message)
	var/list/returns[3]
	var/verb = "says"
	var/handled = 0
	if(silent)
		message = ""
		handled = 1
	if(sdisabilities & MUTE)
		message = ""
		handled = 1
	if(wear_mask)
		if(istype(wear_mask, /obj/item/clothing/mask/horsehead))
			var/obj/item/clothing/mask/horsehead/hoers = wear_mask
			if(hoers.voicechange)
				if(mind && mind.changeling && department_radio_keys[copytext(message, 1, 3)] != "changeling")
					message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
					verb = pick("whinnies","neighs", "says")
					handled = 1

	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("yells","roars","hollers")
		handled = 1
	if(slurring)
		message = slur(message)
		verb = pick("stammers","stutters")
		handled = 1

	var/braindam = getBrainLoss()
	if(braindam >= 60)
		handled = 1
		if(prob(braindam/4))
			message = stutter(message)
			verb = pick("stammers", "stutters")
		if(prob(braindam))
			message = uppertext(message)
			verb = pick("yells like an idiot","says rather loudly")

	returns[1] = message
	returns[2] = verb
	returns[3] = handled

	return returns
