/datum/expansion
	var/datum/holder = null // The holder

/datum/expansion/New(var/atom/holder)
	if(!istype(holder))
		CRASH("Invalid holder.")
	src.holder = holder
	..()

/datum/expansion/Destroy()
	holder = null
	return ..()

/datum/expansion/CanUseTopic(var/mob/user)
	return holder && user ? STATUS_INTERACTIVE : STATUS_CLOSE

/datum/expansion/Topic()
	if(..())
		return 1
	if(CanUseTopic(usr) != STATUS_INTERACTIVE)
		return 1
	return 0

/obj
	var/list/datum/expansion/expansions = list()

/obj/Destroy()
	for(var/expansion in expansions)
		qdel(expansions[expansion])
	expansions.Cut()
	return ..()

/obj/ResetVars(var/list/exclude = list())
	exclude += "expansions"
	..(exclude)
	//expansions = list()

/obj/proc/set_expansion(var/type, var/instance)
	if(expansions[type])
		qdel(expansions[type])
	expansions[type] = instance
