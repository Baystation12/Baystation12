var/global/const/TELEBEACON_WIRE_POWER     = 1
var/global/const/TELEBEACON_WIRE_RELAY     = 2
var/global/const/TELEBEACON_WIRE_SIGNALLER = 4


// Targetable beacon used by teleporters
/obj/machinery/tele_beacon
	name = "teleporter beacon"
	desc = "A beacon used by a teleporter."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "beacon"
	idle_power_usage = 10
	active_power_usage = 50
	anchored = TRUE
	level = ATOM_LEVEL_UNDER_TILE
	obj_flags = OBJ_FLAG_ANCHORABLE

	machine_name = "teleporter beacon"
	machine_desc = "Teleporter beacons allow teleporter systems to target them, for accurate, instantaneous transport of objects and people."
	base_type = /obj/machinery/tele_beacon
	wires = /datum/wires/tele_beacon
	construct_state = /singleton/machine_construction/default/panel_closed

	/// Name of the beacon in the teleporter UI.
	var/beacon_name
	/// Autoset the beacon_name to the beacon's current area.
	var/autoset_name = TRUE
	/// Whether or not power has been cut via wiring.
	var/power_cut = FALSE

	/// Lazy list of connected computers.
	var/list/obj/machinery/computer/teleporter/connected_computers


/obj/machinery/tele_beacon/Initialize()
	. = ..()
	generate_name()
	var/turf/T = get_turf(src)
	hide(hides_under_flooring() && !T.is_plating())
	update_use_power(POWER_USE_IDLE)


/obj/machinery/tele_beacon/Destroy()
	disconnect_computers()
	. = ..()

/obj/machinery/tele_beacon/can_anchor(obj/item/tool, mob/user, silent)
	var/turf/T = get_turf(src)
	if (!T.is_plating())
		to_chat(user, SPAN_WARNING("You cannot anchor \the [src] to \the [T]. You must connect it to the underplating."))
		return FALSE
	return ..()

/obj/machinery/tele_beacon/post_anchor_change()
	if (!anchored)
		disconnect_computers()
	else
		generate_name()

	level = anchored ? ATOM_LEVEL_UNDER_TILE : ATOM_LEVEL_OVER_TILE
	..()

/obj/machinery/tele_beacon/use_tool(obj/item/I, mob/living/user, list/click_params)
	if (!panel_open && isMultitool(I))
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

	return ..()

/obj/machinery/tele_beacon/emp_act(severity)
	..()

	if (use_power && !stat)
		set_stat(MACHINE_STAT_EMPED, TRUE)
		disconnect_computers()
		var/emp_time = rand(15 SECONDS, 30 SECONDS) / severity
		addtimer(new Callback(src, .proc/emp_act_end), emp_time, TIMER_UNIQUE | TIMER_OVERRIDE)


/obj/machinery/tele_beacon/proc/emp_act_end()
	set_stat(MACHINE_STAT_EMPED, FALSE)
	update_icon()


/obj/machinery/tele_beacon/examine(mob/user)
	. = ..()

	if (!anchored)
		to_chat(user, SPAN_WARNING("It is disconnected from \the [get_turf(src)]."))
		return

	if (!functioning())
		if (user.skill_check(SKILL_DEVICES, SKILL_BASIC))
			to_chat(user, SPAN_WARNING("It appears to be offline or disabled."))
		return

	if (user.skill_check(SKILL_DEVICES, SKILL_TRAINED))
		if (wires.IsIndexCut(TELEBEACON_WIRE_SIGNALLER))
			to_chat(user, SPAN_WARNING("The signal lights appear to be disabled."))
		else if (LAZYLEN(connected_computers))
			to_chat(user, SPAN_WARNING("The signal lights indicate it has an active teleporter connection."))


/obj/machinery/tele_beacon/power_change()
	. = ..()
	if (!.)
		return

	if (!is_powered())
		disconnect_computers()


/obj/machinery/tele_beacon/is_powered()
	. = ..()
	if (!.)
		return
	if (power_cut || wires.IsIndexCut(TELEBEACON_WIRE_POWER))
		return FALSE


/obj/machinery/tele_beacon/on_update_icon()
	. = ..()

	icon_state = initial(icon_state)

	if (panel_open)
		icon_state += "_open"
	else if (functioning())
		if (wires.IsIndexCut(TELEBEACON_WIRE_RELAY) || wires.IsIndexCut(TELEBEACON_WIRE_SIGNALLER))
			icon_state += "_offline"
		else if (LAZYLEN(connected_computers))
			icon_state += "_locked"
	else
		icon_state += "_unpowered"


/obj/machinery/tele_beacon/get_mechanics_info()
	. = ..()
	. += "<p>\The [src] can be targeted by teleporter control consoles to allow teleporter pads to send mobs and objects to this [src]'s location. \
		It can only be targeted and used while \the [src] is powered and anchored (wrenched) to the floor.</p>"


/obj/machinery/tele_beacon/get_interactions_info()
	. = ..()
	.["Multitool"] += "<p>If the maintenance panel is closed, renames the beacon. The name will be displayed in teleport control consoles.</p>"
	.["Wrench"] += "<p>If the maintenance panel is closed, anchors/unanchors the beacon, allowing it to be moved. The beacon is not functional unless anchored.</p>"


/obj/machinery/tele_beacon/get_antag_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_EMP] += "<p>Disables all established teleporter locks and disables the beacon for up to 30 seconds.</p>"


/// Connects the beacon to a computer that's locking onto it. Returns TRUE on connection, FALSE if the connection fails.
/obj/machinery/tele_beacon/proc/connect_computer(obj/machinery/computer/teleporter/computer)
	if (wires.IsIndexCut(TELEBEACON_WIRE_RELAY))
		return FALSE

	LAZYDISTINCTADD(connected_computers, computer)
	notify_connection()
	update_icon()
	update_use_power(POWER_USE_ACTIVE)
	return TRUE


/// Plays the 'new connection' beep.
/obj/machinery/tele_beacon/proc/notify_connection()
	if (wires.IsIndexCut(TELEBEACON_WIRE_SIGNALLER))
		return
	audible_message(SPAN_NOTICE("\The [src] beeps as a new teleporter links to it."))
	playsound(loc, 'sound/machines/twobeep.ogg', 75, 1)


/// Disconnects a single hub from the beacon.
/obj/machinery/tele_beacon/proc/disconnect_computer(obj/machinery/computer/teleporter/computer)
	if (!LAZYISIN(connected_computers, computer))
		return

	LAZYREMOVE(connected_computers, computer)
	if (computer.target == src)
		computer.lost_target()
	update_icon()
	if (!LAZYLEN(connected_computers))
		update_use_power(POWER_USE_IDLE)


/// Disconnects all hubs from the beacon.
/obj/machinery/tele_beacon/proc/disconnect_computers()
	if (!LAZYLEN(connected_computers))
		return

	for (var/obj/machinery/computer/teleporter/computer in connected_computers)
		if (computer.target == src)
			computer.lost_target()

	LAZYCLEARLIST(connected_computers)
	update_icon()
	update_use_power(POWER_USE_IDLE)


/// Whether or not the beacon is functional and valid for the purposes of teleporter targeting.
/obj/machinery/tele_beacon/proc/functioning()
	. = TRUE

	if (!anchored)
		return FALSE

	if (inoperable() || GET_FLAGS(stat, MACHINE_STAT_EMPED))
		return FALSE

	var/turf/T = get_turf(src)
	if (!T || !istype(T))
		return FALSE


/// Auto generates the beacon_name based on the area's name.
/obj/machinery/tele_beacon/proc/generate_name(force = FALSE)
	if (force || autoset_name)
		var/area/A = get_area(src)
		if (istype(A))
			beacon_name = A.name
		else
			log_debug("\A [src] ([src.type]) attempted to generate a name but the area [A] ([A.type]) is invalid. LOC [x], [y], [z] ([loc]).")
			beacon_name = "INVALID AREA"


/// Updates the state of power to handle the power wire being messed with.
/obj/machinery/tele_beacon/proc/set_power_cut(new_power_cut = TRUE)
	if (power_cut == new_power_cut)
		return
	power_cut = new_power_cut
	if (power_cut)
		disconnect_computers()
	update_use_power(POWER_USE_OFF)


/datum/wires/tele_beacon
	holder_type = /obj/machinery/tele_beacon
	random = TRUE
	wire_count = 3
	window_y = 500
	descriptions = list(
		new /datum/wire_description(TELEBEACON_WIRE_POWER, "This wire is connected to the power supply unit.", SKILL_EXPERIENCED),
		new /datum/wire_description(TELEBEACON_WIRE_RELAY, "This wire is connected to the remote relay device.", SKILL_MASTER),
		new /datum/wire_description(TELEBEACON_WIRE_SIGNALLER, "This wire is connected to a speaker and several indicator lights.", SKILL_EXPERIENCED)
	)


/datum/wires/tele_beacon/CanUse(mob/living/L)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	if (!tele_beacon.panel_open || !tele_beacon.anchored)
		return FALSE
	return TRUE


/datum/wires/tele_beacon/GetInteractWindow(mob/user)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	. = ..()
	. += "<ul>"
	if (!tele_beacon.functioning())
		. += "<li>The panel seems to be completely unpowered or disabled.</li>"
	else
		. += "<li>The panel is powered.</li>"
		if (user.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
			. += "<li>The remote relay chip is [IsIndexCut(TELEBEACON_WIRE_RELAY) ? "disconnected" : "connected"].</li>"
			. += "<li>The connection signaller circuitry is [IsIndexCut(TELEBEACON_WIRE_SIGNALLER) ? "disconnected" : "connected"].</li>"
		else
			. += "<li>There are lights and wires here, but you don't know how the wiring works.</li>"
	. += "</ul>"


/datum/wires/tele_beacon/UpdateCut(index, mended)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	switch (index)
		// TELEBEACON_WIRE_SIGNALLER - Enable (mended) or disable (cut) the 'connected computer' beep. Handled in `connect_computer()`
		if (TELEBEACON_WIRE_POWER) // Enable (mended) or disable (cut) power. Has a shock risk.
			tele_beacon.set_power_cut(!mended)
			tele_beacon.shock(usr, 50)
		if (TELEBEACON_WIRE_RELAY) // Allow (mended) or disallow (cut) teleporter connections. Handled in `connect_computer()`
			tele_beacon.disconnect_computers()

/datum/wires/tele_beacon/UpdatePulsed(index)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	switch (index)
		if (TELEBEACON_WIRE_POWER)
			tele_beacon.set_power_cut()
			addtimer(new Callback(src, .proc/ResetPulsed), rand(15 SECONDS, 45 SECONDS), TELEBEACON_WIRE_POWER)
		if (TELEBEACON_WIRE_RELAY)
			tele_beacon.disconnect_computers()
		if (TELEBEACON_WIRE_SIGNALLER)
			tele_beacon.notify_connection()


/datum/wires/tele_beacon/ResetPulsed(index)
	var/obj/machinery/tele_beacon/tele_beacon = holder
	switch (index)
		if (TELEBEACON_WIRE_POWER)
			if (IsIndexCut(TELEBEACON_WIRE_POWER))
				return
			tele_beacon.set_power_cut(FALSE)
