/decl/communication_channel/ooc
	name = "OOC"
	config_setting = "ooc_allowed"
	expected_communicator_type = /client
	flags = COMMUNICATION_NO_GUESTS
	log_proc = /proc/log_ooc
	mute_setting = MUTE_OOC
	show_preference_setting = /datum/client_preference/show_ooc

/decl/communication_channel/ooc/can_communicate(var/client/C, var/message)
	. = ..()
	if(!.)
		return

	if(!C.holder)
		if(!config.dooc_allowed && (C.mob.stat == DEAD))
			to_chat(C, "<span class='danger'>[name] for dead mobs has been turned off.</span>")
			return FALSE
		if(findtext(message, "byond://"))
			to_chat(C, "<B>Advertising other servers is not allowed.</B>")
			log_and_message_admins("has attempted to advertise in [name]: [message]")
			return FALSE

/decl/communication_channel/ooc/do_communicate(var/client/C, var/message)
	var/datum/admins/holder = C.holder
	var/is_stealthed = C.is_stealthed()

	var/ooc_style = "everyone"
	if(holder && !is_stealthed)
		ooc_style = "elevated"
		if(holder.rights & R_MOD)
			ooc_style = "moderator"
		if(holder.rights & R_DEBUG)
			ooc_style = "developer"
		if(holder.rights & R_ADMIN)
			ooc_style = "admin"

	var/can_badmin = !is_stealthed && can_select_ooc_color(C) && (C.prefs.ooccolor != initial(C.prefs.ooccolor))
	var/ooc_color = C.prefs.ooccolor

	for(var/client/target in clients)
		if(target.is_key_ignored(C.key)) // If we're ignored by this person, then do nothing.
			continue
		var/sent_message = "[create_text_tag("ooc", "OOC:", target)] <EM>[C.key]:</EM> <span class='message'>[message]</span>"
		if(can_badmin)
			receive_communication(C, target, "<font color='[ooc_color]'><span class='ooc'>[sent_message]</font></span>")
		else
			receive_communication(C, target, "<span class='ooc'><span class='[ooc_style]'>[sent_message]</span></span>")
