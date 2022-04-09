/datum/artifact_effect/emp
	name = "emp"
	effect_type = EFFECT_ELECTRO

/datum/artifact_effect/emp/New()
	..()
	effect = EFFECT_PULSE

/datum/artifact_effect/emp/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		empulse(T, effectrange/2, effectrange)
		return 1

/datum/artifact_effect/emp/destroyed_effect()
	. = ..()

	if(holder)
		var/turf/T = get_turf(holder)
		empulse(T, (effectrange * 2), effectrange)