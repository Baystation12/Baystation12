/datum/artifact_effect/gasco2
	name = "CO2 creation"

/datum/artifact_effect/gasco2/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/gasco2/DoEffectTouch(var/mob/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("carbon_dioxide", rand(2, 15))

/datum/artifact_effect/gasco2/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("carbon_dioxide", pick(0, 0, 0.1, rand()))
