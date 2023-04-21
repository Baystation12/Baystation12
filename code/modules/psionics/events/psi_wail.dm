/datum/event/psi/wail
	var/static/list/whine_messages = list(
		"Душераздирающий психический вой вторгается в ваши мысли и путает сознание, не давая вам сосредоточиться на чём-либо.",
		"Ужасный, отвлекающий жужжащий звук нарушает ход ваших мыслей.",
		"Пугающий сверхъестественный крик вторгается в саму вашу душу и разрывает её изнутри, пытаясь свести вас с ума."
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
