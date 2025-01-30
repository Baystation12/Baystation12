/obj/machinery/rotating_alarm/start_on/capaneus
	alarm_light_color = COLOR_RED_LIGHT
	/// Reference to the sound player looping sound instance.
	var/static/sound_loop


/obj/machinery/rotating_alarm/start_on/capaneus/Initialize(mapload, ...)
	. = ..()
	sound_loop = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'packs/event_legion_capaneus/sounds/alarm_loop.ogg', 40, 7)


/obj/machinery/rotating_alarm/start_on/capaneus/Destroy()
	QDEL_NULL(sound_loop)
	. = ..()
