
/datum/computer_file/program/ship
	abstract_type = /datum/computer_file/program/ship
	requires_ntnet = FALSE
	usage_flags = PROGRAM_CONSOLE
	category = PROG_HELM

/datum/nano_module/ship
	abstract_type = /datum/nano_module/ship
	var/datum/browser/reconnect_popup
	var/obj/overmap/visitable/ship/linked = null

/datum/nano_module/ship/New()
	..()
	sync_linked()

/datum/nano_module/ship/proc/attempt_hook_up(obj/overmap/visitable/ship/sector)
	if (!istype(sector))
		return FALSE
	if (sector.check_ownership(nano_host()))
		linked = sector
		return TRUE

/datum/nano_module/ship/proc/sync_linked()
	var/obj/overmap/visitable/ship/sector = map_sectors["[get_host_z()]"]
	if (!sector)
		return
	return attempt_hook_up_recursive(sector)

/datum/nano_module/ship/proc/attempt_hook_up_recursive(obj/overmap/visitable/ship/sector)
	if (attempt_hook_up(sector))
		return sector
	for (var/obj/overmap/visitable/ship/candidate in sector)
		if ((. = .(candidate)))
			return

/datum/nano_module/ship/Topic(mob/user, list/href_list)
	if (..())
		return TOPIC_HANDLED
	if (href_list["sync"])
		sync_linked()
		return TOPIC_REFRESH
	return TOPIC_NOACTION
