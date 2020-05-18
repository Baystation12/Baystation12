//Lallander was here
/mob/living/carbon/human/whisper(message as text)
	message = sanitize(message, encode = 0)

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot whisper (muted).</span>")
			return

	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return

	if(get_id_name("Unknown") == GetVoice())
		SetName(get_id_name("Unknown"))

	whisper_say(message)


//This is used by both the whisper verb and human/say() to handle whispering
/mob/living/carbon/human/proc/whisper_say(var/message, var/datum/language/speaking = null, var/alt_name="", var/verb="whispers")
	say(message, speaking, verb, alt_name, whispering = 1)