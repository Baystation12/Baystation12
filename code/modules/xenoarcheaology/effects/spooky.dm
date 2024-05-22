/datum/artifact_effect/skeletonise
	name = "skeletonise"
	effect_type = EFFECT_ORGANIC

/datum/artifact_effect/skeletonise/DoEffectTouch(mob/user)
	if (user)
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if (MUTATION_SKELETON in H.mutations)
				return
			var/weakness = GetAnomalySusceptibility(H)
			if (prob(weakness * 100))
				if (!addtimer(new Callback(H, TYPE_PROC_REF(/mob/living/carbon/human, ChangeToSkeleton)), rand(30 SECONDS, 2 MINUTES), TIMER_UNIQUE | TIMER_NO_HASH_WAIT))
					return
				to_chat(H, SPAN_WARNING("You suddenly feel a deep chill in your bones..."))
				var/datum/gas_mixture/env = H.loc.return_air()
				if (env)
					env.temperature -= 15

/datum/artifact_effect/skeletonise/DoEffectAura(atom/holder)
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange, T))
			if (MUTATION_SKELETON in H.mutations)
				return
			var/weakness = GetAnomalySusceptibility(H)
			if (prob(weakness * 100))
				if (!addtimer(new Callback(H, TYPE_PROC_REF(/mob/living/carbon/human, ChangeToSkeleton)), rand(30 SECONDS, 2 MINUTES), TIMER_UNIQUE | TIMER_NO_HASH_WAIT))
					return
				to_chat(H, SPAN_WARNING("You suddenly feel a deep chill in your bones..."))
				var/datum/gas_mixture/env = H.loc.return_air()
				if (env)
					env.temperature -= 15

/datum/artifact_effect/skeletonise/DoEffectPulse(atom/holder)
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange, T))
			if (MUTATION_SKELETON in H.mutations)
				return
			var/weakness = GetAnomalySusceptibility(H)
			if (prob(weakness * 100))
				if (!addtimer(new Callback(H, TYPE_PROC_REF(/mob/living/carbon/human, ChangeToSkeleton)), rand(30 SECONDS, 2 MINUTES), TIMER_UNIQUE | TIMER_NO_HASH_WAIT))
					return
				to_chat(H, SPAN_WARNING("You suddenly feel a deep chill in your bones..."))
				var/datum/gas_mixture/env = H.loc.return_air()
				if (env)
					env.temperature -= 15

/datum/artifact_effect/skeletonise/destroyed_effect()
	. = ..()

	if (holder)
		var/turf/T = get_turf(holder)
		new /mob/living/simple_animal/hostile/skeleton(T)
		for (var/mob/living/carbon/human/H in range(src.effectrange, T))
			if (prob(50))
				H.custom_pain(SPAN_DANGER("You feel a deep ache in your bones!"), 30)
				H.Weaken(10)
