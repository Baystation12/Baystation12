
/datum/artifact_effect/gasnitro
	effecttype = "gasnitro"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gasnitro/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(6,7)
	max_pressure = rand(115,1000)

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
