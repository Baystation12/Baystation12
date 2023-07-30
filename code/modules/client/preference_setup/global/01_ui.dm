/datum/preferences
	var/clientfps = CLIENT_DEFAULT_FPS
	var/ooccolor = "#010000"
	var/UI_style = "Midnight"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255

	var/tooltip_style = "Midnight" //Style for popup tooltips


/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1


/datum/category_item/player_setup_item/player_global/ui/load_preferences(datum/pref_record_reader/R)
	pref.UI_style = R.read("UI_style")
	pref.UI_style_color = R.read("UI_style_color")
	pref.UI_style_alpha = R.read("UI_style_alpha")
	pref.ooccolor = R.read("ooccolor")
	pref.clientfps = R.read("clientfps")


/datum/category_item/player_setup_item/player_global/ui/save_preferences(datum/pref_record_writer/W)
	W.write("UI_style", pref.UI_style)
	W.write("UI_style_color", pref.UI_style_color)
	W.write("UI_style_alpha", pref.UI_style_alpha)
	W.write("ooccolor", pref.ooccolor)
	W.write("clientfps", pref.clientfps)


/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style		= sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color	= sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha	= sanitize_integer(pref.UI_style_alpha, 0, 255, initial(pref.UI_style_alpha))
	pref.ooccolor		= sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	sanitize_client_fps()


/datum/category_item/player_setup_item/player_global/ui/content(mob/user)
	. += "<b>UI Settings</b><br>"
	. += "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	. += "<b>Custom UI</b> (recommended for White UI):<br>"
	. += "-Color: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a> <table style='display:inline;' bgcolor='[pref.UI_style_color]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ui'>reset</a><br>"
	. += "-Alpha(transparency): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a> <a href='?src=\ref[src];reset=alpha'>reset</a><br>"
	. += "<b>Tooltip Style:</b> <a href='?src=\ref[src];select_tooltip_style=1'><b>[pref.tooltip_style]</b></a><br>"
	if (can_select_ooc_color(user))
		. += "<b>OOC Color:</b> "
		if (pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> <table style='display:inline;' bgcolor='[pref.ooccolor]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ooc'>reset</a><br>"
	. += "<b>Client FPS:</b> <a href='?src=\ref[src];select_fps=1'><b>[pref.clientfps]</b></a><br>"


/datum/category_item/player_setup_item/player_global/ui/OnTopic(href,list/href_list, mob/user)
	if (href_list["select_style"])
		var/UI_style_new = input(user, "Choose UI style.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.UI_style) as null|anything in all_ui_styles
		if (!UI_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if (href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		if (isnull(UI_style_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if (href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha) as num|null
		if (isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if (href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if (new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if (href_list["select_fps"])
		var/response = input(user, "[CLIENT_MIN_FPS] - [CLIENT_MAX_FPS] (default [CLIENT_DEFAULT_FPS])", "Select Target FPS") as null | num
		if (isnum(response) && CanUseTopic(user))
			pref.clientfps = response
			sanitize_client_fps()
			var/mob/target_mob = preference_mob()
			if (target_mob?.client)
				target_mob.client.fps = pref.clientfps
			return TOPIC_REFRESH

	else if (href_list["select_tooltip_style"])
		var/tooltip_style_new = input(user, "Choose tooltip style.", "Global Preference", pref.tooltip_style) as null|anything in all_tooltip_styles
		if (!tooltip_style_new || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.tooltip_style = tooltip_style_new
		return TOPIC_REFRESH

	else if (href_list["reset"])
		switch (href_list["reset"])
			if ("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if ("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if ("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return TOPIC_REFRESH

	return ..()


/datum/category_item/player_setup_item/player_global/ui/proc/sanitize_client_fps()
	pref.clientfps = clamp(floor(pref.clientfps), CLIENT_MIN_FPS, CLIENT_MAX_FPS)


/proc/can_select_ooc_color(mob/user)
	return config.allow_admin_ooccolor && check_rights(R_ADMIN, 0, user)
