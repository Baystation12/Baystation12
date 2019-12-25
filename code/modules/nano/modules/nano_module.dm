/datum/nano_module
	var/name
	var/datum/host
	var/available_to_ai = TRUE
	var/datum/topic_manager/topic_manager
	var/list/using_access = list()

/datum/nano_module/New(var/datum/host, var/topic_manager)
	..()
	src.host = host.nano_host()
	src.topic_manager = topic_manager

/datum/nano_module/Destroy()
	host = null
	QDEL_NULL(topic_manager)
	. = ..()

/datum/nano_module/nano_host()
	return host ? host : src

/datum/nano_module/proc/can_still_topic(var/datum/topic_state/state = GLOB.default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE

/datum/nano_module/proc/check_eye(var/mob/user)
	return -1

//returns a list.
/datum/nano_module/proc/get_access(mob/user)
	. = using_access
	if(istype(user))
		var/obj/item/weapon/card/id/I = user.GetIdCard()
		if(I)
			. |= I.access

/datum/nano_module/proc/check_access(var/mob/user, var/access)
	if(!access)
		return 1
	if(!islist(access))
		access = list(access) //listify a single access code.
	if(has_access(access, using_access))
		return 1 //This is faster, and often enough.
	return has_access(access, get_access(user)) //Also checks the mob's ID.

/datum/nano_module/Topic(href, href_list)
	if(topic_manager && topic_manager.Topic(href, href_list))
		return TRUE
	. = ..()

/datum/nano_module/proc/get_host_z()
	return get_z(nano_host())

/datum/nano_module/proc/print_text(var/text, var/mob/user)
	var/datum/extension/interactive/ntos/os = get_extension(nano_host(), /datum/extension/interactive/ntos)
	if(os)
		os.print_paper(text)
	else
		to_chat(user, "Error: Unable to detect compatible printer interface. Are you running NTOSv2 compatible system?")

/datum/proc/initial_data()
	return list()

/datum/proc/update_layout()
	return FALSE