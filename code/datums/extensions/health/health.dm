// Defines used for health extension
#define MAXHEALTH_ADJUST_NONE   "none" // No adjustment to health, except to not exceed the new health_max
#define MAXHEALTH_ADJUST_DIRECT "direct" // Apply the exact same difference to health as was applied to health_max
#define MAXHEALTH_ADJUST_MULT   "mult" // Adjusts health by the same percentage difference as was applied to health_max
#define MAXHEALTH_ADJUST_MAX    "max" // Adjusts health to the max health


/**
 * Handles standardized health processing for various atoms.
 */
/datum/extension/health
	base_type = /datum/extension/health
	expected_type = /atom

	var/current_health
	var/max_health
	var/dead = FALSE // Whether or not the death state has been set


/**
 * Sets the current_health var to the defined new value, clamped between 0 and the current max_health value.
 * Generally this shouldn't be called directly unless you want to set a very specific health value.
 * Returns TRUE if the new health results in death, FALSE otherwise.
 */
/datum/extension/health/proc/set_health(new_health)
	SHOULD_CALL_PARENT(TRUE)
	var/old_health = Clamp(new_health, 0, max_health)
	var/current_health = old_health
	var/atom/A = holder
	A.update_icon()
	if (old_health && current_health <= 0)
		return set_death(TRUE)
	return FALSE

/atom/proc/set_health(new_health)
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return FALSE
	return health.set_health(new_health)


/**
 * Ease of use helper function. Takes the provided health mod and adds it to current health. Accepts negative values for health loss.
 * Provided mainly for subtype override use. It's recommended to use take_damage or repair_damage over this.
 * Returns TRUE if the new health results in death, FALSE otherwise.
 */
/datum/extension/health/proc/mod_health(health_mod)
	SHOULD_CALL_PARENT(TRUE)
	return set_health(current_health + health_mod)

/atom/proc/mod_health(health_mod)
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return FALSE
	return health.mod_health(health_mod)


/**
 * Increases health by the value provided, or sets health back to full if no value is provided.
 * Returns TRUE if the new health results in death, FALSE otherwise.
 */
/datum/extension/health/proc/repair_damage(damage = null)
	SHOULD_CALL_PARENT(TRUE)
	return mod_health(damage != null ? damage : max_health)

/atom/proc/repair_damage(damage = null)
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return FALSE
	return health.repair_damage(damage)


/**
 * Decreases health by the value provided
 * Returns TRUE if the new health results in death, FALSE otherwise.
 */
/datum/extension/health/proc/take_damage(damage, damage_type = BRUTE)
	SHOULD_CALL_PARENT(TRUE)
	return mod_health(-damage)

/atom/proc/take_damage(damage, damage_type = BRUTE)
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return FALSE
	return health.take_damage(damage, damage_type)


/**
 * Sets health to 0, resulting in death.
 * Returns TRUE if the new health results in death, FALSE otherwise.
 */
/datum/extension/health/proc/kill()
	SHOULD_CALL_PARENT(TRUE)
	return set_health(0)

/atom/proc/kill(damage = null)
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return FALSE
	return health.kill()


/**
 * Handles processing of 'death' and 'reviving'.
 * Returns TRUE if the death state was changed, FALSE otherwise
 */
/datum/extension/health/proc/set_death(new_dead = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if (dead == new_dead)
		return FALSE
	dead = !!new_dead // Ensure TRUE/FALSE, just in case
	var/atom/A = holder
	A.handle_death_change(dead, src)
	return TRUE


/**
 * To allow atoms to handle death and revival appropriately
 */
/atom/proc/handle_death_change(death_state, datum/extension/health/health)
	SHOULD_CALL_PARENT(TRUE)
	return


/**
 * Sets a new maximum health and allows options for modifying current health to compensate
 * Returns TRUE if the new health results in death, FALSE otherwise.
 */
/datum/extension/health/proc/set_max_health(new_max_health, health_adjust = MAXHEALTH_ADJUST_NONE)
	SHOULD_CALL_PARENT(TRUE)
	var/old_max_health = max_health
	max_health = max(new_max_health, 1)

	switch (health_adjust)
		if (MAXHEALTH_ADJUST_NONE)
			return set_health(current_health) // To allow for any override checks and clamps on health to take effect

		if (MAXHEALTH_ADJUST_DIRECT)
			var/difference = old_max_health - new_max_health
			return mod_health(difference)

		if (MAXHEALTH_ADJUST_MULT)
			var/multiplier = new_max_health / old_max_health
			return set_health(current_health * multiplier)

		if (MAXHEALTH_ADJUST_MAX)
			return set_health(max_health)

	return FALSE

/atom/proc/set_max_health(new_max_health, health_adjust = MAXHEALTH_ADJUST_NONE)
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return FALSE
	return health.set_max_health(new_max_health, health_adjust)


/**
 * Fetches the current health from the health extension, or NULL if the extension isn't initialized
 */
/atom/proc/get_current_health()
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return
	return health.current_health


/**
 * Fetches the maximum health from the health extension, or NULL if the extension isn't initialized
 */
/atom/proc/get_max_health()
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return
	return health.max_health


/**
 * Returns the difference between maximum and current health
 */
/datum/extension/health/proc/get_health_difference()
	SHOULD_CALL_PARENT(TRUE)
	return max_health - current_health

/atom/proc/get_health_difference()
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return
	return health.get_health_difference()


/**
 * Fetches the current health as a percentage of max health, rounded to the nearest hundredth, where `100%` is `1.00`
 */
/datum/extension/health/proc/get_health_percentage()
	SHOULD_CALL_PARENT(TRUE)
	return round(current_health / max_health, 0.01)

/atom/proc/get_health_percentage()
	SHOULD_CALL_PARENT(TRUE)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	if (!health)
		return
	return health.get_health_percentage()


/**
 * Creates a health extension. Ease of use alias to set_extension(). Intentionally uses set instead of create_or_get to allow rebuilding the extension.
 */
/atom/proc/initialize_health(max_health = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!max_health)
		max_health = init_max_health
	set_extension(src, health_extension_type)
	var/datum/extension/health/health = get_extension(src, health_extension_type)
	health.set_max_health(max_health)
	return health // So that overrides can just grab . to keep updating the extension


// Atom overrides for health handling
/atom
	var/init_max_health // If set, defines a maximum health and causes a health extension to be created on Initialize()
	var/health_extension_type = /datum/extension/health // Used for creation of health extensions


/atom/Initialize(mapload, ...)
	. = ..()

	if (init_max_health)
		initialize_health()
