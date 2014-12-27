
/datum/artifact_effect/gasoxy
	effecttype = "gasoxy"
	var/max_pressure

/datum/artifact_effect/gasoxy/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)


/datum/artifact_effect/gasoxy/DoEffectTouch(var/mob/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("oxygen", rand(2, 15))

/datum/artifact_effect/gasoxy/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("oxygen", pick(0, 0, 0.1, rand()))
