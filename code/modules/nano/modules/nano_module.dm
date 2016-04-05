/datum/nano_module
	var/name
	var/datum/host
	var/available_to_ai = TRUE
	var/datum/topic_manager/topic_manager

/datum/nano_module/New(var/datum/host, var/topic_manager)
	..()
	src.host = host.nano_host()
	src.topic_manager = topic_manager

/datum/nano_module/nano_host()
	return host ? host : src

/datum/nano_module/proc/can_still_topic(var/datum/topic_state/state = default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE

/datum/nano_module/Topic(href, href_list)
	if(topic_manager && topic_manager.Topic(href, href_list))
		return TRUE
	. = ..()

/datum/proc/initial_data()
	return list()

/datum/proc/update_layout()
	return FALSE
