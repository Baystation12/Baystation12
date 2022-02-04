GLOBAL_DATUM_INIT(sound_player, /decl/sound_player, new)

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
	var/list/taken_channels // taken_channels and source_id_uses can be merged into one but would then require a meta-object to store the different values I desire.
	var/list/sound_tokens_by_sound_id

/decl/sound_player/New()
	..()
	taken_channels = list()
	sound_tokens_by_sound_id = list()


//This can be called if either we're doing whole sound setup ourselves or it will be as part of from-file sound setup
/decl/sound_player/proc/PlaySoundDatum(var/atom/source, var/sound_id, var/sound/new_sound, var/range, var/prefer_mute, var/datum/client_preference/preference)
	var/token_type = isnum(new_sound.environment) ? /datum/sound_token : /datum/sound_token/static_environment
	return new token_type(source, sound_id, new_sound, range, prefer_mute, preference)

/decl/sound_player/proc/PlayLoopingSound(var/atom/source, var/sound_id, var/_sound, var/volume, var/range, var/falloff = 1, var/echo, var/frequency, var/prefer_mute, var/datum/client_preference/preference, streaming)
	if(!_sound)
		return
	var/sound/S = istype(_sound, /sound) ? _sound : new(_sound)

	S.environment = 0 // Ensures a 3D effect even if x/y offset happens to be 0 the first time it's played
	S.volume  = volume
	S.falloff = falloff
	S.echo = echo
	S.frequency = frequency
	S.repeat = TRUE

	return PlaySoundDatum(source, sound_id, S, range, prefer_mute, preference)

/decl/sound_player/proc/PrivStopSound(var/datum/sound_token/sound_token)
	var/channel = sound_token._sound.channel
	var/sound_id = sound_token.sound_id

	var/sound_tokens = sound_tokens_by_sound_id[sound_id]
	if(!(sound_token in sound_tokens))
		return
	sound_tokens -= sound_token
	if(length(sound_tokens))
		return

	GLOB.sound_channels.ReleaseChannel(channel)
	taken_channels -= sound_id
	sound_tokens_by_sound_id -= sound_id

/decl/sound_player/proc/PrivGetChannel(var/datum/sound_token/sound_token)
	var/sound_id = sound_token.sound_id

	. = taken_channels[sound_id] // Does this sound_id already have an assigned channel?
	if(!.) // If not, request a new one.
		. = GLOB.sound_channels.RequestChannel(sound_id)
		if(!.) // Oh no, still no channel. Abort
			return
		taken_channels[sound_id] = .

	var/sound_tokens = sound_tokens_by_sound_id[sound_id]
	if(!sound_tokens)
		sound_tokens = list()
		sound_tokens_by_sound_id[sound_id] = sound_tokens
	sound_tokens += sound_token

#define SOUND_STOPPED FLAG(15)

/*
	Outwardly this is a merely a toke/little helper that a user utilize to adjust sounds as desired (and possible).
	In reality this is where the heavy-lifting happens.
*/
/datum/sound_token
	var/atom/source    // Where the sound originates from
	var/list/listeners // Assoc: Atoms hearing this sound, and their sound datum
	var/range          // How many turfs away the sound will stop playing completely
	var/prefer_mute    // If sound should be muted instead of stopped when mob moves out of range. In the general case this should be avoided because listeners will remain tracked.
	var/sound/_sound    // Sound datum, holds most sound relevant data
	var/sound_id       // The associated sound id, used for cleanup
	var/status = 0     // Paused, muted, running? Global for all listeners
	var/listener_status// Paused, muted, running? Specific for the given listener.

	var/datum/proximity_trigger/square/proxy_listener
	var/list/can_be_heard_from

	var/datum/client_preference/preference

/datum/sound_token/New(var/atom/source, var/sound_id, var/sound/new_sound, var/range = 4, var/prefer_mute = FALSE, var/datum/client_preference/preference)
	..()
	if(!istype(source))
		CRASH("Invalid sound source: [log_info_line(source)]")
	if(!istype(new_sound))
		CRASH("Invalid sound: [log_info_line(new_sound)]")
	if(new_sound.repeat && !sound_id)
		CRASH("No sound id given")
	if(!PrivIsValidEnvironment(new_sound.environment))
		CRASH("Invalid sound environment: [log_info_line(new_sound.environment)]")

	src.prefer_mute	= prefer_mute
	src.range		= range
	src.source		= source
	src._sound		= new_sound
	src.sound_id	= sound_id
	src.preference	= preference

	if(new_sound.repeat) // Non-looping sounds may not reserve a sound channel due to the risk of not hearing when someone forgets to stop the token
		var/channel = GLOB.sound_player.PrivGetChannel(src) //Attempt to find a channel
		if(!isnum(channel))
			CRASH("All available sound channels are in active use.")
		_sound.channel = channel
	else
		_sound.channel = 0

	listeners = list()
	listener_status = list()

	GLOB.destroyed_event.register(source, src, /datum/proc/qdel_self)

	if(ismovable(source))
		proxy_listener = new(source, /datum/sound_token/proc/PrivAddListener, /datum/sound_token/proc/PrivLocateListeners, range, proc_owner = src)
		proxy_listener.register_turfs()

/datum/sound_token/Destroy()
	Stop()
	. = ..()

datum/sound_token/proc/SetVolume(var/new_volume)
	new_volume = clamp(new_volume, 0, 100)
	if(_sound.volume == new_volume)
		return
	_sound.volume = new_volume
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

	var/sound/null_sound = new(channel = _sound.channel)
	for(var/listener in listeners)
		PrivRemoveListener(listener, null_sound)
	listeners = null
	listener_status = null

	GLOB.destroyed_event.unregister(source, src, /datum/proc/qdel_self)
	QDEL_NULL(proxy_listener)
	source = null

	GLOB.sound_player.PrivStopSound(src)

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
	if(!check_preference(listener))
		return

	if(isvirtualmob(listener))
		var/mob/observer/virtual/v = listener
		if(!(v.abilities & VIRTUAL_ABILITY_HEAR))
			return
		listener = v.host
	if(listener in listeners)
		return

	listeners += listener

	GLOB.moved_event.register(listener, src, /datum/sound_token/proc/PrivUpdateListenerLoc)
	GLOB.destroyed_event.register(listener, src, /datum/sound_token/proc/PrivRemoveListener)

	PrivUpdateListenerLoc(listener, FALSE)

/datum/sound_token/proc/PrivRemoveListener(var/atom/listener, var/sound/null_sound)
	null_sound = null_sound || new(channel = _sound.channel)
	sound_to(listener, null_sound)
	GLOB.moved_event.unregister(listener, src, /datum/sound_token/proc/PrivUpdateListenerLoc)
	GLOB.destroyed_event.unregister(listener, src, /datum/sound_token/proc/PrivRemoveListener)
	listeners -= listener

/datum/sound_token/proc/PrivUpdateListenerLoc(var/atom/listener, var/update_sound = TRUE)
	var/turf/source_turf = get_turf(source)
	var/turf/listener_turf = get_turf(listener)
	if(!istype(source_turf) || !istype(listener_turf))
		return
	var/distance = get_dist(source_turf, listener_turf)
	if(!listener_turf || (distance > range) || !(listener_turf in can_be_heard_from))
		if(prefer_mute)
			listener_status[listener] |= SOUND_MUTE
		else
			PrivRemoveListener(listener)
			return
	else if(prefer_mute)
		listener_status[listener] &= ~SOUND_MUTE

	_sound.x = source_turf.x - listener_turf.x
	_sound.z = source_turf.y - listener_turf.y
	_sound.y = 1
	// Far as I can tell from testing, sound priority just doesn't work.
	// Sounds happily steal channels from each other no matter what.
	_sound.priority = clamp(255 - distance, 0, 255)
	PrivUpdateListener(listener, update_sound)

/datum/sound_token/proc/PrivUpdateListeners()
	for(var/listener in listeners)
		PrivUpdateListener(listener)

/datum/sound_token/proc/PrivUpdateListener(var/listener, var/update_sound = TRUE)
	if(!check_preference(listener))
		PrivRemoveListener(listener)
		return

	_sound.environment = PrivGetEnvironment(listener)
	_sound.status = status|listener_status[listener]
	if(update_sound)
		_sound.status |= SOUND_UPDATE
	sound_to(listener, _sound)

/datum/sound_token/proc/PrivGetEnvironment(var/listener)
	var/area/A = get_area(listener)
	return A && PrivIsValidEnvironment(A.sound_env) ? A.sound_env : _sound.environment

/datum/sound_token/proc/check_preference(atom/listener)
	if(preference)
		var/mob/M = listener
		if(istype(M))
			if((M.get_preference_value(preference) != GLOB.PREF_YES))
				return FALSE
	return TRUE

/datum/sound_token/proc/PrivIsValidEnvironment(var/environment)
	if(islist(environment) && length(environment) != 23)
		return FALSE
	if(!isnum(environment) || environment < 0 || environment > 25)
		return FALSE
	return TRUE

/datum/sound_token/static_environment/PrivGetEnvironment()
	return _sound.environment

/obj/sound_test
	var/_sound = 'sound/misc/TestLoop1.ogg'

/obj/sound_test/New()
	..()
	GLOB.sound_player.PlayLoopingSound(src, /obj/sound_test, _sound, 50, 3)
