/datum/sound_player/synthesizer
	forced_sound_in = 0

/datum/sound_player/synthesizer/torture
	forced_sound_in = 2

/obj/structure/synthesized_instrument/synthesizer
	name = "The Synthesizer 3.0"
	desc = "This thing emits shockwaves as it plays. This is not good for your hearing."
	icon = 'synthesizer.dmi'
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
			to_chat(usr, "<span class='notice'> You begin to tighten \the [src] to the floor...</span>")
			if (do_after(user, 20))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"<span class='notice'> You tighten \the [src]'s casters. Now it can be played again.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				src.anchored = 1
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, "<span class='notice'> You begin to loosen \the [src]'s casters...</span>")
			if (do_after(user, 40))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"<span class='notice'> You loosen \the [src]. Now it can be pulled somewhere else.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				src.anchored = 0
	else
		..()


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
		"show" = list(
			"playback" = src.player.song.lines.len > 0,
			"custom_env_options" = GLOB.musical_config.is_custom_env(src.player.virtual_environment_selected) && src.player.three_dimensional_sound,
			"env_settings" = GLOB.musical_config.env_settings_available
		),
		"status" = list(
			"channels" = src.player.song.free_channels.len,
			"events" = src.player.event_manager.events.len,
			"max_channels" = GLOB.musical_config.channels_per_instrument,
			"max_events" = GLOB.musical_config.max_events,
		)
	)


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
		to_chat(usr, "Non-numeric value was supplied")
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
				to_chat(usr, "Virtual environment is disabled")

		if ("show_echo_editor")
			if (!src.echo_editor)
				src.echo_editor = new (src.player)
			src.echo_editor.ui_interact(usr)

		if ("select_env")
			if (value in -1 to 26)
				src.player.virtual_environment_selected = round(value)


	return 1


/obj/structure/synthesized_instrument/synthesizer/shouldStopPlaying(mob/user)
	return !((src && in_range(src, user) && src.anchored) || src.player.song.autorepeat)



/obj/structure/synthesized_instrument/synthesizer/mindbreaker
	New()
		..()
		qdel(src.player)
		src.player = new /datum/sound_player/synthesizer/torture(src, instruments[pick(instruments)])