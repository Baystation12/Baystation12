// используется в whitelist.dm при проверке на доступность расы
/datum/species/proc/whitelistName(var/mob/living/carbon/human/H)
	return get_bodytype(H)

/datum/species
	var/pulse_rate_mod = 1
