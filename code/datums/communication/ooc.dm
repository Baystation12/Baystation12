/decl/communication_channel/ooc
	log_proc = /proc/log_ooc
	expected_communicator_type = /mob
	var/ooc_type = "OOC"
	var/show_preference_setting = /datum/client_preference/show_ooc

/decl/communication_channel/ooc/can_communicate(var/mob/communicator, var/message)
	. = ..()
	if(!.)
		return

	var/client/C = communicator.get_client()
	if(!C)
		return FALSE

	if(IsGuestKey(communicator.key))
		to_chat(communicator, "<span class='danger'>Guests may not use [ooc_type].</span>")
		return FALSE

	if(C.is_preference_disabled(show_preference_setting) && !check_rights(R_INVESTIGATE, 0 , C))
		to_chat(communicator, "<span class='warning'>You have [ooc_type] muted.</span>")
		return FALSE

	if(!C.holder)
		if(!config.ooc_allowed)
			to_chat(communicator, "<span class='danger'>[ooc_type] is globally muted.</span>")
			return FALSE
		if(!config.dooc_allowed && (communicator.stat == DEAD))
			to_chat(communicator, "<span class='danger'>[ooc_type] for dead mobs has been turned off.</span>")
			return FALSE
		if(C.prefs.muted & MUTE_OOC)
			to_chat(communicator, "<span class='danger'>You cannot use [ooc_type] (muted).</span>")
			return FALSE
		if(findtext(message, "byond://"))
			to_chat(communicator, "<B>Advertising other servers is not allowed.</B>")
			log_and_message_admins("has attempted to advertise in [ooc_type]: [message]")
			return FALSE

/decl/communication_channel/ooc/do_communicate(var/mob/communicator, var/message)
	var/client/C = communicator.client
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
		// Admins (investigators) are expected to monitor the OOC chat. They can deadmin if they don't wish to bother.
		if(target.is_preference_enabled(/datum/client_preference/show_ooc) || check_rights(R_INVESTIGATE, 0 , target))
			if(target.is_key_ignored(communicator.key)) // If we're ignored by this person, then do nothing.
				continue
			if(can_badmin)
				to_chat(target, "<font color='[ooc_color]'><span class='ooc'>" + create_text_tag("ooc", "OOC:", target) + " <EM>[C.key]:</EM> <span class='message'>[message]</span></span></font>")
			else
				to_chat(target, "<span class='ooc'><span class='[ooc_style]'>" + create_text_tag("ooc", "OOC:", target) + " <EM>[C.key]:</EM> <span class='message'>[message]</span></span></span>")
