/obj/machinery/jukebox/custom_tape
	var/obj/item/music_tape/tape

/obj/machinery/jukebox/custom_tape/verb/eject()
	set name = "Eject"
	set category = "Object"
	set src in oview(1)

	if(!CanPhysicallyInteract(usr))
		return

	if(tape)
		jukebox.Stop()
		for(var/jukebox_track/T in jukebox.tracks)
			if(T == tape.track)
				jukebox.tracks -= T
				jukebox.Last()

		if(!usr.put_in_hands(tape))
			tape.dropInto(loc)

		tape = null
		visible_message(SPAN_NOTICE("[usr] eject \a [tape] from \the [src]."))
		verbs -= /obj/machinery/jukebox/custom_tape/verb/eject
		playsound(src, 'mods/jukebox_tapes/sounds/tape_eject.ogg', 40)
		jukebox.ui_interact(usr)

/obj/machinery/jukebox/custom_tape/Initialize()
	. = ..()
	jukebox = new(src, "mods-jukebox.tmpl", "MediaTronic Library", 400, 600)
	jukebox.falloff = 3
	queue_icon_update()


/obj/machinery/jukebox/custom_tape/Destroy()
	QDEL_NULL(jukebox)
	. = ..()


/obj/machinery/jukebox/custom_tape/on_update_icon()
	ClearOverlays()
	if (!anchored || inoperable())
		icon_state = "[initial(icon_state)]-[MACHINE_IS_BROKEN(src) ? "broken" : "nopower"]"
		return
	icon_state = initial(icon_state)
	if (!jukebox?.playing)
		return
	AddOverlays("[initial(icon_state)]-[emagged ? "emagged" : "running"]")


/obj/machinery/jukebox/custom_tape/powered()
	return anchored && ..()


/obj/machinery/jukebox/custom_tape/power_change()
	. = ..()
	if (inoperable() && jukebox?.playing)
		jukebox.Stop()


/obj/machinery/jukebox/custom_tape/CanUseTopic(mob/user, datum/topic_state/state)
	if (!anchored)
		to_chat(user, SPAN_WARNING("Secure \the [src] first."))
		return STATUS_CLOSE
	return ..()


/obj/machinery/jukebox/custom_tape/interface_interact(mob/user)
	jukebox.ui_interact(user)
	return TRUE

/obj/machinery/jukebox/custom_tape/use_tool(obj/item/tool, mob/user, list/click_params)
	if(istype(tool, /obj/item/music_tape))
		var/obj/item/music_tape/D = tool
		if(tape)
			to_chat(user, "<span class='notice'>There is already \a [tape] inside.</span>")
			return TRUE

		if(D.ruined)
			to_chat(user, "<span class='warning'>\The [D] is ruined, you can't use it.</span>")
			return TRUE

		if(!D.track)
			to_chat(user, "<span class='warning'>There is no music recorded on \a [D].</span>")
			return TRUE

		if(user.drop_item())
			visible_message("<span class='notice'>[usr] insert \a [tape] into \the [src].</span>")
			D.forceMove(src)
			playsound(loc, 'mods/jukebox_tapes/sounds/tape_insert.ogg', 40)
			tape = D
			jukebox.tracks += tape.track
			verbs += /obj/machinery/jukebox/custom_tape/verb/eject
			return TRUE

	return ..()

/obj/machinery/jukebox/custom_tape/old
	name = "space jukebox"
	desc = "A battered and hard-loved jukebox in some forgotten style, carefully restored to some semblance of working condition."
	icon = 'icons/obj/machines/jukebox.dmi'
	icon_state = "jukebox2"
	pixel_x = 0


// SIERRA TODO: Move to corecode or override
/jukebox/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE, datum/topic_state/state = GLOB.default_state)//, datum/topic_state/state = GLOB.jukebox_state)
	var/list/data_tracks = list()
	for (var/i = 1 to length(tracks))
		var/jukebox_track/track = tracks[i]
		data_tracks += list(list("track" = track.title, "index" = i))
	var/jukebox_track/track = tracks[index]
	var/list/data = list(
		"track" = track.title,
		"playing" = playing,
		"volume" = volume,
		"tracks" = data_tracks
	)
	if(istype(owner, /obj/machinery/jukebox/custom_tape))
		var/obj/machinery/jukebox/custom_tape/J = owner
		data["tape"] = J.tape
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, template, ui_title, ui_width, ui_height, state = state)
		ui.set_initial_data(data)
		ui.open()

/jukebox/Topic(href, href_list)
	switch ("[href_list["act"]]")
		if ("next") Next()
		if ("last") Last()
		if ("stop") Stop()
		if ("play") Play()
		if ("volume") Volume("[href_list["dat"]]")
		if ("track") Track("[href_list["dat"]]")
		if ("eject")
			if(istype(owner, /obj/machinery/jukebox/custom_tape))
				var/obj/machinery/jukebox/custom_tape/J = owner
				J.eject()
	return TOPIC_REFRESH

/obj/random/machine/jukebox_custom
	name = "random jukebox"

/obj/random/machine/jukebox_custom/spawn_choices()
	return list(
		/obj/machinery/jukebox/custom_tape,
		/obj/machinery/jukebox/custom_tape/old
		)
