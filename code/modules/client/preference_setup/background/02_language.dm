#define MAX_LANGUAGES 3

/datum/preferences
	var/list/alternate_languages

/datum/category_item/player_setup_item/background/languages
	name = "Languages"
	sort_order = 2
	var/list/allowed_languages
	var/list/free_languages

/datum/category_item/player_setup_item/background/languages/load_character(var/savefile/S)
	from_file(S["language"], pref.alternate_languages)

/datum/category_item/player_setup_item/background/languages/save_character(var/savefile/S)
	to_file(S["language"],   pref.alternate_languages)

/datum/category_item/player_setup_item/background/languages/sanitize_character()
	if(!islist(pref.alternate_languages))
		pref.alternate_languages = list()
	sanitize_alt_languages()

/datum/category_item/player_setup_item/background/languages/content()
	. = list()
	. += "<b>Languages</b><br>"
	var/list/show_langs = get_language_text()
	if(LAZYLEN(show_langs))
		for(var/lang in show_langs)
			. += lang
	else
		. += "Your current species, faction or home system selection does not allow you to choose additional languages.<br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/languages/OnTopic(var/href,var/list/href_list, var/mob/user)

	if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		pref.alternate_languages.Cut(index, index+1)
		return TOPIC_REFRESH

	else if(href_list["add_language"])

		if(pref.alternate_languages.len >= MAX_LANGUAGES)
			alert(user, "You have already selected the maximum number of languages!")
			return

		sanitize_alt_languages()
		var/list/available_languages = allowed_languages - free_languages
		if(!LAZYLEN(available_languages))
			alert(user, "There are no additional languages available to select.")
		else
			var/new_lang = input(user, "Select an additional language", "Character Generation", null) as null|anything in available_languages
			if(new_lang)
				pref.alternate_languages |= new_lang
				return TOPIC_REFRESH
	. = ..()

/datum/category_item/player_setup_item/background/languages/proc/rebuild_language_cache(var/mob/user)

	allowed_languages = list()
	free_languages = list()

	if(!user)
		return

	for(var/thing in pref.cultural_info)
		var/decl/cultural_info/culture = SSculture.get_culture(pref.cultural_info[thing])
		if(istype(culture))
			var/list/langs = culture.get_spoken_languages()
			if(LAZYLEN(langs))
				for(var/checklang in langs)
					free_languages[checklang] =    TRUE
					allowed_languages[checklang] = TRUE
			if(LAZYLEN(culture.secondary_langs))
				for(var/checklang in culture.secondary_langs)
					allowed_languages[checklang] = TRUE

	for(var/thing in all_languages)
		var/datum/language/lang = all_languages[thing]
		if(user.has_admin_rights() || (!(lang.flags & RESTRICTED) && (lang.flags & WHITELISTED) && is_alien_whitelisted(user, lang)))
			allowed_languages[thing] = TRUE

/datum/category_item/player_setup_item/background/languages/proc/is_allowed_language(var/mob/user, var/datum/language/lang)
	if(isnull(allowed_languages) || isnull(free_languages))
		rebuild_language_cache(user)
	if(!user || ((lang.flags & RESTRICTED) && is_alien_whitelisted(user, lang)))
		return TRUE
	return allowed_languages[lang.name]

/datum/category_item/player_setup_item/background/languages/proc/sanitize_alt_languages()
	if(!istype(pref.alternate_languages))
		pref.alternate_languages = list()
	var/preference_mob = preference_mob()
	rebuild_language_cache(preference_mob)
	for(var/L in pref.alternate_languages)
		var/datum/language/lang = all_languages[L]
		if(!lang || !is_allowed_language(preference_mob, lang))
			pref.alternate_languages -= L
	if(LAZYLEN(free_languages))
		for(var/lang in free_languages)
			pref.alternate_languages -= lang
			pref.alternate_languages.Insert(1, lang)

	pref.alternate_languages = uniquelist(pref.alternate_languages)
	if(pref.alternate_languages.len > MAX_LANGUAGES)
		pref.alternate_languages.Cut(MAX_LANGUAGES + 1)

/datum/category_item/player_setup_item/background/languages/proc/get_language_text()
	sanitize_alt_languages()
	if(LAZYLEN(pref.alternate_languages))
		for(var/i = 1 to pref.alternate_languages.len)
			var/lang = pref.alternate_languages[i]
			if(free_languages[lang])
				LAZYADD(., "- [lang] (required).<br>")
			else
				LAZYADD(., "- [lang] <a href='?src=\ref[src];remove_language=[i]'>Remove.</a> <span style='color:#ff0000;font-style:italic;'>[all_languages[lang].warning]</span><br>")
	if(pref.alternate_languages.len < MAX_LANGUAGES)
		var/remaining_langs = MAX_LANGUAGES - pref.alternate_languages.len
		LAZYADD(., "- <a href='?src=\ref[src];add_language=1'>add</a> ([remaining_langs] remaining)<br>")

#undef MAX_LANGUAGES