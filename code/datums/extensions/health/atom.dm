/atom
	/// Whether or not the atom should use the health handler when initialized. If set to `USE_HEALTH_SIMPLE`, uses the simple health system.
	var/use_health_handler = FALSE
	/// Ease-of-use holder for the health extension.
	var/datum/extension/health/health_handler
	/// Current health for simple health processing
	var/simple_health
	/// Maximum health for simple health processing
	var/simple_max_health

/// Returns a list containing the atom's requested health_handler configuration.
/atom/proc/get_initial_health_handler_config()
	return list(
		"max_health" = 100
	)

/**
 * Initializes the health extension.
 * Returns `TRUE` if an extension was initialized, `FALSE` if simple health was initialized.
 */
/atom/proc/initialize_health()
	var/list/health_handler_config = get_initial_health_handler_config()

	if (use_health_handler == USE_HEALTH_SIMPLE)
		simple_max_health = health_handler_config["max_health"]
		simple_health = simple_max_health
		return FALSE

	health_handler = get_or_create_extension(src, use_health_handler)
	health_handler.set_max_health(health_handler_config["max_health"])

	for (var/damage_type in DAMAGE_ALL)
		if ("resist_[damage_type]" in health_handler_config)
			set_damage_resistance(damage_type, health_handler_config["resist_[damage_type]"])

	return TRUE

/// Removes the health extensions.
/atom/proc/destroy_health()
	if (use_health_handler == USE_HEALTH_SIMPLE)
		simple_health = null
		simple_max_health = null
		return
	remove_extension(src, use_health_handler)
	health_handler = null

/// Full-resets the health extension by removing then re-initializing it.
/atom/proc/restart_health()
	destroy_health()
	initialize_health()

/**
 * Whether or not the atom has initialized health.
 * Can be overridden for additional checks.
 * Returns `TRUE` or `FALSE`.
 */
/atom/proc/has_health()
	SHOULD_CALL_PARENT(TRUE)
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return !!simple_max_health
	return !!health_handler

/// Retrieves the atom's current health, or `null` if not using the health extension.
/atom/proc/get_current_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_health
	return min(health_handler.current_health(), get_max_health())

/// Retrieves the atom's maximum health, or `null` if not using the health extension.
/atom/proc/get_max_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_max_health
	return health_handler.max_health(TRUE)

/**
 * Retrieves the atom's current damage, or `null` if not using the health extension.
 * If using the `damage_sources` extension subtype, setting `damage_type` will only show the damage of that given type.
 */
/atom/proc/get_damage_value(damage_type = null)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_max_health - simple_health
	return health_handler.current_damage(damage_type)

/**
 * Retrieves the atom's current damage as a percentage where `100%` is `1.00`.
 * If using the `damage_sources` extension subtype, setting `damage_type` will only show the damage of that given type.
 */
/atom/proc/get_damage_percentage(damage_type = null)
	if (!has_health())
		return
	var/max_health = get_max_health()
	if (max_health == 0)
		return 1.00
	return round(get_damage_value(damage_type) / max_health, 0.01)

/**
 * Checks if the atom's health can be restored.
 * If using the `damage_sources` extension subtype, also checks for damage of that specific type.
 */
/atom/proc/can_restore_health(damage_type = null)
	if (!has_health())
		return
	if (!health_damaged(damage_type))
		return FALSE
	return TRUE

/// Checks if the atom's health can be damaged.
/atom/proc/can_damage_health(damage, damage_type = null)
	if (!has_health())
		return
	if (!is_alive())
		return FALSE
	if (!use_health_handler == USE_HEALTH_SIMPLE)
		if (damage < health_handler.min_damage_threshhold)
			return FALSE
		if (damage_type && LAZYACCESS(health_handler.damage_resistances, damage_type) == 0)
			return FALSE
	return TRUE

/// Checks if the atom is 'alive' or 'dead'.
/atom/proc/is_alive()
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_health > 0
	return !health_handler.get_death_state()

/**
 * Checks if the atom has received damage.
 * Essentially an alias of `get_damage_value()` that converts the value to a boolean.
 * If using the `damage_sources` extension subtype, setting `damage_type` will only show the damage of that given type.
 */
/atom/proc/health_damaged(damage_type = null)
	return has_health() && get_damage_value(damage_type)

/**
 * Basic health modification for the simple_health system. Applies `health_mod` directly to `simple_health` via addition and calls `handle_death_change` as needed.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/simple_adjust_health(health_mod)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	var/old_health = simple_health
	simple_health = Clamp(simple_health + health_mod, 0, simple_max_health)
	if (simple_health == 0 && old_health > 0)
		handle_death_change(TRUE)
		return TRUE
	else if (simple_health > 0 && old_health == 0)
		handle_death_change(FALSE)
		return TRUE
	return FALSE

/**
 * Restore's the atom's health by the given value. Returns `TRUE` if the restoration resulted in a death state change.
 * If using the `damage_sources` extension subtype, will only restore damage from the given damage type.
 * Override only for modifying damage. Do not override to apply additional effects - Use `post_restore_health()` instead.
 */
/atom/proc/restore_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_adjust_health(damage)
	return health_handler.adjust_health(damage, damage_type)

/**
 * Damage's the atom's health by the given value. Returns `TRUE` if the damage resulted in a death state change.
 * If using the `damage_sources` extension subtype, will apply damage to the given damage type.
 * Override only for modifying damage. Do not override to apply additional effects - Use `post_damage_health()` instead.
 */
/atom/proc/damage_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_adjust_health(-damage)
	return health_handler.adjust_health(-damage, damage_type)

/// Proc called after any health changes made by the extension.
/atom/proc/post_health_change(damage, damage_type = null)
	return

/// Immediately sets health to `0` then updates `death_state`, bypassing all other checks and processes.
/atom/proc/kill_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_adjust_health(-simple_max_health)
	return health_handler.kill()

/// Returns health to full, resetting the death state as well.
/atom/proc/revive_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return simple_adjust_health(simple_max_health)
	return health_handler.revive()

/**
 * Proc called when `death_state` changes.
 * Provided for override use.
 */
/atom/proc/handle_death_change(new_death_state)
	return

/// Handler for the health extension's `set_max_health()` proc
/atom/proc/set_max_health(new_max_health)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		simple_max_health = new_max_health
		return FALSE
	return health_handler.set_max_health(new_max_health)

/// Handler for the health extension's `set_resistance()` proc
/atom/proc/set_damage_resistance(damage_type, resistance_value)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health() || use_health_handler == USE_HEALTH_SIMPLE)
		return
	health_handler.set_resistance(damage_type, resistance_value)

/// Handler for the health extension's `set_resistance()` proc
/atom/proc/remove_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health() || use_health_handler == USE_HEALTH_SIMPLE)
		return
	health_handler.remove_resistance(damage_type)

/**
 * Handler for the health extension's `get_resistance()` proc.
 * Always returns `1` for the simple health system.
 * Returns a damage multiplier in decimal form, or `null` if health is not being used.
 */
/atom/proc/get_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (use_health_handler == USE_HEALTH_SIMPLE)
		return 1
	return health_handler.get_resistance(damage_type)

/**
 * Handles sending damage state to users on `examine()`.
 * Overrideable to allow for different messages, or restricting when the messages can or cannot appear.
 */
/atom/proc/examine_damage_state(mob/user)
	if (!has_health())
		return
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
	if (!has_health())
		return
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

/// Copies the state of health from one atom to another.
/proc/copy_health(atom/source_atom, atom/target_atom)
	if (!source_atom || QDELETED(target_atom) || !source_atom.has_health() || !target_atom.has_health())
		return
	if (source_atom.use_health_handler == USE_HEALTH_SIMPLE)
		target_atom.destroy_health()
		target_atom.use_health_handler = source_atom.use_health_handler
		target_atom.simple_health = source_atom.simple_health
		target_atom.simple_max_health = source_atom.simple_max_health
		return
	target_atom.health_handler.copy_from(source_atom.health_handler)
