/client
	var/codex_on_cooldown = FALSE
	var/const/max_codex_entries_shown = 10

/client/verb/search_codex(searching as text)

	set name = "Search Codex"
	set category = "IC"
	set src = usr

	if(!mob || !SScodex)
		return

	if(codex_on_cooldown || !mob.can_use_codex())
		to_chat(src, "<span class='warning'>You cannot perform codex actions currently.</span>")
		return

	if(!searching)
		searching = input("Enter a search string.", "Codex Search") as text|null
		if(!searching)
			return

	if(codex_on_cooldown || !mob.can_use_codex())
		to_chat(src, "<span class='warning'>You cannot perform codex actions currently.</span>")
		return

	codex_on_cooldown = TRUE
	addtimer(CALLBACK(src, .proc/reset_codex_cooldown), 3 SECONDS)

	var/list/all_entries = SScodex.retrieve_entries_for_string(searching)
	if(mob && mob.mind && !player_is_antag(mob.mind))
		all_entries = all_entries.Copy() // So we aren't messing with the codex search cache.
		for(var/datum/codex_entry/entry in all_entries)
			if(entry.antag_text && !entry.mechanics_text && !entry.lore_text)
				all_entries -= entry

	if(LAZYLEN(all_entries) == 1)
		SScodex.present_codex_entry(mob, all_entries[1])
	else
		if(LAZYLEN(all_entries) > 1)
			var/list/codex_data = list("<h3><b>[all_entries.len] matches</b> for '[searching]':</h3>")
			if(LAZYLEN(all_entries) > max_codex_entries_shown)
				codex_data += "Showing first <b>[max_codex_entries_shown]</b> entries. <b>[all_entries.len - 5] result\s</b> omitted.</br>"
			codex_data += "<table width = 100%>"
			for(var/i = 1 to min(all_entries.len, max_codex_entries_shown))
				var/datum/codex_entry/entry = all_entries[i]
				codex_data += "<tr><td>[entry.display_name]</td><td><a href='?src=\ref[SScodex];show_examined_info=\ref[entry];show_to=\ref[mob]'>View</a></td></tr>"
			codex_data += "</table>"
			var/datum/browser/popup = new(mob, "codex-search", "Codex Search")
			popup.set_content(jointext(codex_data, null))
			popup.open()
		else
			to_chat(src, "<span class='notice'>The codex reports <b>no matches</b> for '[searching]'.</span>")

/client/verb/list_codex_entries()

	set name = "List Codex Entries"
	set category = "IC"
	set src = usr

	if(!mob || !SScodex.initialized)
		return

	if(codex_on_cooldown || !mob.can_use_codex())
		to_chat(src, "<span class='warning'>You cannot perform codex actions currently.</span>")
		return
	codex_on_cooldown = TRUE
	addtimer(CALLBACK(src, .proc/reset_codex_cooldown), 10 SECONDS)

	to_chat(mob, "<span class='notice'>The codex forwards you an index file.</span>")

	var/datum/browser/popup = new(mob, "codex-index", "Codex Index")
	var/list/codex_data = list("<h2>Codex Entries</h2>")
	codex_data += "<table width = 100%>"

	var/antag_check = mob && mob.mind && player_is_antag(mob.mind)
	var/last_first_letter
	for(var/thing in SScodex.index_file)

		var/datum/codex_entry/entry = SScodex.index_file[thing]
		if(!antag_check && entry.antag_text && !entry.mechanics_text && !entry.lore_text)
			continue

		var/first_letter = uppertext(copytext(thing, 1, 2))
		if(first_letter != last_first_letter)
			last_first_letter = first_letter
			codex_data += "<tr><td colspan = 2><hr></td></tr>"
			codex_data += "<tr><td colspan = 2>[last_first_letter]</td></tr>"
			codex_data += "<tr><td colspan = 2><hr></td></tr>"
		codex_data += "<tr><td>[thing]</td><td><a href='?src=\ref[SScodex];show_examined_info=\ref[SScodex.index_file[thing]];show_to=\ref[mob]'>View</a></td></tr>"
	codex_data += "</table>"
	popup.set_content(jointext(codex_data, null))
	popup.open()

/client/proc/reset_codex_cooldown()
	codex_on_cooldown = FALSE
