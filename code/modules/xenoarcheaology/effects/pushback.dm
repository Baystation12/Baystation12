/datum/artifact_effect/pushback
	name = "pushback"
	effect_type = EFFECT_ENERGY
	var/throw_range
	var/damage
	var/speed = 3

/datum/artifact_effect/pushback/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)
	throw_range = rand(1, 10)
	damage = rand(30, 50)

/datum/artifact_effect/pushback/DoEffectTouch(mob/toucher)
	if (holder && istype(toucher, /mob/living))
		var/mob/living/M = toucher
		var/weakness = GetAnomalySusceptibility(M)
		M.apply_damage(damage * weakness, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_DISPERSED)
		M.throw_at(get_target_turf(M), throw_range, speed)

		to_chat(M, SPAN_DANGER("A violent force slams into you as you touch \the [holder]!"))
		holder.visible_message(SPAN_WARNING("\The [holder] shines bright as it releases a wave of energy!"))
		playsound(get_turf(holder), "sound/magic/repulse.ogg", 100)

/datum/artifact_effect/pushback/DoEffectPulse()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			M.apply_damage(damage * weakness, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_DISPERSED)
			M.throw_at(get_target_turf(M), throw_range, speed)
			to_chat(M, SPAN_DANGER("A violent force explodes outward from \the [holder] and sends you flying!"))

		holder.visible_message(SPAN_WARNING("\The [holder] shines bright as it releases a wave of energy!"))
		playsound(get_turf(holder), "sound/magic/repulse.ogg", 100)

//returns a turf at a distance of 'throw_range' away from the artifact
/datum/artifact_effect/pushback/proc/get_target_turf(mob/M)
	if (holder)
		var/turf/step = get_step_away(M, holder, throw_range)

		if (!step)
			return get_turf(M)

		var/x = step.x
		var/y = step.y

		if (step.x < M.x)
			x = step.x - throw_range
		else if (step.x > M.x)
			x = step.x + throw_range

		if (step.y < M.y)
			y = step.y - throw_range
		else if (step.y > M.y)
			y = step.y + throw_range

		var/turf/T = locate(x, y, M.z)

		if (T)
			return T
		else
			return step

/datum/artifact_effect/pushback/destroyed_effect()
	. = ..()

	if (holder)
		var/turf/T = get_turf(holder)
		damage = damage * 2
		for (var/mob/living/M in range(effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			M.apply_damage(damage * weakness, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_DISPERSED)
			M.throw_at(get_target_turf(M), throw_range, speed)
			to_chat(M, SPAN_DANGER("A violent force explodes outward from \the [holder] and sends you flying!"))

		playsound(get_turf(holder), "sound/magic/repulse.ogg", 100)
