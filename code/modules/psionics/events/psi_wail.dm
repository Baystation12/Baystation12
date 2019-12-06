/datum/event/psi/wail
	var/static/list/whine_messages = list(
		"A nerve-tearing psychic whine intrudes on your thoughts.",
		"A horrible, distracting humming sound breaks your train of thought.",
		"Your head aches as a psychic wail intrudes on your psyche."
		)

/datum/event/psi/wail/apply_psi_effect(var/datum/psi_complexus/psi)
	var/annoyed
	if(prob(1))
		psi.stunned(1)
		annoyed = TRUE
	else if(psi.stamina > 0)
		psi.stamina = max(0, psi.stamina - rand(1,3))
		annoyed = TRUE
	if(annoyed && prob(1))
		to_chat(psi.owner, "<span class='notice'><i>[pick(whine_messages)]</i></span>")
