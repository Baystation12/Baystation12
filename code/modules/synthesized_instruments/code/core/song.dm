/datum/synthesized_song
	var/list/lines = list()
	var/tempo = 5

	var/playing = 0
	var/autorepeat = 0
	var/current_line = 0

	var/datum/sound_player/player // Not a physical thing
	var/datum/instrument/instrument_data

	var/list/free_channels = list()

	var/linear_decay = 1
	var/sustain_timer = 1
	var/soft_coeff = 2.0
	var/transposition = 0

	var/octave_range_min
	var/octave_range_max

	var/datum/musical_debug/debug_panel


/datum/synthesized_song/New(datum/sound_player/playing_object, datum/instrument/instrument)
	src.player = playing_object
	src.instrument_data = instrument
	src.octave_range_min = GLOB.musical_config.lowest_octave
	src.octave_range_max = GLOB.musical_config.highest_octave
	src.debug_panel = new (src)

	instrument.create_full_sample_deviation_map()
	src.occupy_channels()


/datum/synthesized_song/proc/sanitize_tempo(new_tempo) // Identical to datum/song
	new_tempo = abs(new_tempo)
	return max(round(new_tempo, world.tick_lag), world.tick_lag)


/datum/synthesized_song/proc/occupy_channels()
	if (!GLOB.musical_config.free_channels_populated)
		for (var/i=1 to 1024) // Currently only 1024 channels are allowed
			GLOB.musical_config.free_channels += i
		GLOB.musical_config.free_channels_populated = 1 // Only once

	for (var/i=1 to GLOB.musical_config.channels_per_instrument)
		if (GLOB.musical_config.free_channels.len)
			src.free_channel(pick_n_take(GLOB.musical_config.free_channels))


/datum/synthesized_song/proc/take_any_channel()
	return pick_n_take(src.free_channels)


/datum/synthesized_song/proc/free_channel(channel)
	if (channel in src.free_channels) return
	src.free_channels += channel


/datum/synthesized_song/proc/return_all_channels()
	GLOB.musical_config.free_channels |= src.free_channels
	src.free_channels.Cut()


/datum/synthesized_song/proc/play_synthesized_note(note, acc, oct, duration, where, which_one)
	if (oct < GLOB.musical_config.lowest_octave || oct > GLOB.musical_config.highest_octave)	return
	if (oct < src.octave_range_min || oct > src.octave_range_max)	return

	var/delta1 = acc == "b" ? -1 : acc == "#" ? 1 : acc == "s" ? 1 : acc == "n" ? 0 : 0
	var/delta2 = 12 * oct

	var/note_num = delta1+delta2+GLOB.musical_config.nn2no[note]
	if (note_num < 0 || note_num > 127)
		src.debug_panel.append_message(text("Play synthesized note failed because of 0..127 condition, [] [] []", note, acc, oct))
		return

	var/datum/sample_pair/pair = src.instrument_data.sample_map[GLOB.musical_config.n2t(note_num)]
	#define Q 0.083 // 1/12
	var/freq = 2**(Q*pair.deviation)
	var/chan = src.take_any_channel()
	if (!chan)
		if (!src.player.channel_overload())
			src.playing = 0
			src.autorepeat = 0
			src.debug_panel.append_message("All channels were exhausted")
			return
	#undef Q
	var/list/mob/to_play_for = src.player.who_to_play_for()

	if (!to_play_for.len)
		src.free_channel(chan) // I'm an idiot, fuck
		return

	for (var/mob/hearer in to_play_for)
		src.play_for(hearer, pair.sample, duration, freq, chan, note_num, where, which_one)


/datum/synthesized_song/proc/play_for(mob/who, what, duration, frequency, channel, which, where, which_one)
	var/sound/sound_copy = sound(what)
	sound_copy.wait = 0
	sound_copy.repeat = 0
	sound_copy.frequency = frequency
	sound_copy.channel = channel
	player.apply_modifications_for(who, sound_copy, which, where, which_one)

	who << sound_copy
	#if DM_VERSION < 511
	sound_copy.frequency = 1
	#endif
	/*
	spawn(duration)
		var/delta_volume = player.volume / sustain_timer
		var/stored_soft_coeff = soft_coeff
		var/stored_linear_decay = linear_decay
		while (playing)
			sleep(1)
			if (stored_linear_decay)
				sound_copy.volume = max(sound_copy.volume - delta_volume, 0)
			else
				sound_copy.volume = max(round(sound_copy.volume / stored_soft_coeff), 0)
			if (sound_copy.volume > 0)
				sound_copy.status |= SOUND_UPDATE
				who << sound_copy
			else
				break
		free_channel(sound_copy.channel)
		who << sound(channel=sound_copy.channel, wait=0)

		// Made obsolete by new manual event scheduler
		// Also lagged as shit
	*/
	var/delta_volume = player.volume / src.sustain_timer
	var/current_volume = max(round(sound_copy.volume), 0)
	var/tick = duration
	while (current_volume > 0)
		var/new_volume = current_volume
		tick += world.tick_lag
		if (delta_volume <= 0)
			src.debug_panel.append_message("Delta Volume somehow was non-positive: [delta_volume]")
			break
		if (src.soft_coeff <= 1)
			src.debug_panel.append_message("Soft Coeff somehow was <=1: [src.soft_coeff]")
			break

		if (src.linear_decay)
			new_volume = new_volume - delta_volume
		else
			new_volume = new_volume / src.soft_coeff

		var/sanitized_volume = max(round(new_volume), 0)
		if (sanitized_volume == current_volume)
			current_volume = new_volume
			continue
		current_volume = sanitized_volume
		src.player.event_manager.push_event(src.player, who, sound_copy, tick, current_volume)
		if (current_volume <= 0)
			break


#define CP(L, S) copytext(L, S, S+1)
#define IS_DIGIT(L) (L >= "0" && L <= "9" ? 1 : 0)
#define SAFETY_CHECK if (!src.lines.len || src.player.event_manager.is_overloaded()) {goto Stop}

/datum/synthesized_song/proc/play_song(mob/user)
	// This code is really fucking horrible.
	src.player.cache_unseen_tiles()
	src.player.event_manager.activate()
	var/list/allowed_suff = list("b", "n", "#", "s")
	var/list/note_off_delta = list("a"=91, "b"=91, "c"=98, "d"=98, "e"=98, "f"=98, "g"=98)
	var/list/lines_copy = src.lines.Copy()
	spawn()
		Start
		if (!lines_copy.len) goto Stop
		var/list/cur_accidentals = list("n", "n", "n", "n", "n", "n", "n")
		var/list/cur_octaves = list(3, 3, 3, 3, 3, 3, 3)
		src.current_line = 1
		for (var/line in lines_copy)
			var/cur_note = 1
			if (src.player && src.player.actual_instrument)
				var/obj/structure/synthesized_instrument/S = src.player.actual_instrument // Fuck, this is horrible.
				if (S.song_editor)
					GLOB.nanomanager.update_uis(S.song_editor)
			for (var/notes in splittext(lowertext(line), ","))
				var/list/components = splittext(notes, "/")
				var/delta = components.len==2 && text2num(components[2]) ? text2num(components[2]) : 1
				var/note_str = splittext(components[1], "-")

				var/duration = sanitize_tempo(src.tempo / delta)
				src.player.event_manager.suspended = 1
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
					play_synthesized_note(note_off, accidental, octave+transposition, duration, src.current_line, cur_note)
					if (src.player.event_manager.is_overloaded())
						goto Stop
				cur_note++
				src.player.event_manager.suspended = 0
				if (!src.playing || src.player.shouldStopPlaying(user)) goto Stop
				sleep(duration)
			src.current_line++
		if (src.autorepeat)
			goto Start

		Stop
		src.autorepeat = 0
		src.playing = 0
		src.current_line = 0
		src.player.event_manager.deactivate()

#undef CP
#undef IS_DIGIT
#undef SAFETY_CHECK