
/datum/artifact_effect/gasfluorine
	effecttype = "gasfluorine"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gasfluorine/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)

/datum/artifact_effect/gasfluorine/DoEffectTouch(var/mob/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("fluorine", rand(2, 15))

/datum/artifact_effect/gasfluorine/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("fluorine", pick(0, 0, 0.1, rand()))
