#define plain_key_name(A) key_name(A, highlight_special_characters = 0)

/decl/communication_channel
	var/name
	var/config_setting
	var/expected_communicator_type = /datum
	var/flags
	var/log_proc
	var/mute_setting
	var/show_preference_setting

/*
* Procs for handling sending communication messages
*/
/decl/communication_channel/proc/communicate(var/datum/communicator, var/message)
	if(can_communicate(arglist(args)))
		call(log_proc)("[(flags&COMMUNICATION_LOG_CHANNEL_NAME) ? "([name]) " : ""][communicator.communication_identifier()] : [message]")
		return do_communicate(arglist(args))
	return FALSE

/decl/communication_channel/proc/can_communicate(var/datum/communicator, var/message)
	if(!message)
		return FALSE

	if(!istype(communicator, expected_communicator_type))
		log_debug("[log_info_line(communicator)] attempted to communicate over the channel [src] but was of an unexpected type.")
		return FALSE

	if(config_setting && !config.vars[config_setting] && !check_rights(R_INVESTIGATE,0,communicator))
		to_chat(communicator, "<span class='danger'>[name] is globally muted.</span>")
		return FALSE

	if(requires_client_to_send())
		var/client/C = communicator.get_client()
		if(!C)
			return FALSE

		if(show_preference_setting && C.is_preference_disabled(show_preference_setting) && !check_rights(R_INVESTIGATE,0,C))
			to_chat(communicator, "<span class='warning'>You have [name] muted.</span>")
			return FALSE

		if(mute_setting && (C.prefs.muted & mute_setting))
			to_chat(communicator, "<span class='danger'>You cannot use [name] (muted).</span>")
			return FALSE

		if((flags & COMMUNICATION_NO_GUESTS) && IsGuestKey(C.key))
			to_chat(communicator, "<span class='danger'>Guests may not use the [name] channel.</span>")
			return FALSE

	return TRUE

/decl/communication_channel/proc/do_communicate(var/communicator, var/message)
	return

/*
* Procs for handling the reception of communication messages
*/
/decl/communication_channel/proc/receive_communication(var/datum/communicator, var/datum/receiver, var/message)
	if(can_receive_communication(receiver))
		if(flags & COMMUNICATION_GHOST_FOLLOW)
			var/extra_links = receiver.get_ghost_follow_link(communicator)
			if(extra_links)
				message = "([extra_links]) [message]"
		if(flags & COMMUNICATION_ADMIN_FOLLOW)
			var/extra_links = receiver.get_admin_jump_link(communicator)
			if(extra_links)
				message = "([extra_links]) [message]"
		do_receive_communication(arglist(args))

/decl/communication_channel/proc/can_receive_communication(var/datum/receiver)
	if(requires_client_to_receive())
		var/client/C = receiver.get_client()
		if(!C)
			return FALSE
		// Admins (investigators) are expected to monitor channels. They can deadmin if they don't wish to see everything.
		if(C.is_preference_disabled(show_preference_setting) && !check_rights(R_INVESTIGATE, 0 , C))
			return FALSE
	return TRUE

/decl/communication_channel/proc/do_receive_communication(var/datum/communicator, var/datum/receiver, var/message)
	to_chat(receiver, message)

// These proc returns true if any of the current settings requires a client to send or receive
/decl/communication_channel/proc/requires_client_to_send()
	if(flags & COMMUNICATION_NO_GUESTS)
		return TRUE
	if(mute_setting)
		return TRUE
	if(show_preference_setting)
		return TRUE
	return FALSE

/decl/communication_channel/proc/requires_client_to_receive()
	return show_preference_setting

// Misc. helpers
/datum/proc/communication_identifier()
	return usr ? "[src] - usr: [plain_key_name(usr)]" : "[src]"

/mob/communication_identifier()
	var/key_name = plain_key_name(src)
	return usr != src ? "[key_name] - usr: [plain_key_name(usr)]" : key_name

/proc/sanitize_and_communicate(var/channel_type, var/communicator, var/message)
	message = sanitize(message)
	return communicate(arglist(args))

/proc/communicate(var/channel_type, var/communicator, var/message)
	var/list/channels = decls_repository.decls_of_subtype(/decl/communication_channel)
	var/decl/communication_channel/channel = channels[channel_type]

	var/list/new_args = list(communicator, message)
	new_args += args.Copy(4)

	return channel.communicate(arglist(new_args))

#undef plain_key_name
