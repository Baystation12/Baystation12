// Noise "language", for audible emotes.
/datum/language/noise
	name = "Noise"
	desc = "Noises."
	key = ""
	flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER
	hidden_from_codex = 1

/datum/language/noise/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/datum/language/noise/format_message_plain(message, verb)
	return message

/datum/language/noise/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, -1) == "!") ? 4 : 2

/datum/language/sign
	name = LANGUAGE_SIGN
	desc = "A sign language commonly used for those who are deaf or mute."
	signlang_verb = list("gestures")
	colour = "say_quote"
	key = "s"
	flags = SIGNLANG | NO_STUTTER | NONVERBAL
	shorthand = "HS"