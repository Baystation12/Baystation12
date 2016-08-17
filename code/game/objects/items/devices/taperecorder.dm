/obj/item/device/taperecorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon_state = "taperecorder_empty"
	item_state = "analyzer"
	w_class = 2.0

	matter = list(DEFAULT_WALL_MATERIAL = 60,"glass" = 30)

	var/emagged = 0.0
	var/recording = 0.0
	var/playing = 0.0
	var/playsleepseconds = 0.0
	var/obj/item/device/tape/mytape
	var/canprint = 1
	flags = CONDUCT
	throwforce = 2
	throw_speed = 4
	throw_range = 20

/obj/item/device/taperecorder/New()
	..()
	mytape = new /obj/item/device/tape/random(src)
	update_icon()
	listening_objects += src

/obj/item/device/taperecorder/empty/New()
	..()
	mytape = null
	update_icon()
	listening_objects += src

/obj/item/device/taperecorder/Destroy()
	listening_objects -= src
	mytape = null
	return ..()


/obj/item/device/taperecorder/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/tape))
		if(mytape)
			user << "<span class='notice'>There's already a tape inside.</span>"
			return
		if(!user.unEquip(I))
			return
		I.loc = src
		mytape = I
		user << "<span class='notice'>You insert [I] into [src].</span>"
		update_icon()


/obj/item/device/taperecorder/proc/eject(mob/user)
	if(!mytape)
		user << "<span class='notice'>There's no tape!</span>"
	else
		if(playing == 1 || recording == 1)
			stop()
		user << "<span class='notice'>You remove [mytape] from [src].</span>"
		user.put_in_hands(mytape)
		mytape = null
		update_icon()


/obj/item/device/taperecorder/fire_act()
	mytape.ruin() //Fires destroy the tape
	return()


/obj/item/device/taperecorder/attack_hand(mob/user)
	if(loc == user)
		if(mytape)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			eject(user)
			return
	..()


/obj/item/device/taperecorder/verb/ejectverb()
	set name = "Eject Tape"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape)
		return

	eject(usr)


/obj/item/device/taperecorder/hear_talk(mob/living/M as mob, msg, var/verb="says", datum/language/speaking=null)
	if(mytape && recording)
		mytape.timestamp += mytape.used_capacity

		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] [M.name] [speaking.format_message_plain(msg, verb)]"
		else
			mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] [M.name] [verb], \"[msg]\""


/obj/item/device/taperecorder/see_emote(mob/M as mob, text, var/emote_type)
	if(emote_type != 2) //only hearable emotes
		return
	if(mytape && recording)
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] [strip_html_properly(text)]"


/obj/item/device/taperecorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type == 2) //must be hearable
		recordedtext = msg
	else if (alt && alt_type == 2)
		recordedtext = alt
	else
		return
	if(mytape && recording)
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "*\[[time2text(mytape.used_capacity*10,"mm:ss")]\] [strip_html_properly(recordedtext)]" //"*" at front as a marker

/obj/item/device/taperecorder/emag_act(var/remaining_charges, var/mob/user)
	if(emagged == 0)
		emagged = 1
		recording = 0
		user << "<span class='warning'>PZZTTPFFFT</span>"
		update_icon()
		return 1
	else
		user << "<span class='warning'>It is already emagged!</span>"

/obj/item/device/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		M << "<span class='danger'>\The [src] explodes!</span>"
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/device/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape)
		usr << "<span class='notice'>There's no tape!</span>"
		return
	if(mytape.ruined)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(recording)
		usr << "<span class='notice'>You're already recording!</span>"
		return
	if(playing)
		usr << "<span class='notice'>You can't record when playing!</span>"
		return
	if(emagged == 1)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(mytape.used_capacity < mytape.max_capacity)
		usr << "<span class='notice'>Recording started.</span>"
		recording = 1
		update_icon()
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] Recording started."
		var/used = mytape.used_capacity	//to stop runtimes when you eject the tape
		var/max = mytape.max_capacity
		for(used, used < max)
			if(recording == 0)
				break
			mytape.used_capacity++
			used++
			sleep(10)
		recording = 0
		update_icon()
		return
	else
		usr << "<span class='notice'>The tape is full.</span>"


/obj/item/device/taperecorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.stat)
		return
	if(emagged == 1)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(recording == 1)
		recording = 0
		update_icon()
		mytape.timestamp+= mytape.used_capacity
		mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] Recording stopped."
		usr << "<span class='notice'>Recording stopped.</span>"
		return
	else if(playing == 1)
		playing = 0
		update_icon()
		usr << "<span class='notice'>Playback stopped.</span>"
		return
	else
		usr << "<span class='notice'>Stop what?</span>"


//TODO wipe tape?
/*/obj/item/device/taperecorder/verb/clear_memory()
	set name = "Clear Memory"
	set category = "Object"

	if(usr.stat)
		return
	if(emagged == 1)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(recording == 1 || playing == 1)
		usr << "<span class='notice'>You can't clear the memory while playing or recording!</span>"
		return
	else
		if(storedinfo)	storedinfo.Cut()
		if(timestamp)	timestamp.Cut()
		mytape.used_capacity = 0
		usr << "<span class='notice'>Memory cleared.</span>"
		return*/


/obj/item/device/taperecorder/verb/playback_memory()
	set name = "Playback Tape"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape)
		usr << "<span class='notice'>There's no tape!</span>"
		return
	if(mytape.ruined)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(emagged == 1)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(recording == 1)
		usr << "<span class='notice'>You can't playback when recording!</span>"
		return
	if(playing == 1)
		usr << "<span class='notice'>You're already playing!</span>"
		return
	playing = 1
	update_icon()
	usr << "<span class='notice'>Playing started.</span>"
	var/used = mytape.used_capacity	//to stop runtimes when you eject the tape
	var/max = mytape.max_capacity
	for(var/i=1,used < max, sleep(10 * playsleepseconds ))
		if(!mytape)
			break
		if(playing == 0)
			break
		if(mytape.storedinfo.len < i)
			break

		var/turf/T = get_turf(src)
		var/playedmessage = mytape.storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: [playedmessage]</font>")

		if(mytape.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: End of recording.</font>")
		else
			playsleepseconds = mytape.timestamp[i+1] - mytape.timestamp[i]
		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Skipping [playsleepseconds] seconds of silence</font>")
			playsleepseconds = 1
		i++

	playing = 0
	update_icon()
	// Only triggers if you emag the recorder while it's playing.
	if(emagged == 1.0)
		var/turf/T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: This tape recorder will self-destruct in... Five.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Four.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Three.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Two.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: One.</font>")
		sleep(10)
		explode()


/obj/item/device/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape)
		usr << "<span class='notice'>There's no tape!</span>"
		return
	if(mytape.ruined)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(emagged == 1)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	if(!canprint)
		usr << "<span class='notice'>The recorder can't print that fast!</span>"
		return
	if(recording == 1 || playing == 1)
		usr << "<span class='notice'>You can't print the transcript while playing or recording!</span>"
		return

	usr << "<span class='notice'>Transcript printed.</span>"
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i=1,mytape.storedinfo.len >= i,i++)
		var/printedmessage = mytape.storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(mytape.timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.name = "Transcript"
	canprint = 0
	sleep(300)
	canprint = 1


/obj/item/device/taperecorder/attack_self(mob/user)
	if(recording == 1 || playing == 1)
		stop()
	else
		record()


/obj/item/device/taperecorder/update_icon()
	if(!mytape)
		icon_state = "taperecorder_empty"
	else if(recording)
		icon_state = "taperecorder_recording"
	else if(playing)
		icon_state = "taperecorder_playing"
	else
		icon_state = "taperecorder_idle"




/obj/item/device/tape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	icon_state = "tape_white"
	item_state = "analyzer"
	w_class = 1
	matter = list(DEFAULT_WALL_MATERIAL=20, "glass"=5)
	force = 1
	throwforce = 0
	var/max_capacity = 600
	var/used_capacity = 0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/ruined = 0


/obj/item/device/tape/fire_act()
	ruin()

/obj/item/device/tape/attack_self(mob/user)
	if(!ruined)
		user << "<span class='notice'>You pull out all the tape!</span>"
		ruin()


/obj/item/device/tape/proc/ruin()
	if(!ruined)
		overlays += "ribbonoverlay"
	ruined = 1


/obj/item/device/tape/proc/fix()
	overlays -= "ribbonoverlay"
	ruined = 0


/obj/item/device/tape/attackby(obj/item/I, mob/user, params)
	if(ruined && istype(I, /obj/item/weapon/screwdriver))
		user << "<span class='notice'>You start winding the tape back in...</span>"
		if(do_after(user, 120, target = src))
			user << "<span class='notice'>You wound the tape back in.</span>"
			fix()


//Random colour tapes
/obj/item/device/tape/random/New()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"