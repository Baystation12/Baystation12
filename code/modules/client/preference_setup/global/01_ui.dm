/datum/preferences
	var/clientfps = 60
	var/ooccolor = "#010000" //Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color

	var/chat_on_map = 1
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH

	var/UI_style = "Midnight"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255

/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(var/savefile/S)
	S["UI_style"]		>> pref.UI_style
	S["UI_style_color"]	>> pref.UI_style_color
	S["UI_style_alpha"]	>> pref.UI_style_alpha
	S["chat_on_map"]	>> pref.chat_on_map
	S["max_chat_length"]>> pref.max_chat_length
	S["ooccolor"]		>> pref.ooccolor
	S["clientfps"]		>> pref.clientfps

/datum/category_item/player_setup_item/player_global/ui/save_preferences(var/savefile/S)
	S["UI_style"]		<< pref.UI_style
	S["UI_style_color"]	<< pref.UI_style_color
	S["UI_style_alpha"]	<< pref.UI_style_alpha
	S["chat_on_map"]	<< pref.chat_on_map
	S["max_chat_length"]<< pref.max_chat_length
	S["ooccolor"]		<< pref.ooccolor
	S["clientfps"]		<< pref.clientfps

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style		= sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color	= sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha	= sanitize_integer(pref.UI_style_alpha, 0, 255, initial(pref.UI_style_alpha))
	pref.chat_on_map	= sanitize_integer(pref.chat_on_map, 0, 1, initial(pref.chat_on_map))
	pref.max_chat_length= sanitize_integer(pref.max_chat_length, 1, CHAT_MESSAGE_MAX_LENGTH, initial(pref.max_chat_length))
	pref.ooccolor		= sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	pref.clientfps	    = sanitize_integer(pref.clientfps, CLIENT_MIN_FPS, CLIENT_MAX_FPS, initial(pref.clientfps))

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	. += "<b>UI Settings</b><br>"
	. += "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	. += "<b>Custom UI</b> (recommended for White UI):<br>"
	. += "-Color: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a> <table style='display:inline;' bgcolor='[pref.UI_style_color]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ui'>reset</a><br>"
	. += "-Alpha(transparency): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a> <a href='?src=\ref[src];reset=alpha'>reset</a><br>"
	if(can_select_ooc_color(user))
		. += "<b>OOC Color:</b> "
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> <table style='display:inline;' bgcolor='[pref.ooccolor]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ooc'>reset</a><br>"
	. += "<b>Show Runechat Chat Bubbles:</b> <a href='?src=\ref[src];chat_on_map=1'>[pref.chat_on_map ? "Enabled" : "Disabled"]</a><br>"
	. += "<b>Runechat message char limit:</b> <a href='?src=\ref[src];max_chat_length=1;task=input'>[pref.max_chat_length]</a><br>"
	. += "<b>Client FPS:</b> <a href='?src=\ref[src];select_fps=1'><b>[pref.clientfps]</b></a><br>"

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_style"])
		var/UI_style_new = input(user, "Choose UI style.", "Character Preference", pref.UI_style) as null|anything in all_ui_styles
		if(!UI_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha) as num|null
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if(href_list["select_fps"])
		var/version_message
		if (user.client && user.client.byond_version < 511)
			version_message = "\nYou need to be using byond version 511 or later to take advantage of this feature, your version of [user.client.byond_version] is too low"
		if (world.byond_version < 511)
			version_message += "\nThis server does not currently support client side fps. You can set now for when it does."
		var/new_fps = input(user, "Choose your desired fps.[version_message]\n(0 = synced with server tick rate (currently:[world.fps]))", "Global Preference") as num|null
		if (isnum(new_fps) && CanUseTopic(user))
			pref.clientfps = Clamp(new_fps, CLIENT_MIN_FPS, CLIENT_MAX_FPS)

			var/mob/target_mob = preference_mob()
			if(target_mob && target_mob.client)
				target_mob.client.apply_fps(pref.clientfps)
			return TOPIC_REFRESH

	else if (href_list["max_chat_length"])
		var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [initial(pref.max_chat_length)]))", "Character Preference", pref.max_chat_length)  as null|num
		if (!isnull(desiredlength))
			pref.max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)
		return TOPIC_REFRESH

	else if(href_list["chat_on_map"])
		pref.chat_on_map = !pref.chat_on_map
		return TOPIC_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return TOPIC_REFRESH

	return ..()

/proc/can_select_ooc_color(var/mob/user)
	return config.allow_admin_ooccolor && check_rights(R_ADMIN, 0, user)
