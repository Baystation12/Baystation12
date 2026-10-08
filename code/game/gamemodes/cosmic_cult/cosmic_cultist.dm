/datum/cosmic_cultist
	var/datum/mind/owning_mind = null
	var/alist/active_powers = alist()
	var/list/languages = list(LANGUAGE_MALIGN_GLOBAL, LANGUAGE_MALIGN_LOCAL)

/datum/cosmic_cultist/New(datum/mind/player)
	player.cosmic_cultist = src
	owning_mind = player

	// grant powers available to all cosmic cultists
	for (var/P in cosmic_cult_powers)
		if (get_power_instance(P).innate_power)
			grant_power(P)

	// grant languages
	for (var/L in languages)
		player.current.add_language(L)

var/global/list/cosmic_cult_powers = typesof(/datum/power/cosmic_cult) - /datum/power/cosmic_cult

/datum/cosmic_cultist/proc/Remove()
	owning_mind.cosmic_cultist = null
	for (var/P in active_powers)
		revoke_power(P)

	for (var/L in languages)
		owning_mind.current.remove_language(L)
