/decl/communication_channel/ooc/looc
	name = "LOOC"
	config_setting = "looc_allowed"
	flags = COMMUNICATION_NO_GUESTS|COMMUNICATION_LOG_CHANNEL_NAME|COMMUNICATION_ADMIN_FOLLOW
	show_preference_setting = /datum/client_preference/show_looc

/decl/communication_channel/ooc/looc/can_communicate(var/client/C, var/message)
	. = ..()
	if(!.)
		return
	var/mob/M = C.mob ? C.mob.get_looc_mob() : null
	if(!M)
		to_chat(C, "<span class='danger'>You cannot use [name] without a mob.</span>")
		return FALSE
	if(!get_turf(M))
		to_chat(C, "<span class='danger'>You cannot use [name] while in nullspace.</span>")
		return FALSE

/decl/communication_channel/ooc/looc/do_communicate(var/client/C, var/message)
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
		received_message = emoji_parse(received_message, t)
		receive_communication(C, t, received_message)

	for(var/client/adm in GLOB.admins)	//Now send to all admins that weren't in range.
		if(!(adm in listening_clients) && adm.get_preference_value(/datum/client_preference/staff/show_rlooc) == GLOB.PREF_SHOW)
			var/received_message = adm.receive_looc(C, key, message, "R")
			received_message = emoji_parse(received_message, adm)
			receive_communication(C, adm, received_message)

/client/proc/receive_looc(var/client/C, var/commkey, var/message, var/prefix)
	var/mob/M = C.mob
	var/display_name = isghost(M) ? commkey : M.name
	var/admin_stuff = holder ? "/([commkey])" : ""
	if(prefix)
		prefix = "\[[prefix]\] "
	return "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", src) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[message]</span></span></span>"

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
