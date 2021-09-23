/*
 * General standardized health processing for all atoms.
 * Current health and max health are always rounded to the nearest whole number.
 */
/datum/extension/health
	base_type = /datum/extension/health
	expected_type = /atom

	/// Current health, from `0` to `max_health`.
	var/current_health
	/// Maximum health. `0` or `NULL` means no health handling.
	var/max_health
	/// Whether or not the death state has been set.
	var/death_state = FALSE
	/// LAZY List of damage type resistance or weakness multipliers, decimal form. Only applied to health reduction.
	var/list/damage_resistances
	/// Minimum damage required to actually affect health in `can_damage_health()`
	var/min_damage_threshhold = 0

/**
 * Retrieves the extension's `current_health`.
 * Provided as a proc for override use.
 */
/datum/extension/health/proc/current_health()
	return current_health

/**
 * Retrieves the extension's `max_health`.
 * Provided as a proc for override use.
 */
/datum/extension/health/proc/max_health(real = FALSE)
	var/atom/A = holder
	return real ? max_health : A.get_max_health()

/**
 * Retrieves the extension's damage (Difference between `max_health` and `current_health`).
 * Provided as a proc for override use.
 */
/datum/extension/health/proc/current_damage(damage_type = null)
	return max_health - current_health

/**
 * Retrieves the extension's death state.
 * Provided as a proc for override use.
 */
/datum/extension/health/proc/get_death_state()
	return death_state

/**
 * Sets a new death_state.
 * Returns `TRUE` of the new state is different from the old state, `FALSE` otherwise.
 * Also calls `handle_death_change()` on the holder.
 */
/datum/extension/health/proc/set_death_state(new_death_state)
	if (death_state == new_death_state)
		return FALSE
	death_state = new_death_state
	var/atom/A = holder
	A.handle_death_change(new_death_state)
	return TRUE

/**
 * Checks the current condition of health and sets the death state accordingly.
 * Returns `TRUE` if `death_state` was changed, `FALSE` otherwise.
 */
/datum/extension/health/proc/update_death_state()
	return set_death_state(current_health() <= 0)

/**
 * Modifies `current_health` by the given modifier.
 * Returns `TRUE` if `death_state` was changed, `FALSE` otherwise.
 */
/datum/extension/health/proc/adjust_health(health_mod, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)

	// Apply resistances to negative modifiers
	if (health_mod < 0 && damage_type && LAZYISIN(damage_resistances, damage_type))
		health_mod = health_mod * damage_resistances[damage_type]

	health_mod = round(health_mod, 1)
	if (health_mod == 0)
		return FALSE // No health change, no further processing needed
	current_health = Clamp(current_health + health_mod, 0, max_health())

	var/atom/A = holder
	A.post_health_change(health_mod, damage_type)

	return update_death_state()

/// Immediately sets health to `0` then updates `death_state`, bypassing all other checks and processes.
/datum/extension/health/proc/kill()
	SHOULD_CALL_PARENT(TRUE)
	current_health = 0
	return update_death_state()

/// Immediately restores health to full then updates `death_state`, bypassing all other checks and processes.
/datum/extension/health/proc/revive()
	SHOULD_CALL_PARENT(TRUE)
	current_health = max_health()
	return update_death_state()

/**
 * Changes `max_health` to a new value, with a minimum of `1`.
 * Returns `TRUE` if the health changes causes a death state change, `FALSE` otherwise.
 */
/datum/extension/health/proc/set_max_health(new_max_health)
	SHOULD_CALL_PARENT(TRUE)
	if (new_max_health == max_health)
		return FALSE
	max_health = max(round(new_max_health, 1), 1)
	current_health = max_health()
	return update_death_state()

/// Copies health data from another health extension.
/datum/extension/health/proc/copy_from(datum/extension/health/source)
	SHOULD_CALL_PARENT(TRUE)
	max_health = source.max_health
	current_health = source.current_health
	death_state = source.death_state

/// Sets a damage resistance multiplier for the given damage type.
/datum/extension/health/proc/set_resistance(damage_type, resistance_value)
	SHOULD_CALL_PARENT(TRUE)
	if (resistance_value == 1)
		remove_resistance(damage_type)
		return
	LAZYSET(damage_resistances, damage_type, resistance_value)

/// Removes a damage resistance multiplier for the given damage type.
/datum/extension/health/proc/remove_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	LAZYREMOVE(damage_resistances, damage_type)

/// Retrieves the damage resistance multiplier for the given damage type.
/datum/extension/health/proc/get_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	var/resistance_value = LAZYACCESS(damage_resistances, damage_type)
	return isnull(resistance_value) ? 1 : resistance_value
