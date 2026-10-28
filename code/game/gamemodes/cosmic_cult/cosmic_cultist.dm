/datum/cosmic_cultist
	var/datum/mind/owning_mind = null
	var/alist/active_powers = alist()
	var/list/languages = list(LANGUAGE_MALIGN_GLOBAL, LANGUAGE_MALIGN_LOCAL)

	var/progress = 0
	var/next_influence_at = 12
	var/notified_of_next_influence = FALSE
	var/granting_influence = null

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

var/global/list/cosmic_cult_powers = subtypesof(/datum/power/cosmic_cult)

/datum/cosmic_cultist/proc/Remove()
	owning_mind.cosmic_cultist = null
	for (var/P in active_powers)
		revoke_power(P)

	for (var/L in languages)
		owning_mind.current.remove_language(L)

/datum/cosmic_cultist/proc/adjust_progress(progress)
	src.progress += progress
	if (src.progress >= src.next_influence_at && !src.notified_of_next_influence)
		to_chat(owning_mind.current, SPAN_CLASS("malign", "Astral power surges within you. A new power awaits you in the cosmic dark."))
		src.notified_of_next_influence = TRUE

/datum/cosmic_cultist/proc/try_begin_get_new_influence()
	if (!isnull(src.granting_influence) || src.progress < src.next_influence_at)
		return null

	for (var/P in cosmic_cult_powers)
		if (has_power(P))
			continue

		src.granting_influence = P
		src.progress -= src.next_influence_at
		src.next_influence_at += 1
		src.notified_of_next_influence = FALSE
		break

	return src.granting_influence

/datum/cosmic_cultist/proc/finish_get_new_influence()
	if (isnull(src.granting_influence))
		return

	grant_power(src.granting_influence)
	src.granting_influence = null
