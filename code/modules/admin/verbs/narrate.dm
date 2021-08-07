#define TARGET_ZONE_GLOBAL  "GLOBAL"
#define TARGET_ZONE_INWORLD "INWORLD"
#define TARGET_ZONE_ZLEVEL  "ZLEVEL"
#define TARGET_ZONE_RANGE   "RANGE"
#define TARGET_ZONE_VIEW    "VIEW"

#define TARGET_ZONES list(TARGET_ZONE_GLOBAL, TARGET_ZONE_INWORLD, TARGET_ZONE_ZLEVEL, TARGET_ZONE_RANGE, TARGET_ZONE_VIEW)

/**
 * Narrates the provided text to mobs/clients based on the flags and vars provided. See `select_target_mobs()` for details on parameters.
 */
/proc/narrate(message, target_zone = TARGET_ZONE_GLOBAL, target_origin, target_range)
	set waitfor = FALSE

	var/list/recipients = select_narrate_targets(target_zone, target_origin, target_range)
	if (!recipients)
		return

	for (var/recipient in recipients)
		to_chat(recipient, message)


/// Quick-use alias of `narrate` using the GLOBAL target zone.
/proc/narrate_global(message)
	narrate(message, TARGET_ZONE_GLOBAL)

/// Quick-use alias of `narrate` using the INWORLD target zone.
/proc/narrate_world(message)
	narrate(message, TARGET_ZONE_INWORLD)


/**
 * Returns a list containing all mobs within the given target zone and matching the given parameters.
 * Primarily used for `narrate()`.
 *
 * Target zones:
 * - TARGET_ZONE_GLOBAL - Targets `world`, which essentially means "all connected players".
 * - TARGET_ZONE_INWORLD - Targets all mobs that are actually in world. Effectively the same as GLOBAL, but skips players on the lobby screen.
 * - TARGET_ZONE_ZLEVEL - Targets all mobs in the given z-level in `target_origin`.
 * - TARGET_ZONE_RANGE - Targets all mobs within `target_range` tiles of `target_origin`.
 * - TARGET_ZONE_VIEW - Targets all mobs within `oview()` of `target_origin` within `target_range` tiles.
 */
/proc/select_narrate_targets(target_zone = TARGET_ZONE_GLOBAL, target_origin, target_range)
	log_debug("Targeting mobs in zone [target_zone].")
	var/list/recipients = list()
	switch (target_zone)
		if (TARGET_ZONE_GLOBAL)
			recipients += world

		if (TARGET_ZONE_INWORLD)
			for (var/mob/recipient in world)
				if (!valid_narrate_target(recipient) || istype(recipient, /mob/new_player))
					continue
				recipients += recipient

		if (TARGET_ZONE_ZLEVEL)
			if (!isnum(target_origin))
				to_chat(usr, SPAN_WARNING("Invalid z_level provided."))
				return FALSE
			for (var/mob/recipient in world)
				if (!valid_narrate_target(recipient) || recipient.z != target_origin)
					continue
				recipients += recipient

		if (TARGET_ZONE_RANGE)
			if (!isatom(target_origin))
				to_chat(usr, SPAN_WARNING("Invalid origin point."))
				return FALSE
			if (!isnum(target_range) || target_range <= 0)
				to_chat(usr, SPAN_WARNING("Invalid broadcast range."))
				return FALSE
			for (var/mob/recipient in range(target_range, target_origin))
				if (!valid_narrate_target(recipient))
					continue
				recipients += recipient

		if (TARGET_ZONE_VIEW)
			if (!isatom(target_origin))
				to_chat(usr, SPAN_WARNING("Invalid origin point."))
				return FALSE
			if (!isnum(target_range) || target_range <= 0)
				to_chat(usr, SPAN_WARNING("Invalid broadcast range."))
				return FALSE
			for (var/mob/recipient in orange(target_range, target_origin))
				if (!valid_narrate_target(recipient))
					continue
				recipients += recipient

	for (var/recipient in recipients)
		log_debug(" - Targeted [recipient].")

	return recipients

/// Verifies the target matches any common requirements to be valid.
/proc/valid_narrate_target(mob/target)
	if (!target.client)
		return FALSE

	return TRUE
