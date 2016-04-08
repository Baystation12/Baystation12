// CULT NET
//
// The datum containing all the chunks.

/datum/visualnet/cult
	chunk_type = /datum/chunk/cult

/datum/visualnet/cult/proc/provides_vision(var/mob/living/L)
	return L.provides_cult_vision()

/mob/living/proc/provides_cult_vision()
	return 1

/mob/living/silicon/provides_cult_vision()
	return 0
