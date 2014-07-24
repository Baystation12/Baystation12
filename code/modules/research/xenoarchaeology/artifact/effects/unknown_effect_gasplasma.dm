
/datum/artifact_effect/gasphoron
	effecttype = "gasphoron"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gasphoron/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)

/datum/artifact_effect/gasphoron/DoEffectTouch(var/mob/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("oxygen", rand(2, 15))

/datum/artifact_effect/gasphoron/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("phoron", pick(0, 0, 0.1, rand()))
