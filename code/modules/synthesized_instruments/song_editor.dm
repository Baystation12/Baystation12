/datum/nano_module/song_editor
	name = "Song Editor"
	available_to_ai = 0
	var/datum/synthesized_song/song
	var/show_help = 0
	var/page = 1


/datum/nano_module/song_editor/New(atom/source, datum/synthesized_song/song)
	src.host = source
	src.song = song


/datum/nano_module/song_editor/proc/pages()
	return Ceiling(src.song.lines.len / global.musical_config.song_editor_lines_per_page)


/datum/nano_module/song_editor/proc/current_page()
	return src.song.current_line > 0 ? Ceiling(src.song.current_line / global.musical_config.song_editor_lines_per_page) : src.page


/datum/nano_module/song_editor/proc/page_bounds(page_num)
	return list(
		max(1 + global.musical_config.song_editor_lines_per_page * (page_num-1), 1),
		min(global.musical_config.song_editor_lines_per_page * page_num, src.song.lines.len))


/datum/nano_module/song_editor/ui_interact(mob/user, ui_key = "song_editor", var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list()

	var/current_page = src.current_page()
	var/list/line_bounds = src.page_bounds(src.current_page())

	data["lines"] = src.song.lines.Copy(line_bounds[1], line_bounds[2]+1)
	data["active_line"] = src.song.current_line
	data["max_lines"] = global.musical_config.max_lines
	data["max_line_length"] = global.musical_config.max_line_length
	data["tick_lag"] = world.tick_lag
	data["show_help"] = src.show_help
	data["page_num"] = current_page
	data["page_offset"] = global.musical_config.song_editor_lines_per_page * (current_page-1)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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
		src.song.debug_panel.append_message("Non-numeric value was supplied")
		return 0

	switch (target)
		if("newline")
			var/newline = html_encode(input(usr, "Enter your line: ") as text|null)
			if(!newline)
				return
			if(src.song.lines.len > global.musical_config.max_lines)
				return
			if(length(newline) > global.musical_config.max_line_length)
				newline = copytext(newline, 1, global.musical_config.max_line_length)
			src.song.lines.Add(newline)

		if("deleteline")
			// This could kill the server if the synthesizer was playing, props to BeTePb
			// Impossible to do now. Dumbing down this section.
			var/num = round(value)
			if(num > src.song.lines.len || num < 1)
				return
			src.song.lines.Cut(num, num+1)

		if("modifyline")
			var/num = round(value)
			if(num > src.song.lines.len || num < 1)
				return
			var/content = html_encode(input(usr, "Enter your line: ", "Edit line", src.song.lines[num]) as text|null)
			if(!content)
				return
			if(length(content) > global.musical_config.max_line_length)
				content = copytext(content, 1, global.musical_config.max_line_length)
			src.song.lines[num] = content

		if ("help")
			src.show_help = value

		if ("next_page")
			src.page = max(min(src.page + 1, src.pages()), 1)

		if ("prev_page")
			src.page = max(min(src.page - 1, src.pages()), 1)

		if ("last_page")
			src.page = src.pages()
		if ("first_page")
			src.page = 1

	return 1