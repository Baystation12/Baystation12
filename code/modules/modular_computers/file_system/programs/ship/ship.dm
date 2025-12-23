
/datum/computer_file/program/ship
	abstract_type = /datum/computer_file/program/ship
	requires_ntnet = FALSE
	usage_flags = PROGRAM_CONSOLE
	category = PROG_HELM

/datum/nano_module/program/ship
	abstract_type = /datum/nano_module/program/ship
	var/datum/browser/reconnect_popup
	var/obj/overmap/visitable/ship/linked = null
	var/list/viewers // Weakrefs to mobs in direct-view mode.
	var/extra_view = 0 // how much the view is increased by when the mob is in overmap mode.

/datum/nano_module/program/ship/New()
	..()
	sync_linked()

/datum/nano_module/program/ship/proc/attempt_hook_up(obj/overmap/visitable/ship/sector)
	if (!istype(sector))
		return FALSE
	if (sector.check_ownership(nano_host()))
		linked = sector
		return TRUE

/datum/nano_module/program/ship/proc/sync_linked()
	var/obj/overmap/visitable/ship/sector = map_sectors["[get_host_z()]"]
	if (!sector)
		return
	return attempt_hook_up_recursive(sector)

/datum/nano_module/program/ship/proc/attempt_hook_up_recursive(obj/overmap/visitable/ship/sector)
	if (attempt_hook_up(sector))
		return sector
	for (var/obj/overmap/visitable/ship/candidate in sector)
		if ((. = .(candidate)))
			return

/datum/nano_module/program/ship/Topic(mob/user, list/href_list)
	if (..())
		return TOPIC_HANDLED
	if (href_list["sync"])
		sync_linked()
		return TOPIC_REFRESH
	return TOPIC_NOACTION

/datum/nano_module/program/ship/proc/viewing_overmap(mob/user)
	return (weakref(user) in viewers) || (linked && (weakref(user) in linked.navigation_viewers))

/datum/nano_module/program/ship/proc/look(mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		user.client.view = world.view + extra_view
	if(linked)
		for(var/obj/machinery/shipsensors/sensor in linked.sensors)
			sensor.reveal_contacts(user)
	GLOB.moved_event.register(user, src, PROC_REF(unlook))
	if (!isghost(user))
		GLOB.stat_set_event.register(user, src, PROC_REF(unlook))
	LAZYDISTINCTADD(viewers, weakref(user))
	if(linked)
		LAZYDISTINCTADD(linked.navigation_viewers, weakref(user))

/datum/nano_module/program/ship/proc/unlook(mob/user)
	user.reset_view(null, FALSE)
	if(user.client)
		user.client.view = world.view
	if(linked)
		for(var/obj/machinery/shipsensors/sensor in linked.sensors)
			sensor.hide_contacts(user)
	GLOB.moved_event.unregister(user, src, PROC_REF(unlook))
	GLOB.stat_set_event.unregister(user, src, PROC_REF(unlook))
	LAZYREMOVE(viewers, weakref(user))
	if(linked)
		LAZYREMOVE(linked.navigation_viewers, weakref(user))
