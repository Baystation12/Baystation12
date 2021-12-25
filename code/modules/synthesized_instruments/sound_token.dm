//This is similar to normal sound tokens
//Mostly it allows non repeating sounds to keep channel ownership

/datum/sound_token/instrument
	var/use_env = 0
	var/datum/sound_player/player

//Slight duplication, but there's key differences
/datum/sound_token/instrument/New(var/atom/source, var/sound_id, var/sound/new_sound, var/range = 4, var/prefer_mute = FALSE, var/use_env, var/datum/sound_player/player)
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
	src.use_env		= use_env
	src.player		= player

	var/channel = GLOB.sound_player.PrivGetChannel(src) //Attempt to find a channel
	if(!isnum(channel))
		CRASH("All available sound channels are in active use.")
	_sound.channel = channel

	listeners = list()
	listener_status = list()

	GLOB.destroyed_event.register(source, src, /datum/proc/qdel_self)

	player.subscribe(src)


/datum/sound_token/instrument/PrivGetEnvironment(var/listener)
	//Allow override (in case your instrument has to sound funky or muted)
	if(use_env)
		return _sound.environment
	else
		var/area/A = get_area(listener)
		return A && PrivIsValidEnvironment(A.sound_env) ? A.sound_env : _sound.environment


datum/sound_token/instrument/PrivAddListener(var/atom/listener)
	var/mob/m = listener
	if(istype(m))
		if(m.get_preference_value(/datum/client_preference/play_instruments) != GLOB.PREF_YES)
			return
	return ..()


/datum/sound_token/instrument/PrivUpdateListener(var/listener)
	var/mob/m = listener
	if(istype(m))
		if(m.get_preference_value(/datum/client_preference/play_instruments) != GLOB.PREF_YES)
			PrivRemoveListener(listener)
			return
	return ..()

/datum/sound_token/instrument/Stop()
	player.unsubscribe(src)
	. = ..()

/datum/sound_token/instrument/Destroy()
	. = ..()
	player = null
