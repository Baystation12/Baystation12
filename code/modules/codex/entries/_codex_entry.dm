/datum/codex_entry
	var/display_name
	var/list/associated_strings
	var/list/associated_paths
	var/lore_text
	var/mechanics_text
	var/antag_text

/datum/codex_entry/dd_SortValue()
	return display_name

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
