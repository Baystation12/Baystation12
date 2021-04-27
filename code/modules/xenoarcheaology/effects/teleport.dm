/datum/artifact_effect/teleport
	name = "teleport"
	effect_type = EFFECT_BLUESPACE
	var/list/teleporting = list() //mobs waiting to be teleported

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
	if (istype(user))
		try_teleport(user, get_turf(holder))

/datum/artifact_effect/teleport/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			try_teleport(M, T)

/datum/artifact_effect/teleport/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange, T))
			try_teleport(M, T)

/datum/artifact_effect/teleport/proc/try_teleport(mob/living/M, turf/center)
	if (M in teleporting)
		return

	var/weakness = GetAnomalySusceptibility(M)
	if(prob(100 * weakness))
		to_chat(M, SPAN_WARNING("You feel strange and tingly as some sort of force gathers around you!"))
		teleporting += M
		spawn(rand(50, 100))
			if (M.buckled)
				M.buckled.unbuckle_mob()

			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, get_turf(M))
			sparks.start()

			M.Move(pick(trange(50, center)))
			sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, M.loc)
			sparks.start()

			teleporting -= M

			to_chat(M, SPAN_WARNING("You are displaced by a strange force!"))
	else
		to_chat(M, SPAN_NOTICE("You feel some sort of force gather around you, before it quickly dissapates."))