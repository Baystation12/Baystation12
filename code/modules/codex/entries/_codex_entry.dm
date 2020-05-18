/datum/codex_entry
	var/display_name
	var/list/associated_strings
	var/list/associated_paths
	var/lore_text
	var/mechanics_text
	var/antag_text

/datum/codex_entry/dd_SortValue()
	return display_name

/datum/codex_entry/proc/update_links()
	return

/datum/codex_entry/New(var/_display_name, var/list/_associated_paths, var/list/_associated_strings, var/_lore_text, var/_mechanics_text, var/_antag_text)

	if(_display_name)       display_name =       _display_name
	if(_associated_paths)   associated_paths =   _associated_paths
	if(_associated_strings) associated_strings = _associated_strings
	if(_lore_text)          lore_text =          _lore_text
	if(_mechanics_text)     mechanics_text =     _mechanics_text
	if(_antag_text)         antag_text =         _antag_text

	if(associated_paths && associated_paths.len)
		for(var/tpath in associated_paths)
			var/atom/thing = tpath
			LAZYADD(associated_strings, sanitize(lowertext(initial(thing.name))))
	if(display_name)
		LAZYADD(associated_strings, display_name)
	else if(associated_strings && associated_strings.len)
		display_name = associated_strings[1]
	..()

/datum/codex_entry/proc/get_header(var/mob/presenting_to)
	var/list/dat = list()
	var/datum/codex_entry/linked_entry = SScodex.get_entry_by_string("nexus")
	dat += "<a href='?src=\ref[SScodex];show_examined_info=\ref[linked_entry];show_to=\ref[presenting_to]'>Home</a>"
	dat += "<a href='?src=\ref[presenting_to.client];codex_search=1'>Search Codex</a>"
	dat += "<a href='?src=\ref[presenting_to.client];codex_index=1'>List All Entries</a>"
	dat += "<hr><h2>[display_name]</h2>"
	return jointext(dat, null)

/datum/codex_entry/proc/get_text(var/mob/presenting_to)
	var/list/dat = list(get_header(presenting_to))
	if(lore_text)
		dat += "<font color = '[CODEX_COLOR_LORE]'>[lore_text]</font>"
	if(mechanics_text)
		dat += "<h3>OOC Information</h3>"
		dat += "<font color = '[CODEX_COLOR_MECHANICS]'>[mechanics_text]</font>"
	if(antag_text && presenting_to.mind && player_is_antag(presenting_to.mind))
		dat += "<h3>Antagonist Information</h3>"
		dat += "<font color='[CODEX_COLOR_ANTAG]'>[antag_text]</font>"
	return jointext(dat, null)
