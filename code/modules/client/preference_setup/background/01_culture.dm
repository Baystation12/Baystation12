#define GET_ALLOWED_VALUES(write_to, check_key) \
	var/datum/species/S = all_species[pref.species]; \
	if(!S) { \
		write_to = list(); \
	} else if(S.force_cultural_info[check_key]) { \
		write_to = list(S.force_cultural_info[check_key] = TRUE); \
	} else { \
		write_to = list(); \
		for(var/cul in S.available_cultural_info[check_key]) { \
			write_to[cul] = TRUE; \
		} \
	}

/datum/preferences
	var/list/cultural_info = list()

/datum/category_item/player_setup_item/background/culture
	name = "Culture"
	sort_order = 1
	var/list/hidden
	var/list/tokens = ALL_CULTURAL_TAGS

/datum/category_item/player_setup_item/background/culture/New()
	hidden = list()
	for(var/token in tokens)
		hidden[token] = TRUE
	..()

/datum/category_item/player_setup_item/background/culture/sanitize_character()
	if(!islist(pref.cultural_info))
		pref.cultural_info = list()
	for(var/token in tokens)
		var/list/_cultures
		GET_ALLOWED_VALUES(_cultures, token)
		if(!LAZYLEN(_cultures))
			pref.cultural_info[token] = GLOB.using_map.default_cultural_info[token]
		else
			var/current_value = pref.cultural_info[token]
			if(!current_value|| !_cultures[current_value])
				pref.cultural_info[token] = _cultures[1]

/datum/category_item/player_setup_item/background/culture/load_character(var/savefile/S)
	for(var/token in tokens)
		var/load_val
		from_file(S[token], load_val)
		pref.cultural_info[token] = load_val

/datum/category_item/player_setup_item/background/culture/save_character(var/savefile/S)
	for(var/token in tokens)
		to_file(S[token], pref.cultural_info[token])

/datum/category_item/player_setup_item/background/culture/content()
	. = list()
	for(var/token in tokens)
		var/decl/cultural_info/culture = SSculture.get_culture(pref.cultural_info[token])
		var/title = "<b>[tokens[token]]<a href='?src=\ref[src];set_[token]=1'><small>?</small></a>:</b><a href='?src=\ref[src];set_[token]=2'>[pref.cultural_info[token]]</a>"
		var/append_text = "<a href='?src=\ref[src];toggle_verbose_[token]=1'>[hidden[token] ? "Expand" : "Collapse"]</a>"
		. += culture.get_description(title, append_text, verbose = !hidden[token])
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/culture/OnTopic(var/href,var/list/href_list, var/mob/user)

	for(var/token in tokens)

		if(href_list["toggle_verbose_[token]"])
			hidden[token] = !hidden[token]
			return TOPIC_REFRESH

		var/check_href = text2num(href_list["set_[token]"])
		if(check_href > 0)

			var/list/valid_values
			if(check_href == 1)
				valid_values = SSculture.get_all_entries_tagged_with(token)
			else
				GET_ALLOWED_VALUES(valid_values, token)

			var/choice = input("Please select an entry.") as null|anything in valid_values
			if(!choice)
				return

			// Check if anything changed between now and then.
			if(check_href == 1)
				valid_values = SSculture.get_all_entries_tagged_with(token)
			else
				GET_ALLOWED_VALUES(valid_values, token)

			if(valid_values[choice])
				var/decl/cultural_info/culture = SSculture.get_culture(choice)
				if(check_href == 1)
					show_browser(user, culture.get_description(), "window=[token];size=700x400")
				else
					pref.cultural_info[token] = choice
				return TOPIC_REFRESH
	. = ..()

#undef GET_ALLOWED_VALUES