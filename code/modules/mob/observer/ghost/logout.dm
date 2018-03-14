/mob/observer/ghost/Logout()
	..()
	addtimer(CALLBACK(src, .proc/complete_logout), 0)

/mob/observer/ghost/proc/complete_logout()
	if(src && !key)	//we've transferred to another mob. This ghost should be deleted.
		qdel(src)