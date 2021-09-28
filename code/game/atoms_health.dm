/atom
	/// Current health for health processing. Use `get_current_health()`, `damage_health()`, or `restore_health()` for general health references.
	var/health_current
	/// Maximum health for simple health processing. Use `get_max_health()` or `set_max_health()` to reference/modify.
	var/health_max
	/// Whether or not the atom is considered 'dead'. Use `is_alive()` for general checks.
	var/health_dead = FALSE

	/**
	 * LAZY List of damage type resistance or weakness multipliers, decimal form. Only applied to health reduction. Use `set_damage_resistance()`, `remove_damage_resistance()`, and `get_damage_resistance()` to reference/modify.
	 *
	 * Index should be one of the `DAMAGE_` flags.
	 * Value should be a multiplier that is applied against damage. Values below 1 are a resistance, above 1 are a weakness.
	 * Value of `0` is considered immunity.
	 */
	var/list/health_resistances

	/// Minimum damage required to actually affect health in `can_damage_health()`.
	var/health_min_damage = 0

/**
 * Whether or not the atom has health. Checks for a value in `health_max`.
 * Can be overridden for additional checks.
 * Returns `TRUE` or `FALSE`.
 */
/atom/proc/has_health()
	SHOULD_CALL_PARENT(TRUE)
	return !!health_max

/**
 * Retrieves the atom's current health, or `null` if not using health
 */
/atom/proc/get_current_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	return health_current

/**
 * Retrieves the atom's maximum health, or `null` if not using health.
 */
/atom/proc/get_max_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	return health_max

/**
 * Retrieves the atom's current damage, or `null` if not using health.
 * If `use_raw_values` is `TRUE`, uses the raw var values instead of the `get_*` proc results.
 */
/atom/proc/get_damage_value(use_raw_values)
	if (!has_health())
		return
	if (use_raw_values)
		return health_max - health_current
	else
		return get_max_health() - get_current_health()

/**
 * Retrieves the atom's current damage as a percentage where `100%` is `1.00`.
 * If `use_raw_values` is `TRUE`, uses the raw var values instead of the `get_*` proc results.
 */
/atom/proc/get_damage_percentage(use_raw_values)
	if (!has_health())
		return
	var/max_health = use_raw_values ? health_max : get_max_health()
	return round(get_damage_value(use_raw_values) / max_health, 0.01)

/**
 * Checks if the atom's health can be restored.
 * Should be called before `restore_health()` in most cases.
 * Returns `null` if health is not in use.
 * NOTE: Does not include a check for death state by default, to allow repairing/healing atoms back to life.
 */
/atom/proc/can_restore_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (!damage)
		return FALSE
	if (get_current_health() == get_max_health())
		return FALSE
	return TRUE

/**
 * Checks if the atom's health can be damaged.
 * Should be called before `damage_health()` in most cases.
 * Returns `null` if health is not in use.
 */
/atom/proc/can_damage_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (!is_alive())
		return FALSE
	if (!damage || damage < health_min_damage)
		return FALSE
	if (get_damage_resistance(damage_type) == 0)
		return FALSE
	return TRUE

/**
 * Checks if the atom is 'alive' or 'dead'.
 * Returns `null` if health is not in use.
 */
/atom/proc/is_alive()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	return !health_dead

/**
 * Health modification for the health system. Applies `health_mod` directly to `simple_health` via addition and calls `handle_death_change` as needed.
 * Has no pre-modification checks, you should be using `damage_health()` or `restore_health()` instead of this.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/mod_health(health_mod, damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	health_current = Clamp(health_current + health_mod, 0, get_max_health())
	post_health_change(health_mod, damage_type)
	return check_death_state()

/**
 * Sets `health_current` to the new value, clamped between `0` and `health_max`.
 * Has no pre-modification checks.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/set_health(new_health)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	var/health_mod = new_health - health_current
	return mod_health(health_mod)

/**
 * Restore's the atom's health by the given value. Returns `TRUE` if the restoration resulted in a death state change.
 */
/atom/proc/restore_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	return mod_health(damage, damage_type = null)

/**
 * Damage's the atom's health by the given value. Returns `TRUE` if the damage resulted in a death state change.
 * Resistance and weakness modifiers are applied here.
 */
/atom/proc/damage_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return

	// Apply resistance/weakness modifiers
	damage *= get_damage_resistance(damage_type)

	return mod_health(-damage, damage_type = null)

/**
 * Proc called after any health changes made by the system
 */
/atom/proc/post_health_change(health_mod, damage_type = null)
	return

/**
 * Checks the current health value and updates the death state accordingly.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/check_death_state()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	var/health_current = get_current_health()
	if (health_current > 0 && health_dead)
		health_dead = FALSE
		handle_death_change(FALSE)
		return TRUE
	if (health_current <= 0 && !health_dead)
		health_dead = TRUE
		handle_death_change(TRUE)
		return TRUE
	return FALSE

/**
 * Force-sets the atom's death state, bypassing any and all checks.
 */
/atom/proc/set_death_state(new_death_state)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (new_death_state == health_dead)
		return FALSE
	health_dead = new_death_state
	health_current = health_dead ? 0 : get_max_health()
	handle_death_change(new_death_state)
	return TRUE

/**
 * Immediately sets health to `0` then updates `death_state`, bypassing all other checks and processes.
 */
/atom/proc/kill_health()
	SHOULD_CALL_PARENT(TRUE)
	return mod_health(-health_max)

/**
 * Returns health to full, resetting the death state as well.
 */
/atom/proc/revive_health()
	SHOULD_CALL_PARENT(TRUE)
	return mod_health(health_max)

/**
 * Proc called when `health_dead` changes.
 * Provided for override use.
 */
/atom/proc/handle_death_change(new_death_state)
	return

/**
 * Sets the atoms maximum health to the new value.
 * If `set_current_health` is `TRUE`, also sets the current health to the new value.
 */
/atom/proc/set_max_health(new_max_health, set_current_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	health_max = new_max_health
	health_current = set_current_health ? get_max_health() : min(health_current, get_max_health())

/**
 * Sets the atom's resistance/weakness to the given damage type.
 * Value should be a multiplier that is applied against damage. Values below 1 are a resistance, above 1 are a weakness.
 * Value of `0` is considered immunity.
 */
/atom/proc/set_damage_resistance(damage_type, resistance_value)
	SHOULD_CALL_PARENT(TRUE)
	if (resistance_value == 1)
		remove_damage_resistance(damage_type)
		return
	LAZYSET(health_resistances, damage_type, resistance_value)

/**
 * Removes the atom's resistance/weakness to the given damage type.
 */
/atom/proc/remove_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	LAZYREMOVE(health_resistances, damage_type)

/**
 * Fetches the atom's current resistance value for the given damage type.
 */
/atom/proc/get_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!damage_type)
		return 1
	var/resistance_value = LAZYACCESS(health_resistances, damage_type)
	return isnull(resistance_value) ? 1 : resistance_value

/**
 * Handles sending damage state to users on `examine()`.
 * Overrideable to allow for different messages, or restricting when the messages can or cannot appear.
 */
/atom/proc/examine_damage_state(mob/user)
	if (!is_alive())
		to_chat(user, SPAN_DANGER("It looks broken."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0.00)
			to_chat(user, SPAN_NOTICE("It looks fully intact."))
		if (0.01 to 0.32)
			to_chat(user, SPAN_WARNING("It looks slightly damaged."))
		if (0.33 to 0.65)
			to_chat(user, SPAN_WARNING("It looks moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("It looks severely damaged."))

/mob/examine_damage_state(mob/user)
	if (!is_alive())
		to_chat(user, SPAN_DANGER("They look severely hurt and is not moving or responding to anything around them."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0.00)
			to_chat(user, SPAN_NOTICE("They appear unhurt."))
		if (0.01 to 0.32)
			to_chat(user, SPAN_WARNING("They look slightly hurt."))
		if (0.33 to 0.65)
			to_chat(user, SPAN_WARNING("They look moderately hurt."))
		else
			to_chat(user, SPAN_DANGER("They look severely hurt."))

/atom/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (has_health())
		examine_damage_state(user)

/**
 * Copies the state of health from one atom to another.
 */
/proc/copy_health(atom/source_atom, atom/target_atom)
	if (!source_atom || QDELETED(target_atom) || !source_atom.has_health() || !target_atom.has_health())
		return
	target_atom.health_current = source_atom.health_current
	target_atom.health_max = source_atom.health_max
	target_atom.health_dead = source_atom.health_dead
	target_atom.health_resistances = source_atom.health_resistances
	target_atom.health_min_damage = source_atom.health_min_damage
