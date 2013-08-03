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