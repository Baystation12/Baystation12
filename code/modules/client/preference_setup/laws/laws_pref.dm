/datum/preferences
	var/list/laws = list()
	var/is_shackled = FALSE

/datum/preferences/proc/get_lawset()
	if(!laws || !laws.len)
		return
	var/datum/ai_laws/custom_lawset = new
	for(var/law in laws)
		custom_lawset.add_inherent_law(law)
	return custom_lawset

	return gear_list[gear_slot]

/datum/category_item/player_setup_item/law_pref
	name = "Laws"
	sort_order = 1

/datum/category_item/player_setup_item/law_pref/load_character(var/savefile/S)
	from_file(S["laws"], pref.laws)
	from_file(S["is_shackled"], pref.is_shackled)

/datum/category_item/player_setup_item/law_pref/save_character(var/savefile/S)
	to_file(S["laws"], pref.laws)
	to_file(S["is_shackled"], pref.is_shackled)

/datum/category_item/player_setup_item/law_pref/sanitize_character()
	if(!istype(pref.laws))	pref.laws = list()
	for(var/law in pref.laws)
		pref.laws -= law
		sanitize_text(law, default="")
		pref.laws |= law

	var/datum/species/species = all_species[pref.species]
	if(!(species && species.has_organ[BP_POSIBRAIN]))
		pref.is_shackled = initial(pref.is_shackled)
	else
		pref.is_shackled = sanitize_bool(pref.is_shackled, initial(pref.is_shackled))

/datum/category_item/player_setup_item/law_pref/content()
	. = list()
	var/datum/species/species = all_species[pref.species]

	if(!(species && species.has_organ[BP_POSIBRAIN]))
		. += "<b>Your Species Has No Laws</b><br>"
	else
		. += "<b>Shackle: </b>"
		if(!pref.is_shackled)
			. += "<span class='linkOn'>Off</span>"
			. += "<a href='?src=\ref[src];toggle_shackle=[pref.is_shackled]'>On</a>"
			. += "<br>Only shackled positronics have laws in an integrated positronic chassis."
			. += "<hr>"
		else
			. += "<a href='?src=\ref[src];toggle_shackle=[pref.is_shackled]'>Off</a>"
			. += "<span class='linkOn'>On</span>"
			. += "<br>You are shackled and have laws that, if you attempt to break them, prevent you from moving."
			. += "<hr>"

			. += "<b>Your Current Laws:</b><br>"

			if(!pref.laws.len)
				. += "<b>You currently have no laws.</b><br>"
			else
				for(var/i in 1 to pref.laws.len)
					. += "[i]) [pref.laws[i]]<br>"

			. += "Law sets: <a href='?src=\ref[src];lawsets=1'>Load Set</a><br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/law_pref/OnTopic(href, href_list, user)
	if(href_list["toggle_shackle"])
		pref.is_shackled = !pref.is_shackled
		return TOPIC_REFRESH

	else if(href_list["lawsets"])
		var/list/datum/ai_laws/valid_lawsets = list()
		var/list/datum/ai_laws/all_lawsets = list()
		init_subtypes(/datum/ai_laws, all_lawsets)
		all_lawsets = dd_sortedObjectList(all_lawsets)
		var/list/lawset_names = list()

		for(var/datum/ai_laws/lawset in all_lawsets)
			if(lawset.shackles)
				valid_lawsets[lawset.name] = lawset
				lawset_names += lawset.name

		var/chosen_lawset = input(user, "Choose a law set:", "Character Preference", pref.laws)  as null|anything in lawset_names
		if(valid_lawsets[chosen_lawset] && CanUseTopic(user))
			var/datum/ai_laws/lawset = valid_lawsets[chosen_lawset]
			var/datum/ai_law/list/laws = lawset.all_laws()
			pref.laws.Cut()
			for(var/datum/ai_law/law in laws)
				pref.laws += "[law.law]"
		return TOPIC_REFRESH
	return ..()
