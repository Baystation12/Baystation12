/datum/extension/armor
	base_type = /datum/extension/armor
	expected_type = /atom/movable
	var/list/armor_values
	var/full_block_message = "Your armor absorbs the blow!"
	var/partial_block_message = "Your armor softens the blow!"

	// Armor 'works' for damages in range from 0 to [armor_range_mult * armor].
	// The lower the damage, the harder it gets blocked, tapering to 0 mitigation at [armor_range_mult * armor]
	var/armor_range_mult = 2
	// [under_armor_mult] multiplies how strongly damage that is <= armor value is blocked.
	//  E.g. setting it to 0 will flat out block all damage below armor
	var/under_armor_mult = 0.7
	// [over_armor_mult] multiplies how strongly damage that is > armor value is blocked.
	//  E.g. setting it to more than 1 will make mitigation drop off faster, effectively reducing the range of damage mitigation
	var/over_armor_mult = 1

/datum/extension/armor/New(atom/movable/holder, list/armor)
	..()
	if(armor)
		armor_values = armor.Copy()

// Takes in incoming damage value
// Applies state changes to self, holder, and whatever else caused by damage mitigation
// Returns modified damage, a list to allow for flag modification or damage conversion, in the same format as the arguments.
/datum/extension/armor/proc/apply_damage_modifications(damage, damage_type, damage_flags, mob/living/victim, armor_pen, silent = FALSE)
	if(damage <= 0)
		return args.Copy()

	var/blocked = get_blocked(damage_type, damage_flags, armor_pen, damage)
	on_blocking(damage, damage_type, damage_flags, armor_pen, blocked)

	// Blocking values that mean the damage was under armor, so all dangerous flags are removed (edge/sharp)
	var/armor_border_blocking = 1 - (under_armor_mult * 1/armor_range_mult)
	if(blocked >= armor_border_blocking)
		if(damage_flags & DAM_LASER)
			damage *= FLUIDLOSS_CONC_BURN/FLUIDLOSS_WIDE_BURN
		damage_flags &= ~(DAM_SHARP | DAM_EDGE | DAM_LASER)
	if(damage_type == IRRADIATE)
		damage = max(0, damage - 100 * blocked)
		silent = TRUE
	damage *= 1 - blocked

	if(!silent)
		if(blocked > 0.7)
			to_chat(victim, SPAN_NOTICE(full_block_message))
		else if(blocked > 0.2)
			to_chat(victim, SPAN_NOTICE(partial_block_message))
	return args.Copy()

/datum/extension/armor/proc/on_blocking(damage, damage_type, damage_flags, armor_pen, blocked)

// A simpler proc used as a helper for above but can also be used externally. Does not modify state.
/datum/extension/armor/proc/get_blocked(damage_type, damage_flags, armor_pen = 0, damage = 5)
	var/key = get_armor_key(damage_type, damage_flags)
	if(!key)
		return 0

	var/armor = max(0, get_value(key) - armor_pen)
	if(!armor)
		return 0
	var/efficiency = min(damage / (armor_range_mult * armor), 1)
	var/coef = damage <= armor ? under_armor_mult : over_armor_mult
	return max(1 - coef * efficiency, 0)

/datum/extension/armor/proc/get_value(key)
	if(isnull(armor_values[key]))
		return 0
	return min(armor_values[key], 100)

/datum/extension/armor/proc/set_value(key, newval)
	armor_values[key] = Clamp(newval, 0, 100)

// There is a disconnect between legacy damage and armor code. This here helps bridge the gap.
/proc/get_armor_key(damage_type, damage_flags)
	var/key
	switch(damage_type)
		if(BRUTE)
			if(damage_flags & DAM_BULLET)
				key = "bullet"
			else if(damage_flags & DAM_EXPLODE)
				key = "bomb"
			else
				key = "melee"
		if(BURN)
			if(damage_flags & DAM_LASER)
				key = "laser"
			else if(damage_flags & DAM_EXPLODE)
				key = "bomb"
			else
				key = "energy"
		if(TOX)
			if(damage_flags & DAM_BIO)
				key = "bio" // Otherwise just not blocked by default.
		if(IRRADIATE)
			key = "rad"
		if(PSIONIC)
			key = PSIONIC
	return key

/datum/extension/armor/toggle
	var/active = TRUE

/datum/extension/armor/toggle/proc/toggle(new_state)
	active = new_state

/datum/extension/armor/toggle/get_value(key)
	return active ? ..() : 0