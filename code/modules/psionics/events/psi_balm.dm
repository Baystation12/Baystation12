/datum/event/psi/balm
	var/static/list/balm_messages = list(
		"Псионическая энергия медленно омывает вашу душу, вызывая ранее неизведанные эмоции и ощущения.",
		"На мгновение вы слышите далекий, знакомый голос, поющий тихую колыбельную.",
		"Будто тёплое одеяло, вас накрывает чувство покоя и уюта.",
		"В вашем разуме начинают мелькать давно забытые тёплые воспоминания о прошедшем и будущем, как будто вы проживаете их вновь и проживёте ещё раз после."
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
