/singleton/communication_channel/ooc/looc
	name = "LOOC"
	config_setting = "looc_allowed"
	flags = COMMUNICATION_NO_GUESTS|COMMUNICATION_LOG_CHANNEL_NAME|COMMUNICATION_ADMIN_FOLLOW
	show_preference_setting = /datum/client_preference/show_looc

/singleton/communication_channel/ooc/looc/can_communicate(client/C, message)
	. = ..()
	if(!.)
		return
	var/mob/M = C.mob ? C.mob.get_looc_mob() : null
	if(!M)
		to_chat(C, SPAN_DANGER("You cannot use [name] without a mob."))
		return FALSE
	if(!get_turf(M))
		to_chat(C, SPAN_DANGER("You cannot use [name] while in nullspace."))
		return FALSE

/singleton/communication_channel/ooc/looc/do_communicate(client/C, message)
	var/mob/M = C.mob ? C.mob.get_looc_mob() : null
	var/list/listening_hosts = hosts_in_view_range(M)
	var/list/listening_clients = list()

	var/key = C.key

	for(var/listener in listening_hosts)
		var/mob/listening_mob = listener
		var/client/t = listening_mob.get_client()
		if(!t)
			continue
		listening_clients |= t
		var/received_message = t.receive_looc(C, key, message, listening_mob.looc_prefix())
		receive_communication(C, t, received_message)

	for(var/client/adm as anything in GLOB.admins)	//Now send to all admins that weren't in range.
		if(!(adm in listening_clients) && adm.get_preference_value(/datum/client_preference/staff/show_rlooc) == GLOB.PREF_SHOW)
			var/received_message = adm.receive_looc(C, key, message, "R")
			receive_communication(C, adm, received_message)

/client/proc/receive_looc(client/C, commkey, message, prefix)
	var/mob/M = C.mob
	var/display_name = isghost(M) ? commkey : M.name
	var/admin_stuff = holder ? "/([commkey])" : ""
	if(prefix)
		prefix = "\[[prefix]\] "
	return SPAN_CLASS("ooc", SPAN_CLASS("looc", "[create_text_tag("looc", "LOOC:", src)] [SPAN_CLASS("prefix", prefix)]<em>[display_name][admin_stuff]:</em> [SPAN_CLASS("message", message)]"))

/mob/proc/looc_prefix()
	return eyeobj ? "Body" : ""

/mob/observer/eye/looc_prefix()
	return "Eye"

/mob/proc/get_looc_mob()
	return src

/mob/living/silicon/ai/get_looc_mob()
	if(!eyeobj)
		return src
	return eyeobj
