var/decl/sound_player/sound_player = new()

/*
	A sound player/manager for looping 3D sound effects.

	Due to how the BYOND sound engine works a sound datum must be played on a specific channel for updates to work properly.
	If a channel is not assigned it will just result in a new sound effect playing, even if re-using the same datum instance.
	We also use the channel to play a null-sound on Stop(), just in case BYOND clients don't like having a large nuber, albeit stopped, looping sounds.

	As such there is a maximum limit of 1024 sound sources, with further limitations due to some channels already being potentially in use.
	However, multiple sources may share the same sound_id and there is a best-effort attempt to play the closest source where possible.
	The line above is currently a lie. Will probably just have to enforce moderately short sound ranges.
*/

/decl/sound_player
	var/channel_ceiling = 1024

	var/datum/stack/available_channels
	var/list/taken_channels // taken_channels and source_id_uses can be merged into one but would then require a meta-object to store the different values I desire.
	var/list/source_id_uses

	var/static/list/reserved_channels = list(1,2,3,123) // The following channels have been found to be in use at various locations in the codebase

/decl/sound_player/New()
	..()
	available_channels = new()
	taken_channels = list()
	source_id_uses = list()

/decl/sound_player/proc/PlayLoopingSound(var/atom/source, var/sound_id, var/sound, var/volume, var/range, var/falloff, var/prefer_mute)
	var/channel = PrivGetChannel(sound_id)
	if(!channel)
		log_warning("All available sound channels are in active use.")
		return

	return new/datum/sound_token(source, sound_id, sound, volume, channel, range, falloff, prefer_mute)

/decl/sound_player/proc/PrivStopSound(var/datum/sound_token/sound_token)
	var/channel = sound_token.channel
	var/sound_id = sound_token.sound_id

	if(--source_id_uses[sound_id])
		return

	available_channels.Push(channel)
	taken_channels -= sound_id
	source_id_uses -= sound_id

/decl/sound_player/proc/PrivGetChannel(var/sound_id)
	. = taken_channels[sound_id] // Does this sound_id already have an assigned channel?
	if(!.)
		. = available_channels.Pop() // If not, check if someone else has released their channel.
		if(!.)
			do // Finally attempt to locate a fresh, non-reserved channel
				. = channel_ceiling--
			while(. && (. in reserved_channels))
			if(. <= 0) // Should never be negative but never say never.
				return

		taken_channels[sound_id] = .
	source_id_uses[sound_id]++



/*
	Outwardly this is a merely a toke/little helper that a user utilize to adjust sounds as desired (and possible).
	In reality this is where the heavy-lifting happens.
*/
/datum/sound_token
	var/atom/source    // Where the sound originates from
	var/channel        // The current sound channel
	var/falloff        // How many turfs away the sound will still play at full volume
	var/list/listeners // Assoc: Atoms hearing this sound, and their sound datum
	var/range          // How many turfs away the sound will stop playing completely
	var/prefer_mute    // If sound should be muted instead of stopped when mob moves out of range. In the general case this should be avoided because listeners will remain tracked.
	var/sound          // Sound file, not sound datum
	var/sound_id       // The associated sound id, used for cleanup
	var/status = 0     // Paused, muted, running? Global for all listeners
	var/listener_status// Paused, muted, running? Specific for the given listener.
	var/volume         // Take a guess

	var/const/SOUND_STOPPED = 0x8000

	var/datum/proximity_trigger/square/proxy_listener
	var/list/can_be_heard_from

/datum/sound_token/New(var/atom/source, var/sound_id, var/sound, var/volume, var/channel, var/range = 4, var/falloff = 1, var/prefer_mute = FALSE)
	..()
	listeners = list()
	listener_status = list()

	src.channel = channel
	src.falloff = falloff
	src.range = range
	src.prefer_mute = prefer_mute
	src.sound = sound
	src.sound_id = sound_id
	src.source = source
	src.volume = volume

	destroyed_event.register(source, src, /datum/sound_token/proc/Stop)

	if(ismovable(source))
		proxy_listener = new(source, /datum/sound_token/proc/PrivAddListener, /datum/sound_token/proc/PrivLocateListeners, range, proc_owner = src)
		proxy_listener.register_turfs()

/datum/sound_token/Destroy()
	Stop()
	. = ..()

datum/sound_token/proc/SetVolume(var/new_volume)
	new_volume = Clamp(new_volume, 0, 100)
	if(volume == new_volume)
		return
	volume = new_volume
	PrivUpdateListeners()

datum/sound_token/proc/Mute()
	PrivUpdateStatus(status|SOUND_MUTE)

/datum/sound_token/proc/Unmute()
	PrivUpdateStatus(status & ~SOUND_MUTE)

/datum/sound_token/proc/Pause()
	PrivUpdateStatus(status|SOUND_PAUSED)

// Normally called Resume but I don't want to give people false hope about being unable to un-stop a sound
/datum/sound_token/proc/Unpause()
	PrivUpdateStatus(status & ~SOUND_PAUSED)

/datum/sound_token/proc/Stop()
	if(status & SOUND_STOPPED)
		return
	status |= SOUND_STOPPED

	var/sound/null_sound = new(channel = channel)
	for(var/listener in listeners)
		PrivRemoveListener(listener, null_sound)
	listeners = null

	destroyed_event.unregister(source, src, /datum/sound_token/proc/Stop)
	qdel_null(proxy_listener)
	source = null

	sound_player.PrivStopSound(src)

/datum/sound_token/proc/PrivLocateListeners(var/list/prior_turfs, var/list/current_turfs)
	if(status & SOUND_STOPPED)
		return

	can_be_heard_from = current_turfs
	var/current_listeners = all_hearers(source, range)
	var/former_listeners = listeners - current_listeners
	var/new_listeners = current_listeners - listeners

	for(var/listener in former_listeners)
		PrivRemoveListener(listener)

	for(var/listener in new_listeners)
		PrivAddListener(listener)

	for(var/listener in current_listeners)
		PrivUpdateListenerLoc(listener)

/datum/sound_token/proc/PrivUpdateStatus(var/new_status)
	// Once stopped, always stopped. Go ask the player to play the sound again.
	if(status & SOUND_STOPPED)
		return
	if(new_status == status)
		return
	status = new_status
	PrivUpdateListeners()

datum/sound_token/proc/PrivAddListener(var/atom/listener)
	if(isvirtualmob(listener))
		var/mob/observer/virtual/v = listener
		if(!(v.abilities & VIRTUAL_ABILITY_HEAR))
			return
		listener = v.host
	if(listener in listeners)
		return

	var/sound/S = new(sound, repeat = TRUE, volume = volume, channel = channel)
	S.environment = 0 // Ensures a 3D effect even if x/y offset happens to be 0 the first time it's played
	S.falloff = falloff
	listeners[listener] = S

	moved_event.register(listener, src, /datum/sound_token/proc/PrivUpdateListenerLoc)
	destroyed_event.register(listener, src, /datum/sound_token/proc/PrivRemoveListener)

	PrivUpdateListenerLoc(listener)

/datum/sound_token/proc/PrivRemoveListener(var/atom/listener, var/sound/null_sound)
	if(!null_sound)
		null_sound = new(channel = channel)
	sound_to(listener, null_sound)
	moved_event.unregister(listener, src, /datum/sound_token/proc/PrivUpdateListenerLoc)
	destroyed_event.unregister(listener, src, /datum/sound_token/proc/PrivRemoveListener)
	listeners -= listener

/datum/sound_token/proc/PrivUpdateListenerLoc(var/atom/listener)
	var/sound/S = listeners[listener]

	var/turf/source_turf = get_turf(source)
	var/turf/listener_turf = get_turf(listener)

	var/distance = get_dist(source_turf, listener_turf)
	if(!listener_turf || (distance > range) || !(listener_turf in can_be_heard_from))
		if(prefer_mute)
			listener_status[listener] |= SOUND_MUTE
		else
			PrivRemoveListener(listener)
			return
	else if(prefer_mute)
		listener_status[listener] &= ~SOUND_MUTE

	S.x = source_turf.x - listener_turf.x
	S.y = source_turf.y - listener_turf.y

	// Far as I can tell from testing, sound priority just doesn't work.
	// Sounds happily steal channels from each other no matter what.
	S.priority = Clamp(255 - distance, 0, 255)
	PrivUpdateListener(listener)

/datum/sound_token/proc/PrivUpdateListeners()
	for(var/listener in listeners)
		PrivUpdateListener(listener)

/datum/sound_token/proc/PrivUpdateListener(var/listener)
	var/sound/S = listeners[listener]
	S.volume = volume
	S.status = status|listener_status[listener]|SOUND_UPDATE
	sound_to(listener, S)

/obj/sound_test
	var/sound = 'sound/misc/TestLoop1.ogg'

/obj/sound_test/New()
	..()
	sound_player.PlayLoopingSound(src, /obj/sound_test, sound, 50, 3)
