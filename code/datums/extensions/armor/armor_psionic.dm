/datum/extension/armor/psionic
	expected_type = /datum/psi_complexus
	full_block_message = "You block the blow with your mind!"
	partial_block_message = "You soften the blow with your mind!"

/datum/extension/armor/psionic/get_value(key)
	var/datum/psi_complexus/psi = holder
	return psi.get_armour(key)

/datum/extension/armor/psionic/on_blocking(damage, damage_type, damage_flags, armor_pen, blocked)
	var/datum/psi_complexus/psi = holder
	var/blocked_damage = damage * blocked
	if(blocked_damage)
		psi.spend_power_armor(blocked_damage)
