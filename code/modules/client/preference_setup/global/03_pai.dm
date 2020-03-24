/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 3

	var/icon/pai_preview
	var/datum/paiCandidate/candidate
	var/icon/bgstate = MATERIAL_STEEL
	var/list/bgstate_options = list("FFF", MATERIAL_STEEL, "white")

/datum/category_item/player_setup_item/player_global/pai/load_preferences(var/savefile/S)
	if(!candidate)
		candidate = new()

	if(!preference_mob())
		return

	candidate.savefile_load(preference_mob())
	update_pai_preview()

/datum/category_item/player_setup_item/player_global/pai/save_preferences(var/savefile/S)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/content(var/mob/user)
	if(!candidate)
		candidate = new()
	update_pai_preview()
	. += "<b>pAI:</b><br>"
	if(!candidate)
		log_debug("[user] pAI prefs have a null candidate var.")
		return .
	. += "Name: <a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>"
	. += "Description: <a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>"
	. += "Role: <a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>"
	. += "OOC Comments: <a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>"
	. += "<div>Chassis: <a href='?src=\ref[src];option=chassis'>[candidate.chassis]</a><br>"
	. += "<div>Say Verb: <a href='?src=\ref[src];option=say'>[candidate.say_verb]</a><br>"
	. += "<table><tr style='vertical-align:top'><td><div class='statusDisplay'><center><img src=pai_preview.png width=[pai_preview.Width()] height=[pai_preview.Height()]></center><a href='?src=\ref[src];option=cyclebg'>Cycle Background</a></div>"
	. += "</td></tr></table>"

/datum/category_item/player_setup_item/player_global/pai/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["option"])
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
			if("chassis")
				candidate.chassis = input(usr,"What would you like to use for your mobile chassis icon?") as null|anything in GLOB.possible_chassis
				update_pai_preview()
			if("say")
				candidate.say_verb = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in GLOB.possible_say_verbs
			if("cyclebg")
				bgstate = next_in_list(bgstate, bgstate_options)
				update_pai_preview()

		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/pai/proc/update_pai_preview()
	pai_preview = icon('icons/effects/128x48.dmi', bgstate)
	var/icon/pai = icon('icons/mob/pai.dmi', GLOB.possible_chassis[candidate.chassis], NORTH)
	pai_preview.Scale(48+32, 16+32)

	pai_preview.Blend(pai, ICON_OVERLAY, 25, 22)
	pai = icon('icons/mob/pai.dmi', GLOB.possible_chassis[candidate.chassis], WEST)
	pai_preview.Blend(pai, ICON_OVERLAY, 1, 9)
	pai = icon('icons/mob/pai.dmi', GLOB.possible_chassis[candidate.chassis], SOUTH)
	pai_preview.Blend(pai, ICON_OVERLAY, 49, 5)

	pai_preview.Scale(pai_preview.Width() * 2, pai_preview.Height() * 2)

	send_rsc(usr, pai_preview, "pai_preview.png")