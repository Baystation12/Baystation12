var/list/default_broadcasts = newlist(/datum/broadcast/hivemind, /datum/broadcast/audible, /datum/broadcast/visual)

/datum/broadcast/proc/attempt_broadcast(var/datum/communication/c, var/datum/communication_metadata/cm)
	return FALSE

/datum/broadcast/hivemind/attempt_broadcast(var/mob/observer/virtual/v, var/datum/communication/c, var/datum/communication_metadata/cm)
	if(c.language.flags & HIVEMIND)
		c.language.broadcast(c)
		return TRUE

	return FALSE

/datum/broadcast/audible/attempt_broadcast(var/mob/observer/virtual/v, var/datum/communication/c, var/datum/communication_metadata/cm)
	if(c.language.flags & SIGNLANG)
		return FALSE

	for(var/mob/observer/virtual/V in hearers(world.view, v))
		if(V.abilities & VIRTUAL_ABILITY_HEAR)
			V.receive_sound(c, cm)
	return TRUE

/datum/broadcast/visual/attempt_broadcast(var/mob/observer/virtual/v, var/datum/communication/c, var/datum/communication_metadata/cm)
	if(!(c.language.flags & SIGNLANG))
		return FALSE

	for(var/mob/observer/virtual/V in viewers(world.view, v))
		if(V.abilities & VIRTUAL_ABILITY_SEE)
			V.receive_sight(c, cm)
	return TRUE
