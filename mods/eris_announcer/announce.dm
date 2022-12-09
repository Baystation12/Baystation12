
/singleton/modpack/announce
	name = "Eris Announce"
	dreams = list("AI voice")

#define GET_ANNOUNCEMENT_FREQ(X) GLOB.using_map.use_job_frequency_announcement ? get_announcement_frequency(X) : "Common"
#define ANNOUNSER_NAME "[station_name()] Automated Announcement System"

var/global/command_name
/proc/command_name()
	if (global.command_name)
		return global.command_name
	global.command_name = "[GLOB.using_map.boss_name]"
	return global.command_name

/datum/announcement
	var/channel_name = "Station Announcements"


/datum/announcement/priority/security/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/announcement/priority/command/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "[command_name()] Update"
	announcement_type = "[command_name()] Update"

/datum/announcement/proc/Announce(var/message as text, var/new_title = "", var/new_sound = null, var/do_newscast = newscast, var/msg_sanitized = 0, var/zlevels = GLOB.using_map.contact_levels, var/radio_mode = GLOB.using_map.use_radio_announcement)
	if(!message)
		return
	var/message_title = new_title ? new_title : title
	var/message_sound = new_sound ? new_sound : sound
	var/zlevel = LAZYLEN(zlevels) ? pick(zlevels) : 1

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
	message_title = sanitize(message_title)

	var/msg = radio_mode ? FormRadioMessage(message, message_title, zlevel) : FormMessage(message, message_title)
	for(var/mob/M in GLOB.player_list)
		if((M.z in (zlevels | GLOB.using_map.admin_levels)) && !istype(M,/mob/new_player) && !isdeaf(M))
			to_chat(M, msg)
			if(message_sound)
				sound_to(M, message_sound)

	if(do_newscast)
		NewsCast(message, message_title)

	if(log)
		log_say("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)

/datum/announcement/proc/FormMessage(message as text, message_title as text)
	. = "<h2 class='alert'>[message_title]</h2>"
	. += "<br><span class='alert'>[message]</span>"
	if (announcer)
		. += "<br><span class='alert'> -[html_encode(announcer)]</span>"

/datum/announcement/minor/FormMessage(message as text, message_title as text)
	. = "<b>[message]</b>"

/datum/announcement/priority/FormMessage(message as text, message_title as text)
	. = "<h1 class='alert'>[message_title]</h1>"
	. += "<br><span class='alert'>[message]</span>"
	if(announcer)
		. += "<br><span class='alert'> -[html_encode(announcer)]</span>"
	. += "<br>"

/datum/announcement/priority/command/FormMessage(message as text, message_title as text)
	. = "<h1 class='alert'>[command_name()] Update</h1>"
	if (message_title)
		. += "<br><h2 class='alert'>[message_title]</h2>"
	. += "<br><span class='alert'>[message]</span><br>"
	. += "<br>"

/datum/announcement/priority/security/FormMessage(message as text, message_title as text)
	. = "<font size=4 color='red'>[message_title]</font>"
	. += "<br><font color='red'>[message]</font>"

/////// ANNOUNCEMENT PROCS VIA RADIO ///////
/datum/announcement/proc/FormRadioMessage(message as text, message_title as text, zlevel)
	GLOB.global_announcer.autosay("<b><font size=3><span class='warning'>[title]:</span> [message]</font></b>", announcer ? announcer : ANNOUNSER_NAME,, zlevel)

/datum/announcement/minor/FormRadioMessage(message as text, message_title as text, zlevel)
	GLOB.global_announcer.autosay(message, ANNOUNSER_NAME,, zlevel)

/datum/announcement/priority/FormRadioMessage(message as text, message_title as text, zlevel)
	GLOB.global_announcer.autosay("<b><font size=3><span class='warning'>[message_title]:</span> [message]</font></b>", announcer ? announcer : ANNOUNSER_NAME,, zlevel)

/datum/announcement/priority/command/FormRadioMessage(message as text, message_title as text, zlevel)
	GLOB.global_announcer.autosay("<b><font size=3><span class='warning'>[command_name()] Update[message_title ? " — [message_title]" : ""]:</span> [message]</font></b>", ANNOUNSER_NAME,, zlevel)

/datum/announcement/priority/security/FormRadioMessage(message as text, message_title as text, zlevel)
	GLOB.global_announcer.autosay("<b><font size=3><span class='warning'>[message_title]:</span> [message]</font></b>", ANNOUNSER_NAME,, zlevel)

/////// ANNOUNCEMENT PROCS ///////
/datum/announcement/proc/Message(message as text, message_title as text)
	GLOB.global_announcer.autosay("<font size=3><span class='warning'>[title]:</span> [message]</font>", announcer ? announcer : ANNOUNSER_NAME)

/datum/announcement/minor/Message(message as text, message_title as text)
	GLOB.global_announcer.autosay(message, ANNOUNSER_NAME)

/datum/announcement/priority/Message(message as text, message_title as text)
	GLOB.global_announcer.autosay("<font size=3><span class='alert'>[message_title]:</span> [message]</font>", announcer ? announcer : ANNOUNSER_NAME)

/datum/announcement/priority/command/Message(message as text, message_title as text)
	GLOB.global_announcer.autosay("<font size=3><span class='warning'>[command_name()] [message_title]:</span> [message]</font>", ANNOUNSER_NAME)

/datum/announcement/priority/security/Message(message as text, message_title as text)
	GLOB.global_announcer.autosay("<font size=3><font color='red'>[message_title]:</span> [message]</font>", ANNOUNSER_NAME)


/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/datum/job/job, var/join_message)
	if(!istype(job) || !job.announced)
		return
	if (GAME_STATE != RUNLEVEL_GAME)
		return
	var/rank = job.title
	if(character.mind.role_alt_title)
		rank = character.mind.role_alt_title

	AnnounceArrivalSimple(character.real_name, rank, join_message, GET_ANNOUNCEMENT_FREQ(job))
