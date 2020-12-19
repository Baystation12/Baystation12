// Targetable beacon used by teleporters
/obj/machinery/teleport/beacon
	name = "teleporter beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "floor_beacon"
	idle_power_usage = 10
	active_power_usage = 1000
	use_power = TRUE
	density = FALSE
	level = 1

	var/beacon_name // Name of the beacon in the teleporter UI
	var/autoset_name = TRUE // Autoset the beacon_name to the beacon's current area

	var/list/obj/machinery/teleport/hub/connected_hubs // List of connected hubs


/obj/machinery/teleport/beacon/Initialize()
	. = ..()
	generate_name()
	var/turf/T = get_turf(src)
	hide(hides_under_flooring() && !T.is_plating())


/obj/machinery/teleport/beacon/Destroy()
	disconnect_hubs()
	. = ..()


/obj/machinery/teleport/beacon/attackby(obj/item/I, mob/user)
	if (isWrench(I) && !panel_open)
		var/turf/T = get_turf(src)
		if (is_space_turf(T) || istype(T, /turf/simulated/open))
			to_chat(user, SPAN_WARNING("You cannot anchor \the [src] to \the [T]. It requires solid plating."))
			return FALSE
		if (!T.is_plating())
			to_chat(user, SPAN_WARNING("You cannot anchor \the [src] to \the [T]. You must connect it to the underplating."))
			return FALSE

		user.visible_message(
			SPAN_NOTICE("\The [user] starts to [anchored ? "disconnect" : "connect"] \the [src] [anchored ? "to" : "from"] \the [T]."),
			SPAN_NOTICE("You start to [anchored ? "disconnect" : "connect"] \the [src] [anchored ? "to" : "from"] \the [T].")
		)

		if (do_after(user, 3 SECONDS, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			anchored = !anchored
			level = anchored ? 1 : 2
			user.visible_message(
				SPAN_NOTICE("\The [user] [anchored ? "connects" : "disconnects"] \the [src] [anchored ? "to" : "from"] \the [T]."),
				SPAN_NOTICE("You [anchored ? "connect" : "disconnect"] \the [src] [anchored ? "to" : "from"] \the [T].")
			)
			playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
			generate_name()
			queue_icon_update()
			if (!anchored)
				disconnect_hubs()

		return TRUE

	. = ..()


/obj/machinery/teleport/beacon/emp_act(severity)
	if (use_power && !stat)
		stat |= EMPED
		disconnect_hubs()
		var/emp_time = rand(5 SECONDS, 10 SECONDS) * severity
		addtimer(CALLBACK(src, .proc/emp_act_end), emp_time, TIMER_UNIQUE | TIMER_OVERRIDE)
	. = ..()


/obj/machinery/teleport/beacon/proc/emp_act_end()
	stat &= ~EMPED


/obj/machinery/teleport/beacon/examine(mob/user)
	. = ..()

	if (!anchored)
		to_chat(user, SPAN_WARNING("It is disconnected from \the [get_turf(src)]."))
	else if (!functioning())
		to_chat(user, SPAN_WARNING("It appears to be offline or disabled."))


/obj/machinery/teleport/beacon/power_change()
	. = ..()
	if (!.)
		return

	if (stat & NOPOWER)
		disconnect_hubs()


/obj/machinery/teleport/beacon/on_update_icon()
	. = ..()

	if (functioning())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_dead"


/obj/machinery/teleport/beacon/proc/connect_hub(obj/machinery/teleport/hub/hub)
	LAZYDISTINCTADD(connected_hubs, hub)
	audible_message(
		SPAN_NOTICE("\The [src] beeps as a new hub links to it."),
		SPAN_NOTICE("You hear a pair of beeps.")
	)
	playsound(loc, 'sound/machines/twobeep.ogg', 75, 1)


// Disconnects a single hub from the beacon
/obj/machinery/teleport/beacon/proc/disconnect_hub(obj/machinery/teleport/hub/hub)
	if (!LAZYISIN(connected_hubs, hub))
		return

	connected_hubs -= hub
	if (hub.beacon == src)
		hub.disconnect_beacon()

	if (!connected_hubs.len)
		LAZYCLEARLIST(connected_hubs)



// Disconnects all hubs from the beacon
/obj/machinery/teleport/beacon/proc/disconnect_hubs()
	if (!LAZYLEN(connected_hubs))
		return

	for (var/obj/machinery/teleport/hub/connected_hub in connected_hubs)
		connected_hubs -= connected_hub
		if (connected_hub.beacon == src)
			connected_hub.disconnect_beacon()

	LAZYCLEARLIST(connected_hubs)


// Whether or not the beacon is functional and valid for the purposes of teleporter targeting
/obj/machinery/teleport/beacon/proc/functioning()
	. = TRUE

	if (!anchored)
		return FALSE

	if (stat & (BROKEN | NOPOWER | EMPED))
		return FALSE

	var/turf/T = get_turf(src)
	if (!T || !istype(T))
		return FALSE


// Auto generates the beacon_name based on the area's name
/obj/machinery/teleport/beacon/proc/generate_name(force = FALSE)
	if (force || autoset_name)
		var/area/A = get_area(src)
		if (istype(A))
			beacon_name = A.name
		else
			beacon_name = "INVALID"
