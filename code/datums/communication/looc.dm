/decl/communication_channel/ooc/looc
	name = "LOOC"
	config_setting = "looc_allowed"
	flags = COMMUNICATION_NO_GUESTS|COMMUNICATION_LOG_CHANNEL_NAME
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
		receive_communication(communicator, t, message, key, listening_mob.looc_prefix())

	for(var/client/adm in admins)	//Now send to all admins that weren't in range.
		if(!(adm in listening_clients) && adm.is_preference_enabled(/datum/client_preference/holder/show_rlooc))
			receive_communication(communicator, adm, message, key, "R")

/decl/communication_channel/ooc/looc/do_receive_communication(var/datum/communicator, var/client/receiver, var/message, var/key, var/prefix)
	receiver.receive_looc(communicator, key, message, prefix)

/client/proc/receive_looc(var/mob/communicator, var/commkey, var/message, var/prefix)
	var/display_name = isghost(communicator) ? commkey : communicator.name
	var/admin_stuff = holder ? "/([commkey])" : ""
	if(prefix)
		prefix = "\[[prefix]\] "
	to_chat(src, "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", src) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[message]</span></span></span>")

/mob/proc/looc_prefix()
	return eyeobj ? "Body" : ""

/mob/observer/eye/looc_prefix()
	return "Eye"
