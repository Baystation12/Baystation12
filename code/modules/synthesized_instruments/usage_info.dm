/datum/nano_module/usage_info
	name = "Usage Info"
	available_to_ai = 0
	var/datum/sound_player/player

/datum/nano_module/usage_info/New(atom/source, datum/sound_player/player)
	src.host = source
	src.player = player

//This will let you easily monitor when you're going overboard with tempo and sound duration, generally if the bars fill up it is BAD
/datum/nano_module/usage_info/ui_interact(mob/user, ui_key = "usage_info", var/datum/nanoui/ui = null, var/force_open = 0)
	var/static/list/data = list()
	data.Cut()
	data["channels_left"] = GLOB.sound_channels.available_channels.stack.len
	data["events_active"] = src.player.event_manager.events.len
	data["max_channels"] = GLOB.sound_channels.channel_ceiling
	data["max_events"] = GLOB.musical_config.max_events

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, "song_usage_info.tmpl", "Usage info", 500, 150)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/datum/nano_module/usage_info/Destroy()
	player = null
	..()