
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
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			env.phoron += rand(2,15)

/datum/artifact_effect/gasphoron/DoEffectAura()
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.total_moles < max_pressure)
			env.phoron += pick(0, 0, 0.1, rand())
