datum/musical_event
	var/sound/object
	var/datum/sound_player/source
	var/time = 0
	var/new_volume = 100
	var/datum/sound_token/token
	var/sound_id


/datum/musical_event/New(datum/sound_player/source, sound/object, time, volume)
	src.source = source
	src.object = object
	src.time = time
	src.new_volume = volume
	src.sound_id = "[type]_[sequential_id(type)]"


/datum/musical_event/Destroy()
	source = null
	if(token)
		QDEL_NULL(token)
	object = null


/datum/musical_event/proc/tick()
	if (!(istype(object) && istype(source)))
		return
	if (src.new_volume > 0) src.update_sound()
	else src.destroy_sound()



/datum/musical_event/proc/update_sound()
	src.token = sound_player.PlayLoopingSound(src.source.actual_instrument, sound_id, src.object, volume = src.new_volume, range = src.source.range, falloff = src.object.falloff, prefer_mute = FALSE)
	if(src.token == null)
		log_world("THIS IS FAILING!")


/datum/musical_event/proc/destroy_sound()
	QDEL_NULL(token)


/datum/musical_event_manager
	var/list/datum/musical_event/events = list()
	var/suspended = 0
	var/active = 0
	var/kill_loop = 0


/datum/musical_event_manager/proc/push_event(datum/sound_player/source, sound/object, time, volume)
	if (istype(source) && istype(object) && volume >= 0 && volume <= 100)
		src.events += new /datum/musical_event(source, object, time, volume)



/datum/musical_event_manager/proc/handle_events()
	var/list/datum/musical_event/left_events = list()
	while (1)
		left_events.Cut()
		if (src.kill_loop)
			src.active = 0
			src.kill_loop = 0
			break
		if (!src.suspended)
			for (var/datum/musical_event/event in src.events)
				event.time -= world.tick_lag
				if (event.time <= 0)
					event.tick()
				else left_events += event
			src.events.Cut()
			src.events += left_events
		sleep(world.tick_lag) // High priority

/datum/musical_event_manager/proc/activate()
	if (active)	return 0
	src.active = 1

	addtimer(CALLBACK(src, .proc/handle_events), 0)



/datum/musical_event_manager/proc/deactivate()
	if (src.kill_loop) return 0
	if (src.active) src.kill_loop = 1
	for (var/datum/musical_event/event in src.events)
		event.destroy_sound()
	src.events.Cut()
	src.active = 0
	src.suspended = 0
	return 1


/datum/musical_event_manager/proc/is_overloaded()
	return src.events.len > GLOB.musical_config.max_events