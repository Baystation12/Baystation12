#define REFRESH_FREQUENCY 5
/namespace/synthesized_instruments/manager/player
	var/obj/real_instrument

	var/last_updated_listeners = 0
	var/list/mob/present_listeners = list()
	var/list/turf/blocked_turfs = list()

	var/list/lines = list()
	var/tempo = 5
	var/playing = 0
	var/autorepeat = 0
	var/current_line = 0

	var/list/free_channels = list()

	var/base_volume
	var/forced_sound_in = 0


/namespace/synthesized_instruments/manager/player/New(namespace/synthesized_instruments/player/source)
	..(source)
	spawn(10)
		for (var/i=1 to GLOB.synthesized_instruments.constants.max_channels_per_instrument)
			if (GLOB.synthesized_instruments.shared.free_channels.len)
				src.free_channel(pick_n_take(GLOB.synthesized_instruments.shared.free_channels))


/namespace/synthesized_instruments/manager/player/Destroy()
	GLOB.synthesized_instruments.shared.free_channels |= src.free_channels
	src.free_channels.Cut()
	if (src.source && src.source.player_manager == src)
		src.source.player_manager = null

	return ..()


/namespace/synthesized_instruments/manager/player/proc/free_channel(channel)
	src.free_channels |= channel


/namespace/synthesized_instruments/manager/player/proc/get_listeners()
	if (world.time - src.last_updated_listeners > REFRESH_FREQUENCY)
		src.present_listeners.Cut()
		for (var/mob/some_hearer in GLOB.mob_list) // Apparently hearers only works for local things -- so if something's inside a closet, only things inside this closet can hear it
			var/dist = get_dist(some_hearer, src.actual_instrument)
			var/eligible = 1
			eligible &= some_hearer.client && some_hearer.mind
			eligible &= isdeaf(some_hearer)
			eligible &= some_hearer.ear_deaf <= 0
			eligible &= some_hearer.is_preference_enabled(/datum/client_preference/hear_instruments) || (dist in 0 to src.forced_sound_in)
			eligible &= (dist in 0 to src.source.range)
			if (!eligible) continue
			src.present_listeners += some_hearer
		src.last_updated_listeners = world.time
	return src.present_listeners


/namespace/synthesized_instruments/manager/player/proc/get_blocked_turfs()
	// src.blocked_turfs = range(src.source.range, get_turf(src.actual_instrument)) - view(src.source.range, get_turf(src.actual_instrument))
	return 0  // Unused for now
