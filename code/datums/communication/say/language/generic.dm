/decl/language/noise
	name = "Noise"
	desc = "Noises"
	key = ""
	property_flags = (LANG_PROPERTY_RESTRICTED|LANG_PROPERTY_NONGLOBAL|LANG_PROPERTY_INNATE)

/decl/language/sign
	name = "Sign Language"
	shorthand = "HS"
	desc = "A sign language commonly used for those who are deaf or mute."
	key = "s"
	speech_verbs = ("gestures")
	exclamation_verbs = list("gestures wildly", "gestures fiercely")
	whisper_verbs = list("discretely gestures")
	component_flags = LANG_COMPONENT_VISIBLE
	distance_modifier = -3

/decl/language/common
	name = "Common"
	ask_verbs = list("asks")
	exclamation_verbs = list("shouts")
	speech_verbs = list("says")
	whisper_verbs = list("whispers")