/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 3

	var/icon/pai_preview
	var/datum/paiCandidate/candidate
	var/icon/bgstate = MATERIAL_STEEL
	var/list/bgstate_options = list("FFF", MATERIAL_STEEL, "white")

/datum/category_item/player_setup_item/player_global/pai/load_preferences(datum/pref_record_reader/R)
	if(!candidate)
		candidate = new()

	if(!preference_mob())
		return

	candidate.savefile_load(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/save_preferences(datum/pref_record_writer/W)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/content(var/mob/user)
	if(!candidate)
		candidate = new()
	if (!pai_preview)
		update_pai_preview(user)

	. += "<b>pAI:</b><br>"
	if(!candidate)
		log_debug("[user] Las preferencias de pAI tienen una variable candidata nula.")
		return .
	. += "Nombre: <a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>"
	. += "Descripcion: <a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>"
	. += "Rol: <a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>"
	. += "Comentarios OOC: <a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>"
	. += "<div>Chassis: <a href='?src=\ref[src];option=chassis'>[candidate.chassis]</a><br>"
	. += "<div>Decir verbo: <a href='?src=\ref[src];option=say'>[candidate.say_verb]</a><br>"
	. += "<table><tr style='vertical-align:top'><td><div class='statusDisplay'><center><img src=pai_preview.png width=[pai_preview.Width()] height=[pai_preview.Height()]></center><a href='?src=\ref[src];option=cyclebg'>Cambiar fondo</a></div>"
	. += "</td></tr></table>"

/datum/category_item/player_setup_item/player_global/pai/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["option"])
		var/t
		. = TOPIC_REFRESH
		switch(href_list["option"])
			if("name")
				t = sanitizeName(input(user, "Ingrese un nombre para su pAI", "Preferencia global", candidate.name) as text|null, MAX_NAME_LEN, 1)
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				t = input(user, "Ingrese una descripcion para su pAI", "Preferencia global", html_decode(candidate.description)) as message|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				t = input(user, "Ingrese un rol para su pAI", "Preferencia global", html_decode(candidate.role)) as text|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				t = input(user, "Ingrese cualquier comentario OOC", "Preferencia global", html_decode(candidate.comments)) as message
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)
			if("chassis")
				candidate.chassis = input(user,"Que le gustaria usar como holograma de su chasis movil?") as null|anything in GLOB.possible_chassis
				update_pai_preview(user)
				. = TOPIC_HARD_REFRESH
			if("say")
				candidate.say_verb = input(user,"Que tema le gustaria usar para sus verbos de habla?") as null|anything in GLOB.possible_say_verbs
			if("cyclebg")
				bgstate = next_in_list(bgstate, bgstate_options)
				update_pai_preview(user)
				. = TOPIC_HARD_REFRESH

		return

	return ..()

/datum/category_item/player_setup_item/player_global/pai/proc/update_pai_preview(var/mob/user)
	pai_preview = icon('icons/effects/128x48.dmi', bgstate)
	var/icon/pai = icon('icons/mob/pai.dmi', GLOB.possible_chassis[candidate.chassis], NORTH)
	pai_preview.Scale(48+32, 16+32)

	pai_preview.Blend(pai, ICON_OVERLAY, 25, 22)
	pai = icon('icons/mob/pai.dmi', GLOB.possible_chassis[candidate.chassis], WEST)
	pai_preview.Blend(pai, ICON_OVERLAY, 1, 9)
	pai = icon('icons/mob/pai.dmi', GLOB.possible_chassis[candidate.chassis], SOUTH)
	pai_preview.Blend(pai, ICON_OVERLAY, 49, 5)

	pai_preview.Scale(pai_preview.Width() * 2, pai_preview.Height() * 2)

	send_rsc(user, pai_preview, "pai_preview.png")
