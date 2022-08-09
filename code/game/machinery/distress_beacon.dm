/obj/machinery/computer/distress
	name = "distress signal"
	desc = "A console connected to a standardized system for broadcasting long-range distress signals, capable of communicating navigational coordinates and a message on a repeating loop."
	base_type = /obj/machinery/computer/distress
	silicon_restriction = STATUS_UPDATE
	can_use_tools = FALSE

	/// Boolean. Whether or not the distress beacon has been activated.
	var/active = FALSE/obj/machinery/light
	/// String. The message to be broadcast.
	var/distress_message
	/// Integer. The `world.time` value of the last distress broadcast.
	var/last_message_time = 0
	/// Integer. The `world.time` of the last activation toggle.
	var/last_activation_time = 0

	/// Integer. The amount of time between distress signal pings.
	var/const/signal_frequency = 5 MINUTES
	/// Integer. The amount of time the machine must wait before toggling activation state. Used to prevent spam.
	var/const/activation_frequency = 1 MINUTE


/obj/machinery/computer/distress/get_mechanics_info()
	. = ..()
	. += {"
		<p>The distress beacon, when activated, will send out your overmap coordinates, heading, speed, and a message every [time_to_readable(signal_frequency)] to all navigational and helm consoles in the world.</p>
	"}


/obj/machinery/computer/distress/on_update_icon()
	icon_state = active ? "active" : "inactive"


/obj/machinery/computer/distress/Process()
	if (!can_broadcast())
		return
	broadcast()


/// Activates the distress beacon.
/obj/machinery/computer/distress/proc/activate()
	if (active)
		return
	active = TRUE
	last_activation_time = world.time
	log_and_message_admins("A distress beacon was activated in [get_area(src)].", usr, get_turf(src))
	update_use_power(POWER_USE_ACTIVE)
	update_icon()


/// Deactivates the distress beacon.
/obj/machinery/computer/distress/proc/deactivate()
	if (!active)
		return
	active = FALSE
	last_activation_time = world.time
	log_and_message_admins("A distress beacon was de-activated in [get_area(src)].", usr, get_turf(src))
	update_use_power(POWER_USE_OFF)
	update_icon()


/**
 * Whether or not the distress beacon is currently able to broadcast a signal.
 *
 * **Parameters**:
 * - `skip_time_check` Boolean, default `FALSE`. If set, `last_message_time` and `signal_frequency` checks are skipped.
 *
 * Returns boolean.
 */
/obj/machinery/computer/distress/proc/can_broadcast(skip_time_check = FALSE)
	if (!active)
		return FALSE
	if (!skip_time_check && world.time - last_message_time < signal_frequency)
		return FALSE
	return TRUE


/**
 * Handles the actual broadcasting of a message. This proc will create a visible message from every helm and navigational console in the world.
 *
 * **Parameters**:
 * - `message` String - The message to be broadcast. If not provided, defaults to a generic distress signal alert combined with `distress_message`.
 * - `skip_time_check` Boolean, default `FALSE`. Passed through to `can_broadcast()` checks.
 *
 * Returns boolean. Wheather or not the message was broadcast.
 */
/obj/machinery/computer/distress/proc/broadcast(message = null, skip_time_check = FALSE)
	if (!can_broadcast(skip_time_check))
		return FALSE

	if (!message)
		if (distress_message)
			message = "Receiving incoming distress signal: \"[distress_message]\"."
		else
			message = "Receiving incoming distress signal. No message provided."

	// TODO Do the actual signal broadcast here
	log_debug(append_admin_tools("A distress beacon broadcasst a message: [message]", location = get_turf(src)))

	last_message_time = world.time
	return TRUE
