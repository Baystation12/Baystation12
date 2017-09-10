var/list/department_radio_keys = list(
	  ":r" = "right ear",	".r" = "right ear",
	  ":l" = "left ear",	".l" = "left ear",
	  ":i" = "intercom",	".i" = "intercom",
	  ":h" = "department",	".h" = "department",
	  ":+" = "special",		".+" = "special", //activate radio-specific special functions
	  ":c" = "Command",		".c" = "Command",
	  ":n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", ".e" = "Engineering",
	  ":s" = "Security",	".s" = "Security",
	  ":w" = "whisper",		".w" = "whisper",
	  ":t" = "Mercenary",	".t" = "Mercenary",
	  ":x" = "Raider",		".x" = "Raider",
	  ":u" = "Supply",		".u" = "Supply",
	  ":v" = "Service",		".v" = "Service",
	  ":p" = "AI Private",	".p" = "AI Private",
	  ":z" = "Entertainment",".z" = "Entertainment",
	  ":y" = "Utility",		".y" = "Utility",

	  ":R" = "right ear",	".R" = "right ear",
	  ":L" = "left ear",	".L" = "left ear",
	  ":I" = "intercom",	".I" = "intercom",
	  ":H" = "department",	".H" = "department",
	  ":C" = "Command",		".C" = "Command",
	  ":N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	".S" = "Security",
	  ":W" = "whisper",		".W" = "whisper",
	  ":T" = "Mercenary",	".T" = "Mercenary",
	  ":X" = "Raider",		".X" = "Raider",
	  ":U" = "Supply",		".U" = "Supply",
	  ":V" = "Service",		".V" = "Service",
	  ":P" = "AI Private",	".P" = "AI Private",
	  ":Z" = "Entertainment",".Z" = "Entertainment",
	  ":Y" = "Utility",		".Y" = "Utility",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":ê" = "right ear",	".ê" = "right ear",
	  ":ä" = "left ear",	".ä" = "left ear",
	  ":ø" = "intercom",	".ø" = "intercom",
	  ":ð" = "department",	".ð" = "department",
	  ":ñ" = "Command",		".ñ" = "Command",
	  ":ò" = "Science",		".ò" = "Science",
	  ":ü" = "Medical",		".ü" = "Medical",
	  ":ó" = "Engineering",	".ó" = "Engineering",
	  ":û" = "Security",	".û" = "Security",
	  ":ö" = "whisper",		".ö" = "whisper",
	  ":å" = "Mercenary",	".å" = "Mercenary",
	  ":é" = "Supply",		".é" = "Supply",
)


var/list/channel_to_radio_key = new
proc/get_radio_key_from_channel(var/channel)
	var/key = channel_to_radio_key[channel]
	if(!key)
		for(var/radio_key in department_radio_keys)
			if(department_radio_keys[radio_key] == channel)
				key = radio_key
				break
		if(!key)
			key = ""
		channel_to_radio_key[channel] = key

	return key

/mob/living/proc/binarycheck()

	if (istype(src, /mob/living/silicon/pai))
		return

	if (!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if (H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear,/obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/get_default_language()
	return default_language

/mob/proc/is_muzzled()
	return 0

//Takes a list of the form list(message, verb, whispering) and modifies it as needed
//Returns 1 if a speech problem was applied, 0 otherwise
/mob/living/proc/handle_speech_problems(var/list/message_data)
	var/message = message_data[1]
	var/verb = message_data[2]

	. = 0

	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("yells","roars","hollers")
		message_data[3] = 0
		. = 1
	if(slurring)
		message = slur(message)
		verb = pick("slobbers","slurs")
		. = 1
	if(stuttering)
		message = stutter(message)
		verb = pick("stammers","stutters")
		. = 1

	message_data[1] = message
	message_data[2] = verb

/mob/living/proc/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(message_mode == "intercom")
		for(var/obj/item/device/radio/intercom/I in view(1, null))
			I.talk_into(src, message, verb, speaking)
			used_radios += I
	return 0

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending=="!")
		return pick("exclaims","shouts","yells")
	if(ending=="?")
		return "asks"
	return verb

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (Muted).</span>")
			return

	if(stat)
		if(stat == 2)
			return say_dead(message)
		return

	var/message_mode = parse_message_mode(message, "headset")

	switch(copytext(message,1,2))
		if("*") return emote(copytext(message,2))
		if("^") return custom_emote(1, copytext(message,2))

	//parse the radio code and consume it
	if (message_mode)
		if (message_mode == "headset")
			message = copytext(message,2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext(message,3)

	message = trim_left(message)

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
		if(speaking)
			message = copytext(message,2+length(speaking.key))
		else
			speaking = get_default_language()

	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(speaking && (speaking.flags & HIVEMIND))
		speaking.broadcast(src,trim(message))
		return 1

	verb = say_quote(message, speaking)

	if(is_muzzled())
		to_chat(src, "<span class='danger'>You're muzzled and cannot speak!</span>")
		return

	message = trim_left(message)

	message = handle_autohiss(message, speaking)

	if(!(speaking && (speaking.flags & NO_STUTTER)))
		var/list/message_data = list(message, verb, 0)
		if(handle_speech_problems(message_data))
			message = message_data[1]
			verb = message_data[2]

	if(!message || message == "")
		return 0

	var/list/obj/item/used_radios = new
	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name))
		return 1

	var/list/handle_v = handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2]

	var/italics = 0
	var/message_range = world.view

	//speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		var/msg
		if(!speaking || !(speaking.flags & NO_TALK_MSG))
			msg = "<span class='notice'>\The [src] talks into \the [used_radios[1]]</span>"
		for(var/mob/living/M in hearers(5, src))
			if((M != src) && msg)
				M.show_message(msg)
			if (speech_sound)
				sound_vol *= 0.5

	var/list/listening = list()
	var/list/listening_obj = list()
	var/turf/T = get_turf(src)

	//handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & NONVERBAL)
			if (prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & SIGNLANG)
			log_say("[name]/[key] : SIGN: [message]")
			return say_signlang(message, pick(speaking.signlang_verb), speaking)

	if(T)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		get_mobs_and_objs_in_view_fast(T, message_range, listening, listening_obj, /datum/client_preference/ghost_ears)


	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	spawn(30) qdel(speech_bubble)

	for(var/mob/M in listening)
		if(M)
			M << speech_bubble
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)

	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	log_say("[name]/[key] : [message]")
	return 1

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
