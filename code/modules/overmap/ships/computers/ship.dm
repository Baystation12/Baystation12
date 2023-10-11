/*
While these computers can be placed anywhere, they will only function if placed on either a non-space, non-shuttle turf
with an /obj/overmap/visitable/ship present elsewhere on that z level, or else placed in a shuttle area with an /obj/overmap/visitable/ship
somewhere on that shuttle. Subtypes of these can be then used to perform ship overmap movement functions.
*/
/obj/machinery/computer/ship
	var/datum/browser/reconnect_popup
	var/obj/overmap/visitable/ship/linked
	var/list/viewers // Weakrefs to mobs in direct-view mode.
	var/extra_view = 0 // how much the view is increased by when the mob is in overmap mode.

// A late init operation called in SSshuttle, used to attach the thing to the right ship.
/obj/machinery/computer/ship/proc/attempt_hook_up(obj/overmap/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(src))
		linked = sector
		LAZYADD(linked.consoles, src)
		return 1

/obj/machinery/computer/ship/Destroy()
	if(linked)
		LAZYREMOVE(linked.consoles, src)
	. = ..()

/obj/machinery/computer/ship/proc/sync_linked()
	var/obj/overmap/visitable/ship/sector = map_sectors["[z]"]
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/obj/machinery/computer/ship/proc/attempt_hook_up_recursive(obj/overmap/visitable/ship/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/obj/machinery/computer/ship/proc/display_reconnect_dialog(mob/user, flavor)
	if (!reconnect_popup)
		reconnect_popup = new (user, "[src]", "[src]")
		reconnect_popup.set_content("<center><strong>[SPAN_COLOR("red", "Error</strong>")]<br>Unable to connect to [flavor].<br><a href='?src=\ref[src];sync=1'>Reconnect</a></center>")
	reconnect_popup.open()

/obj/machinery/computer/ship/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/ship/OnTopic(mob/user, list/href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["sync"])
		if (sync_linked() && reconnect_popup)
			reconnect_popup.close()
		return TOPIC_REFRESH
	if(href_list["close"])
		unlook(user)
		user.unset_machine()
		return TOPIC_HANDLED
	return TOPIC_NOACTION

// Management of mob view displacement. look to shift view to the ship on the overmap; unlook to shift back.

/obj/machinery/computer/ship/on_user_login(mob/M)
	unlook(M)

/obj/machinery/computer/ship/proc/look(mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		user.client.view = world.view + extra_view
	if(linked)
		for(var/obj/machinery/shipsensors/sensor in linked.sensors)
			sensor.reveal_contacts(user)
	GLOB.moved_event.register(user, src, /obj/machinery/computer/ship/proc/unlook)
	if (!isghost(user))
		GLOB.stat_set_event.register(user, src, /obj/machinery/computer/ship/proc/unlook)
	LAZYDISTINCTADD(viewers, weakref(user))
	if(linked)
		LAZYDISTINCTADD(linked.navigation_viewers, weakref(user))

/obj/machinery/computer/ship/proc/unlook(mob/user)
	user.reset_view(null, FALSE)
	if(user.client)
		user.client.view = world.view
	if(linked)
		for(var/obj/machinery/shipsensors/sensor in linked.sensors)
			sensor.hide_contacts(user)
	GLOB.moved_event.unregister(user, src, /obj/machinery/computer/ship/proc/unlook)
	GLOB.stat_set_event.unregister(user, src, /obj/machinery/computer/ship/proc/unlook)
	LAZYREMOVE(viewers, weakref(user))
	if(linked)
		LAZYREMOVE(linked.navigation_viewers, weakref(user))

/obj/machinery/computer/ship/proc/viewing_overmap(mob/user)
	return (weakref(user) in viewers) || (linked && (weakref(user) in linked.navigation_viewers))

/obj/machinery/computer/ship/CouldNotUseTopic(mob/user)
	. = ..()
	unlook(user)

/obj/machinery/computer/ship/CouldUseTopic(mob/user)
	. = ..()
	if(viewing_overmap(user))
		look(user)

/obj/machinery/computer/ship/check_eye(mob/user)
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		unlook(user)
		return -1
	else
		return 0

/obj/machinery/computer/ship/Destroy()
	linked.consoles -= src
	. = ..()

/obj/machinery/computer/ship/sensors/Destroy()
	var/obj/machinery/shipsensors/sensor = sensor_ref.resolve()
	LAZYREMOVE(sensor.linked_consoles, src)
	sensor_ref = null
	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()
