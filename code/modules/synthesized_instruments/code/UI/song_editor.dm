/datum/nano_module/song_editor
	name = "Song Editor"
	available_to_ai = 0
	var/namespace/synthesized_instruments/manager/player/player
	var/show_help = 0
	var/page = 1


/datum/nano_module/song_editor/New(atom/source, namespace/synthesized_instruments/manager/player)
	src.host = source
	src.player = player


/datum/nano_module/song_editor/proc/_pages()
	return Ceiling(src.player.lines.len / GLOB.synthesized_instruments.constants.lines_per_page_in_song_editor)


/datum/nano_module/song_editor/proc/_current_page()
	return src.player.current_line > 0 ? Ceiling(src.player.current_line / GLOB.synthesized_instruments.constants.lines_per_page_in_song_editor) : src.page


/datum/nano_module/song_editor/proc/_page_bounds(page_num)
	return list(
		max(1 + GLOB.synthesized_instruments.constants.lines_per_page_in_song_editor * (page_num-1), 1),
		min(GLOB.synthesized_instruments.constants.lines_per_page_in_song_editor * page_num, src.player.lines.len))


/datum/nano_module/song_editor/ui_interact(mob/user, ui_key = "song_editor", var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list()

	var/current_page = src._current_page()
	var/list/line_bounds = src._page_bounds(current_page)

	data["lines"] = src.player.lines.Copy(line_bounds[1], line_bounds[2]+1)
	data["active_line"] = src.player.current_line
	data["max_lines"] = GLOB.synthesized_instruments.constants.max_lines_in_song
	data["max_line_length"] = GLOB.synthesized_instruments.constants.max_length_of_line_in_song
	data["tick_lag"] = world.tick_lag
	data["show_help"] = src.show_help
	data["page_num"] = current_page
	data["page_offset"] = GLOB.synthesized_instruments.constants.lines_per_page_in_song_editor * (current_page-1)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, "song_editor.tmpl", "Song Editor", 550, 600)
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/song_editor/Topic(href, href_list)
	if (..())
		return 1

	var/target = href_list["target"]
	var/value = text2num(href_list["value"])
	if (href_list["value"] && !isnum(value))
		to_chat(usr, "Invalid input")
		return 0

	switch (target)
		if("newline")
			var/newline = html_encode(input(usr, "Enter your line: ") as text|null)
			if(!newline)
				return
			if(src.player.lines.len > GLOB.synthesized_instruments.constants.max_lines_in_song)
				return
			if(length(newline) > GLOB.synthesized_instruments.constants.max_length_of_line_in_song)
				newline = copytext(newline, 1, GLOB.synthesized_instruments.constants.max_length_of_line_in_song)
			src.player.lines.Add(newline)

		if("deleteline")
			// This could kill the server if the synthesizer was playing, props to BeTePb
			// Impossible to do now. Dumbing down this section.
			var/num = round(value)
			if(num > src.player.lines.len || num < 1)
				return
			src.player.lines.Cut(num, num+1)

		if("modifyline")
			var/num = round(value)
			if(num > src.player.lines.len || num < 1)
				return
			var/content = html_encode(input(usr, "Enter your line: ", "Edit line", src.player.lines[num]) as text|null)
			if(!content)
				return
			if(length(content) > GLOB.synthesized_instruments.constants.max_length_of_line_in_song)
				content = copytext(content, 1, GLOB.synthesized_instruments.constants.max_length_of_line_in_song)
			src.player.lines[num] = content

		if ("help")
			src.show_help = value

		if ("next_page")
			src.page = max(min(src.page + 1, src._pages()), 1)

		if ("prev_page")
			src.page = max(min(src.page - 1, src._pages()), 1)

		if ("last_page")
			src.page = src._pages()
		if ("first_page")
			src.page = 1

	return 1