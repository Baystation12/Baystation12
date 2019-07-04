/datum/extension/armor
	expected_type = /atom/movable
	var/list/armor_values
	var/full_block_message = "Your armor absorbs the blow!"
	var/partial_block_message = "Your armor softens the blow!"

/datum/extension/armor/New(atom/movable/holder, list/armor)
	..(holder)
	if(armor)
		armor_values = armor.Copy()

// Takes in incoming damage value
// Applies state changes to self, holder, and whatever else caused by damage mitigation
// Returns modified damage, a list to allow for flag modification or damage conversion, in the same format as the arguments.
/datum/extension/armor/proc/apply_damage_modifications(damage, damage_type, damage_flags, mob/living/victim, armor_pen, silent = FALSE)
	if(damage <= 0)
		return args.Copy()

	var/blocked = get_blocked(damage_type, damage_flags, armor_pen)
	if(prob(blocked * 100))
		if(damage_flags & DAM_LASER)
			damage *= FLUIDLOSS_CONC_BURN/FLUIDLOSS_WIDE_BURN
		damage_flags &= ~(DAM_SHARP | DAM_EDGE | DAM_LASER)

	on_blocking(damage, blocked)

	if(damage_type == IRRADIATE)
		damage = max(0, damage - 100 * blocked)
		silent = TRUE
	damage *= 1 - blocked

	if(!silent)
		if(blocked == 1)
			to_chat(victim, SPAN_WARNING(full_block_message))
		else if(blocked > 0.2)
			to_chat(victim, SPAN_WARNING(partial_block_message))
	return args.Copy()

/datum/extension/armor/proc/on_blocking(damage, blocked)

// A simpler proc used as a helper for above but can also be used externally. Does not modify state.
/datum/extension/armor/proc/get_blocked(damage_type, damage_flags, armor_pen = 0)
	var/key = get_armor_key(damage_type, damage_flags)
	if(!key)
		return 0

	var/armor = get_value(key)
	if(armor_pen >= armor)
		return 0

	var/effective_armor = (armor - armor_pen)/100
	var/fullblock = effective_armor ** 2
	//this makes it so that X armour blocks X% damage, when including the chance of hard block.
	//I double checked and this formula will also ensure that a higher effective_armor
	//will always result in higher (non-fullblock) damage absorption too, which is also a nice property
	//In particular, blocked will increase from 0 to 50 as effective_armor increases from 0 to 0.999 (if it is 1 then we never get here because ofc)
	//and the average damage absorption = (blocked/100)*(1-fullblock) + 1.0*(fullblock) = effective_armor
	var/blocked
#ifndef UNIT_TEST // Removes the probablity of full blocks for the purposes of testing innate armor.
	if(fullblock >= 1  || prob(fullblock*100))
#else
	if(fullblock >= 1)
#endif
		blocked = 1
	else
		blocked = (effective_armor - fullblock)/(1 - fullblock)
	return blocked

/datum/extension/armor/proc/get_value(key)
	return min(armor_values[key], 100)

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