datum/preferences/proc/contentGlobalPreference()
	var/data = {"

		<html><body>

		<nav class='vNav'>
		<ul>
		<li><a href='?src=\ref[src];page=1'>Character</a>
		<li><a href='?src=\ref[src];page=2'>Occupation</a>
		<li><a href='?src=\ref[src];page=3'>Loadout</a>
		<li><a href='?src=\ref[src];page=4'>Local Preferences</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=9'>Records</a>
		<li><hr>
		<li> <a class='active' href='?src=\ref[src];page=8'>Global Preferences</a>
		</ul>
		</nav>

		<nav class='hNav'>
		<ul>
		<li><a href='?src=\ref[src];save=1'>Save</a>
		<li><a href='?src=\ref[src];load=1'>Load</a>
		<li><a href='?src=\ref[src];delete=1'>Reset</a>
		<li><a href='?src=\ref[src];lock=1'>Lock</a>
		</ul>
		</nav>

		<div class='main' style='width:650px; font-size: small;'> "}
	data += "<b>UI Settings</b><br>"
	data += "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[UI_style]</b></a><br>"
	data += "<b>Custom UI</b> (recommended for White UI):<br>"
	data += "-Color: <a href='?src=\ref[src];select_color=1'><b>[UI_style_color]</b></a> <table style='display:inline;' bgcolor='[UI_style_color]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ui'>reset</a><br>"
	data += "-Alpha(transparency): <a href='?src=\ref[src];select_alpha=1'><b>[UI_style_alpha]</b></a> <a href='?src=\ref[src];reset=alpha'>reset</a><br>"
	if(can_select_ooc_color(user))
		data += "<b>OOC Color:</b> "
		if(ooccolor == initial(ooccolor))
			data += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			data += "<a href='?src=\ref[src];select_ooc_color=1'><b>[ooccolor]</b></a> <table style='display:inline;' bgcolor='[ooccolor]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ooc'>reset</a><br>"

	data += "<br><b>Preferences</b><br>"
	data += "<table>"
	var/mob/pref_mob = preference_mob()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		if(!client_pref.may_toggle(pref_mob))
			continue

		data += "<tr><td>[client_pref.description]: </td>"
		if(pref_mob.is_preference_enabled(client_pref.key))
			data += "<td><span class='linkOn'><b>[client_pref.enabled_description]</b></span></td> <td><a href='?src=\ref[src];toggle_off=[client_pref.key]'>[client_pref.disabled_description]</a></td>"
		else
			data += "<td><a  href='?src=\ref[src];toggle_on=[client_pref.key]'>[client_pref.enabled_description]</a></td> <td><span class='linkOn'><b>[client_pref.disabled_description]</b></span></td>"
		data += "</tr>"
	data += "</table>"
	data += "<br><b>Language Keys</b><br>"
	data += " [jointext(language_prefixes, " ")] <a href='?src=\ref[src];change_prefix=1'>Change</a> <a href='?src=\ref[src];reset_prefix=1'>Reset</a><br>"

	data += {"
		</div>

		<div class='secondary'>

		"}
	if(!candidate)
		candidate = new()
	data += "<b>pAI:</b><br>"
	if(!candidate)
		log_debug("[user] pAI prefs have a null candidate var.")
		return
	data += {"

			Name: <a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>
			Description: <a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>
			Role: <a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>
			OOC Comments: <a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>

			<br><b>OOC:</b><br>
			Ignored Players<br>

			"}
	for(var/ignored_player in ignored_players)
		data += "[ignored_player] (<a href='?src=\ref[src];unignore_player=[ignored_player]'>Unignore</a>)<br>"
	data += {"

			(<a href='?src=\ref[src];ignore_player=1'>Ignore Player</a>)
			</div>

			<div class='background'>
			</div>

			</body></html>

			"}

	return data

/datum/preferences/proc/Topic8(var/href, var/list/href_list)

	if(href_list["page"])
		selected_menu = text2num(href_list["page"])

	else if(href_list["option"])
		var/t
		switch(href_list["option"])
			if("name")
				t = sanitizeName(input(user, "Enter a name for your pAI", "Global Preference", candidate.name) as text|null, MAX_NAME_LEN, 1)
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				t = input(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description)) as message|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				t = input(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role)) as text|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				t = input(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments)) as message
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)

	else if(href_list["change_prefix"])
		var/char
		var/keys[0]
		do
			char = input("Enter a single special character.\nYou may re-select the same characters.\nThe following characters are already in use by radio: ; : .\nThe following characters are already in use by special say commands: ! * ^", "Enter Character - [3 - keys.len] remaining") as null|text
			if(char)
				if(length(char) > 1)
					alert(user, "Only single characters allowed.", "Error", "Ok")
				else if(char in list(";", ":", "."))
					alert(user, "Radio character. Rejected.", "Error", "Ok")
				else if(char in list("!","*", "^"))
					alert(user, "Say character. Rejected.", "Error", "Ok")
				else if(contains_az09(char))
					alert(user, "Non-special character. Rejected.", "Error", "Ok")
				else
					keys.Add(char)
		while(char && keys.len < 3)

		if(keys.len == 3)
			language_prefixes = keys
			return

	else if(href_list["reset_prefix"])
		language_prefixes = config.language_prefixes.Copy()

	var/mob/pref_mob = preference_mob()
	if(href_list["toggle_on"])
		. = pref_mob.set_preference(href_list["toggle_on"], TRUE)
	else if(href_list["toggle_off"])
		. = pref_mob.set_preference(href_list["toggle_off"], FALSE)
	if(.)
		return

	else if(href_list["select_style"])
		var/UI_style_new = input(user, "Choose UI style.", "Character Preference", UI_style) as null|anything in all_ui_styles
		if(!UI_style_new || !CanUseTopic(user)) return
		UI_style = UI_style_new


	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user)) return
		UI_style_color = UI_style_color_new


	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", UI_style_alpha) as num|null
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return
		UI_style_alpha = UI_style_alpha_new


	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			ooccolor = new_ooccolor


	else if(href_list["select_fps"])
		var/version_message
		if (usr.client && usr.client.byond_version < 511)
			version_message = "\nYou need to be using byond version 511 or later to take advantage of this feature, your version of [usr.client.byond_version] is too low"
		if (world.byond_version < 511)
			version_message += "\nThis server does not currently support client side fps. You can set now for when it does."
		var/new_fps = input(user, "Choose your desired fps.[version_message]\n(0 = synced with server tick rate (currently:[world.fps]))", "Global Preference") as num|null
		if (isnum(new_fps) && CanUseTopic(user))
			clientfps = Clamp(new_fps, CLIENT_MIN_FPS, CLIENT_MAX_FPS)

			var/mob/target_mob = preference_mob()
			if(target_mob && target_mob.client)
				target_mob.client.apply_fps(clientfps)


	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				UI_style_color = initial(UI_style_color)
			if("alpha")
				UI_style_alpha = initial(UI_style_alpha)
			if("ooc")
				ooccolor = initial(ooccolor)

	else if(href_list["unignore_player"])
		ignored_players -= href_list["unignore_player"]

	if(href_list["ignore_player"])
		var/player_to_ignore = sanitize(ckey(input(user, "Who do you want to ignore?","Ignore") as null|text))
		//input() sleeps while waiting for the user to respond, so we need to check CanUseTopic() again here
		if(player_to_ignore && CanUseTopic(user))
			ignored_players |= player_to_ignore

	return