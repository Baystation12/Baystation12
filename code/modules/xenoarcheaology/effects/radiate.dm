/datum/artifact_effect/radiate
	name = "radiation"
	var/radiation_strength
	var/radiation_range

/datum/artifact_effect/radiate/New()
	..()
	radiation_strength = rand(10, 50)
	effect_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(user)
		user.apply_effect(radiation_strength * 2,IRRADIATE, blocked = user.getarmor(null, "rad"))
		user.updatehealth()
		return 1

/datum/artifact_effect/radiate/DoEffectAura()
	if(holder)
		radiation_repository.radiate(holder, radiation_strength)
		return 1

/datum/artifact_effect/radiate/DoEffectPulse()
	if(holder)
		radiation_repository.radiate(holder, radiation_strength * rand(5, 10)) //Need to get feedback on this
		return 1
