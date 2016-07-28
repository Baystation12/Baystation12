/atom
	var/list/languages = list()         // For speaking/listening.
	var/universal_speak = 0 // Set to 1 to enable the object to speak to everyone
	var/universal_understand = 0 // Set to 1 to enable the object to understand everyone

// Language handling.
/mob/proc/add_language(var/language)

	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language) || (new_language in languages))
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/remove_language(var/rem_language)
	var/datum/language/L = all_languages[rem_language]
	. = (L in languages)
	languages.Remove(L)

/mob/living/remove_language(rem_language)
	var/datum/language/L = all_languages[rem_language]
	if(default_language == L)
		default_language = null
	return ..()

/atom/proc/can_understand_language(var/datum/language/speaking)
	if(universal_understand)
		return 1

	if(speaking.flags & INNATE)
		return 1

	//Language check.
	for(var/datum/language/L in src.languages)
		if(speaking == L)
			return 1

	return 0

// Can we speak this language, as opposed to just understanding it?
/atom/proc/can_speak_language(datum/language/speaking)
	return universal_speak || (speaking && speaking.flags & INNATE)
