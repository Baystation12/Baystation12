/datum/sound_player/synthesizer
	forced_sound_in = 0
	var/list/datum/music_code/code = list()


/datum/sound_player/synthesizer/apply_modifications_for(mob/who, sound/what, which, where, which_one)
	..(who, what, which)
	for (var/datum/music_code/cond in code)
		if (cond.test(which, where, which_one))
			var/datum/sample_pair/pair = cond.instrument.sample_map[GLOB.musical_config.n2t(which)]
			what.file = pair.sample



/datum/sound_player/synthesizer/torture
	forced_sound_in = 2


#define LESSER 1
#define EQUAL 2
#define GREATER 3
#define COMPARE(alpha, beta) ((alpha)<(beta) ? LESSER : (alpha)==(beta) ? EQUAL : GREATER)

/datum/music_code
	var/octave = null
	var/octave_condition = null
	var/line_num = null
	var/line_condition = null
	var/line_note_num = null
	var/line_note_condition = null
	var/datum/instrument/instrument = null


/datum/music_code/proc/test(note_num, line_num, line_note_num)
	var/result = 1
	if (src.octave!=null && src.octave_condition)
		var/cur_octave = round(note_num * 0.083)
		if (COMPARE(cur_octave, octave) != octave_condition)
			result = 0
	if (src.line_num && src.line_condition)
		if (COMPARE(line_num, src.line_num) != line_condition)
			result = 0
	if (src.line_note_num && src.line_note_condition)
		if (COMPARE(line_num, src.line_note_num) != line_note_condition)
			result = 0
	return result


/datum/music_code/proc/octave_code()
	if (src.octave!=null)
		var/sym = (octave_condition==LESSER ? "<" :
		           octave_condition==EQUAL ? "=" :
		           octave_condition==GREATER ? ">" : null)
		return "O[sym][octave]"
	return ""


/datum/music_code/proc/line_num_code()
	if (src.line_num)
		var/sym = (line_condition==LESSER ? "<" :
		           line_condition==EQUAL ? "=" :
		           line_condition==GREATER ? ">" : null)
		return "L[sym][line_num]"
	return ""


/datum/music_code/proc/line_note_num_code()
	if (src.line_note_num)
		var/sym = (line_note_condition==LESSER ? "<" :
		           line_note_condition==EQUAL ? "=" :
		           line_note_condition==GREATER ? ">" : null)
		return "N[sym][line_note_num]"
	return ""



#undef LESSER
#undef EQUAL
#undef GREATER
#undef COMPARE

/obj/structure/synthesized_instrument/synthesizer
	name = "The Synthesizer 3.0"
	desc = "This thing emits shockwaves as it plays. This is not good for your hearing."
	icon = 'code/modules/synthesized_instruments/real_instruments/Synthesizer/icons/synthesizer.dmi'
	icon_state = "synthesizer"
	anchored = 1
	density = 1
	var/datum/instrument/instruments = list()
	var/datum/nano_module/env_editor/env_editor
	var/datum/nano_module/echo_editor/echo_editor

/obj/structure/synthesized_instrument/synthesizer/New()
	..()
	for (var/type in typesof(/datum/instrument))
		var/datum/instrument/new_instrument = new type
		if (!new_instrument.id) continue
		new_instrument.create_full_sample_deviation_map()
		src.instruments[new_instrument.name] = new_instrument
	src.player = new /datum/sound_player/synthesizer(src, instruments[pick(instruments)])


/obj/structure/synthesized_instrument/synthesizer/attackby(obj/item/O, mob/user, params)
	if (istype(O, /obj/item/weapon/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to tighten \the [src] to the floor...</span>"
			if (do_after(user, 20))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"<span class='notice'> You tighten \the [src]'s casters. Now it can be played again.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				src.anchored = 1
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to loosen \the [src]'s casters...</span>"
			if (do_after(user, 40))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"<span class='notice'> You loosen \the [src]. Now it can be pulled somewhere else.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				src.anchored = 0
	else
		..()


/obj/structure/synthesized_instrument/synthesizer/proc/compose_code(var/html=0)
	var/code = ""
	var/line_number = 1
	if (src.player:code:len)
		// Find instruments involved and create a list of statements
		var/list/list/datum/music_code/statements = list() // Instruments involved
		for (var/datum/music_code/this_code in src.player:code)
			if (statements[this_code.instrument.id])
				statements[this_code.instrument.id] += this_code
			else
				statements[this_code.instrument.id] = list(this_code)

		// Each instrument statement is split by ;\n or ;<br> in this case
		// Each statement is in parenthesises and separated by |
		// Statements have up to 3 conditions separated by &

		for (var/instrument_id in statements)
			var/conditions = ""
			for (var/datum/music_code/cond in statements[instrument_id])
				var/sub_code = "("
				var/octave_code = cond.octave_code()
				var/line_code = cond.line_num_code()
				var/line_note_code = cond.line_note_num_code()
				sub_code += octave_code ? octave_code+"|" : ""
				sub_code += line_code ? line_code + "|" : ""
				sub_code += line_note_code
				sub_code = copytext(sub_code, 1, -1)
				sub_code += ")"
				conditions = sub_code + " & "
			conditions = copytext(conditions, 1, -3)
			code = code + (html ? "[line_number]: " : "") + conditions + " -> " + (instrument_id + (html ? "<br>" : "\n"))
			line_number++
	return code


/obj/structure/synthesized_instrument/synthesizer/proc/decompose_code(code, mob/blame)
	if (length(code) > 10000)
		blame << "This code is WAAAAY too long."
		return
	code = replacetext(code, " ", "")
	code = replacetext(code, "(", "")
	code = replacetext(code, ")", "")

	var/list/instruments_ids = list()
	var/list/datum/instrument/instruments_by_id = list()
	for (var/ins in instruments)
		var/datum/instrument/instr = instruments[ins]
		instruments_by_id[instr.id] = instr
		instruments_ids += instr.id

	var/line = 1
	var/list/datum/music_code/conditions = list()
	for (var/super_statement in splittext(code, "\n"))
		var/list/delta = splittext(super_statement, "->")
		if (delta.len==0)
			blame << "Line [line]: Empty super statement"
			return
		if (delta.len==1)
			blame << "Line [line]: Not enough parameters in super statement"
			return
		if (delta.len>2)
			blame << "Line [line]: Too many parameters in super statement"
			return
		var/id = delta[2]
		if (!(id in instruments_ids))
			blame << "Line [line]: Unknown ID. [id]"
			return

		for (var/statements in splittext(delta[1], "|"))
			var/datum/music_code/new_condition = new

			for (var/property in splittext(statements, "&"))
				if (length(property) < 3)
					blame << "Line [line]: Invalid property [property]"
					return
				var/variable = copytext(property, 1, 2)
				if (variable != "O" && variable != "N" && variable != "L")
					blame << "Line [line]: Unknown variable [variable] in [property]"
					return
				var/operator = copytext(property, 2, 3)
				if (operator != "<" && operator != ">" && operator != "=")
					blame << "Line [line]: Unknown operator [operator] in [property]"
					return
				var/list/que = splittext(property, operator)
				var/value = que[2]
				operator = operator=="<" ? 1 : operator=="=" ? 2 : 3
				if (num2text(text2num(value)) != value)
					blame << "Line [line]: Invalid value [value] in [property]"
					return
				value = text2num(value)
				switch(variable)
					if ("O")
						new_condition.octave = value
						new_condition.octave_condition = operator
					if ("N")
						new_condition.line_note_num = value
						new_condition.line_note_condition = operator
					if ("L")
						new_condition.line_num = value
						new_condition.line_condition = operator
			new_condition.instrument = instruments_by_id[id]
			conditions += new_condition
		line++
	src.player:code = conditions


/obj/structure/synthesized_instrument/synthesizer/ui_interact(mob/user, ui_key = "instrument", var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data
	data = list(
		"playback" = list(
			"playing" = src.player.song.playing,
			"autorepeat" = src.player.song.autorepeat,
			"three_dimensional_sound" = src.player.three_dimensional_sound
		),
		"basic_options" = list(
			"cur_instrument" = src.player.song.instrument_data.name,
			"volume" = src.player.volume,
			"BPM" = round(600 / src.player.song.tempo),
			"transposition" = src.player.song.transposition,
			"octave_range" = list(
				"min" = src.player.song.octave_range_min,
				"max" = src.player.song.octave_range_max
			)
		),
		"advanced_options" = list(
			"all_environments" = GLOB.musical_config.all_environments,
			"selected_environment" = GLOB.musical_config.id_to_environment(src.player.virtual_environment_selected),
			"apply_echo" = src.player.apply_echo
		),
		"sustain" = list(
			"linear_decay_active" = src.player.song.linear_decay,
			"sustain_timer" = src.player.song.sustain_timer,
			"soft_coeff" = src.player.song.soft_coeff
		),
		/*
		"code" = list(
			"code" = src.compose_code(html=1),
		),*/
		"show" = list(
			"playback" = src.player.song.lines.len > 0,
			"custom_env_options" = GLOB.musical_config.is_custom_env(src.player.virtual_environment_selected) && src.player.three_dimensional_sound,
			"debug_button" = GLOB.musical_config.debug_active,
			"env_settings" = GLOB.musical_config.env_settings_available
		),
		"status" = list(
			"channels" = src.player.song.free_channels.len,
			"events" = src.player.event_manager.events.len,
			"max_channels" = GLOB.musical_config.channels_per_instrument,
			"max_events" = GLOB.musical_config.max_events,
		)
	)
	/*
	var/list/ids = list()
	for (var/ins in src.instruments)
		var/datum/instrument/instr = instruments[ins]
		ids[instr.name] = instr.id
	data["code"]["ids"] = ids
	*/

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, "synthesizer.tmpl", src.name, 600, 800)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/structure/synthesized_instrument/synthesizer/Topic(href, href_list)
	if (..())
		return 1

	var/target = href_list["target"]
	var/value = text2num(href_list["value"])
	if (href_list["value"] && !isnum(value))
		src.player.song.debug_panel.append_message("Non-numeric value was supplied")
		return 0

	switch (target)
		if ("volume")
			src.player.volume = max(min(player.volume+text2num(value), 100), 0)
		if ("transposition")
			src.player.song.transposition = max(min(player.song.transposition+value, GLOB.musical_config.highest_transposition), GLOB.musical_config.lowest_transposition)
		if ("min_octave")
			src.player.song.octave_range_min = max(min(player.song.octave_range_min+value, GLOB.musical_config.highest_octave), GLOB.musical_config.lowest_octave)
			src.player.song.octave_range_max = max(player.song.octave_range_max, player.song.octave_range_min)
		if ("max_octave")
			src.player.song.octave_range_max = max(min(player.song.octave_range_max+value, GLOB.musical_config.highest_octave), GLOB.musical_config.lowest_octave)
			src.player.song.octave_range_min = min(player.song.octave_range_max, player.song.octave_range_min)
		if ("sustain_timer")
			src.player.song.sustain_timer = max(min(player.song.sustain_timer+value, GLOB.musical_config.longest_sustain_timer), 1)
		if ("soft_coeff")
			var/new_coeff = input(usr, "from [GLOB.musical_config.gentlest_drop] to [GLOB.musical_config.steepest_drop]") as num
			new_coeff = round(min(max(new_coeff, GLOB.musical_config.gentlest_drop), GLOB.musical_config.steepest_drop), 0.001)
			src.player.song.soft_coeff = new_coeff
		if ("instrument")
			var/list/categories = list()
			for (var/key in instruments)
				var/datum/instrument/instrument = instruments[key]
				categories |= instrument.category

			var/category = input(usr, "Choose a category") in categories as text|null
			var/list/instruments_available = list()
			for (var/key in instruments)
				var/datum/instrument/instrument = instruments[key]
				if (instrument.category == category)
					instruments_available += key

			var/new_instrument = input(usr, "Choose an instrument") in instruments_available as text|null
			if (new_instrument)
				src.player.song.instrument_data = instruments[new_instrument]
		if ("3d_sound") src.player.three_dimensional_sound = value
		if ("autorepeat") src.player.song.autorepeat = value
		if ("decay") src.player.song.linear_decay = value
		if ("echo") src.player.apply_echo = value
		if ("show_env_editor")
			if (GLOB.musical_config.env_settings_available)
				if (!src.env_editor)
					src.env_editor = new (src.player)
				src.env_editor.ui_interact(usr)
			else
				usr << "Virtual environment is disabled"

		if ("show_echo_editor")
			if (!src.echo_editor)
				src.echo_editor = new (src.player)
			src.echo_editor.ui_interact(usr)

		if ("select_env")
			if (value in -1 to 26)
				src.player.virtual_environment_selected = round(value)
		/*
		if ("show_code_editor") src.coding = value
		if ("show_ids") src.showing_ids = value
		if ("show_code_help") src.coding_help = value
		if ("edit_code")
			var/new_code = input(usr, "Program code", "Coding", src.compose_code()) as message
			src.decompose_code(new_code, usr)
		*/

	return 1


/obj/structure/synthesized_instrument/synthesizer/shouldStopPlaying(mob/user)
	return !((src && in_range(src, user) && src.anchored) || src.player.song.autorepeat)



/obj/structure/synthesized_instrument/synthesizer/mindbreaker
	New()
		..()
		qdel(src.player)
		src.player = new /datum/sound_player/synthesizer/torture(src, instruments[pick(instruments)])