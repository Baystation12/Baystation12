
/datum/artifact_effect/gassleeping
	effecttype = "gassleeping"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gassleeping/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)

/datum/artifact_effect/gassleeping/DoEffectTouch(var/mob/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("sleeping_agent", rand(2, 15))

/datum/artifact_effect/gassleeping/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("sleeping_agent", pick(0, 0, 0.1, rand()))
