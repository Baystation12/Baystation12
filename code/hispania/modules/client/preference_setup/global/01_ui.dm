/datum/preferences
	var/clientfps = 40
	var/ooccolor = "#010000" //Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color

	var/UI_style = "Midnight"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255

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
	pref.clientfps	    = sanitize_integer(pref.clientfps, CLIENT_MIN_FPS, CLIENT_MAX_FPS, initial(pref.clientfps))

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	. += "<b>Configuracion de la interfaz</b><br>"
	. += "<b>Estilo de la interfaz:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	. += "<b>Interfaz personalizada</b> (recomendado para White UI):<br>"
	. += "-Color: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a> <table style='display:inline;' bgcolor='[pref.UI_style_color]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ui'>reiniciar</a><br>"
	. += "-Alpha(transparencia): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a> <a href='?src=\ref[src];reset=alpha'>reiniciar</a><br>"
	if(can_select_ooc_color(user))
		. += "<b>OOC Color:</b> "
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>Uso predtr</b></a><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> <table style='display:inline;' bgcolor='[pref.ooccolor]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ooc'>reiniciar</a><br>"
	. += "<b>Limite de FPS:</b> <a href='?src=\ref[src];select_fps=1'><b>[pref.clientfps]</b></a><br>"

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_style"])
		var/UI_style_new = input(user, "Elija el estilo de interfaz de usuario.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.UI_style) as null|anything in all_ui_styles
		if(!UI_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Elija el color de la interfaz de usuario, no se recomiendan los colores oscuros!", "Preferencia global", pref.UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Seleccione el nivel de transparencia de la interfaz (alfa), entre 50 y 255.", "Preferencia global", pref.UI_style_alpha) as num|null
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Elija el color OOC:", "Preferencia global") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if(href_list["select_fps"])
		var/version_message
		if (user.client && user.client.byond_version < 511)
			version_message = "\nDebe usar la version 511 o posterior para aprovechar esta funcion, su version de [user.client.byond_version] es muy baja"
		if (world.byond_version < 511)
			version_message += "\nEste servidor actualmente no admite fps del lado del cliente. Puede configurar ahora para cuando lo haga."
		var/new_fps = input(user, "Elige tus fps deseados.[version_message]\n(0 = sincronizado con la tasa de ticks del servidor (corrientemente:[world.fps]))", "Preferencia global") as num|null
		if (isnum(new_fps) && CanUseTopic(user))
			pref.clientfps = clamp(new_fps, CLIENT_MIN_FPS, CLIENT_MAX_FPS)

			var/mob/target_mob = preference_mob()
			if(target_mob && target_mob.client)
				target_mob.client.apply_fps(pref.clientfps)
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
