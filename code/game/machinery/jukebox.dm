/obj/machinery/jukebox
	name = "mediatronic jukebox"
	desc = "An immense, standalone touchscreen on a swiveling base, equipped with phased array speakers. Embossed on one corner of the ultrathin bezel is the brand name, 'Leitmotif Enterprise Edition'."
	icon = 'icons/obj/jukebox_new.dmi'
	icon_state = "jukebox3"
	anchored = TRUE
	density = TRUE
	power_channel = EQUIP
	idle_power_usage = 10
	active_power_usage = 100
	clicksound = 'sound/machines/buttonbeep.ogg'
	pixel_x = -8
	obj_flags = OBJ_FLAG_ANCHORABLE
	layer = ABOVE_WINDOW_LAYER

	var/jukebox/jukebox


/obj/machinery/jukebox/Initialize()
	. = ..()
	jukebox = new(src, "jukebox.tmpl", "MediaTronic Library", 400, 600)
	jukebox.falloff = 3
	queue_icon_update()


/obj/machinery/jukebox/Destroy()
	QDEL_NULL(jukebox)
	. = ..()


/obj/machinery/jukebox/on_update_icon()
	overlays.Cut()
	if (!anchored || inoperable())
		icon_state = "[initial(icon_state)]-[MACHINE_IS_BROKEN(src) ? "broken" : "nopower"]"
		return
	icon_state = initial(icon_state)
	if (!jukebox?.playing)
		return
	overlays += "[initial(icon_state)]-[emagged ? "emagged" : "running"]"


/obj/machinery/jukebox/powered()
	return anchored && ..()


/obj/machinery/jukebox/power_change()
	. = ..()
	if (inoperable() && jukebox?.playing)
		jukebox.Stop()


/obj/machinery/jukebox/CanUseTopic(mob/user, datum/topic_state/state)
	if (!anchored)
		to_chat(user, SPAN_WARNING("Secure \the [src] first."))
		return STATUS_CLOSE
	return ..()


/obj/machinery/jukebox/interface_interact(mob/user)
	jukebox.ui_interact(user)
	return TRUE


/obj/machinery/jukebox/old
	name = "space jukebox"
	desc = "A battered and hard-loved jukebox in some forgotten style, carefully restored to some semblance of working condition."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2"
	pixel_x = 0
	layer = STRUCTURE_LAYER
