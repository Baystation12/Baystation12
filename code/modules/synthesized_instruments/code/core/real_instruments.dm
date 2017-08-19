/obj/structure/synthesized_instrument
	var/datum/sound_player/player
	var/datum/nano_module/song_editor/song_editor
	var/datum/nano_module/usage_info/usage_info
	var/maximum_lines
	var/maximum_line_length


	Topic(href, href_list)
		if (..())
			return 1

		var/target = href_list["target"]
		var/value = text2num(href_list["value"])
		if (href_list["value"] && !isnum(value))
			src.player.song.debug_panel.append_message("Non-numeric value was supplied")
			return 0

		src.add_fingerprint(usr)

		switch (target)
			if ("tempo") src.player.song.tempo = src.player.song.sanitize_tempo(src.player.song.tempo + value*world.tick_lag)

			if ("play")
				src.player.song.playing = value
				if (src.player.song.playing)
					src.player.song.play_song(usr)

			if ("newsong")
				src.player.song.lines.Cut()
				src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM

			if ("import")
				var/t = ""
				do
					t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", name), t)  as message)
					if(!in_range(src, usr))
						return

					if(length(t) >= 2*src.maximum_lines*src.maximum_line_length)
						var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
						if(cont == "no")
							break
				while(length(t) > 2*src.maximum_lines*src.maximum_line_length)
				if (length(t))
					src.player.song.lines = splittext(t, "\n")
					if(copytext(src.player.song.lines[1],1,6) == "BPM: ")
						if(text2num(copytext(src.player.song.lines[1],6)) != 0)
							src.player.song.tempo = src.player.song.sanitize_tempo(600 / text2num(copytext(src.player.song.lines[1],6)))
							src.player.song.lines.Cut(1,2)
						else
							src.player.song.tempo = src.player.song.sanitize_tempo(5)
					else
						src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
					if(src.player.song.lines.len > maximum_lines)
						to_chat(usr, "Too many lines!")
						src.player.song.lines.Cut(maximum_lines+1)
					var/linenum = 1
					for(var/l in src.player.song.lines)
						if(length(l) > maximum_line_length)
							to_chat(usr, "Line [linenum] too long!")
							src.player.song.lines.Remove(l)
						else
							linenum++

			if ("show_song_editor")
				if (!src.song_editor)
					src.song_editor = new (src, src.player.song)
				src.song_editor.ui_interact(usr)

			if ("show_usage")
				if (!src.usage_info)
					src.usage_info = new (src, src.player)
				src.usage_info.ui_interact(usr)

			if ("debug")
				if (!GLOB.musical_config.debug_active)
					to_chat("Debug flag is set to 0.")

				else if (src.player.song.debug_panel)
					var/password = input(usr, "Enter password to access debug") as text
					var/hash = md5(password)
					if (GLOB.musical_config.debug_password_hash == hash)
						src.player.song.debug_panel.access_panel(usr)
					else
						to_chat(usr, "Wrong password")
			else
				return 0

		return 1


	New()
		..()
		src.maximum_lines = GLOB.musical_config.max_lines
		src.maximum_line_length = GLOB.musical_config.max_line_length


	Destroy()
		qdel(src.player)
		return ..()


	attack_hand(mob/user)
		src.ui_interact(user)


	ui_interact(mob/user)
		return 0


	proc/shouldStopPlaying(mob/user)
		return 0


/obj/item/device/synthesized_instrument
	var/datum/sound_player/player
	var/datum/nano_module/song_editor/song_editor
	var/datum/nano_module/usage_info/usage_info
	var/maximum_lines
	var/maximum_line_length


	Topic(href, href_list)
		if (..())
			return 1

		var/target = href_list["target"]
		var/value = text2num(href_list["value"])
		if (href_list["value"] && !isnum(value))
			src.player.song.debug_panel.append_message("Non-numeric value was supplied")
			return 0

		src.add_fingerprint(usr)

		switch (target)
			if ("tempo") src.player.song.tempo = src.player.song.sanitize_tempo(src.player.song.tempo + value*world.tick_lag)

			if ("play")
				src.player.song.playing = value
				if (src.player.song.playing)
					src.player.song.play_song(usr)

			if ("newsong")
				src.player.song.lines.Cut()
				src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM

			if ("import")
				var/t = ""
				do
					t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", name), t)  as message)
					if(!in_range(src, usr))
						return

					if(length(t) >= 2*src.maximum_lines*src.maximum_line_length)
						var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
						if(cont == "no")
							break
				while(length(t) > 2*src.maximum_lines*src.maximum_line_length)
				if (length(t))
					src.player.song.lines = splittext(t, "\n")
					if(copytext(src.player.song.lines[1],1,6) == "BPM: ")
						if(text2num(copytext(src.player.song.lines[1],6)) != 0)
							src.player.song.tempo = src.player.song.sanitize_tempo(600 / text2num(copytext(src.player.song.lines[1],6)))
							src.player.song.lines.Cut(1,2)
						else
							src.player.song.tempo = src.player.song.sanitize_tempo(5)
					else
						src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
					if(src.player.song.lines.len > maximum_lines)
						to_chat(usr, "Too many lines!")
						src.player.song.lines.Cut(maximum_lines+1)
					var/linenum = 1
					for(var/l in src.player.song.lines)
						if(length(l) > maximum_line_length)
							to_chat(usr, "Line [linenum] too long!")
							src.player.song.lines.Remove(l)
						else
							linenum++

			if ("show_song_editor")
				if (!src.song_editor)
					src.song_editor = new (src, src.player.song)
				src.song_editor.ui_interact(usr)

			if ("show_usage")
				if (!src.usage_info)
					src.usage_info = new (src, src.player)
				src.usage_info.ui_interact(usr)

			if ("debug")
				if (!GLOB.musical_config.debug_active)
					to_chat(usr, "Debug flag is set to 0.")

				else if (src.player.song.debug_panel)
					var/password = input(usr, "Enter password to access debug") as text
					var/hash = md5(password)
					if (GLOB.musical_config.debug_password_hash == hash)
						src.player.song.debug_panel.access_panel(usr)
					else
						to_chat(usr, "Wrong password")
			else
				return 0

		return 1


	New()
		..()
		src.maximum_lines = GLOB.musical_config.max_lines
		src.maximum_line_length = GLOB.musical_config.max_line_length


	Destroy()
		qdel(src.player)
		return ..()


	attack_hand(mob/user)
		src.ui_interact(user)


	ui_interact(mob/user)
		return 0


	proc/shouldStopPlaying(mob/user)
		return 0