/obj/item/device/taperecorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon = 'icons/obj/tools/tape_recorder.dmi'
	icon_state = "taperecorder"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL

	matter = list(MATERIAL_ALUMINIUM = 60,MATERIAL_GLASS = 30)

	var/emagged = FALSE
	var/recording = 0.0
	var/playing = 0.0
	var/playsleepseconds = 0.0
	var/obj/item/device/tape/mytape = /obj/item/device/tape/random
	var/canprint = 1
	var/datum/wires/taperecorder/wires = null // Wires datum
	var/maintenance = 0
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 2
	throw_speed = 4
	throw_range = 20

/obj/item/device/taperecorder/New()
	..()
	wires = new(src)
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	if(ispath(mytape))
		mytape = new mytape(src)
	GLOB.listening_objects += src
	update_icon()

/obj/item/device/taperecorder/empty
	mytape = null

/obj/item/device/taperecorder/Destroy()
	QDEL_NULL(wires)
	GLOB.listening_objects -= src
	if(mytape)
		qdel(mytape)
		mytape = null
	return ..()


/obj/item/device/taperecorder/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Toggle maintenance cover
	if (isScrewdriver(tool))
		maintenance = !maintenance
		user.visible_message(
			SPAN_NOTICE("\The [user] [maintenance ? "opens" : "closes"] \a [src]'s lid with \a [tool]."),
			SPAN_NOTICE("You [maintenance ? "open" : "close"] \the [src]'s lid with \the [tool].")
		)
		return TRUE

	// Tape - Insert tape
	if (istype(tool, /obj/item/device/tape))
		if (mytape)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [mytape] inside.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		mytape = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [tool] into \a [src]."),
			SPAN_NOTICE("You insert \the [tool] into \the [src].")
		)
		return TRUE

	return ..()


/obj/item/device/taperecorder/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(mytape)
		mytape.ruin() //Fires destroy the tape
	return ..()


/obj/item/device/taperecorder/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(mytape)
			eject()
			return
	..()


/obj/item/device/taperecorder/verb/eject()
	set name = "Eject Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, SPAN_NOTICE("There's no tape in \the [src]."))
		return
	if(emagged)
		to_chat(usr, SPAN_NOTICE("The tape seems to be stuck inside."))
		return

	if(playing || recording)
		stop()
	to_chat(usr, SPAN_NOTICE("You remove [mytape] from [src]."))
	usr.put_in_hands(mytape)
	mytape = null
	update_icon()

/obj/item/device/taperecorder/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && maintenance)
		to_chat(user, SPAN_NOTICE("The wires are exposed."))

/obj/item/device/taperecorder/hear_talk(mob/living/M as mob, msg, verb="says", datum/language/speaking=null)
	var/speaker = null
	if(mytape && recording)
		if (istype(M, /mob/living/carbon/human))
			speaker = M.GetVoice()
		else
			speaker = M.name
		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			mytape.record_speech("[speaker] [speaking.format_message_plain(msg, verb)]")
		else
			mytape.record_speech("[speaker] [verb], \"[msg]\"")


/obj/item/device/taperecorder/see_emote(mob/M as mob, text, emote_type)
	if(emote_type != AUDIBLE_MESSAGE) //only hearable emotes
		return
	if(mytape && recording)
		mytape.record_speech("[strip_html_properly(text)]")


/obj/item/device/taperecorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type == AUDIBLE_MESSAGE) //must be hearable
		recordedtext = msg
	else if (alt && alt_type == AUDIBLE_MESSAGE)
		recordedtext = alt
	else
		return
	if(mytape && recording)
		mytape.record_noise("[strip_html_properly(recordedtext)]")

/obj/item/device/taperecorder/emag_act(remaining_charges, mob/user)
	if(!emagged)
		emagged = TRUE
		recording = 0
		to_chat(user, SPAN_WARNING("PZZTTPFFFT"))
		update_icon()
		return 1
	else
		to_chat(user, SPAN_WARNING("It is already emagged!"))

/obj/item/device/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_DANGER("\The [src] explodes!"))
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, 1, EX_ACT_LIGHT)
	qdel(src)
	return

/obj/item/device/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.incapacitated())
		return
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	if(!mytape)
		to_chat(usr, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined || emagged)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(usr, SPAN_NOTICE("You're already recording!"))
		return
	if(playing)
		to_chat(usr, SPAN_NOTICE("You can't record when playing!"))
		return
	if(mytape.used_capacity < mytape.max_capacity)
		to_chat(usr, SPAN_NOTICE("Recording started."))
		recording = 1
		update_icon()

		mytape.record_speech("Recording started.")

		//count seconds until full, or recording is stopped
		while(mytape && recording && mytape.used_capacity < mytape.max_capacity)
			sleep(10)
			if (!mytape)
				if(ismob(loc))
					var/mob/M = loc
					to_chat(M, SPAN_NOTICE("\The [src]'s tape has been removed."))
				stop_recording()
				break
			mytape.used_capacity++
			if(mytape.used_capacity >= mytape.max_capacity)
				if(ismob(loc))
					var/mob/M = loc
					to_chat(M, SPAN_NOTICE("The tape is full."))
				stop_recording()
				break


		update_icon()
		return
	else
		to_chat(usr, SPAN_NOTICE("The tape is full."))


/obj/item/device/taperecorder/proc/stop_recording()
	//Sanity checks skipped, should not be called unless actually recording
	recording = 0
	update_icon()
	if (mytape)
		mytape.record_speech("Recording stopped.")
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_NOTICE("Recording stopped."))


/obj/item/device/taperecorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.incapacitated())
		return
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	if(recording)
		stop_recording()
		return
	else if(playing)
		playing = 0
		update_icon()
		to_chat(usr, SPAN_NOTICE("Playback stopped."))
		return
	else
		to_chat(usr, SPAN_NOTICE("Stop what?"))


/obj/item/device/taperecorder/verb/wipe_tape()
	set name = "Wipe Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		return
	if(emagged || mytape.ruined)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording || playing)
		to_chat(usr, SPAN_NOTICE("You can't wipe the tape while playing or recording!"))
		return
	else
		if(mytape.storedinfo)	mytape.storedinfo.Cut()
		if(mytape.timestamp)	mytape.timestamp.Cut()
		mytape.used_capacity = 0
		to_chat(usr, SPAN_NOTICE("You wipe the tape."))
		return


/obj/item/device/taperecorder/verb/playback_memory()
	set name = "Playback Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	play(usr)

/obj/item/device/taperecorder/proc/play(mob/user)
	if(!mytape)
		to_chat(user, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(user, SPAN_NOTICE("You can't playback when recording!"))
		return
	if(playing)
		to_chat(user, SPAN_NOTICE("You're already playing!"))
		return
	playing = 1
	update_icon()
	to_chat(user, SPAN_NOTICE("Audio playback started."))
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	for(var/i=1 , i < mytape?.max_capacity , i++)
		if(!mytape || !playing)
			break
		if(length(mytape.storedinfo) < i)
			break

		var/turf/T = get_turf(src)
		var/playedmessage = mytape.storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message(SPAN_COLOR("maroon", "<B>Tape Recorder</B>: [playedmessage]"))

		if(length(mytape.storedinfo) < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message(SPAN_COLOR("maroon", "<B>Tape Recorder</B>: End of recording."))
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			break
		else
			playsleepseconds = mytape.timestamp[i+1] - mytape.timestamp[i]

		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message(SPAN_COLOR("Maroon", "<B>Tape Recorder</B>: Skipping [playsleepseconds] seconds of silence"))
			playsleepseconds = 1
		sleep(10 * playsleepseconds)


	playing = 0
	update_icon()

	if(emagged)
		var/turf/T = get_turf(src)
		T.audible_message(SPAN_COLOR("Maroon", "<B>Tape Recorder</B>: This tape recorder will self-destruct in... Five."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_COLOR("Maroon", "<B>Tape Recorder</B>: Four."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_COLOR("Maroon", "<B>Tape Recorder</B>: Three."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_COLOR("Maroon", "<B>Tape Recorder</B>: Two."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_COLOR("Maroon", "<B>Tape Recorder</B>: One."))
		sleep(10)
		explode()


/obj/item/device/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined || emagged)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(!canprint)
		to_chat(usr, SPAN_NOTICE("The recorder can't print that fast!"))
		return
	if(recording || playing)
		to_chat(usr, SPAN_NOTICE("You can't print the transcript while playing or recording!"))
		return

	to_chat(usr, SPAN_NOTICE("Transcript printed."))
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i=1,length(mytape.storedinfo) >= i,i++)
		var/printedmessage = mytape.storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(mytape.timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.set_content(t1, "Transcript", FALSE)
	usr.put_in_hands(P)
	playsound(src, "sound/machines/dotprinter.ogg", 30)
	canprint = 0
	sleep(150)
	canprint = 1


/obj/item/device/taperecorder/attack_self(mob/user)
	if(maintenance)
		wires.Interact(user)
		return

	if(recording || playing)
		stop()
	else
		record()


/obj/item/device/taperecorder/on_update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	if(!mytape)
		icon_state = "[bis.base_icon_state]_empty"
	else if(recording)
		icon_state = "[bis.base_icon_state]_recording"
	else if(playing)
		icon_state = "[bis.base_icon_state]_playing"
	else
		icon_state = "[bis.base_icon_state]_idle"

/obj/item/device/tape
	name = "tape"
	desc = "A magnetic tape that can hold up to twenty minutes of content."
	icon = 'icons/obj/tools/tape_recorder.dmi'
	icon_state = "tape_white"
	item_state = "analyzer"
	w_class = ITEM_SIZE_TINY
	matter = list(MATERIAL_PLASTIC=20, MATERIAL_STEEL=5, MATERIAL_GLASS=5)
	force = 1
	throwforce = 0
	var/max_capacity = 1200
	var/used_capacity = 0
	var/list/storedinfo = list()
	var/list/timestamp = list()
	var/ruined = 0
	var/doctored = 0


/obj/item/device/tape/on_update_icon()
	ClearOverlays()
	if(ruined && max_capacity)
		AddOverlays("ribbonoverlay")


/obj/item/device/tape/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ruin()

/obj/item/device/tape/attack_self(mob/user)
	if(!ruined)
		to_chat(user, SPAN_NOTICE("You pull out all the tape!"))
		get_loose_tape(user, length(storedinfo))
		ruin()


/obj/item/device/tape/proc/ruin()
	ruined = 1
	update_icon()


/obj/item/device/tape/proc/fix()
	ruined = 0
	update_icon()


/obj/item/device/tape/proc/record_speech(text)
	timestamp += used_capacity
	storedinfo += "\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


//shows up on the printed transcript as (Unrecognized sound)
/obj/item/device/tape/proc/record_noise(text)
	timestamp += used_capacity
	storedinfo += "*\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


/obj/item/device/tape/use_tool(obj/item/tool, mob/user, list/click_params)
	// Magnetic Tape - Join tape
	if (istype(tool, /obj/item/device/tape/loose))
		join(user, tool)
		return TRUE

	// Pen - Label tape
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What would you like to label the tape?", "[initial(name)] - Label") as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!input || !user.use_sanity_check(src, tool))
			return TRUE
		SetName("[initial(name)] - '[input]'")
		user.visible_message(
			SPAN_NOTICE("\The [user] labels \a [src] with \a [tool]."),
			SPAN_NOTICE("You label \the [src] with \the [tool].")
		)
		return TRUE

	// Screwdriver - Fix tape
	if (isScrewdriver(tool))
		if (!max_capacity)
			USE_FEEDBACK_FAILURE("\The [src] has no tape to wind.")
			return TRUE
		if (!ruined)
			USE_FEEDBACK_FAILURE("\The [src]'s tape doesn't need re-winding.")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts winding \a [src]'s tape back in with \a [tool]."),
			SPAN_NOTICE("You start winding \the [src]'s tape back in with \the [tool].")
		)
		if (!do_after(user, 12 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!max_capacity)
			USE_FEEDBACK_FAILURE("\The [src] has no tape to wind.")
			return TRUE
		if (!ruined)
			USE_FEEDBACK_FAILURE("\The [src]'s tape doesn't need re-winding.")
			return TRUE
		fix()
		user.visible_message(
			SPAN_NOTICE("\The [user] winds \a [src]'s tape back in with \a [tool]."),
			SPAN_NOTICE("You wind \the [src]'s tape back in with \the [tool].")
		)
		return TRUE

	// Wirecutter - Cut tape
	if (isWirecutter(tool))
		cut(user)
		return TRUE

	return ..()


/obj/item/device/tape/proc/cut(mob/user)
	if(!LAZYLEN(timestamp))
		to_chat(user, SPAN_NOTICE("There's nothing on this tape!"))
		return
	var/list/output = list("<center>")
	for(var/i=1, i < length(timestamp), i++)
		var/time = "\[[time2text(timestamp[i]*10,"mm:ss")]\]"
		output += "[time]<br><a href='?src=\ref[src];cut_after=[i]'>-----CUT------</a><br>"
	output += "</center>"

	var/datum/browser/popup = new(user, "tape_cutting", "Cutting tape", 170, 600)
	popup.set_content(jointext(output,null))
	popup.open()

/obj/item/device/tape/proc/join(mob/user, obj/item/device/tape/other)
	if(max_capacity + other.max_capacity > initial(max_capacity))
		to_chat(user, SPAN_NOTICE("You can't fit this much tape in!"))
		return
	if(user.unEquip(other))
		to_chat(user, SPAN_NOTICE("You join ends of the tape together."))
		max_capacity += other.max_capacity
		used_capacity = min(used_capacity + other.used_capacity, max_capacity)
		timestamp += other.timestamp
		storedinfo += other.storedinfo
		doctored = 1
		ruin()
		update_icon()
		qdel(other)

/obj/item/device/tape/OnTopic(mob/user, list/href_list)
	if(href_list["cut_after"])
		var/index = text2num(href_list["cut_after"])
		if(index >= length(timestamp))
			return

		to_chat(user, SPAN_NOTICE("You remove part of the tape off."))
		get_loose_tape(user, index)
		cut(user)
		return TOPIC_REFRESH

//Spawns new loose tape item, with data starting from [index] entry
/obj/item/device/tape/proc/get_loose_tape(mob/user, index)
	var/obj/item/device/tape/loose/newtape = new()
	newtape.timestamp = timestamp.Copy(index+1)
	newtape.storedinfo = storedinfo.Copy(index+1)
	newtape.max_capacity = max_capacity - index
	newtape.used_capacity = max(0, used_capacity - max_capacity)
	newtape.doctored = doctored
	user.put_in_hands(newtape)

	timestamp.Cut(index+1)
	storedinfo.Cut(index+1)
	max_capacity = index
	used_capacity = min(used_capacity,index)

//Random colour tapes
/obj/item/device/tape/random/Initialize()
	. = ..()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"

/obj/item/device/tape/loose
	name = "magnetic tape"
	desc = "Quantum-enriched self-repairing nanotape, used for magnetic storage of information."
	icon = 'icons/obj/tools/tape_recorder.dmi'
	icon_state = "magtape"
	ruined = 1

/obj/item/device/tape/loose/fix()
	return

/obj/item/device/tape/loose/on_update_icon()
	return

/obj/item/device/tape/loose/get_loose_tape()
	return

/obj/item/device/tape/loose/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, SPAN_NOTICE("It looks long enough to hold [max_capacity] seconds worth of recording."))
		if(doctored && user.skill_check(SKILL_FORENSICS, SKILL_MASTER))
			to_chat(user, SPAN_NOTICE("It has been tampered with..."))
