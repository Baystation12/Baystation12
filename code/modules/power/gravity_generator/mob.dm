/mob/proc/update_gravity()
	return

/mob/proc/mob_has_gravity()
	return has_gravity(src)

/mob/proc/mob_negates_gravity()
	return 0

/mob/living/update_gravity(has_gravity)
	if(has_gravity)
		stop_floating()
	else
		start_floating()
