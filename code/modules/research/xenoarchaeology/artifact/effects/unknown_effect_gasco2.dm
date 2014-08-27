
/datum/artifact_effect/gasco2
	effecttype = "gasco2"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/heat/New()
	..()
	effect_type = pick(6,7)

/datum/artifact_effect/gasco2/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)

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
