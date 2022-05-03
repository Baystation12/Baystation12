/// Current health for health processing. Use `get_current_health()`, `damage_health()`, or `restore_health()` for general health references.
/atom/var/health_current

/// Maximum health for simple health processing. Use `get_max_health()` or `set_max_health()` to reference/modify.
/atom/var/health_max

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

/**
 * Retrieves the atom's current health, or `null` if not using health
 */
/atom/proc/get_current_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	return health_current

/**
 * Retrieves the atom's maximum health.
 */
/atom/proc/get_max_health()
	SHOULD_CALL_PARENT(TRUE)
	return health_max

/**
 * Whether or not the atom's health is damaged.
 */
/atom/proc/health_damaged(use_raw_values)
	if (!health_max)
		return
	if (use_raw_values)
		return health_current < health_max
	return get_current_health() < get_max_health()

/**
 * Retrieves the atom's current damage, or `null` if not using health.
 * If `use_raw_values` is `TRUE`, uses the raw var values instead of the `get_*` proc results.
 */
/atom/proc/get_damage_value(use_raw_values)
	if (!health_max)
		return
	if (use_raw_values)
		return health_max - health_current
	else
		return get_max_health() - get_current_health()

/**
 * Retrieves the atom's current damage as a percentage where `100%` is `100`.
 * If `use_raw_values` is `TRUE`, uses the raw var values instead of the `get_*` proc results.
 */
/atom/proc/get_damage_percentage(use_raw_values)
	if (!health_max)
		return
	var/max_health = use_raw_values ? health_max : get_max_health()
	return Percent(get_damage_value(use_raw_values), max_health, 0)

/**
 * Checks if the atom's health can be restored.
 * Should be called before `restore_health()` in most cases.
 * Returns `null` if health is not in use.
 * NOTE: Does not include a check for death state by default, to allow repairing/healing atoms back to life.
 */
/atom/proc/can_restore_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
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
	if (!health_max)
		return
	if (!is_alive())
		return FALSE
	if (!damage || damage < health_min_damage)
		return FALSE
	if (get_damage_resistance(damage_type) == 0)
		return FALSE
	return TRUE

/mob/can_damage_health(damage, damage_type)
	if (status_flags & GODMODE)
		return FALSE
	. = ..()

/**
 * Checks if the atom is 'alive' or 'dead'.
 * Returns `null` if health is not in use.
 */
/atom/proc/is_alive()
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	return health_current > 0

/**
 * Health modification for the health system. Applies `health_mod` directly to `simple_health` via addition and calls `handle_death_change` as needed.
 * Has no pre-modification checks, you should be using `damage_health()` or `restore_health()` instead of this.
 * `skip_death_state_change` will skip calling `handle_death_change()` when applicable. Used for when the originally calling proc needs handle it in a unique way.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/mod_health(health_mod, damage_type, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	health_mod = round(health_mod)
	var/death_state = !is_alive()
	health_current = round(clamp(health_current + health_mod, 0, get_max_health()))
	post_health_change(health_mod, damage_type)
	var/new_death_state = !is_alive()
	if (death_state == new_death_state)
		return FALSE
	if (!skip_death_state_change)
		handle_death_change(new_death_state)
	return TRUE

/**
 * Sets `health_current` to the new value, clamped between `0` and `health_max`.
 * Has no pre-modification checks.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/set_health(new_health, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	var/health_mod = new_health - health_current
	return mod_health(health_mod, skip_death_state_change = skip_death_state_change)

/**
 * Restore's the atom's health by the given value. Returns `TRUE` if the restoration resulted in a death state change.
 */
/atom/proc/restore_health(damage, damage_type = null, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	if (!can_restore_health(damage, damage_type))
		return FALSE
	return mod_health(damage, damage_type, skip_death_state_change)

/**
 * Damage's the atom's health by the given value. Returns `TRUE` if the damage resulted in a death state change.
 * Resistance and weakness modifiers are applied here.
 * - `damage_type` should be one of the `DAMAGE_*` damage types, or `null`. Defining a damage type is preferable over not.
 * - `damage_flags` is a bitfield of `DAMAGE_FLAG_*` values.
 * - `severity` should be a passthrough of `severity` from `ex_act()` and `emp_act()` for `DAMAGE_EXPLODE` and `DAMAGE_EMP` types respectively.
 */
/atom/proc/damage_health(damage, damage_type, damage_flags = EMPTY_BITFIELD, severity)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	if (!can_damage_health(damage, damage_type))
		return FALSE

	// Apply resistance/weakness modifiers
	damage *= get_damage_resistance(damage_type)

	var/skip_death_state_change = HAS_FLAGS(damage_flags, DAMAGE_FLAG_SKIP_DEATH_STATE_CHANGE)

	return mod_health(-damage, damage_type, skip_death_state_change)

/**
 * Proc called after any health changes made by the system
 */
/atom/proc/post_health_change(health_mod, damage_type = null)
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
	return set_health(health_max)

/**
 * Proc called when death state changes.
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
	health_max = round(new_max_health)
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
		if (0)
			to_chat(user, SPAN_NOTICE("It looks fully intact."))
		if (1 to 32)
			to_chat(user, SPAN_WARNING("It looks slightly damaged."))
		if (33 to 65)
			to_chat(user, SPAN_WARNING("It looks moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("It looks severely damaged."))

/mob/examine_damage_state(mob/user)
	if (!is_alive())
		to_chat(user, SPAN_DANGER("They look severely hurt and is not moving or responding to anything around them."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0)
			to_chat(user, SPAN_NOTICE("They appear unhurt."))
		if (1 to 32)
			to_chat(user, SPAN_WARNING("They look slightly hurt."))
		if (33 to 65)
			to_chat(user, SPAN_WARNING("They look moderately hurt."))
		else
			to_chat(user, SPAN_DANGER("They look severely hurt."))

/**
 * Copies the state of health from one atom to another.
 */
/proc/copy_health(atom/source_atom, atom/target_atom)
	if (!source_atom || QDELETED(target_atom) || !source_atom.health_max || !target_atom.health_max)
		return
	target_atom.health_current = source_atom.health_current
	target_atom.health_max = source_atom.health_max
	target_atom.health_resistances = source_atom.health_resistances
	target_atom.health_min_damage = source_atom.health_min_damage


// Generalized *_act() handlers
/atom/emp_act(severity)
	..()
	// No hitsound here - Doesn't make sense for EMPs.
	// Generalized - 75-125 damage at max, 38-63 at medium, 25-42 at minimum severities.
	damage_health(rand(75, 125) / severity, DAMAGE_EMP, severity = severity)


/atom/ex_act(severity, turf_breaker)
	..()
	// No hitsound here to avoid noise spam.
	// Generalized - 250-350 damage at max, 125-175 at medium, 83-117 at minimum severities.
	var/damage_flags = turf_breaker ? DAMAGE_FLAG_TURF_BREAKER : EMPTY_BITFIELD
	damage_health(rand(250, 350) / severity, DAMAGE_EXPLODE, damage_flags, severity)


/atom/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	// No hitsound here to avoid noise spam.
	// 1 point of damage for every 100 kelvin above 300 (~27 C).
	damage_health(round(max(exposed_temperature - 300, 0) / 100), DAMAGE_FIRE)


/atom/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if (get_max_health())
		var/damage = P.damage
		if (istype(src, /obj/structure) || istype(src, /turf/simulated/wall)) // TODO Better conditions for non-structures that want to use structure damage
			damage = P.get_structure_damage()
		if (!can_damage_health(damage, P.damage_type))
			return
		playsound(damage_hitsound, src, 75)
		damage_health(damage, P.damage_type)
		return 0


/atom/attackby(obj/item/W, mob/user, click_params)
	. = ..()
	if (user.a_intent == I_HURT && get_max_health() && !(W.item_flags & ITEM_FLAG_NO_BLUDGEON))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
		if (!can_damage_health(W.force, W.damtype))
			playsound(damage_hitsound, src, 50)
			user.visible_message(
				SPAN_WARNING("\The [user] hits \the [src] with \a [W], but it bounces off!"),
				SPAN_WARNING("You hit \the [src] with \the [W], but it bounces off!")
			)
			return
		playsound(damage_hitsound, src, 75)
		user.visible_message(
			SPAN_DANGER("\The [user] hits \the [src] with \a [W]!"),
			SPAN_DANGER("You hit \the [src] with \the [W]!")
		)
		damage_health(W.force, W.damtype)
