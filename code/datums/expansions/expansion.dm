/datum/expansion

/datum/expansion
	var/atom/holder = null // The holder

/datum/expansion/New(var/atom/holder)
	if(!istype(holder))
		CRASH()
	src.holder = holder
	..()

/datum/expansion/Destroy()
	holder = null
	return ..()

/datum/expansion/CanUseTopic(var/mob/user)
	return holder && user && !user.incapacitated() ? STATUS_INTERACTIVE : STATUS_CLOSE

/datum/expansion/Topic()
	if(..())
		return 1
	if(CanUseTopic(usr) != STATUS_INTERACTIVE)
		return 1
	return 0
