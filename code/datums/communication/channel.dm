#define plain_key_name(A) key_name(A, highlight_special_characters = 0)

/singleton/communication_channel
	var/name
	var/config_setting
	var/expected_communicator_type = /datum
	var/flags
	var/log_proc
	var/mute_setting
	var/show_preference_setting


/singleton/communication_channel/proc/can_ignore(client/C)
	if (!C)
		return TRUE
	// Channels that cannot be toggled can never be ignored
	if (!show_preference_setting)
		return FALSE
	// If you're trying to see the channel, you can't ignore it
	return C.get_preference_value(show_preference_setting) != GLOB.PREF_SHOW


/*
* Procs for handling sending communication messages
*/
/singleton/communication_channel/proc/communicate(datum/communicator, message)
	if(can_communicate(arglist(args)))
		call(log_proc)("[(flags&COMMUNICATION_LOG_CHANNEL_NAME) ? "([name]) " : ""][communicator.communication_identifier()] : [message]")
		return do_communicate(arglist(args))
	return FALSE

/singleton/communication_channel/proc/can_communicate(datum/communicator, message)

	if(!message)
		return FALSE

	if(!istype(communicator, expected_communicator_type))
		log_debug("[log_info_line(communicator)] attempted to communicate over the channel [src] but was of an unexpected type.")
		return FALSE

	if(config_setting && !config.vars[config_setting] && !check_rights(R_INVESTIGATE,0,communicator))
		to_chat(communicator, SPAN_DANGER("[name] is globally muted."))
		return FALSE

	var/client/C = communicator.get_client()

	if(jobban_isbanned(C.mob, name))
		to_chat(communicator, SPAN_DANGER("You cannot use [name] (banned)."))
		return FALSE

	if(can_ignore(C))
		to_chat(communicator, SPAN_WARNING("Couldn't send message - you have [name] muted."))
		return FALSE

	if(C && mute_setting && (C.prefs.muted & mute_setting))
		to_chat(communicator, SPAN_DANGER("You cannot use [name] (muted)."))
		return FALSE

	if(C && (flags & COMMUNICATION_NO_GUESTS) && IsGuestKey(C.key))
		to_chat(communicator, SPAN_DANGER("Guests may not use the [name] channel."))
		return FALSE

	if (config.forbidden_message_regex && !check_rights(R_INVESTIGATE, 0, communicator) && findtext(message, config.forbidden_message_regex))
		if (!config.forbidden_message_no_notifications)
			if (!config.forbidden_message_hide_details)
				log_and_message_admins("attempted to send a forbidden message in [name]: [message]", user = C)
			else
				log_and_message_admins("attempted to send a forbidden message in [name]", user = C)
		if (C && config.forbidden_message_warning)
			to_chat(C, config.forbidden_message_warning)
		return FALSE

	return TRUE

/singleton/communication_channel/proc/do_communicate(communicator, message)
	return

/*
* Procs for handling the reception of communication messages
*/
/singleton/communication_channel/proc/receive_communication(datum/communicator, datum/receiver, message)
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

/singleton/communication_channel/proc/can_receive_communication(datum/receiver)
	if(show_preference_setting)
		var/client/C = receiver.get_client()
		if(can_ignore(C))
			return FALSE
	return TRUE

/singleton/communication_channel/proc/do_receive_communication(datum/communicator, datum/receiver, message)
	to_chat(receiver, message)


/*
 * Procs for the handling of system broadcasts
 */
/singleton/communication_channel/proc/broadcast(message, force = FALSE)
	if (!can_broadcast(message, force))
		return FALSE
	call(log_proc)("[(flags & COMMUNICATION_LOG_CHANNEL_NAME) ? "([name]) " : ""]SYSTEM BROADCAST : [message]")
	return do_broadcast(message, force)


/singleton/communication_channel/proc/can_broadcast(message, override_config = FALSE)
	if (!message)
		return FALSE

	if (!override_config && config_setting && !config.vars[config_setting])
		return FALSE

	return TRUE


/singleton/communication_channel/proc/do_broadcast(message)
	return


/singleton/communication_channel/proc/receive_broadcast(datum/receiver, message)
	if (!can_receive_communication(receiver))
		return
	do_receive_broadcast(receiver, message)


/singleton/communication_channel/proc/do_receive_broadcast(datum/receiver, message)
	to_chat(receiver, message)


// Misc. helpers
/datum/proc/communication_identifier()
	return usr ? "[src] - usr: [plain_key_name(usr)]" : "[src]"

/mob/communication_identifier()
	var/key_name = plain_key_name(src)
	return usr != src ? "[key_name] - usr: [plain_key_name(usr)]" : key_name

/proc/sanitize_and_communicate(channel_type, communicator, message)
	message = sanitize(message)
	return communicate(arglist(args))

/proc/communicate(channel_type, communicator, message)
	var/list/channels = GET_SINGLETON_SUBTYPE_MAP(/singleton/communication_channel)
	var/singleton/communication_channel/channel = channels[channel_type]

	message = process_chat_markup(message)
	var/list/new_args = list(communicator, message)
	new_args += args.Copy(4)

	return channel.communicate(arglist(new_args))

/proc/communicate_broadcast(channel_type, message, forced = FALSE)
	var/list/channels = GET_SINGLETON_SUBTYPE_MAP(/singleton/communication_channel)
	var/singleton/communication_channel/channel = channels[channel_type]

	return channel.broadcast(message, forced)

#undef plain_key_name
