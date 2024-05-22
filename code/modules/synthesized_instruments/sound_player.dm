
/datum/sound_player
	// Virtual object
	// It's the one used to modify shit
	var/range = 15
	var/volume = 30
	var/max_volume = 50
	var/falloff = 2
	var/apply_echo = 0
	var/virtual_environment_selected = 0
	var/env[23]
	var/echo[18]

	var/weakref/wait = null

	var/datum/synthesized_song/song
	var/datum/instrument/instrument
	var/obj/actual_instrument

	var/datum/musical_event_manager/event_manager = new

	var/datum/proximity_trigger/square/proxy_listener
	var/list/datum/sound_token/instrument/tokens = list()
	var/list/seen_turfs

/datum/sound_player/New(datum/real_instrument/where, datum/instrument/what)
	src.song = new (src, what)
	src.actual_instrument = where
	src.echo = GLOB.musical_config.echo_default.Copy()
	src.env = GLOB.musical_config.env_default.Copy()
	src.proxy_listener = new(src.actual_instrument, TYPE_PROC_REF(/datum/sound_player, on_turf_entered_relay), TYPE_PROC_REF(/datum/sound_player, on_turfs_changed_relay), range, proc_owner = src)
	proxy_listener.register_turfs()
	GLOB.instrument_synchronizer.register_global(src, PROC_REF(check_wait))

/datum/sound_player/Destroy()
	src.song.playing = 0
	src.actual_instrument = null
	src.instrument = null
	QDEL_NULL(song)
	QDEL_NULL(event_manager)
	QDEL_NULL(proxy_listener)
	seen_turfs.Cut()
	tokens.Cut()
	GLOB.instrument_synchronizer.unregister_global(src, PROC_REF(check_wait))
	wait = null
	. = ..()

/datum/sound_player/proc/check_wait(obj/other)
	if(wait && (other != actual_instrument))
		var/mob/M = wait.resolve()
		if(istype(M) && CanPhysicallyInteractWith(M, actual_instrument) && !shouldStopPlaying(M))
			if(get_dist(get_turf(actual_instrument), get_turf(other)) <= 5 && !song.playing)
				song.playing = TRUE
				song.play_song(M)
	wait = null //Either way clean it up

/datum/sound_player/proc/subscribe(datum/sound_token/instrument/newtoken)
	if(!istype(newtoken))
		CRASH("Non token type passed to subscribe function.")
	tokens += newtoken

	//Tell it of what we saw prior to it spawning
	newtoken.PrivLocateListeners(list(), seen_turfs.Copy())


/datum/sound_player/proc/unsubscribe(datum/sound_token/instrument/oldtoken)
	if(!istype(oldtoken))
		CRASH("Non token type passed to unsubscribe function.")
	tokens -= oldtoken

/datum/sound_player/proc/on_turf_entered_relay(atom/enteree)
	for(var/datum/sound_token/instrument/I in tokens)
		I.PrivAddListener(enteree)

/datum/sound_player/proc/on_turfs_changed_relay(list/prior_turfs, list/current_turfs)
	seen_turfs = current_turfs
	for(var/datum/sound_token/instrument/I in tokens)
		I.PrivLocateListeners(prior_turfs.Copy(), current_turfs.Copy())

/datum/sound_player/proc/apply_modifications(sound/what, note_num, which_line, which_note) // You don't need to override this
	what.volume = volume
	what.falloff = falloff
	if (GLOB.musical_config.env_settings_available)
		what.environment = GLOB.musical_config.is_custom_env(src.virtual_environment_selected) ? src.env : src.virtual_environment_selected
	if (src.apply_echo)
		what.echo = src.echo
	return

/datum/sound_player/proc/shouldStopPlaying(mob/user)
	var/obj/structure/synthesized_instrument/S = actual_instrument
	var/obj/item/device/synthesized_instrument/D = actual_instrument
	if(istype(S))
		return S.shouldStopPlaying(user)
	if(istype(D))
		return D.shouldStopPlaying(user)

	return 1 //Well if you got this far you did something very wrong
