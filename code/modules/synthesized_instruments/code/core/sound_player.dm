#define OUTBOUNDS_CHECK(var, min, max) !(var in min to max)
#define CP(L, S) copytext(L, S, S+1)
#define IS_DIGIT(L) (L >= "0" && L <= "9" ? 1 : 0)
// God object much, huh?
/namespace/synthesized_instruments/player
	var/range = 15
	var/volume_falloff_exponent = 0.9
	var/falloff = 2
	var/three_dimensional_sound = 1
	var/apply_echo = 0
	var/env_preset = -1
	var/env[23]
	var/echo[18]

	/*
	This needs an explanation.
	This is beyond dumb, this is fucking retarded.
	Basically when you send a sound with a non-minus-one environment to a client, it sets their _global_ environment value to whatever you sent to them
	So ALL sounds will have this environment setting assigned afterwards.
	You could sort of hear it if you were standing in a hallway and got a PM or something.
	*/


	var/namespace/synthesized_instruments/instrument/instrument_data
	var/namespace/synthesized_instruments/manager/event/event_manager
	var/namespace/synthesized_instruments/manager/effect/effect_manager
	var/namespace/synthesized_instruments/manager/ADSR/ADSR_manager
	var/namespace/synthesized_instruments/manager/player/player_manager

	var/datum/nano_module/song_editor/song_editor
	var/datum/nano_module/usage_info/usage_info

	var/sustain_mode
	var/sustain_timer = 1
	var/soft_coeff = 2.0
	var/transposition = 0

	var/namespace/synthesized_instruments/bound/octave_range = new {min = 0; max = 9; is_integer = 1}
	var/namespace/synthesized_instruments/bound/volume_range = new {min = 0; max = 100; is_integer = 0} // 100 is actually painfully loud


/namespace/synthesized_instruments/player/New(obj/actual_instrument, datum/instrument/default_instrument)
	src.actual_instrument = actual_instrument
	src.echo = GLOB.synthesized_instruments.echo.echo_default.Copy()
	src.env = GLOB.synthesized_instruments.environment.env_default.Copy()
	src.volume = src.volume_range.max

	default_instrument.create_full_sample_deviation_map()
	src.instrument_data = default_instrument


/namespace/synthesized_instruments/player/proc/play_synthesized_note(note, accidental_char, octave, duration)
	var/static/list/NOTE_NUM_TO_NOTE_OFFSET = list(0,2,4,5,7,9,11)
	var/static/OCTAVE_CONST = round(1/12, 10**-3)

	if (GLOB.synthesized_instruments.bounds.octave_range.in_bounds(octave)) return
	if (src.octave_range.in_bounds(octave)) return

	var/delta1 = 0
	switch(accidental_char)
		if ("b") delta = -1
		if ("#") delta = 1
		if ("s") delta = 1
		if ("n") delta = 0

	var/delta2 = 12 * octave

	var/note_num = delta1+delta2+NOTE_NUM_TO_NOTE_OFFSET
	if (note_num in 0 to 127)
		CRASH("play_synthesized note failed because of 0..127 condition")
		return

	var/datum/sample_pair/pair = src.instrument_data.sample_map[num2text(note_num)]
	var/freq = 2**(OCTAVE_CONST*pair.deviation)
	var/chan = pick_n_take(src.free_channels)
	if (!chan)
		src.playing = 0
		src.autorepeat = 0
		return

	var/list/mob/to_play_for = src.player.who_to_play_for()

	if (!to_play_for.len)
		src.free_channel(chan) // I'm an idiot, fuck
		return

	for (var/mob/hearer in to_play_for)
		var/sound/sound_copy = sound(pair.sample)
		sound_copy.wait = 0
		sound_copy.repeat = 0
		sound_copy.frequency = freq
		sound_copy.channel = chan
		// src.apply_modifications_for(hearer, sound_copy, note_index, line_index, note_name) -- Music Code is unused for now
		src.apply_modifications_for(hearer, sound_copy)

		sound_to(receiver, sound_copy)
		#if DM_VERSION < 511
		// Shit broke when I updated BYOND to 511
		// It took me forever to track down the issue
		sound_copy.frequency = 1
		#endif
		var/delta_volume = player.volume / src.sustain_timer
		var/current_volume = max(round(sound_copy.volume), 0)
		var/tick = duration
		while (current_volume > 0)
			var/new_volume = current_volume
			tick += world.tick_lag
			if (0 >= delta_volume)
				CRASH("Delta Volume somehow was non-positive: [delta_volume]")
			if (1 >= src.soft_coeff)
				CRASH("Soft Coeff somehow was <=1: [src.soft_coeff]")
			if (src.linear_decay)
				new_volume = new_volume - delta_volume
			else
				new_volume = new_volume / src.soft_coeff

			var/sanitized_volume = max(round(new_volume), 0)
			if (sanitized_volume == current_volume)
				current_volume = new_volume
				continue
			current_volume = sanitized_volume
			src.event_manager.push_event(src, who, sound_copy, tick, current_volume)


/namespace/synthesized_instruments/player/Destroy()
	src.song.playing = 0
	src.present_listeners.Cut()
	src.stored_locations.Cut()
	src.actual_instrument = null
	src.instrument = null
	sleep(1)
	for (var/channel in src.song.free_channels)
		GLOB.musical_config.free_channels += channel // Deoccupy channels
	song = null
	qdel(song)
	return ..()


/namespace/synthesized_instruments/player/proc/apply_modifications_for(mob/who, sound/what, note_num, which_line, which_note) // You don't need to override this
	var/mod = (get_dist_euclidian(who, get_turf(src.actual_instrument))-1) / src.range
	what.volume = volume / (100**mod**src.volume_falloff_exponent)
	if (get_turf(who) in stored_locations)
		what.volume /= 10 // Twice as low

	if (src.three_dimensional_sound)
		what.falloff = falloff
		var/turf/source = get_turf(src.actual_instrument)
		var/turf/receiver = get_turf(who)
		var/dx = source.x - receiver.x // Hearing from the right/left
		what.x = dx

		var/dz = source.y - receiver.y // Hearing from infront/behind
		what.z = dz

		what.y = 1
	if (GLOB.musical_config.env_settings_available)
		what.environment = GLOB.musical_config.is_custom_env(src.virtual_environment_selected) ? src.env : src.virtual_environment_selected
	if (src.apply_echo)
		what.echo = src.echo
	return


/namespace/synthesized_instruments/player/proc/play_song(mob/user)
	// This code is really fucking horrible.
	src.cache_unseen_tiles()
	src.event_manager.activate()
	var/global/list/allowed_suff = list("b", "n", "#", "s")
	var/global/list/note_off_delta = list("a"=91, "b"=91, "c"=98, "d"=98, "e"=98, "f"=98, "g"=98)
	var/list/lines_copy = src.lines.Copy()
	spawn()
		Start
		if (!lines_copy.len) goto Stop
		var/list/cur_accidentals = list("n", "n", "n", "n", "n", "n", "n")
		var/list/cur_octaves = list(3, 3, 3, 3, 3, 3, 3)
		src.current_line = 1
		for (var/line in lines_copy)
			var/cur_note = 1
			if (src && src.actual_instrument)
				var/obj/structure/synthesized_instrument/S = src.actual_instrument // Fuck, this is horrible.
				if (S.song_editor)
					GLOB.nanomanager.update_uis(S.song_editor)
			for (var/notes in splittext(lowertext(line), ","))
				var/list/components = splittext(notes, "/")
				var/delta = components.len==2 && text2num(components[2]) ? text2num(components[2]) : 1
				var/note_str = splittext(components[1], "-")

				var/duration = sanitize_tempo(src.tempo / delta)
				src.event_manager.suspended = 1
				for (var/note in note_str)
					if (!note)	continue // wtf, empty note
					var/note_sym = CP(note, 1)
					var/note_off = 0
					if (note_sym in note_off_delta)
						note_off = text2ascii(note_sym) - note_off_delta[note_sym]

					var/octave = cur_octaves[note_off]
					var/accidental = cur_accidentals[note_off]

					switch (length(note))
						if (3)
							accidental = CP(note, 2)
							octave = CP(note, 3)
							if (!(accidental in allowed_suff) || !IS_DIGIT(octave))
								continue
							else
								octave = text2num(octave)
						if (2)
							if (IS_DIGIT(CP(note, 2)))
								octave = text2num(CP(note, 2))
							else
								accidental = CP(note, 2)
								if (!(accidental in allowed_suff))
									continue
					cur_octaves[note_off] = octave
					cur_accidentals[note_off] = accidental
					// play_synthesized_note(note_off, accidental, octave+transposition, duration, src.current_line, cur_note) -- Music Code is not used
					if (src.player.event_manager.is_overloaded())
						goto Stop
				cur_note++
				src.player.event_manager.suspended = 0
				if (!src.playing || src.shouldStopPlaying(user)) goto Stop
				sleep(duration)
			src.current_line++
		if (src.autorepeat)
			goto Start

		Stop
		src.autorepeat = 0
		src.playing = 0
		src.current_line = 0
		src.event_manager.deactivate()


/namespace/synthesized_instruments/player/proc/Topic(href, href_list)
	var/static/sanitize_tempo = GLOB.synthesized_instruments.functions.sanitize_tempo
	var/mob/user = usr
	if (!istype(user)) // What the fuck
		return 0

	var/target = href_list["target"]
	var/value = text2num(href_list["value"])
	if (href_list["value"] && !isnum(value))
		to_chat(usr, "Invalid input")
		return 0

	src.actual_instrument.add_fingerprint(usr)

	switch (target)
		if ("tempo") src.tempo = sanitize_tempo(src.tempo + value*world.tick_lag)

		if ("play")
			src.playing = value
			if (src.playing)
				src.play_song(usr)

		if ("newsong")
			src.player.song.lines.Cut()
			src.player.song.tempo = sanitize_tempo(5) // default 120 BPM

		if ("import")
			var/t = ""
			do
				t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", name), t)  as message)
				if(!in_range(src, usr))
					return

				if(2*src.maximum_lines*src.maximum_line_length <= length(t))
					var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
					if(cont == "no")
						break
			while(2*src.maximum_lines*src.maximum_line_length < length(t))
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

		else
			return 0

	return 1


/namespace/synthesized_instruments/player/proc/shouldStopPlaying(mob/user)
	return actual_instrument:shouldStopPlaying(user)
#undef OUTBOUNDS_CHECK
#undef CP
#undef IS_DIGIT
