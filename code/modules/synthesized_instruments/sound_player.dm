
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

	var/datum/synthesized_song/song
	var/datum/instrument/instrument
	var/obj/actual_instrument

	var/datum/musical_event_manager/event_manager = new


/datum/sound_player/New(datum/real_instrument/where, datum/instrument/what)
	src.song = new (src, what)
	src.actual_instrument = where
	src.echo = GLOB.musical_config.echo_default.Copy()
	src.env = GLOB.musical_config.env_default.Copy()


/datum/sound_player/Destroy()
	src.song.playing = 0
	src.actual_instrument = null
	src.instrument = null
	QDEL_NULL(song)
	QDEL_NULL(event_manager)
	. = ..()


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



