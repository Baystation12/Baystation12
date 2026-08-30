// Noise "language", for audible emotes.
/datum/language/noise
	name = "Noise"
	desc = "Noises."
	key = ""
	flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER
	hidden_from_codex = 1

/datum/language/noise/format_message(message, verb)
	return SPAN_CLASS("message", SPAN_CLASS("[colour]", "[message]"))

/datum/language/noise/format_message_plain(message, verb)
	return message

/datum/language/noise/format_message_radio(message, verb)
	return SPAN_CLASS("[colour]", "[message]")

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, -1) == "!") ? 4 : 2

/datum/language/sign
	name = LANGUAGE_SIGN
	desc = "A constructed sign language created by a conference hosted by an international federation of the Deaf in 2232, \
			adopted by the then newly established Sol Central Government as the standard language for official sign interpretations."
	signlang_verb = list("signs")
	colour = "say_quote"
	key = "s"
	flags = SIGNLANG | NO_STUTTER | NONVERBAL
	shorthand = "ZASL"
