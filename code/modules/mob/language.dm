/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "name"   // Fluff name of language if any.
	var/speech_verb     // 'says', 'hisses', 'farts'.
	var/colour          // CSS style to use for strings in this language.
	var/key             // Character used to speak in language eg. :o for Unathi.

/datum/language/unathi
	name = "Sinta'unathi"
	speech_verb = "hisses"
	colour = "soghun"
	key = "o"

/datum/language/tajaran
	name = "Siik'mas"
	speech_verb = "mrowls"
	colour = "tajaran"
	key = "j"

/datum/language/skrell
	name = "Skrellian"
	speech_verb = "warbles"
	colour = "skrell"
	key = "k"

/datum/language/vox
	name = "Vox-pidgin"
	speech_verb = "shrieks"
	colour = "vox"
	key = "v"


// Language handling.
/mob/proc/add_language(var/language)

	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language,/datum/language))
		return

	for(var/datum/language/L in languages)
		if(L && L.name == new_language)
			return 0

	languages += new_language
	return 1

/mob/proc/remove_language(var/rem_language)

	for(var/datum/language/L in languages)
		if(L && L.name == rem_language)
			languages -= L
			return 1

	return 0