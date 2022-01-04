//from infinity
/obj/machinery/jukebox
	var/obj/item/music_tape/tape

/obj/machinery/jukebox/verb/eject()
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
		verbs -= /obj/machinery/jukebox/verb/eject
		jukebox.ui_interact(usr)
