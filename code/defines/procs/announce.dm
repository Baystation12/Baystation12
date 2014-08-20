// A default priority announcement which doesn't log
var/global/datum/announcement/priority/priority_announcement = new(0)

/datum/announcement
	var/title = "Attention"
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	var/channel_name = "Public Station Announcements"
	var/announcement_type = "Announcement"

/datum/announcement/New(var/new_sound = null)
	sound = new_sound

/datum/announcement/priority/New(var/do_log = 1, var/new_sound = sound('sound/items/AirHorn.ogg'))
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"
	log = do_log
	sound = new_sound

/datum/announcement/proc/Announce(message as text)
	if (!message)
		return
	Message(message)
	NewsCast(message)
	Sound()
	Log(message)

/datum/announcement/proc/Message(message as text)
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			M << "<h2 class='alert'>[title]</h2>"
			M << "<span class='alert'>[html_encode(message)]</span>"
			if (announcer)
				M << "<span class='alert'> -[html_encode(announcer)]</span>"

/datum/announcement/proc/NewsCast(message as text)
	if(!newscast)
		return

	var/datum/news_announcement/news = new
	news.channel_name = channel_name
	news.author = announcer
	news.message = message
	news.message_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

/datum/announcement/proc/Sound()
	if(!sound)
		return
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			M << sound

/datum/announcement/proc/Log(message as text)
	if(log)
		log_say("[key_name(usr)] has made a(n) [announcement_type]: [title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made a(n) [announcement_type].", 1)

/datum/announcement/priority/Message(message as text)
	world << "<h1 class='alert'>[title]</h1>"
	world << "<span class='alert'>[html_encode(message)]</span>"
	if(announcer)
		world << "<span class='alert'> -[html_encode(announcer)]</span>"
	world << "<br>"

/datum/announcement/priority/Sound()
	if(sound)
		world << sound

/proc/GetNameAndAssignmentFromId(var/obj/item/weapon/card/id/I)
	// Formant currently matches that of newscaster feeds.
	return I.assignment ? "[I.registered_name] ([I.assignment])" : I.registered_name