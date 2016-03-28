/datum/nano_module
	var/name
	var/datum/host
	var/available_to_ai = TRUE
	var/datum/computer_file/program/program = null	// Program-Based computer program that runs this nano module. Defaults to null.

/datum/nano_module/New(var/host, var/program)
	src.program = program
	// Machinery-based computers wouldn't work w/o this as nano will assume they're items inside containers.
	if(istype(host, /obj/item/modular_computer/processor))
		var/obj/item/modular_computer/processor/H = host
		src.host = H.machinery_computer
	else
		src.host = host

/datum/nano_module/Topic(href, href_list)
	// Calls forwarded to PROGRAM itself should begin with "PRG_"
	// Calls forwarded to COMPUTER running the program should begin with "PC_"
	if(program && program.Topic(href, href_list))
		return TRUE
	return ..()

/datum/nano_module/nano_host()
	return host ? host : src

/datum/nano_module/proc/can_still_topic(var/datum/topic_state/state = default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE

/datum/proc/initial_data()
	return list()

/datum/proc/update_layout()
	return FALSE
