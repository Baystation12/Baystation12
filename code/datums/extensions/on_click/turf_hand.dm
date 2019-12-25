/*
	This extension is used on airlocks and cult runes.
	When a mob [attack_hand]s a turf, it will look for objects in itself containing this component.
	If such is found, it will call attack_hand on that atom

	When multiple of these components are in the tile, the one with the highest priority wins it.
*/
/datum/extension/turf_hand
	base_type = /datum/extension/turf_hand
	var/priority = 1
	expected_type = /atom

/datum/extension/turf_hand/New(var/holder, var/priority = 1)
	..()
	src.priority = priority


/datum/extension/turf_hand/proc/OnHandInterception(var/mob/user)
	var/atom/A = holder
	return A.attack_hand(user)