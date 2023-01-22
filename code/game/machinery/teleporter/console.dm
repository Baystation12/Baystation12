/obj/machinery/computer/teleporter
	name = "Teleporter Control Console"
	desc = "Used to control a linked teleportation hub and station."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	machine_name = "teleporter control console"
	machine_desc = "Used in teleporter systems to configure a destination for the teleportation hub."

	var/obj/machinery/tele_projector/projector
	var/obj/machinery/tele_pad/pad
	var/atom/target
	var/active
	var/id
	/// The timer ID for any active online timers, for stopping the timer if the teleporter is manually shut off, or dies before the timer ends.
	var/active_timer


/obj/machinery/computer/teleporter/Destroy()
	clear_target()
	if (projector)
		projector.lost_computer()
	clear_projector()
	if (pad)
		pad.lost_computer()
	clear_pad()
	. = ..()


/obj/machinery/computer/teleporter/Initialize()
	. = ..()
	underlays.Cut()
	underlays += image('icons/obj/stationobjs.dmi', icon_state = "telecomp-wires")
	id = "[random_id(/obj/machinery/computer/teleporter, 1000, 9999)]"
	update_refs()


/obj/machinery/computer/teleporter/proc/update_refs()
	for (var/dir in GLOB.cardinal)
		projector = locate() in get_step(src, dir)
		if (projector)
			break
	if (projector)
		var/pad_dir
		for (var/dir in GLOB.cardinal)
			pad = locate() in get_step(projector, dir)
			if (pad)
				pad_dir = dir
				break
		if (pad)
			projector.set_computer(src)
			projector.set_dir(pad_dir)
			pad.set_computer(src)
			projector.queue_icon_update()
			pad.queue_icon_update()


/obj/machinery/computer/teleporter/proc/clear_projector()
	if (!projector)
		return
	GLOB.destroyed_event.unregister(projector, src, /obj/machinery/computer/teleporter/proc/lost_projector)
	projector = null
	set_active(FALSE)


/obj/machinery/computer/teleporter/proc/lost_projector()
	audible_message(SPAN_WARNING("\The [src] buzzes, \"Projector missing.\""))
	clear_projector()


/obj/machinery/computer/teleporter/proc/set_projector(obj/machinery/tele_projector/_projector)
	if (projector == _projector)
		return
	clear_projector()
	projector = _projector
	GLOB.destroyed_event.register(projector, src, /obj/machinery/computer/teleporter/proc/lost_projector)


/obj/machinery/computer/teleporter/proc/clear_pad()
	if (!pad)
		return
	GLOB.destroyed_event.unregister(pad, src, /obj/machinery/computer/teleporter/proc/lost_pad)
	pad = null
	set_active(FALSE)


/obj/machinery/computer/teleporter/proc/lost_pad()
	audible_message(SPAN_WARNING("\The [src] buzzes, \"Pad missing.\""))
	clear_pad()


/obj/machinery/computer/teleporter/proc/set_pad(obj/machinery/tele_pad/_pad)
	if (pad == _pad)
		return
	clear_pad()
	pad = _pad
	GLOB.destroyed_event.register(pad, src, /obj/machinery/computer/teleporter/proc/lost_pad)


/obj/machinery/computer/teleporter/proc/clear_target()
	if (!target)
		return
	var/old_target = target
	GLOB.destroyed_event.unregister(target, src, /obj/machinery/computer/teleporter/proc/lost_target)
	target = null
	if (istype(old_target, /obj/machinery/tele_beacon))
		var/obj/machinery/tele_beacon/beacon = old_target
		beacon.disconnect_computer(src)
	set_active(FALSE)
	set_timer(TRUE)


/obj/machinery/computer/teleporter/proc/lost_target()
	audible_message(SPAN_WARNING("\The [src] buzzes, \"Target lost.\""))
	clear_target()


/obj/machinery/computer/teleporter/proc/set_target(atom/_target)
	if (target == _target)
		return
	clear_target()
	if (istype(_target, /obj/machinery/tele_beacon))
		var/obj/machinery/tele_beacon/beacon = _target
		if (!beacon.connect_computer(src))
			return FALSE
	target = _target
	GLOB.destroyed_event.register(target, src, /obj/machinery/computer/teleporter/proc/lost_target)
	return TRUE


/obj/machinery/computer/teleporter/proc/set_active(_active, notify)
	var/effective = _active && target && projector && pad
	if (active == effective)
		return
	active = effective
	set_timer(!active)
	if (notify && effective)
		if (active)
			visible_message(SPAN_NOTICE("The teleporter sparks and hums to life."))
		else
			visible_message(SPAN_WARNING("The teleporter sputters and fails."))
	if (projector)
		projector.queue_icon_update()
	if (pad)
		pad.queue_icon_update()


/obj/machinery/computer/teleporter/proc/set_timer(clear = FALSE)
	if (clear)
		if (active_timer)
			deltimer(active_timer)
			active_timer = null
	else
		active_timer = addtimer(CALLBACK(src, .proc/clear_target), 10 MINUTE, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)


/obj/machinery/computer/teleporter/proc/get_targets()
	var/list/ids = list()
	var/list/result = list()
	for (var/obj/machinery/tele_beacon/B)
		if (QDELETED(B) || !B.functioning() || !isPlayerLevel(B.z))
			continue
		var/area/A = get_area(B)
		if (!A)
			continue
		result["[B.beacon_name] \[[++ids[B.beacon_name]]\]"] = B
	for (var/obj/item/implant/tracking/T)
		if (QDELETED(T) || !T.implanted || !ismob(T.loc))
			continue
		var/mob/M = T.loc
		if (M.stat == DEAD && world.time > M.timeofdeath + 15 MINUTES)
			continue
		if (!isPlayerLevel(M.z))
			continue
		result["[M.name] \[[++ids[M.name]]\]"] = T
	return result


/obj/machinery/computer/teleporter/power_change()
	. = ..()
	if (!.)
		return
	if (stat & NOPOWER)
		clear_target()


/obj/machinery/computer/teleporter/interface_interact(mob/user)
	if (!projector || !pad)
		var/data_search = alert(user, "Projector or Pad missing. Search?", "Teleporter", "Yes", "No")
		if (isnull(data_search) || !CanDefaultInteract(user))
			return TRUE
		if (data_search == "Yes")
			update_refs()
		return TRUE
	var/message = "Teleporter [!target ? "Idle" : !active ? "Locked" : "Engaged"]\n[!target ? "" : "\[[get_area(target)]\]"]"
	var/btn_active = active ? "Shut Down" : target ? "Start Up" : "-"
	var/btn_target = active ? "-" : "Set Target"
	var/data_action = alert(user, message, "Teleporter", btn_active, "Cancel", btn_target)
	if (isnull(data_action) || !CanDefaultInteract(user))
		return TRUE
	switch (data_action)
		if ("-", "Cancel")
			return
		if ("Shut Down")
			set_active(FALSE, TRUE)
		if ("Start Up")
			set_active(TRUE, TRUE)
		if ("Set Target")
			var/list/targets = get_targets()
			var/data_target = input(user, "Select Target", "Teleporter") in null | targets
			if (isnull(data_target) || !CanDefaultInteract(user))
				return TRUE
			if (set_target(targets[data_target]))
				audible_message(SPAN_NOTICE("\The [src] hums, \"Target updated.\""))
			else
				audible_message(SPAN_WARNING("\The [src] buzzes, \"Failed to establish teleporter lock.\""))
