var/repository/adminhelp/adminhelp_repository = new()

/repository/adminhelp
	var/list/adminhelps_archive
	var/list/adminhelps_taken
	var/list/adminhelps_available

	var/list/event_listeners // things that get their on_adminhelp called when we update

/repository/adminhelp/New()
	..()
	adminhelps_archive = list()
	adminhelps_taken = list()
	adminhelps_available = list()

	event_listeners = list()

/repository/adminhelp/proc/admin_disconnect(var/client/C)
	dispatch("on_admindiscon", C)

/repository/adminhelp/proc/listen(var/listener)
	if(!(listener in event_listeners))
		event_listeners += listener

/repository/adminhelp/proc/dispatch(var/name, var/p)
	for(var/listener in event_listeners)
		call(listener,name)(p)

/repository/adminhelp/proc/store_new_adminhelp(var/sender, var/msg)
	if(istype(sender, /client))
		sender = client_repository.get_lite_client(sender)

	if(!istype(sender, /datum/client_lite))
		return

	var/datum/adminhelp/AH = new(sender, msg)
	adminhelps_available.Insert(1, AH) // newest first
	dispatch("on_adminhelp")
	return AH

/repository/adminhelp/proc/mark_handled(var/datum/adminhelp/AH, var/forwarding)
	if(!istype(AH))
		return

	if(!(AH in adminhelps_available))
		return
	if(AH in adminhelps_taken)
		return

	adminhelps_available -= AH
	adminhelps_taken += AH
	if(!forwarding)
		dispatch("on_adminhelp")

/repository/adminhelp/proc/mark_released(var/datum/adminhelp/AH)
	if(!istype(AH))
		return

	if(!(AH in adminhelps_taken))
		return

	if(AH in adminhelps_available)
		return

	adminhelps_taken -= AH
	adminhelps_available += AH
	dispatch("on_adminhelp")

/repository/adminhelp/proc/mark_dismissed(var/datum/adminhelp/AH)
	if(!istype(AH))
		return

	if(AH in adminhelps_archive)
		return

	if(AH in adminhelps_available)
		adminhelps_available -= AH
	else if(AH in adminhelps_taken)
		adminhelps_taken -= AH

	adminhelps_archive += AH
	dispatch("on_adminhelp")

/repository/adminhelp/proc/mark_forwarded(var/datum/adminhelp/AH)
	mark_handled(AH, forwarding=TRUE)
	AH.forwarded = TRUE
	dispatch("on_adminhelp")

/repository/adminhelp/proc/outstanding_adminhelps()
	return adminhelps_available.len

/datum/adminhelp
	var/station_time
	var/datum/client_lite/sender
	var/datum/client_lite/handler
	var/msg
	var/forwarded
	var/archived

/datum/adminhelp/New(var/datum/client_lite/sender, var/msg)
	src.station_time = time_stamp()
	src.sender = sender
	src.handler = null
	src.msg = msg
	src.archived = FALSE

/datum/adminhelp/proc/forward(var/client/handler)
	src.handler = client_repository.get_lite_client(handler)
	log_and_message_admins("has forwarded ahelp from [sender.key_name(rank=FALSE)] --> [src.handler.key_name(name=FALSE)]")
	if(handler.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
		sound_to(handler, 'sound/effects/adminhelp.ogg')
	to_chat(handler, "<span class='notice'><font color='red'><b>[key_name(usr)] has forwarded you an adminhelp from [sender.key_name(rank=FALSE)]:</b></font> [msg]</span>")
	adminhelp_repository.mark_forwarded(src)

/datum/adminhelp/proc/take(var/client/handler)
	src.handler = client_repository.get_lite_client(handler)
	var/take_msg = "<span class='notice'><b>ADMINHELP</b>: <b>[src.handler.key_name(name=FALSE)]</b> is attending to <b>[sender.key_name(rank=FALSE)]'s</b> message, please don't dogpile them.</span>"
	send2adminirc("[src.handler.key_name(FALSE, name=FALSE)] is attending to [sender.key_name(FALSE, rank=FALSE)]'s message, please don't dogpile them.")
	for(var/client/X in admins)
		if(R_ADMINHELP & X.holder.rights)
			to_chat(X, take_msg)

	adminhelp_repository.mark_handled(src)

	var/client/C = locate(sender.ref)
	if(!C)
		C = client_by_ckey(sender.ckey)
		if(!C)
			to_chat(usr, "<span class='warn'>[sender.key_name(rank=FALSE)] is offline!</span>")
			return
	to_chat(C, "<span class='notice'><b>Your message is being attended to by [src.handler.key_name(name=FALSE)]. Thanks for your patience!</b></span>")

/datum/adminhelp/proc/release()
	src.handler = null
	var/datum/client_lite/freeby = client_repository.get_lite_client(usr) // solely for asthetics
	var/take_msg = "<span class='notice'><b>ADMINHELP</b>: <b>[freeby.key_name(name=FALSE)]</b> has released <b>[sender.key_name(rank=FALSE)]'s</b> message.</span>"
	send2adminirc("[freeby.key_name(FALSE, name=FALSE)] has released [sender.key_name(FALSE, rank=FALSE)]'s message.")
	for(var/client/X in admins)
		if(R_ADMINHELP & X.holder.rights)
			to_chat(X, take_msg)

	adminhelp_repository.mark_released(src)

/datum/adminhelp/proc/dismiss()
	archived = TRUE
	var/datum/client_lite/dismissor = client_repository.get_lite_client(usr) // solely for asthetics
	var/take_msg = "<span class='notice'><b>ADMINHELP</b>: <b>[dismissor.key_name(name=FALSE)]</b> has dismissed <b>[sender.key_name(rank=FALSE)]'s</b> message.</span>"
	for(var/client/X in admins)
		if(R_ADMINHELP & X.holder.rights)
			to_chat(X, take_msg)

	adminhelp_repository.mark_dismissed(src)

	var/client/C = locate(sender.ref)
	if(!C)
		C = client_by_ckey(sender.ckey)
		if(!C)
			return
	to_chat(C, "<span class='notice'><b>Your message has been marked as resolved by [dismissor.key_name(name=FALSE)].</b></span>")
