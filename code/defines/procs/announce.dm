/var/datum/announcement/priority/priority_announcement = new(do_log = 0)
/var/datum/announcement/priority/command/command_announcement = new(do_log = 0, do_newscast = 1)

/datum/announcement
	var/title = "Attention"
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	var/channel_name = "Station Announcements"
	var/announcement_type = "Announcement"

/datum/announcement/New(var/do_log = 0, var/new_sound = null, var/do_newscast = 0)
	sound = new_sound
	log = do_log
	newscast = do_newscast

/datum/announcement/priority/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"

/datum/announcement/priority/command/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "[command_name()] Update"
	announcement_type = "[command_name()] Update"

/datum/announcement/priority/security/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/announcement/proc/Announce(var/message as text, var/new_title = "", var/new_sound = null, var/do_newscast = newscast, var/msg_sanitized = 0)
	if(!message)
		return
	var/message_title = new_title ? new_title : title
	var/message_sound = new_sound ? new_sound : sound

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
	message_title = sanitizeSafe(message_title)

	Message(message, message_title)
	if(do_newscast)
		NewsCast(message, message_title)
	Sound(message_sound)
	Log(message, message_title)

datum/announcement/proc/Message(message as text, message_title as text)
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			to_chat(M, "<h2 class='alert'>[title]</h2>")
			to_chat(M, "<span class='alert'>[message]</span>")
			if (announcer)
				to_chat(M, "<span class='alert'> -[html_encode(announcer)]</span>")
datum/announcement/minor/Message(message as text, message_title as text)
	to_world("<b>[message]</b>")

datum/announcement/priority/Message(message as text, message_title as text)
	to_world("<h1 class='alert'>[message_title]</h1>")
	to_world("<span class='alert'>[message]</span>")
	if(announcer)
		to_world("<span class='alert'> -[html_encode(announcer)]</span>")
	to_world("<br>")

datum/announcement/priority/command/Message(message as text, message_title as text)
	var/command
	command += "<h1 class='alert'>[command_name()] Update</h1>"
	if (message_title)
		command += "<br><h2 class='alert'>[message_title]</h2>"

	command += "<br><span class='alert'>[message]</span><br>"
	command += "<br>"
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			to_chat(M, command)
datum/announcement/priority/security/Message(message as text, message_title as text)
	to_world("<font size=4 color='red'>[message_title]</font>")
	to_world("<font color='red'>[message]</font>")

datum/announcement/proc/NewsCast(message as text, message_title as text)
	if(!newscast)
		return

	var/datum/news_announcement/news = new
	news.channel_name = channel_name
	news.author = announcer
	news.message = message
	news.message_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

datum/announcement/proc/PlaySound(var/message_sound)
	if(!message_sound)
		return
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			sound_to(M, message_sound)

datum/announcement/proc/Sound(var/message_sound)
	PlaySound(message_sound)

datum/announcement/priority/Sound(var/message_sound)
	if(message_sound)
		sound_to(world, message_sound)

datum/announcement/priority/command/Sound(var/message_sound)
	PlaySound(message_sound)

datum/announcement/proc/Log(message as text, message_title as text)
	if(log)
		log_say("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)

/proc/GetNameAndAssignmentFromId(var/obj/item/weapon/card/id/I)
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	return I.assignment ? "[I.registered_name] ([I.assignment])" : I.registered_name

/proc/level_seven_announcement()
	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

/proc/ion_storm_announcement()
	command_announcement.Announce("It has come to our attention that the station passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert")

/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank, var/join_message)
	if (ticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		AnnounceArrivalSimple(character.real_name, rank, join_message)

/proc/AnnounceArrivalSimple(var/name, var/rank = "visitor", var/join_message = "has arrived on the station")
	global_announcer.autosay("[name], [rank], [join_message].", "Arrivals Announcement Computer")
