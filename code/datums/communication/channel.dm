#define plain_key_name(A) key_name(A, highlight_special_characters = 0)

/decl/communication_channel
	var/log_proc
	var/log_prefix
	var/expected_communicator_type = /datum

/decl/communication_channel/proc/communicate(var/datum/communicator, var/message)
	if(can_communicate(communicator, message))
		call(log_proc)("[log_prefix ? "([log_prefix]) " : ""][communicator.communication_identifier()] : [message]")
		return do_communicate(communicator, message)
	return FALSE

/decl/communication_channel/proc/can_communicate(var/communicator, var/message)
	if(!message)
		return FALSE
	if(!istype(communicator, expected_communicator_type))
		log_debug("[log_info_line(communicator)] attempted to communicate over the channel [src] but was of an unexpected type.")
		return FALSE
	return TRUE

/decl/communication_channel/proc/do_communicate(var/communicator, var/message)
	return

/datum/proc/communication_identifier()
	return usr ? "[src] - usr: [plain_key_name(usr)]" : "[src]"

/mob/communication_identifier()
	var/key_name = plain_key_name(src)
	return usr != src ? "[key_name] - usr: [plain_key_name(usr)]" : key_name

var/list/decl/communication_channel/communication_channels_
/proc/communication_channels()
	if(!communication_channels_)
		communication_channels_ = init_subtypes_assoc(/decl/communication_channel)
	return communication_channels_

/proc/sanitize_and_communicate(var/channel_type, var/communicator, var/message)
	return communicate(channel_type, communicator, sanitize(message))

/proc/communicate(var/channel_type, var/communicator, var/message)
	var/list/channels = communication_channels()
	var/decl/communication_channel/channel = channels[channel_type]
	return channel.communicate(communicator, message)

#undef plain_key_name
