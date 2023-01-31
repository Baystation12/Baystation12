var/global/datum/announcement/priority/priority_announcement = new(do_log = 0)
var/global/datum/announcement/priority/command/command_announcement = new(do_log = 0, do_newscast = 1)
var/global/datum/announcement/minor/minor_announcement = new(new_sound = 'sound/AI/commandreport.ogg',)

/datum/announcement
	var/title = "Attention"
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	var/channel_name = "Announcements"
	var/announcement_type = "Announcement"

/datum/announcement/priority
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"

/datum/announcement/priority/security
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/announcement/New(do_log = 0, new_sound = null, do_newscast = 0)
	sound = new_sound
	log = do_log
	newscast = do_newscast

/datum/announcement/priority/command/New(do_log = 1, new_sound = 'sound/misc/notice2.ogg', do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "[GLOB.using_map.boss_name] Update"
	announcement_type = "[GLOB.using_map.boss_name] Update"

/datum/announcement/proc/Announce(message as text, new_title = "", new_sound = null, do_newscast = newscast, msg_sanitized = 0, zlevels = GLOB.using_map.contact_levels)
	if(!message)
		return
	var/message_title = new_title ? new_title : title
	var/message_sound = new_sound ? new_sound : sound

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
	message_title = sanitizeSafe(message_title)

	var/msg = FormMessage(message, message_title)
	for(var/mob/M in GLOB.player_list)
		if(M.client && (get_z(M) in (zlevels | GLOB.using_map.admin_levels)) && !istype(M,/mob/new_player) && !isdeaf(M))
			to_chat(M, msg)
			if(message_sound && M.client.get_preference_value(/datum/client_preference/play_announcement_sfx) == GLOB.PREF_YES)
				sound_to(M, message_sound)

	if(do_newscast)
		NewsCast(message, zlevels)

	if(log)
		log_say("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)

/datum/announcement/proc/FormMessage(message as text, message_title as text)
	. = "<h2 class='alert'>[message_title]</h2>"
	. += "<br>[SPAN_CLASS("alert", "[message]")]"
	if (announcer)
		. += "<br>[SPAN_CLASS("alert", " -[html_encode(announcer)]")]"

/datum/announcement/minor/FormMessage(message as text, message_title as text)
	. = "<b>[message]</b>"

/datum/announcement/priority/FormMessage(message as text, message_title as text)
	. = "<h1 class='alert'>[message_title]</h1>"
	. += "<br>[SPAN_CLASS("alert", "[message]")]"
	if(announcer)
		. += "<br>[SPAN_CLASS("alert", " -[html_encode(announcer)]")]"
	. += "<br>"

/datum/announcement/priority/command/FormMessage(message as text, message_title as text)
	. = "<h1 class='alert'>[GLOB.using_map.boss_name] Update</h1>"
	if (message_title)
		. += "<br><h2 class='alert'>[message_title]</h2>"

	. += "<br>[SPAN_CLASS("alert", "[message]")]<br>"
	. += "<br>"

/datum/announcement/priority/security/FormMessage(message as text, message_title as text)
	. = FONT_HUGE(SPAN_COLOR("red", message_title))
	. += "<br>[SPAN_COLOR("red", message)]"


/datum/announcement/proc/NewsCast(message, list/zlevels)
	if (!message || !islist(zlevels))
		return
	var/datum/feed_network/network
	for (var/datum/feed_network/candidate as anything in news_network)
		if (zlevels[1] in candidate.z_levels)
			network = candidate
			break
	if (!network)
		return
	var/datum/feed_channel/channel
	for (var/datum/feed_channel/candidate as anything in network.network_channels)
		if (candidate.channel_name == channel_name)
			channel = candidate
			break
	if (!channel)
		channel = new
		channel.channel_name = channel_name
		channel.author = announcer
		channel.locked = TRUE
		channel.is_admin_channel = TRUE
		network.network_channels += channel
	network.SubmitArticle(message, announcer || channel.author, channel_name, null, FALSE, announcement_type)


/proc/GetNameAndAssignmentFromId(obj/item/card/id/I)
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	if (!I)
		return "Unknown"
	if (I.assignment)
		return "[I.registered_name] ([I.assignment])"
	return "[I.registered_name]"

/proc/level_seven_announcement()
	GLOB.using_map.level_x_biohazard_announcement(7)

/proc/ion_storm_announcement(list/affecting_z)
	command_announcement.Announce("It has come to our attention that the [station_name()] passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert", zlevels = affecting_z)

/proc/AnnounceArrival(mob/living/carbon/human/character, datum/job/job, join_message)
	if(!istype(job) || !job.announced)
		return
	if (GAME_STATE != RUNLEVEL_GAME)
		return
	var/rank = job.title
	if(character.mind.role_alt_title)
		rank = character.mind.role_alt_title

	AnnounceArrivalSimple(character.real_name, rank, join_message, get_announcement_frequency(job))

/proc/AnnounceArrivalSimple(name, rank = "visitor", join_message = "has arrived on the [station_name()]", frequency)
	GLOB.global_announcer.autosay("[name], [rank], [join_message].", "Arrivals Announcement Computer", frequency)

/proc/get_announcement_frequency(datum/job/job)
	// During red alert all jobs are announced on main frequency.
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	if (security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level))
		return "Common"

	if(job.department_flag & (COM | CIV | MSC))
		return "Common"
	if(job.department_flag & SUP)
		return "Supply"
	if(job.department_flag & SPT)
		return "Command"
	if(job.department_flag & SEC)
		return "Security"
	if(job.department_flag & ENG)
		return "Engineering"
	if(job.department_flag & MED)
		return "Medical"
	if(job.department_flag & SCI)
		return "Science"
	if(job.department_flag & SRV)
		return "Service"
	if(job.department_flag & EXP)
		return "Exploration"
	return "Common"
