/datum/preferences
	var/list/uplink_sources
	var/exploit_record = ""

/datum/category_item/player_setup_item/antagonism/basic
	name = "Setup"
	sort_order = 2

	var/static/list/uplink_sources_by_name

/datum/category_item/player_setup_item/antagonism/basic/New()
	..()
	SETUP_SUBTYPE_DECLS_BY_NAME(/decl/uplink_source, uplink_sources_by_name)

/datum/category_item/player_setup_item/antagonism/basic/load_character(datum/pref_record_reader/R)
	var/list/uplink_order
	uplink_order = R.read("uplink_sources")
	pref.exploit_record = R.read("exploit_record")

	if(istype(uplink_order))
		pref.uplink_sources = list()
		for(var/entry in uplink_order)
			var/uplink_source = uplink_sources_by_name[entry]
			if(uplink_source)
				pref.uplink_sources += uplink_source

/datum/category_item/player_setup_item/antagonism/basic/save_character(datum/pref_record_writer/W)
	var/uplink_order = list()
	for(var/entry in pref.uplink_sources)
		var/decl/uplink_source/UL = entry
		uplink_order += UL.name

	W.write("uplink_sources", uplink_order)
	W.write("exploit_record", pref.exploit_record)

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	if(!istype(pref.uplink_sources))
		pref.uplink_sources = list()
		for(var/entry in GLOB.default_uplink_source_priority)
			pref.uplink_sources += decls_repository.get_decl(entry)

/datum/category_item/player_setup_item/antagonism/basic/content(var/mob/user)
	. +="<b>Antag Setup:</b><br>"
	. +="Uplink Source Priority: <a href='?src=\ref[src];add_source=1'>Add</a><br>"
	for(var/entry in pref.uplink_sources)
		var/decl/uplink_source/US = entry
		. +="[US.name] <a href='?src=\ref[src];move_source_up=\ref[US]'>Move Up</a> <a href='?src=\ref[src];move_source_down=\ref[US]'>Move Down</a> <a href='?src=\ref[src];remove_source=\ref[US]'>Remove</a><br>"
		if(US.desc)
			. += "<font size=1>[US.desc]</font><br>"
	if(!pref.uplink_sources.len)
		. += "<span class='warning'>You will not receive an uplink unless you add an uplink source!</span>"
	. +="<br>"
	. +="Exploitable information:<br>"
	if(jobban_isbanned(user, "Records"))
		. += "<b>You are banned from using character records.</b><br>"
	else
		. +="<a href='?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["add_source"])
		var/source_selection = input(user, "Select Uplink Source to Add", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in (list_values(uplink_sources_by_name) - pref.uplink_sources)
		if(source_selection && CanUseTopic(user))
			pref.uplink_sources |= source_selection
			return TOPIC_REFRESH

	if(href_list["remove_source"])
		var/decl/uplink_source/US = locate(href_list["remove_source"]) in pref.uplink_sources
		if(US && pref.uplink_sources.Remove(US))
			return TOPIC_REFRESH

	if(href_list["move_source_up"])
		var/decl/uplink_source/US = locate(href_list["move_source_up"]) in pref.uplink_sources
		if(!US)
			return TOPIC_NOACTION
		var/index = list_find(pref.uplink_sources, US)
		if(index <= 1)
			return TOPIC_NOACTION
		pref.uplink_sources.Swap(index, index - 1)
		return TOPIC_REFRESH

	if(href_list["move_source_down"])
		var/decl/uplink_source/US = locate(href_list["move_source_down"]) in pref.uplink_sources
		if(!US)
			return TOPIC_NOACTION
		var/index = list_find(pref.uplink_sources, US)
		if(index >= pref.uplink_sources.len)
			return TOPIC_NOACTION
		pref.uplink_sources.Swap(index, index + 1)
		return TOPIC_REFRESH


	if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(input(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return TOPIC_REFRESH

	return ..()
