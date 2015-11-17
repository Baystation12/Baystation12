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
