/datum/artifact_trigger
	var/name = "nothing ever"
	var/toggle = TRUE  //TRUE - effect is toggled between on and off when triggered. FALSE - effects is on when triggered, off if not triggered. 

//There procs should return TRUE if trigger is activated, FALSE if nothing happens

/datum/artifact_trigger/proc/on_hit(obj/O, mob/user)
	return FALSE

/datum/artifact_trigger/proc/on_touch(mob/M)
	return FALSE

/datum/artifact_trigger/proc/on_gas_exposure(datum/gas_mixture/gas)
	return FALSE

/datum/artifact_trigger/proc/on_explosion(severity)
	return FALSE

/datum/artifact_trigger/proc/on_bump(atom/movable/AM)
	return FALSE