/datum/event/psi/balm
	var/static/list/balm_messages = list(
		"A soothing balm washes over your psyche.",
		"For a moment, you can hear a distant, familiar voice singing a quiet lullaby.",
		"A sense of peace and comfort falls over you like a warm blanket."
		)

/datum/event/psi/balm/apply_psi_effect(var/datum/psi_complexus/psi)
	var/soothed
	if(psi.stun > 1)
		psi.stun--
		soothed = TRUE
	else if(psi.stamina < psi.max_stamina)
		psi.stamina = min(psi.max_stamina, psi.stamina + rand(1,3))
		soothed = TRUE
	else if(psi.owner.getBrainLoss() > 0)
		psi.owner.adjustBrainLoss(-1)
		soothed = TRUE
	if(soothed && prob(10))
		to_chat(psi.owner, SPAN_NOTICE("<i>[pick(balm_messages)]</i>"))
