/mob
	var/saved_ckey = ""

/mob/before_save()
	if(stat != DEAD) // Temporary, until revival mechanics are in place.
		saved_ckey = LAST_CKEY(src)