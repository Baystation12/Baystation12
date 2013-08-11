/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language" // Fluff name of language if any.
	var/speech_verb = "says"         // 'says', 'hisses', 'farts'.
	var/colour = "say_quote"         // CSS style to use for strings in this language.
	var/key = "x"                    // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                    // Various language flags.
	var/native                       // If set, non-native speakers will have trouble speaking.

/datum/language/unathi
	name = "Sinta'unathi"
	speech_verb = "hisses"
	colour = "soghun"
	key = "o"
	native = "Unathi"
	flags = RESTRICTED

/datum/language/tajaran
	name = "Siik'tjar"
	speech_verb = "mrowls"
	colour = "tajaran"
	key = "j"
	native = "Tajaran"
	flags = RESTRICTED

/datum/language/skrell
	name = "Skrellian"
	speech_verb = "warbles"
	colour = "skrell"
	key = "k"
	native = "Skrell"
	flags = RESTRICTED

/datum/language/vox
	name = "Vox-pidgin"
	speech_verb = "shrieks"
	colour = "vox"
	key = "v"
	native = "Vox"
	flags = RESTRICTED

/datum/language/human
	name = "Sol Common"
	key = "1"
	native = "Human"
	flags = RESTRICTED

//Pidgin languages, imperfectly speakable by people not a member of the core species.

/datum/language/unathi/common
	name = "Common Unathi"
	flags = WHITELISTED

/datum/language/tajaran/common
	name = "Siik'mas"
	flags = WHITELISTED

/datum/language/skrell/common
	name = "Common Skrell"
	flags = WHITELISTED

/datum/language/human/common
	name = "Common Human"
	flags = WHITELISTED

// Galactic common languages (systemwide accepted standards).

/datum/language/trader
	name = "Tradeband"
	key = "tra"

/datum/language/gutter
	name = "Gutter"
	key = "gut"

// Language handling.
/mob/proc/add_language(var/language)

	for(var/datum/language/L in languages)
		if(L && L.name == language)
			return 0

	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language,/datum/language))
		return 0

	languages += new_language
	return 1

/mob/proc/remove_language(var/rem_language)

	for(var/datum/language/L in languages)
		if(L && L.name == rem_language)
			languages -= L
			return 1

	return 0