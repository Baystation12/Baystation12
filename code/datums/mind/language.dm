/datum/mind
	var/list/languages
	var/datum/language/default_language


/datum/mind/proc/add_language(datum/language/language)
	if (!istype(language))
		language = all_languages[language]
	if(!istype(language) || (language in languages))
		return FALSE

	languages += language
	return TRUE


/datum/mind/proc/remove_language(datum/language/language)
	if (!istype(language))
		language = all_languages[language]
	if (!istype(language) || !(language in languages))
		return FALSE

	languages -= language
	if (language == default_language)
		set_default_language()
	return TRUE


/datum/mind/proc/clear_languages()
	languages.Cut()
	default_language = null


/datum/mind/proc/apply_languages_to_mob()
	if (current)
		current.languages = languages.Copy()
		current.default_language = default_language


/datum/mind/proc/apply_languages_from_mob()
	if (current)
		languages = current.languages.Copy()
		default_language = current.default_language


/datum/mind/proc/set_default_language(datum/language/language, force)
	if (!language)
		if (languages.len)
			default_language = languages[1]
		else
			default_language = null
		return

	if (!istype(language))
		language = all_languages[language]
	if (!istype(language))
		return

	if (language in languages)
		default_language = language
	else if (force)
		add_language(language)
		default_language = language
