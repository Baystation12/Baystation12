SUBSYSTEM_DEF(codex)
	name = "Codex"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_CODEX
	var/regex/linkRegex

	var/list/entries_by_path =   list()
	var/list/entries_by_string = list()
	var/list/index_file =        list()
	var/list/search_cache =      list()

/datum/controller/subsystem/codex/Initialize()
	// Codex link syntax is such: 
	// <l>keyword</l> when keyword is mentioned verbatim, 
	// <span codexlink='keyword'>whatever</span> when shit gets tricky
	linkRegex = regex(@"<(span|l)(\s+codexlink='([^>]*)'|)>([^<]+)</(span|l)>","g")

	// Create general hardcoded entries.
	for(var/ctype in typesof(/datum/codex_entry))
		var/datum/codex_entry/centry = ctype
		if(initial(centry.display_name) || initial(centry.associated_paths) || initial(centry.associated_strings))
			centry = new centry()
			for(var/associated_path in centry.associated_paths)
				entries_by_path[associated_path] = centry
			for(var/associated_string in centry.associated_strings)
				add_entry_by_string(associated_string, centry)
			if(centry.display_name)
				add_entry_by_string(centry.display_name, centry)
			centry.update_links()

	// Create categorized entries.
	for(var/ctype in subtypesof(/datum/codex_category))
		var/datum/codex_category/cat = new ctype
		cat.Initialize()
		qdel(cat)

	// Create the index file for later use.
	for(var/thing in SScodex.entries_by_path)
		var/datum/codex_entry/entry = SScodex.entries_by_path[thing]
		index_file[entry.display_name] = entry
	for(var/thing in SScodex.entries_by_string)
		var/datum/codex_entry/entry = SScodex.entries_by_string[thing]
		index_file[entry.display_name] = entry
	index_file = sortAssoc(index_file)
	. = ..()

/datum/controller/subsystem/codex/proc/parse_links(string, viewer)
	while(regex_find(linkRegex, string))
		var/key = linkRegex.group[4]
		if(linkRegex.group[2])
			key = linkRegex.group[3]
		key = lowertext(trim(key))
		var/datum/codex_entry/linked_entry = get_entry_by_string(key)
		var/replacement = linkRegex.group[4]
		if(linked_entry)
			replacement = "<a href='?src=\ref[SScodex];show_examined_info=\ref[linked_entry];show_to=\ref[viewer]'>[replacement]</a>"
		string = replacetextEx_char(string, linkRegex.match, replacement)
	return string

/datum/controller/subsystem/codex/proc/get_codex_entry(var/entry)
	if(istype(entry, /atom))
		var/atom/entity = entry
		if(entity.get_specific_codex_entry())
			return entity.get_specific_codex_entry()
		return get_entry_by_string(entity.name) || entries_by_path[entity.type]
	else if(entries_by_path[entry])
		return entries_by_path[entry]
	else if(entries_by_string[lowertext(entry)])
		return entries_by_string[lowertext(entry)]

/datum/controller/subsystem/codex/proc/add_entry_by_string(var/string, var/entry)
	entries_by_string[lowertext(trim(string))] = entry

/datum/controller/subsystem/codex/proc/get_entry_by_string(var/string)
	return entries_by_string[lowertext(trim(string))]

/datum/controller/subsystem/codex/proc/present_codex_entry(var/mob/presenting_to, var/datum/codex_entry/entry)
	if(entry && istype(presenting_to) && presenting_to.client)
		var/datum/browser/popup = new(presenting_to, "codex", "Codex", nheight=425)
		popup.set_content(parse_links(entry.get_text(presenting_to), presenting_to))
		popup.open()

/datum/controller/subsystem/codex/proc/retrieve_entries_for_string(var/searching)

	if(!initialized)
		return list()

	searching = sanitize(lowertext(trim(searching)))
	if(!searching)
		return list()
	if(!search_cache[searching])
		var/list/results
		if(entries_by_string[searching])
			results = list(entries_by_string[searching])
		else
			results = list()
			for(var/entry_title in entries_by_string)
				var/datum/codex_entry/entry = entries_by_string[entry_title]
				if(findtext(entry.display_name, searching) || \
				 findtext(entry.lore_text, searching) || \
				 findtext(entry.mechanics_text, searching) || \
				 findtext(entry.antag_text, searching))
					results |= entry
		search_cache[searching] = dd_sortedObjectList(results)
	return search_cache[searching]

/datum/controller/subsystem/codex/Topic(href, href_list)
	. = ..()
	if(!. && href_list["show_examined_info"] && href_list["show_to"])
		var/mob/showing_mob =   locate(href_list["show_to"])
		if(!istype(showing_mob) || !showing_mob.can_use_codex())
			return 
		var/atom/showing_atom = locate(href_list["show_examined_info"])
		var/entry
		if(istype(showing_atom, /datum/codex_entry))
			entry = showing_atom
		else
			if(istype(showing_atom))
				entry = get_codex_entry(showing_atom.get_codex_value())
			else
				entry = get_codex_entry(showing_atom)
		if(entry)
			present_codex_entry(showing_mob, entry)
			return TRUE
