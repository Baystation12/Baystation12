/obj/item/device/taperecorder
	name = "universal recorder"
	desc = "A device that can record up to an hour of dialogue and play it back. It automatically translates the content in playback."
	icon_state = "taperecorderidle"
	item_state = "analyzer"
	w_class = 2.0

	matter = list(DEFAULT_WALL_MATERIAL = 60,"glass" = 30)

	var/emagged = 0.0
	var/recording = 0.0
	var/playing = 0.0
	var/timerecorded = 0.0
	var/playsleepseconds = 0.0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/canprint = 1
	flags = CONDUCT
	throwforce = 2
	throw_speed = 4
	throw_range = 20

/obj/item/device/taperecorder/hear_talk(mob/living/M as mob, msg, var/verb="says", datum/language/speaking=null)
	if(recording)
		timestamp += timerecorded

		if(speaking)
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] [speaking.format_message_plain(msg, verb)]"
		else
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] [verb], \"[msg]\""

/obj/item/device/taperecorder/see_emote(mob/M as mob, text, var/emote_type)
	if(emote_type != 2) //only hearable emotes
		return
	if(recording)
		timestamp += timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [strip_html_properly(text)]"

/obj/item/device/taperecorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type == 2) //must be hearable
		recordedtext = msg
	else if (alt && alt_type == 2)
		recordedtext = alt
	else
		return
	if(recording)
		timestamp += timerecorded
		storedinfo += "*\[[time2text(timerecorded*10,"mm:ss")]\] *[strip_html_properly(recordedtext)]*" //"*" at front as a marker

/obj/item/device/taperecorder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/card/emag))
		if(emagged == 0)
			emagged = 1
			recording = 0
			user << "<span class='warning'>PZZTTPFFFT</span>"
			icon_state = "taperecorderidle"
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
	if(emagged == 1)
		usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
		return
	icon_state = "taperecorderrecording"
	if(timerecorded < 3600 && playing == 0)
		usr << "<span class='notice'>Recording started.</span>"
		recording = 1
		timestamp+= timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording started."
		for(timerecorded, timerecorded<3600)
			if(recording == 0)
				break
			timerecorded++
			sleep(10)
		recording = 0
		icon_state = "taperecorderidle"
		return
	else
		usr << "<span class='notice'>Either your tape recorder's memory is full, or it is currently playing back its memory.</span>"


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
		timestamp+= timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording stopped."
		usr << "<span class='notice'>Recording stopped.</span>"
		icon_state = "taperecorderidle"
		return
	else if(playing == 1)
		playing = 0
		var/turf/T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Playback stopped.</font>")
		icon_state = "taperecorderidle"
		return


/obj/item/device/taperecorder/verb/clear_memory()
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
		timerecorded = 0
		usr << "<span class='notice'>Memory cleared.</span>"
		return


/obj/item/device/taperecorder/verb/playback_memory()
	set name = "Playback Memory"
	set category = "Object"

	if(usr.stat)
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
	icon_state = "taperecorderplaying"
	usr << "<span class='notice'>Playing started.</span>"
	for(var/i=1,timerecorded<3600,sleep(10 * (playsleepseconds) ))
		if(playing == 0)
			break
		if(storedinfo.len < i)
			break
		var/turf/T = get_turf(src)
		var/playedmessage = storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: [playedmessage]</font>")
		if(storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: End of recording.</font>")
		else
			playsleepseconds = timestamp[i+1] - timestamp[i]
		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Skipping [playsleepseconds] seconds of silence</font>")
			playsleepseconds = 1
		i++
	icon_state = "taperecorderidle"
	playing = 0
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
	for(var/i=1,storedinfo.len >= i,i++)
		var/printedmessage = storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.name = "Transcript"
	canprint = 0
	sleep(300)
	canprint = 1


/obj/item/device/taperecorder/attack_self(mob/user)
	if(recording == 0 && playing == 0)
		if(usr.stat)
			return
		if(emagged == 1)
			usr << "<span class='warning'>The tape recorder makes a scratchy noise.</span>"
			return
		icon_state = "taperecorderrecording"
		if(timerecorded < 3600 && playing == 0)
			usr << "<span class='notice'>Recording started.</span>"
			recording = 1
			timestamp+= timerecorded
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording started."
			for(timerecorded, timerecorded<3600)
				if(recording == 0)
					break
				timerecorded++
				sleep(10)
			recording = 0
			icon_state = "taperecorderidle"
			return
		else
			usr << "<span class='warning'>Either your tape recorder's memory is full, or it is currently playing back its memory.</span>"
	else
		if(usr.stat)
			usr << "Not when you're incapacitated."
			return
		if(recording == 1)
			recording = 0
			timestamp+= timerecorded
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording stopped."
			usr << "<span class='notice'>Recording stopped.</span>"
			icon_state = "taperecorderidle"
			return
		else if(playing == 1)
			playing = 0
			var/turf/T = get_turf(src)
			for(var/mob/O in hearers(world.view-1, T))
				O.show_message("<font color=Maroon><B>Tape Recorder</B>: Playback stopped.</font>",2)
			icon_state = "taperecorderidle"
			return
		else
			usr << "<span class='warning'>Stop what?</span>"
			return
