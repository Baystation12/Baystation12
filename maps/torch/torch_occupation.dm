/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["char_branch"])
		var/choice = input(user, "Choose your branch of service.", "Character Preference", pref.char_branch) as null|anything in BRANCHES_SCG
		if(choice && CanUseTopic(user))
			pref.char_branch = choice
			pref.char_rank = "Unset"
			return TOPIC_REFRESH

	else if(href_list["char_rank"])
		var/choice
		if(pref.char_branch == SCG_FLEET || pref.char_branch == SCG_EXPCORP)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in RANKS_SCG_FLEET
		else if(pref.char_branch == SCG_MARINE)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in RANKS_SCG_MARINE
		else if(pref.char_branch == SCG_CIVILIAN)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in RANKS_SCG_CIVILIAN

		if(choice && CanUseTopic(user))
			pref.char_rank = choice
			return TOPIC_REFRESH

	return ..()
