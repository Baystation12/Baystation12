/mob/living/carbon/slime/say(message)

	message = sanitize(message)

	var/verb = say_quote(message)

	if(copytext_char(message,1,2) == get_prefix_key(/singleton/prefix/custom_emote))
		return emote(copytext_char(message,2))

	return ..(message, null, verb)

/mob/living/carbon/slime/say_quote(text)
	var/ending = copytext(text, -1)

	if (ending == "?")
		return "asks";
	else if (ending == "!")
		return "cries";

	return "chirps";

/mob/living/carbon/slime/say_understands(other)
	if (istype(other, /mob/living/carbon/slime))
		return 1
	return ..()

/mob/living/carbon/slime/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol)
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(html_decode(message)))
	..()

/mob/living/carbon/slime/hear_radio(message, verb="says", datum/language/language=null, part_a, part_b, part_c, mob/speaker = null, hard_to_hear = 0, vname ="")
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(html_decode(message)))
	..()
