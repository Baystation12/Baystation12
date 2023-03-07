/datum/artifact_effect/mindswap
	name = "mind swap"
	effect_type = EFFECT_PSIONIC
	var/successful_swap = FALSE

/datum/artifact_effect/mindswap/DoEffectTouch(mob/user)
	if (user)
		do_mind_swap()

/datum/artifact_effect/mindswap/DoEffectAura()
	if (holder && prob(20))
		do_mind_swap()

/datum/artifact_effect/mindswap/DoEffectPulse()
	if (holder && prob(50))
		do_mind_swap()

/datum/artifact_effect/mindswap/proc/do_mind_swap()
	// Only one successful mind swap per activation.
	if (successful_swap)
		return
	// Collect a shuffled list of valid targets in range.
	var/turf/T = get_turf(holder)
	var/list/targets = list()
	for (var/mob/living/L in shuffle(range(src.effectrange, T)))
		var/weakness = GetAnomalySusceptibility(L)
		if (prob(weakness * 100))
			targets += L
	var/t_length = length(targets)
	// No targets: No visible effect.
	if (!t_length)
		return
	// One target: Make them feel something.
	if (t_length == 1 && prob(20))
		to_chat(targets[1], SPAN_WARNING("You feel an invisible force drag on your mind..."))
		return
	// Put each target's mind into the next target in the list.
	// This ensures that every target's mind ends up somewhere else.
	var/list/minds = list()
	for (var/mob/living/L in targets)
		minds += L.mind
		L.confused += 3
		L.eye_blurry += 2
		L.visible_message(SPAN_WARNING("[L] looks momentarily confused."))
	for (var/i in 1 to t_length)
		if (!minds[i])
			continue
		var/datum/mind/origin_mind = minds[i]
		origin_mind.transfer_to(targets[(i % t_length) + 1])
	// Remember that we had a successful swap during this activation phase.
	successful_swap = TRUE

/datum/artifact_effect/mindswap/toggle_off()
	. = ..()
	successful_swap = FALSE
