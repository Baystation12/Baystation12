/datum/category_item/player_setup_item/player_global/ooc
	name = "OOC"
	sort_order = 5

/datum/category_item/player_setup_item/player_global/ooc/load_preferences(var/savefile/S)
	S["ignored_players"]	>> pref.ignored_players


/datum/category_item/player_setup_item/player_global/ooc/save_preferences(var/savefile/S)
	S["ignored_players"]	<< pref.ignored_players


/datum/category_item/player_setup_item/player_global/ooc/sanitize_preferences()
	if(isnull(pref.ignored_players))
		pref.ignored_players = list()

/datum/category_item/player_setup_item/player_global/ooc/content(var/mob/user)
	. += "<b>OOC:</b><br>"
	. += "Ignored Players<br>"
	for(var/ignored_player in pref.ignored_players)
		. += "[ignored_player] (<a href='?src=\ref[src];unignore_player=[ignored_player]'>Unignore</a>)<br>"
	. += "(<a href='?src=\ref[src];ignore_player=1'>Ignore Player</a>)"

/datum/category_item/player_setup_item/player_global/ooc/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["unignore_player"])
		if(CanUseTopic(user))
			pref.ignored_players -= href_list["unignore_player"]
			return TOPIC_REFRESH

	if(href_list["ignore_player"])
		if(CanUseTopic(user))
			var/player_to_ignore = input(user, "Who do you want to ignore?","Ignore") as null|text
			if(player_to_ignore)
				player_to_ignore = sanitize(ckey(player_to_ignore))
				pref.ignored_players |= player_to_ignore
			return TOPIC_REFRESH

	return ..()
