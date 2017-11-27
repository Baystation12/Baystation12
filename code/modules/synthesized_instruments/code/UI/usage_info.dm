/datum/nano_module/usage_info
	name = "Usage Info"
	available_to_ai = 0
	var/list/song_channels
	var/list/namespace/synthesized_instruments/event/event_manager_events


/datum/nano_module/usage_info/New(atom/source, namespace/synthesized_instruments/player)
	src.host = source
	src.song_channels = player.player_manager.free_channels
	src.event_manager_events = player.event_manager.events
	src._track_usage()


/datum/nano_module/usage_info/ui_interact(mob/user, ui_key = "usage_info", var/datum/nanoui/ui = null, var/force_open = 0)
	var/global/list/data = list()
	data.Cut()
	data["channels_left"] = src.song_channels.len
	data["events_active"] = src.event_manager_events.len
	data["max_channels"] = GLOB.synthesized_instruments.constants.max_channels_per_instrument
	data["max_events"] = GLOB.synthesized_instruments.constants.max_events_per_instrument

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, "song_usage_info.tmpl", "Usage info", 500, 150)
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/usage_info/proc/_track_usage()
	var/cur_channels = src.song_channels.len
	var/cur_events = src.event_manager_events.len
	spawn while (src && src.song_channels && src.event_manager_events)
		var/new_channel_len = round(src.song_channels.len / GLOB.synthesized_instruments.constants.usage_info_channel_resolution)
		var/new_event_len = round(src.event_manager_events.len / GLOB.synthesized_instruments.constants.usage_info_event_resolution)
		if (cur_channels != new_channel_len || cur_events != new_event_len)
			GLOB.nanomanager.update_uis(src)
			cur_channels = src.song_channels.len
			cur_events = src.event_manager_events.len
		sleep(2*world.tick_lag) // Every two ticks