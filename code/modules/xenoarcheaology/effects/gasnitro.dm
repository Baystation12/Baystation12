/datum/artifact_effect/gasnitro
	name = "N2 creation"

/datum/artifact_effect/gasnitro/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/gasnitro/DoEffectTouch(var/mob/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("nitrogen", rand(2, 15))

/datum/artifact_effect/gasnitro/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("nitrogen", pick(0, 0, 0.1, rand()))
