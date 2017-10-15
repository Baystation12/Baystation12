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

	var/client/C = communicator.get_client()

	if(C && show_preference_setting && C.get_preference_value(show_preference_setting) == GLOB.PREF_HIDE && !check_rights(R_INVESTIGATE,0,C))
		to_chat(communicator, "<span class='warning'>You have [name] muted.</span>")
		return FALSE

	if(C && mute_setting && (C.prefs.muted & mute_setting))
		to_chat(communicator, "<span class='danger'>You cannot use [name] (muted).</span>")
		return FALSE

	if(C && (flags & COMMUNICATION_NO_GUESTS) && IsGuestKey(C.key))
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
		var/has_follow_links = FALSE
		if((flags & COMMUNICATION_ADMIN_FOLLOW))
			var/extra_links = receiver.get_admin_jump_link(communicator,"","\[","\]")
			if(extra_links)
				has_follow_links = TRUE
				message = "[extra_links] [message]"
		if(flags & COMMUNICATION_GHOST_FOLLOW && !has_follow_links)
			var/extra_links = receiver.get_ghost_follow_link(communicator,"","\[","\]")
			if(extra_links)
				message = "[extra_links] [message]"
		do_receive_communication(arglist(args))

/decl/communication_channel/proc/can_receive_communication(var/datum/receiver)
	if(show_preference_setting)
		var/client/C = receiver.get_client()
		// Admins (investigators) are expected to monitor channels. They can deadmin if they don't wish to see everything.
		if(C && C.get_preference_value(show_preference_setting) == GLOB.PREF_HIDE && !check_rights(R_INVESTIGATE, 0 , C))
			return FALSE
	return TRUE

/decl/communication_channel/proc/do_receive_communication(var/datum/communicator, var/datum/receiver, var/message)
	to_chat(receiver, message)

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
	var/list/channels = decls_repository.get_decls_of_subtype(/decl/communication_channel)
	var/decl/communication_channel/channel = channels[channel_type]

	var/list/new_args = list(communicator, message)
	new_args += args.Copy(4)

	return channel.communicate(arglist(new_args))

#undef plain_key_name
