/datum/artifact_effect/radiate
	name = "radiation"
	var/radiation_strength
	var/radiation_range

/datum/artifact_effect/radiate/New()
	..()
	radiation_strength = rand(10, 50)
	effect_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(istype(user))
		user.apply_damage(radiation_strength * 2, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
		user.updatehealth()
		return 1

/datum/artifact_effect/radiate/DoEffectAura()
	if(holder)
		SSradiation.radiate(holder, radiation_strength)
		return 1

/datum/artifact_effect/radiate/DoEffectPulse()
	if(holder)
		SSradiation.radiate(holder, radiation_strength * rand(5, 10)) //Need to get feedback on this
		return 1

/datum/artifact_effect/radiate/destroyed_effect()
	. = ..()

	if(holder)
		SSradiation.radiate(holder, radiation_strength * rand(10, 15))
