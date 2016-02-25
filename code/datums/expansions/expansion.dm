/datum/expansion

	var/datum/holder = null // The holder

/datum/expansion/New(var/datum/holder)
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
	for(var/expansion_key in expansions)
		var/list/expansion = expansions[expansion_key]
		if(islist(expansion))
			expansion.Cut()
		else
			qdel(expansion)
	expansions.Cut()
	return ..()

/obj/ResetVars(var/list/exclude = list())
	exclude += "expansions"
	..(exclude)
	//expansions = list()

/proc/set_expansion(var/obj/source, var/base_type, var/expansion_type, var/list/arguments = list())
	source.expansions[base_type] = list(expansion_type, arguments)

/proc/get_expansion(var/obj/source, var/base_type)
	var/list/expansion = source.expansions[base_type]
	if(!expansion)
		return
	if(istype(expansion))
		var/expansion_type = expansion[1]
		var/expansion_arguments = expansion[2]
		expansion = new expansion_type(source, expansion_arguments)
		source.expansions[base_type] = expansion
	return expansion
