/mob/living/health_resistances = null // Not currently supported in health passthrough


/mob/living/use_weapon_hitsound = TRUE


/mob/living/get_current_health()
	if (maxHealth)
		return health
	return ..()


/mob/living/get_max_health()
	if (maxHealth)
		return getMaxHealth()
	return ..()


/mob/living/health_dead()
	if (stat == DEAD)
		return TRUE
	return ..()


/mob/living/mod_health(health_mod, damage_type, skip_death_state_change)
	if (maxHealth)
		crash_with("Living mob using legacy health attempted to call mod_health. This is not currently supported and should not be possible.")
		return FALSE
	return ..()


/mob/living/set_health(new_health, skip_death_state_change)
	if (maxHealth)
		crash_with("Living mob using legacy health attempted to call set_health. This is not currently supported and should not be possible.")
		return FALSE
	return ..()


/mob/living/proc/general_health_adjustment(damage, damage_type, damage_flags = EMPTY_BITFIELD, def_zone, obj/item/used_weapon = null)
	var/prior_death_state = health_dead()
	// Convert damage types to types recognized by legacy mob health
	switch (damage_type)
		if (DAMAGE_EMP, DAMAGE_FIRE)
			return FALSE // These damages are handled separately by existing legacy code
		if (DAMAGE_SHOCK)
			damage_type = DAMAGE_BURN
		if (DAMAGE_BIO)
			damage_type = DAMAGE_TOXIN
		if (DAMAGE_EXPLODE, DAMAGE_PSIONIC)
			damage_type = DAMAGE_BRUTE
	// Apply damage
	switch (damage_type)
		if (DAMAGE_RADIATION)
			apply_radiation(damage)
		if (DAMAGE_STUN, DAMAGE_PAIN)
			adjustHalLoss(damage)
		if (DAMAGE_BRAIN)
			adjustBrainLoss(damage)
		else
			if (used_weapon)
				apply_damage(damage, damage_type, def_zone, damage_flags, used_weapon, used_weapon.armor_penetration, TRUE)
			else
				apply_damage(damage, damage_type, def_zone, damage_flags, silent = TRUE)
	return prior_death_state != health_dead()


/mob/living/restore_health(damage, damage_type, skip_death_state_change, skip_can_restore_check)
	if (maxHealth)
		if (!can_restore_health(damage, damage_type))
			return FALSE
		return general_health_adjustment(-damage, damage_type)
	return ..()


/mob/living/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	if (maxHealth)
		if (!can_damage_health(damage, damage_type, damage_flags))
			return FALSE
		return general_health_adjustment(damage, damage_type, damage_flags)
	return ..()


/mob/living/kill_health()
	if (maxHealth)
		if (health_dead())
			return FALSE
		death()
		return TRUE
	return ..()


/mob/living/revive_health()
	if (maxHealth)
		var/prior_death_state = health_dead()
		rejuvenate()
		return prior_death_state != health_dead()
	return ..()


/mob/living/set_max_health(new_max_health, set_current_health, use_standardized_health = FALSE)
	if (use_standardized_health)
		if (maxHealth)
			maxHealth = 0
			health_current = health
			health = 0
		..()
		return
	setMaxHealth(new_max_health)
	if (set_current_health)
		rejuvenate()
	else
		updatehealth()


/mob/living/set_damage_resistance(damage_type, resistance_value)
	if (maxHealth)
		return
	..()


/mob/living/remove_damage_resistance(damage_type)
	if (maxHealth)
		return
	..()


/mob/living/get_damage_resistance(damage_type)
	if (maxHealth)
		return 1
	return ..()


/mob/living/is_damage_immune(damage_type)
	if (maxHealth)
		return FALSE
	return ..()
