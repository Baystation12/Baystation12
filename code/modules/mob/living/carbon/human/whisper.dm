//Lallander was here
/mob/living/carbon/human/whisper(message as text)
	message = sanitize(message, encode = 0)

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot whisper (muted)."))
			return

	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return

	if(get_id_name("Unknown") == GetVoice())
		SetName(get_id_name("Unknown"))

	whisper_say(message)


//This is used by both the whisper verb and human/say() to handle whispering
/mob/living/carbon/human/proc/whisper_say(message, datum/language/speaking = null, alt_name="", verb="whispers")
	say(message, speaking, verb, alt_name, whispering = 1)
