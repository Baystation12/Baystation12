#define REFRESH_FREQUENCY 5
/datum/sound_player
	// Virtual object
	// It's the one used to modify shit
	var/range = 15
	var/volume = 100
	var/volume_falloff_exponent = 0.9
	var/forced_sound_in = 4
	var/falloff = 2
	var/apply_echo = 0
	var/virtual_environment_selected = 0
	var/env[23]
	var/echo[18]

	var/datum/synthesized_song/song
	var/datum/instrument/instrument
	var/obj/actual_instrument

	var/list/mob/present_listeners = list()
	var/list/turf/stored_locations = list()

	/*
	This needs an explanation.
	This is beyond dumb, this is fucking retarded.
	Basically when you send a sound with a non-minus-one environment to a client, it sets their _global_ environment value to whatever you sent to them
	So ALL sounds will have this environment setting assigned afterwards.
	You could sort of hear it if you were standing in a hallway and got a PM or something.
	*/
	var/last_updated_listeners = 0

	var/datum/musical_event_manager/event_manager = new


/datum/sound_player/New(datum/real_instrument/where, datum/instrument/what)
	src.song = new (src, what)
	src.actual_instrument = where
	src.echo = GLOB.musical_config.echo_default.Copy()
	src.env = GLOB.musical_config.env_default.Copy()


/datum/sound_player/Destroy()
	src.song.playing = 0
	src.present_listeners.Cut()
	src.stored_locations.Cut()
	src.actual_instrument = null
	src.instrument = null
	QDEL_NULL(song)
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


#undef REFRESH_FREQUENCY
