var/global/list/department_radio_keys = list(
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
	  ":y" = "Exploration",		".y" = "Exploration",
	  ":o" = "Response Team",".o" = "Response Team", //ERT
	  ":j" = "Hailing", ".j" = "Hailing",

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
	  ":Y" = "Exploration",		".Y" = "Exploration",
	  ":O" = "Response Team", ".O" = "Response Team",
	  ":J" = "Hailing", ".J" = "Hailing",

	  //kinda localization -- Sweden_Moose
	  ":к" = "right ear",	".к" = "right ear",
	  ":д" = "left ear",	".д" = "left ear",
	  ":ш" = "intercom",	".ш" = "intercom",
	  ":р" = "department",	".р" = "department",
	  ":+" = "special",		".+" = "special", //activate radio-specific special functions
	  ":с" = "Command",		".с" = "Command",
	  ":т" = "Science",		".т" = "Science",
	  ":ь" = "Medical",		".ь" = "Medical",
	  ":у" = "Engineering", ".у" = "Engineering",
	  ":ы" = "Security",	".ы" = "Security",
	  ":ц" = "whisper",		".ц" = "whisper",
	  ":е" = "Mercenary",	".е" = "Mercenary",
	  ":ч" = "Raider",		".ч" = "Raider",
	  ":г" = "Supply",		".г" = "Supply",
	  ":м" = "Service",		".м" = "Service",
	  ":з" = "AI Private",	".з" = "AI Private",
	  ":я" = "Entertainment",".я" = "Entertainment",
	  ":н" = "Exploration",		".н" = "Exploration",
	  ":щ" = "Response Team",".щ" = "Response Team", //ERT
	  ":о" = "Hailing", ".о" = "Hailing",

	  ":К" = "right ear",	".К" = "right ear",
	  ":Д" = "left ear",	".Д" = "left ear",
	  ":Ш" = "intercom",	".Ш" = "intercom",
	  ":Р" = "department",	".Р" = "department",
	  ":С" = "Command",		".С" = "Command",
	  ":Т" = "Science",		".Т" = "Science",
	  ":Ь" = "Medical",		".Ь" = "Medical",
	  ":У" = "Engineering",	".У" = "Engineering",
	  ":Ы" = "Security",	".Ы" = "Security",
	  ":Ц" = "whisper",		".Ц" = "whisper",
	  ":Е" = "Mercenary",	".Е" = "Mercenary",
	  ":Ч" = "Raider",		".Ч" = "Raider",
	  ":Г" = "Supply",		".Г" = "Supply",
	  ":М" = "Service",		".М" = "Service",
	  ":З" = "AI Private",	".З" = "AI Private",
	  ":Я" = "Entertainment",".Я" = "Entertainment",
	  ":Н" = "Exploration",		".Н" = "Exploration",
	  ":Щ" = "Response Team", ".Щ" = "Response Team",
	  ":О" = "Hailing", ".О" = "Hailing"
)


var/global/list/channel_to_radio_key = new
/proc/get_radio_key_from_channel(var/channel)
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
	return istype(wear_mask, /obj/item/clothing/mask/muzzle)

//Takes a list of the form list(message, verb, whispering) and modifies it as needed
//Returns 1 if a speech problem was applied, 0 otherwise
/mob/living/proc/handle_speech_problems(var/list/message_data)
	var/message = message_data[1]
	var/verb = message_data[2]

	. = 0

	if((MUTATION_HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("кричит","вопит") //INF, WAS verb = pick("yells","roars","hollers")
		message_data[3] = 0
		. = 1
	else if(slurring)
		message = slur(message)
		verb = "заплетается" //INF, WAS verb = pick("slobbers","slurs")
		. = 1
	else if(stuttering)
		message = NewStutter(message)
		verb = pick("бормочет","заикается") //INF, WAS verb = pick("stammers","stutters")
		. = 1
	else if(has_chem_effect(CE_SQUEAKY, 1))
		message = "<font face = 'Comic Sans MS'>[message]</font>"
		verb = "скрипит"  //INF, WAS verb = "squeaks"
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
		return pick("восклицает","выкрикивает") //INF, WAS return pick("exclaims","shouts","yells")
	if(ending=="?")
		return "спрашивает" //INF, WAS return "asks"
	return verb

/mob/living/proc/format_say_message(var/message = null)
	if(!message)
		return

	message = html_decode(message)

	var/end_char = copytext_char(message, length_char(message), length_char(message) + 1) // INF Localiztion
	if(!(end_char in list(".", "?", "!", "-", "~", ":")))
		message += "."

	message = html_encode(message)
	return message

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", whispering)
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (Muted).</span>")
			return

	if(stat)
		if(stat == 2)
			return say_dead(message)
		return

	var/prefix = copytext_char(message, 1, 2)
	if(prefix == get_prefix_key(/decl/prefix/custom_emote))
		return emote(copytext_char(message, 2))
	if(prefix == get_prefix_key(/decl/prefix/visible_emote))
		return custom_emote(1, copytext_char(message, 2))

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
		if(speaking)
			message = copytext_char(message, 2 + length_char(speaking.key))
		else
			speaking = get_default_language()

	//parse the radio code and consume it
	var/message_mode = parse_message_mode(message, "headset")
	if (message_mode)
		if (message_mode == "headset")
			message = copytext_char(message,2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext_char(message,3)

	message = trim_left(message)

	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(speaking && (speaking.flags & HIVEMIND))
		speaking.broadcast(src,trim(message))
		return 1

	if((is_muzzled()) && !(speaking && (speaking.flags & SIGNLANG)))
		to_chat(src, "<span class='danger'>You're muzzled and cannot speak!</span>")
		return

	if (speaking)
		if(whispering)
			verb = speaking.whisper_verb ? speaking.whisper_verb : speaking.speech_verb
		else
			verb = say_quote(message, speaking)
			if(verb == "кричит")
				message = copytext_char(message, 1, length(message))

	message = trim_left(message)
	message = handle_autohiss(message, speaking)
	message = format_say_message(message)
	message = process_chat_markup(message)

	if(speaking && !speaking.can_be_spoken_properly_by(src))
		message = speaking.muddle(message)

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

	if(whispering)
		italics = 1
		message_range = 1

	//speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		if(!speaking || !(speaking.flags & NO_TALK_MSG))
			src.visible_message(SPAN_NOTICE("\The [src] talks into \the [used_radios[1]]."), blind_message = SPAN_NOTICE("You hear someone talk into their headset."), range = 5, exclude_mobs = list(src))
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
	speech_bubble.layer = layer
	speech_bubble.plane = plane
	speech_bubble.alpha = 0
	// VOREStation Port - Attempt Multi-Z Talking
	// for (var/atom/movable/AM in get_above_oo())
	// 	var/turf/ST = get_turf(AM)
	// 	if(ST)
	// 		get_mobs_and_objs_in_view_fast(ST, world.view, listening, listening_obj, /datum/client_preference/ghost_ears)
	// 		var/image/z_speech_bubble = image('icons/mob/talk.dmi', AM, "h[speech_bubble_test]")
	// 		QDEL_IN(z_speech_bubble, 30)

	// VOREStation Port End

	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M)
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
			if(M.client)
				speech_bubble_recipients += M.client


	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	var/list/eavesdroppers = list()
	if(whispering)
		var/eavesdroping_range = 5
		var/list/eavesdroping = list()
		var/list/eavesdroping_obj = list()
		get_mobs_and_objs_in_view_fast(T, eavesdroping_range, eavesdroping, eavesdroping_obj)
		eavesdroping -= listening
		eavesdroping_obj -= listening_obj
		for(var/mob/M in eavesdroping)
			if(M)
				M.hear_say(stars(message), verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
				if(M.client)
					speech_bubble_recipients |= M.client
					eavesdroppers |= M.client

		for(var/obj/O in eavesdroping)
			spawn(0)
				if(O) //It's possible that it could be deleted in the meantime.
					O.hear_talk(src, stars(message), verb, speaking)

	INVOKE_ASYNC(GLOBAL_PROC, .proc/animate_speech_bubble, speech_bubble, speech_bubble_recipients | eavesdroppers, 30)
	INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, speaking, italics, speech_bubble_recipients)
	if(length(eavesdroppers))
		INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, stars(message), speaking, italics, eavesdroppers)

	if(whispering)
		log_whisper("[name]/[key] : [message]")
	else
		log_say("[name]/[key] : [message]")

	flick_overlay(speech_bubble, speech_bubble_recipients, 50)
	animate(speech_bubble, alpha = 255, time = 10, easing = CIRCULAR_EASING)
	animate(time = 20)
	animate(alpha = 0, pixel_y = 12, time = 20, easing = CIRCULAR_EASING)
	return 1


/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
