/decl/communication_channel/ooc/looc
	name = "LOOC"
	config_setting = "looc_allowed"
	flags = COMMUNICATION_NO_GUESTS|COMMUNICATION_LOG_CHANNEL_NAME|COMMUNICATION_ADMIN_FOLLOW
	show_preference_setting = /datum/client_preference/show_looc

/decl/communication_channel/ooc/looc/can_communicate(var/mob/communicator, var/message)
	. = ..()
	if(!.)
		return
	if(!get_turf(communicator))
		to_chat(communicator, "<span class='danger'>You cannot use [name] while in nullspace.</span>")
		return FALSE

/decl/communication_channel/ooc/looc/do_communicate(var/mob/communicator, var/message)
	var/list/listening_hosts = hosts_in_view_range(communicator)
	var/list/listening_clients = list()

	var/client/C = communicator.get_client()
	var/key = C.key

	for(var/listener in listening_hosts)
		var/mob/listening_mob = listener
		var/client/t = listening_mob.get_client()
		if(!t)
			continue
		listening_clients |= t
		var/received_message = t.receive_looc(communicator, key, message, listening_mob.looc_prefix())
		receive_communication(communicator, t, received_message)

	for(var/client/adm in admins)	//Now send to all admins that weren't in range.
		if(!(adm in listening_clients) && adm.is_preference_enabled(/datum/client_preference/holder/show_rlooc))
			var/received_message = adm.receive_looc(communicator, key, message, "R")
			receive_communication(communicator, adm, received_message)

/client/proc/receive_looc(var/mob/communicator, var/commkey, var/message, var/prefix)
	var/display_name = isghost(communicator) ? commkey : communicator.name
	var/admin_stuff = holder ? "/([commkey])" : ""
	if(prefix)
		prefix = "\[[prefix]\] "
	return "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", src) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[message]</span></span></span>"

/mob/proc/looc_prefix()
	return eyeobj ? "Body" : ""

/mob/observer/eye/looc_prefix()
	return "Eye"
