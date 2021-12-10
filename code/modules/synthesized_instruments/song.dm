/datum/synthesized_song
	var/list/lines = list()
	var/tempo = 5

	var/playing = 0
	var/autorepeat = 0
	var/current_line = 0

	var/datum/sound_player/player // Not a physical thing
	var/datum/instrument/instrument_data

	var/linear_decay = 1
	var/sustain_timer = 1
	var/soft_coeff = 2.0
	var/transposition = 0

	var/octave_range_min
	var/octave_range_max

	var/sound_id

	var/available_channels //Alright, this basically starts as the max config value and we will decrease and increase at runtime


/datum/synthesized_song/New(datum/sound_player/playing_object, datum/instrument/instrument)
	src.player = playing_object
	src.instrument_data = instrument
	src.octave_range_min = GLOB.musical_config.lowest_octave
	src.octave_range_max = GLOB.musical_config.highest_octave
	instrument.create_full_sample_deviation_map()
	available_channels = GLOB.musical_config.channels_per_instrument

/datum/synthesized_song/Destroy()
	player.event_manager.deactivate()
	return ..()

/datum/synthesized_song/proc/sanitize_tempo(new_tempo) // Identical to datum/song
	new_tempo = abs(new_tempo)
	return max(round(new_tempo, world.tick_lag), world.tick_lag)


/datum/synthesized_song/proc/play_synthesized_note(note, acc, oct, duration, where, which_one)
	if (oct < GLOB.musical_config.lowest_octave || oct > GLOB.musical_config.highest_octave)	return
	if (oct < src.octave_range_min || oct > src.octave_range_max)	return

	var/delta1 = acc == "b" ? -1 : acc == "#" ? 1 : acc == "s" ? 1 : acc == "n" ? 0 : 0
	var/delta2 = 12 * oct

	var/note_num = delta1+delta2+GLOB.musical_config.nn2no[note]
	if (note_num < 0 || note_num > 127)
		CRASH("play_synthesized note failed because of 0..127 condition, [note], [acc], [oct]")

	var/datum/sample_pair/pair = src.instrument_data.sample_map[GLOB.musical_config.n2t(note_num)]
	#define Q 0.083 // 1/12
	var/freq = 2**(Q*pair.deviation)
	#undef Q

	src.play(pair.sample, duration, freq, note_num, where, which_one)


/datum/synthesized_song/proc/play(what, duration, frequency, which, where, which_one)
	if(available_channels <= 0) //Ignore requests for new channels if we go over limit
		return
	available_channels -= 1
	src.sound_id = "[type]_[sequential_id(type)]"


	var/sound/sound_copy = sound(what)
	sound_copy.wait = 0
	sound_copy.repeat = 0
	sound_copy.frequency = frequency

	player.apply_modifications(sound_copy, which, where, which_one)
	//Environment, anything other than -1 means override
	var/use_env = 0

	if(isnum(sound_copy.environment) && sound_copy.environment <= -1)
		sound_copy.environment = 0 // set it to 0 and just not set use env
	else
		use_env = 1

	var/current_volume = Clamp(sound_copy.volume, 0, 100)
	sound_copy.volume = current_volume //Sanitize volume
	var/datum/sound_token/token = new /datum/sound_token/instrument(src.player.actual_instrument, src.sound_id, sound_copy, src.player.range, FALSE, use_env, player)
	var/delta_volume = player.volume / src.sustain_timer

	var/tick = duration
	while ((current_volume > 0) && token)
		var/new_volume = current_volume
		tick += world.tick_lag
		if (delta_volume <= 0)
			CRASH("Delta Volume somehow was non-positive: [delta_volume]")
		if (src.soft_coeff <= 1)
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
		src.player.event_manager.push_event(src.player, token, tick, current_volume)
		if (current_volume <= 0)
			break


#define CP(L, S) copytext_char(L, S, S+1)
#define IS_DIGIT(L) (L >= "0" && L <= "9" ? 1 : 0)

#define STOP_PLAY_LINES \
	autorepeat = 0 ;\
	playing = 0 ;\
	current_line = 0 ;\
	player.event_manager.deactivate() ;\
	return

/datum/synthesized_song/proc/play_lines(mob/user, list/allowed_suff, list/note_off_delta, list/lines)
	if (!lines.len)
		STOP_PLAY_LINES
	var/list/cur_accidentals = list("n", "n", "n", "n", "n", "n", "n")
	var/list/cur_octaves = list(3, 3, 3, 3, 3, 3, 3)
	src.current_line = 1
	for (var/line in lines)
		var/cur_note = 1
		if (src.player && src.player.actual_instrument)
			var/obj/structure/synthesized_instrument/S = src.player.actual_instrument
			var/datum/real_instrument/R = S.real_instrument
			if (R.song_editor)
				SSnano.update_uis(R.song_editor)
		for (var/notes in splittext(lowertext(line), ","))
			var/list/components = splittext(notes, "/")
			var/duration = sanitize_tempo(src.tempo)
			if (components.len)
				var/delta = components.len==2 && text2num(components[2]) ? text2num(components[2]) : 1
				var/note_str = splittext(components[1], "-")

				duration = sanitize_tempo(src.tempo / delta)
				src.player.event_manager.suspended = 1
				for (var/note in note_str)
					if (!note)	continue // wtf, empty note
					var/note_sym = CP(note, 1)
					var/note_off = 0
					if (note_sym in note_off_delta)
						note_off = text2ascii(note_sym) - note_off_delta[note_sym]
					else
						continue // Shitty note, move along and avoid runtimes

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
						STOP_PLAY_LINES
			cur_note++
			src.player.event_manager.suspended = 0
			if (!src.playing || src.player.shouldStopPlaying(user))
				STOP_PLAY_LINES
			sleep(duration)
		src.current_line++
	if (src.autorepeat)
		.()

#undef STOP_PLAY_LINES

/datum/synthesized_song/proc/play_song(mob/user)
	// This code is really fucking horrible.
	src.player.event_manager.activate()
	var/list/allowed_suff = list("b", "n", "#", "s")
	var/list/note_off_delta = list("a"=91, "b"=91, "c"=98, "d"=98, "e"=98, "f"=98, "g"=98)
	var/list/lines_copy = src.lines.Copy()
	addtimer(CALLBACK(src, .proc/play_lines, user, allowed_suff, note_off_delta, lines_copy), 0)

#undef CP
#undef IS_DIGIT
