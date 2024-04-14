/// Current health for health processing. Use `get_current_health()`, `damage_health()`, or `restore_health()` for general health references.
/atom/var/health_current

/// Maximum health for simple health processing. Use `get_max_health()` or `set_max_health()` to reference/modify.
/atom/var/health_max

/// Bitflag (Any of `HEALTH_STATUS_*`). Various health-related status flags for the atom. See `code\__defines\health.dm` for details.
/atom/var/health_status = EMPTY_BITFIELD

/**
 * LAZY List of damage type resistance or weakness multipliers, decimal form. Only applied to health reduction. Use `set_damage_resistance()`, `remove_damage_resistance()`, and `get_damage_resistance()` to reference/modify.
 *
 * Index should be one of the `DAMAGE_` flags.
 * Value should be a multiplier that is applied against damage. Values below 1 are a resistance, above 1 are a weakness.
 * Value of `0` is considered immunity.
 */
/atom/var/list/health_resistances = DAMAGE_RESIST_PHYSICAL

/// Minimum damage required to actually affect health in `can_damage_health()`.
/atom/var/health_min_damage = 0

/// Sound effect played when hit
/atom/var/damage_hitsound = 'sound/weapons/genhit.ogg'

/// Boolean. If set, uses the item's hit sound file instead of the source atom's when attacked.
/atom/var/use_weapon_hitsound = FALSE

/**
 * Retrieves the atom's current health, or `null` if not using health
 */
/atom/proc/get_current_health()
	SHOULD_CALL_PARENT(TRUE)
	return min(health_current, get_max_health())

/**
 * Retrieves the atom's maximum health.
 */
/atom/proc/get_max_health()
	SHOULD_CALL_PARENT(TRUE)
	return health_max

/**
 * Whether or not the atom's health is damaged.
 */
/atom/proc/health_damaged()
	return get_current_health() < get_max_health()


/**
 * Whether or not the atom is currently dead.
 *
 * Returns boolean.
 */
/atom/proc/health_dead()
	return HAS_FLAGS(health_status, HEALTH_STATUS_DEAD)


/**
 * Retrieves the atom's current damage, or `null` if not using health.
 */
/atom/proc/get_damage_value()
	return get_max_health() - get_current_health()

/**
 * Retrieves the atom's current damage as a percentage where `100%` is `100`.
 */
/atom/proc/get_damage_percentage()
	return Percent(get_damage_value(), get_max_health(), 0)

/**
 * Checks if the atom's health can be restored.
 * Should be called before `restore_health()` in most cases.
 * NOTE: Does not include a check for death state by default, to allow repairing/healing atoms back to life.
 */
/atom/proc/can_restore_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!get_max_health())
		return FALSE
	if (!damage)
		return FALSE
	if (!health_damaged())
		return FALSE
	return TRUE

/**
 * Checks if the atom's health can be damaged.
 * Should be called before `damage_health()` in most cases.
 */
/atom/proc/can_damage_health(damage, damage_type = null, damage_flags = EMPTY_BITFIELD)
	SHOULD_CALL_PARENT(TRUE)
	if (!get_max_health())
		return FALSE
	if (!damage || damage < health_min_damage)
		return FALSE
	if (is_damage_immune(damage_type))
		return FALSE
	return TRUE

/mob/can_damage_health(damage, damage_type)
	if (status_flags & GODMODE)
		return FALSE
	. = ..()

/**
 * Health modification for the health system. Applies `health_mod` directly to `simple_health` via addition and calls `handle_death_change` as needed.
 * Has no pre-modification checks, you should be using `damage_health()` or `restore_health()` instead of this.
 * `skip_death_state_change` will skip calling `handle_death_change()` when applicable. Used for when the originally calling proc needs handle it in a unique way.
 * Returns `TRUE` if the death state changes, `FALSE` otherwise.
 */
/atom/proc/mod_health(health_mod, damage_type, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!get_max_health())
		return FALSE
	health_mod = round(health_mod)
	var/prior_health = get_current_health()
	var/death_state = health_dead()
	health_current = round(clamp(health_current + health_mod, 0, get_max_health()))
	post_health_change(health_mod, prior_health, damage_type)
	var/new_death_state = health_current > 0 ? FALSE : TRUE
	if (death_state == new_death_state)
		return FALSE
	if (new_death_state)
		SET_FLAGS(health_status, HEALTH_STATUS_DEAD)
	else
		CLEAR_FLAGS(health_status, HEALTH_STATUS_DEAD)
	if (!skip_death_state_change)
		if (new_death_state)
			on_death()
		else
			on_revive()
	return TRUE

/**
 * Sets `health_current` to the new value, clamped between `0` and `health_max`.
 * Has no pre-modification checks.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/set_health(new_health, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	var/health_mod = new_health - get_current_health()
	return mod_health(health_mod, skip_death_state_change = skip_death_state_change)

/**
 * Restore's the atom's health by the given value. Returns `TRUE` if the restoration resulted in a death state change.
 */
/atom/proc/restore_health(damage, damage_type = null, skip_death_state_change = FALSE, skip_can_restore_check = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!skip_can_restore_check && !can_restore_health(damage, damage_type))
		return FALSE
	return mod_health(damage, damage_type, skip_death_state_change)

/**
 * Damage's the atom's health by the given value. Returns `TRUE` if the damage resulted in a death state change.
 * Resistance and weakness modifiers are applied here.
 * - `damage_type` should be one of the `DAMAGE_*` damage types, or `null`. Defining a damage type is preferable over not.
 * - `damage_flags` is a bitfield of `DAMAGE_FLAG_*` values.
 * - `severity` should be a passthrough of `severity` from `ex_act()` and `emp_act()` for `DAMAGE_EXPLODE` and `DAMAGE_EMP` types respectively.
 * - `skip_can_damage_check` (boolean) - If `TRUE` skips checking `can_damage_health()`. Intended for cases where this was already checked.
 */
/atom/proc/damage_health(damage, damage_type, damage_flags = EMPTY_BITFIELD, severity, skip_can_damage_check = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!skip_can_damage_check && !can_damage_health(damage, damage_type, damage_flags))
		return FALSE

	// Apply resistance/weakness modifiers
	damage *= get_damage_resistance(damage_type)

	var/skip_death_state_change = HAS_FLAGS(damage_flags, DAMAGE_FLAG_SKIP_DEATH_STATE_CHANGE)

	return mod_health(-damage, damage_type, skip_death_state_change)

/**
 * Proc called after any health changes made by the system
 */
/atom/proc/post_health_change(health_mod, prior_health, damage_type = null)
	return

/**
 * Immediately sets health to `0` then updates `death_state`, bypassing all other checks and processes.
 */
/atom/proc/kill_health()
	SHOULD_CALL_PARENT(TRUE)
	return set_health(0)

/**
 * Returns health to full, resetting the death state as well.
 */
/atom/proc/revive_health()
	SHOULD_CALL_PARENT(TRUE)
	return set_health(get_max_health())

/// Proc called when the atom transitions from alive to dead.
/atom/proc/on_death()
	return

/// Proc called when the atom transitions from dead to alive.
/atom/proc/on_revive()
	return

/**
 * Sets the atoms maximum health to the new value.
 * If `set_current_health` is `TRUE`, also sets the current health to the new value.
 */
/atom/proc/set_max_health(new_max_health, set_current_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	health_max = round(new_max_health)
	if (set_current_health)
		set_health(get_max_health())
	else
		set_health(min(get_current_health(), get_max_health()))

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
 * Determines whether or not the atom has full immunity to the given damage type.
 */
/atom/proc/is_damage_immune(damage_type)
	if (get_damage_resistance(damage_type) == 0)
		return TRUE
	return FALSE

/**
 * Handles sending damage state to users on `examine()`.
 * Overrideable to allow for different messages, or restricting when the messages can or cannot appear.
 */
/atom/proc/examine_damage_state(mob/user)
	var/datum/pronouns/pronouns = choose_from_pronouns()

	if (health_dead())
		to_chat(user, SPAN_DANGER("[pronouns.He] look[pronouns.s] broken."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0)
			to_chat(user, SPAN_NOTICE("[pronouns.He] look[pronouns.s] fully intact."))
		if (1 to 32)
			to_chat(user, SPAN_WARNING("[pronouns.He] look[pronouns.s] slightly damaged."))
		if (33 to 65)
			to_chat(user, SPAN_WARNING("[pronouns.He] look[pronouns.s] moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("[pronouns.He] look[pronouns.s] severely damaged."))

/mob/examine_damage_state(mob/user)
	var/datum/pronouns/pronouns = choose_from_pronouns()
	if (health_dead())
		to_chat(user, SPAN_DANGER("[pronouns.He] look[pronouns.s] severely hurt and [pronouns.is] not moving or responding to anything around [pronouns.him]."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0)
			to_chat(user, SPAN_NOTICE("[pronouns.He] appear[pronouns.s] unhurt."))
		if (1 to 32)
			to_chat(user, SPAN_WARNING("[pronouns.He] look[pronouns.s] slightly hurt."))
		if (33 to 65)
			to_chat(user, SPAN_WARNING("[pronouns.He] look[pronouns.s] moderately hurt."))
		else
			to_chat(user, SPAN_DANGER("[pronouns.He] look[pronouns.s] severely hurt."))

/**
 * Copies the state of health from one atom to another.
 *
 * Does not support mobs that don't use standardized health.
 */
/proc/copy_health(atom/source_atom, atom/target_atom)
	if (!source_atom || QDELETED(target_atom) || !source_atom.health_max || !target_atom.health_max)
		return
	target_atom.health_current = source_atom.health_current
	target_atom.health_max = source_atom.health_max
	target_atom.health_resistances = source_atom.health_resistances
	target_atom.health_min_damage = source_atom.health_min_damage
	target_atom.health_status = source_atom.health_status
