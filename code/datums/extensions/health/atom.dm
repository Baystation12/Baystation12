/atom
	/**
	 * Whether or not the atom should use the health handler when initialized.
	 */
	var/use_health_handler = FALSE

	/**
	 * Ease-of-use holder for the health extension.
	 */
	var/datum/extension/health/health_handler

	/**
	 * Current health for simple health processing
	 */
	var/simple_health

	/**
	 * Maximum health for simple health processing
	 */
	var/simple_max_health


/// Returns a list containing the atom's requested health_handler configuration.
/atom/proc/health_handler_config()
	return list(
		"max_health" = 100
	)


/**
 * Initializes the health extension.
 */
/atom/proc/initialize_health()
	var/list/health_handler_config = health_handler_config()

	if (using_simple_health())
		simple_max_health = health_handler_config["max_health"]
		simple_health = simple_max_health
		return

	health_handler = get_or_create_extension(src, use_health_handler)
	health_handler.set_max_health(health_handler_config["max_health"])

	for (var/damage_type in DAMAGE_ALL)
		if ("resist_[damage_type]" in health_handler_config)
			set_damage_resistance(damage_type, health_handler_config["resist_[damage_type]"])

	on_initialize_health(health_handler_config)


/**
 * To allow for additional init processing.
 */
/atom/proc/on_initialize_health(list/health_handler_config)
	return


/**
 * Removes the health extensions.
 */
/atom/proc/destroy_health()
	if (using_simple_health())
		simple_health = null
		simple_max_health = null
		return
	remove_extension(src, use_health_handler)
	health_handler = null


/**
 * Whether or not the health handler is set to simple health. Used to bypass extension calls.
 */
/atom/proc/using_simple_health()
	return !!(use_health_handler == USE_HEALTH_SIMPLE)


/**
 * Full-resets the health extension by removing then re-initializing it.
 */
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
	if (using_simple_health())
		if (!simple_max_health)
			return FALSE
		return !!simple_max_health
	return !!health_handler


/**
 * Retrieves the atom's current health, or `null` if not using the health extension.
 */
/atom/proc/get_current_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
		return simple_health
	return min(health_handler.current_health(), get_max_health())


/**
 * Retrieves the atom's maximum health, or `null` if not using the health extension.
 */
/atom/proc/get_max_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
		return simple_max_health
	return health_handler.max_health(TRUE)


/**
 * Retrieves the atom's current damage, or `null` if not using the health extension.
 * If using the `damage_sources` extension subtype, setting `damage_type` will only show the damage of that given type.
 */
/atom/proc/get_damage_value(damage_type)
	if (!has_health())
		return
	if (using_simple_health())
		return simple_max_health - simple_health
	return health_handler.current_damage(damage_type)


/**
 * Retrieves the atom's current damage as a percentage where `100%` is `1.00`.
 * If using the `damage_sources` extension subtype, setting `damage_type` will only show the damage of that given type.
 */
/atom/proc/get_damage_percentage(damage_type)
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
/atom/proc/can_restore_health(damage_type)
	if (!has_health())
		return
	if (!health_damaged(damage_type))
		return FALSE
	return TRUE


/**
 * Checks if the atom's health can be damaged.
 */
/atom/proc/can_damage_health(damage, damage_type)
	if (!has_health())
		return
	if (!is_alive())
		return FALSE
	if (!using_simple_health())
		if (damage < health_handler.min_damage_threshhold)
			return FALSE
		if (damage_type && LAZYACCESS(health_handler.damage_resistances, damage_type) == 0)
			return FALSE
	return TRUE


/**
 * Checks if the atom is 'alive' or 'dead'.
 */
/atom/proc/is_alive()
	if (!has_health())
		return
	if (using_simple_health())
		return simple_health > 0
	return !health_handler.get_death_state()


/**
 * Checks if the atom has received damage.
 * Essentially an alias of `get_damage_value()` that converts the value to a boolean.
 * If using the `damage_sources` extension subtype, setting `damage_type` will only show the damage of that given type.
 */
/atom/proc/health_damaged(damage_type)
	if (!has_health())
		return
	return !!get_damage_value(damage_type)


/atom/proc/simple_mod_health(health_mod)
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
 * Restore's the atom's health by the given value.
 * If using the `damage_sources` extension subtype, will only restore damage from the given damage type.
 * Override only for modifying damage. Do not override to apply additional effects - Use `post_restore_health()` instead.
 */
/atom/proc/restore_health(damage, damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
		return simple_mod_health(damage)
	return health_handler.mod_health(damage, damage_type)


/**
 * Proc called after health has been increased.
 * Provided for override use.
 */
/atom/proc/post_restore_health(damage, damage_type)
	return


/**
 * Damage's the atom's health by the given value.
 * If using the `damage_sources` extension subtype, will apply damage to the given damage type.
 * Override only for modifying damage. Do not override to apply additional effects - Use `post_damage_health()` instead.
 */
/atom/proc/damage_health(damage, damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
		return simple_mod_health(-damage)
	return health_handler.mod_health(-damage, damage_type)


/**
 * Proc called after health has been decreased.
 * Provided for override use.
 */
/atom/proc/post_damage_health(damage, damage_type)
	return


/**
 * Proc called after any health changes.
 */
/atom/proc/post_health_change(damage, damage_type)
	return


/**
 * Immediately sets health to `0` then updates `death_state`, bypassing all other checks and processes.
 */
/atom/proc/kill_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
		return simple_mod_health(-simple_max_health)
	return health_handler.kill()


/atom/proc/revive_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
		return simple_mod_health(simple_max_health)
	return health_handler.revive()


/**
 * Proc called when `death_state` changes.
 * Provided for override use.
 */
/atom/proc/handle_death_change(new_death_state)
	return


/**
 * Handler for the health extension's `set_max_health()` proc
 */
/atom/proc/set_max_health(new_max_health)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
		simple_max_health = new_max_health
		return FALSE
	return health_handler.set_max_health(new_max_health)


/**
 * Handler for the health extension's `set_resistance()` proc
 */
/atom/proc/set_damage_resistance(damage_type, resistance_value)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health() || using_simple_health())
		return
	health_handler.set_resistance(damage_type, resistance_value)


/**
 * Handler for the health extension's `set_resistance()` proc
 */
/atom/proc/remove_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health() || using_simple_health())
		return
	health_handler.remove_resistance(damage_type)


/**
 * Handler for the health extension's `get_resistance()` proc
 */
/atom/proc/get_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!has_health())
		return
	if (using_simple_health())
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

	var/health_percentage = get_damage_percentage()
	switch (health_percentage)
		if (1)
			to_chat(user, SPAN_NOTICE("It looks fully intact."))
		if (0.66 to 0.99)
			to_chat(user, SPAN_WARNING("It looks slightly damaged."))
		if (0.33 to 0.65)
			to_chat(user, SPAN_WARNING("It looks moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("It looks severely damaged."))

/mob/examine_damage_state(mob/user)
	if (!has_health())
		return
	var/datum/gender/gender = get_gender()
	if (!is_alive())
		to_chat(user, SPAN_DANGER("[gender.He] looks severely hurt and [gender.is] not moving or responding to anything around [gender.him]."))
		return

	var/health_percentage = get_damage_percentage()
	switch (health_percentage)
		if (1)
			to_chat(user, SPAN_NOTICE("[gender.He] appears unhurt."))
		if (0.66 to 0.99)
			to_chat(user, SPAN_WARNING("[gender.He] looks slightly hurt."))
		if (0.33 to 0.65)
			to_chat(user, SPAN_WARNING("[gender.He] looks moderately hurt."))
		else
			to_chat(user, SPAN_DANGER("[gender.He] looks severely hurt."))

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
	if (source_atom.using_simple_health())
		target_atom.destroy_health()
		target_atom.use_health_handler = source_atom.use_health_handler
		target_atom.simple_health = source_atom.simple_health
		target_atom.simple_max_health = source_atom.simple_max_health
		return
	target_atom.health_handler.clone(source_atom.health_handler)
