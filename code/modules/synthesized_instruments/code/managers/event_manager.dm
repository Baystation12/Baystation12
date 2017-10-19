/namespace/synthesized_instruments/event
	var/sound/object
	var/mob/subject
	var/namespace/synthesized_instruments/player/source
	var/time = 0
	var/new_volume = 100


/namespace/synthesized_instruments/event/New(namespace/synthesized_instruments/player/source, mob/subject, sound/object, time, volume)
	src.source = source
	src.subject = subject
	src.object = object
	src.time = time
	src.new_volume = volume


/namespace/synthesized_instruments/event/proc/tick()
	var/update_sound = 1
	update_sound &= 0 < src.new_volume
	update_sound &= istype(src.object)
	update_sound &= istype(src.subject)
	update_sound &= istype(src.source)
	if (update_sound) src._update_sound()
	else src._destroy_sound()


/namespace/synthesized_instruments/event/proc/_update_sound()
	src.object.volume = src.new_volume
	src.object.status |= SOUND_UPDATE
	sound_to(src.subject, src.object)


/namespace/synthesized_instruments/event/proc/_destroy_sound()
	if (istype(src.object) && istype(src.subject))
		var/sound/null_sound = sound(channel=src.object.channel, wait=0)
		if (GLOB.synthesized_instruments.flags.env_settings_available)
			null_sound.environment = -1
		sound_to(src.subject, null_sound)
	if (istype(src.source))
		src.source.free_channel(src.object.channel)
	qdel(src)



/namespace/synthesized_instruments/manager/event_manager
	var/list/namespace/synthesized_instruments/event/events = list()
	var/suspended = 0
	var/active = 0
	var/kill_loop = 0


/namespace/synthesized_instruments/manager/event_manager/proc/push_event(mob/subject, sound/object, time, volume)
	var/valid_event = 1
	valid_event &= istype(src.source)
	valid_event &= istype(subject)
	valid_event &= istype(object)
	valid_event &= volume in 0 to 100
	if (valid_event)
		src.events += new (src.source, subject, object, time, volume)


/namespace/synthesized_instruments/manager/event_manager/proc/activate()
	if (active) return 0
	src.active = 1

	spawn
		var/list/namespace/synthesized_instruments/event/left_events = list()
		while (1)
			left_events.Cut()
			if (src.kill_loop) break
			if (!src.suspended)
				for (var/namespace/synthesized_instruments/event/event in src.events)
					event.time -= world.tick_lag
					if (0 >= event.time)
						event.tick()
					else left_events += event
				src.events.Cut()
				src.events += left_events
			sleep(world.tick_lag) // High priority


/namespace/synthesized_instruments/manager/event_manager/proc/deactivate()
	if (src.kill_loop) return
	if (src.active) src.kill_loop = 1
	for (var/namespace/synthesized_instruments/event/event in src.events)
		event._destroy_sound()
	src.events.Cut()
	src.active = 0
	src.suspended = 0


/namespace/synthesized_instruments/event_manager/proc/is_overloaded()
	return src.events.len > GLOB.synthesized_instruments.constants.max_events_per_instrument
