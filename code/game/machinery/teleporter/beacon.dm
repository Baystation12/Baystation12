var/const/TELEBEACON_WIRE_POWER = 1
var/const/TELEBEACON_WIRE_RELAY = 2
var/const/TELEBEACON_WIRE_SAFETY = 4
var/const/TELEBEACON_WIRE_SIGNALLER = 8


// Targetable beacon used by teleporters
/obj/machinery/tele_beacon
	name = "teleporter beacon"
	desc = "A beacon used by a teleporter."
	icon = 'icons/obj/teleporter.dmi'
	icon_state = "beacon"
	idle_power_usage = 10
	anchored = TRUE
	level = 1
	wires = /datum/wires/tele_beacon

	var/beacon_name // Name of the beacon in the teleporter UI
	var/autoset_name = TRUE // Autoset the beacon_name to the beacon's current area

	var/list/obj/machinery/computer/teleporter/connected_computers // List of connected computers


/obj/machinery/tele_beacon/Initialize()
	. = ..()
	generate_name()
	var/turf/T = get_turf(src)
	hide(hides_under_flooring() && !T.is_plating())


/obj/machinery/tele_beacon/Destroy()
	disconnect_computers()
	. = ..()


/obj/machinery/tele_beacon/attackby(obj/item/I, mob/user)
	if (!panel_open)
		if (isWrench(I))
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

			if (!do_after(user, 3 SECONDS, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
				return TRUE

			anchored = !anchored
			level = anchored ? 1 : 2
			user.visible_message(
				SPAN_NOTICE("\The [user] [anchored ? "connects" : "disconnects"] \the [src] [anchored ? "to" : "from"] \the [T] with \the [I]."),
				SPAN_NOTICE("You [anchored ? "connect" : "disconnect"] \the [src] [anchored ? "to" : "from"] \the [T] with \the [I].")
			)
			playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
			queue_icon_update()
			update_use_power(anchored ? POWER_USE_IDLE : POWER_USE_OFF)
			if (!anchored)
				disconnect_computers()
			else
				generate_name()

			return TRUE

		if (isMultitool(I))
			var/new_name = input(user, "What label would you like to set this beacon to? Leave empty to enable automatic naming based on area.", "Set Beacon Label", beacon_name) as text|null
			if (QDELETED(src))
				return TRUE
			if (new_name == null)
				autoset_name = TRUE
				generate_name()
				user.visible_message(
					SPAN_NOTICE("\The [user] reconfigures \the [src] with \the [I]."),
					SPAN_NOTICE("You enable \the [src]'s automatic labeling with \the [I].")
				)
			else
				beacon_name = new_name
				autoset_name = FALSE
				user.visible_message(
					SPAN_NOTICE("\The [user] reconfigures \the [src] with \the [I]."),
					SPAN_NOTICE("You reconfigure \the [src]'s relay label to \"[beacon_name]\" with \the [I].")
				)
			return TRUE

	if (isScrewdriver(I))
		panel_open = !panel_open
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] [panel_open ? "opens" : "closes"] \the [src]'s cover panel with \the [I]."),
			SPAN_NOTICE("You [panel_open ? "open" : "close"] \the [src]'s cover panel with \the [I].")
		)
		queue_icon_update()
		return TRUE

	. = ..()


/obj/machinery/tele_beacon/emp_act(severity)
	..()

	if (use_power && !stat)
		stat |= EMPED
		disconnect_computers()
		var/emp_time = rand(15 SECONDS, 30 SECONDS) / severity
		addtimer(CALLBACK(src, .proc/emp_act_end), emp_time, TIMER_UNIQUE | TIMER_OVERRIDE)


/obj/machinery/tele_beacon/proc/emp_act_end()
	stat &= ~EMPED


/obj/machinery/tele_beacon/examine(mob/user)
	. = ..()

	if (!anchored)
		to_chat(user, SPAN_WARNING("It is disconnected from \the [get_turf(src)]."))
		return

	if (!functioning())
		if (user.skill_check(SKILL_DEVICES, SKILL_BASIC))
			to_chat(user, SPAN_WARNING("It appears to be offline or disabled."))
		return

	if (user.skill_check(SKILL_DEVICES, SKILL_ADEPT))
		if (!wires.IsIndexCut(TELEBEACON_WIRE_SIGNALLER))
			to_chat(user, SPAN_WARNING("The signal lights appear to be disabled."))
		else if (LAZYLEN(connected_computers))
			to_chat(user, SPAN_WARNING("The signal lights indicate it has an active teleporter connection."))


/obj/machinery/tele_beacon/power_change()
	. = ..()
	if (!.)
		return

	if (stat & NOPOWER)
		disconnect_computers()


/obj/machinery/tele_beacon/on_update_icon()
	. = ..()

	icon_state = initial(icon_state)

	if (functioning())
		if (panel_open)
			icon_state += "_open"
		else if (wires.IsIndexCut(TELEBEACON_WIRE_RELAY) || wires.IsIndexCut(TELEBEACON_WIRE_SIGNALLER))
			icon_state += "_offline"
		else if (LAZYLEN(connected_computers))
			icon_state += "_locked"
	else
		icon_state += "_unpowered"


/obj/machinery/tele_beacon/proc/connect_computer(obj/machinery/computer/teleporter/computer)
	LAZYDISTINCTADD(connected_computers, computer)
	if (!wires.IsIndexCut(TELEBEACON_WIRE_SIGNALLER))
		audible_message(
			SPAN_NOTICE("\The [src] beeps as a new teleporter links to it."),
			SPAN_NOTICE("You hear a pair of beeps.")
		)
		playsound(loc, 'sound/machines/twobeep.ogg', 75, 1)
		queue_icon_update()


// Disconnects a single hub from the beacon
/obj/machinery/tele_beacon/proc/disconnect_computer(obj/machinery/computer/teleporter/computer)
	if (!LAZYISIN(connected_computers, computer))
		return

	LAZYREMOVE(connected_computers, computer)
	if (computer.target == src)
		computer.lost_target()
	queue_icon_update()


// Disconnects all hubs from the beacon
/obj/machinery/tele_beacon/proc/disconnect_computers()
	if (!LAZYLEN(connected_computers))
		return

	for (var/obj/machinery/computer/teleporter/computer in connected_computers)
		if (computer.target == src)
			computer.lost_target()

	LAZYCLEARLIST(connected_computers)
	queue_icon_update()


// Whether or not the beacon is functional and valid for the purposes of teleporter targeting
/obj/machinery/tele_beacon/proc/functioning()
	. = TRUE

	if (!anchored)
		return FALSE

	if (inoperable(EMPED))
		return FALSE

	var/turf/T = get_turf(src)
	if (!T || !istype(T))
		return FALSE


// Auto generates the beacon_name based on the area's name
/obj/machinery/tele_beacon/proc/generate_name(force = FALSE)
	if (force || autoset_name)
		var/area/A = get_area(src)
		if (istype(A))
			beacon_name = A.name
		else
			beacon_name = "INVALID"


/datum/wires/tele_beacon
	holder_type = /obj/machinery/tele_beacon
	random = TRUE
	wire_count = 4
	window_y = 500
	descriptions = list(
		new /datum/wire_description(TELEBEACON_WIRE_POWER, "This wire is connected to the power supply unit.", SKILL_EXPERT),
		new /datum/wire_description(TELEBEACON_WIRE_RELAY, "This wire is connected to the remote relay device.", SKILL_PROF),
		new /datum/wire_description(TELEBEACON_WIRE_SAFETY, "This wire is connected to the materialization safety circuitry.", SKILL_PROF),
		new /datum/wire_description(TELEBEACON_WIRE_SIGNALLER, "This wire is connected to a speaker and several indicator lights.", SKILL_EXPERT)
	)


/datum/wires/tele_beacon/CanUse(mob/living/L)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	if (!tele_beacon.panel_open || !tele_beacon.anchored)
		return FALSE
	return TRUE


/datum/wires/tele_beacon/GetInteractWindow(mob/user)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	. = ..()
	if (!tele_beacon.functioning())
		. += "The panel seems to be completely unpowered or disabled."
	else
		// TODO - Wire specific displays


/datum/wires/tele_beacon/UpdateCut(index, mended)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	switch (index)
		if (TELEBEACON_WIRE_POWER)
			log_debug("Power wire [mended ? "mended" : "cut"]")
			// TODO - Enable (mended) or disable (cut) power
			// TODO - Shock risk (It's a main power wire)
		if (TELEBEACON_WIRE_RELAY)
			log_debug("Relay wire [mended ? "mended" : "cut"]")
			// TODO - Allow (mended) or disallow (cut) teleporter connections
		if (TELEBEACON_WIRE_SAFETY)
			log_debug("Safety wire [mended ? "mended" : "cut"]")
			// TODO - If cut, start throwing anything that's teleported to this beacon
		if (TELEBEACON_WIRE_SIGNALLER)
			log_debug("Signaller wire [mended ? "mended" : "cut"]")
			// TODO - Enable (mended) or disable (cut) the 'connected computer' beep


/datum/wires/tele_beacon/UpdatePulsed(index)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	switch (index)
		if (TELEBEACON_WIRE_POWER)
			log_debug("Power wire pulsed")
			// TODO - Cut power for X seconds
		if (TELEBEACON_WIRE_RELAY)
			log_debug("Relay wire pulsed")
			// TODO - Severe all teleporter connections
		if (TELEBEACON_WIRE_SAFETY)
			log_debug("Safety wire pulsed")
			// TODO - Spark
		if (TELEBEACON_WIRE_SIGNALLER)
			log_debug("Signaller wire pulsed")
			// TODO - Trigger the 'connected computer' beep
