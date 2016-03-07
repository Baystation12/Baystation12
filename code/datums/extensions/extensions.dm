/datum/extension

	var/datum/holder = null // The holder

/datum/extension/New(var/datum/holder)
	if(!istype(holder))
		CRASH("Invalid holder.")
	src.holder = holder
	..()

/datum/extension/Destroy()
	holder = null
	return ..()

/datum/extension/CanUseTopic(var/mob/user)
	return holder && user ? STATUS_INTERACTIVE : STATUS_CLOSE

/datum/extension/Topic()
	if(..())
		return 1
	if(CanUseTopic(usr) != STATUS_INTERACTIVE)
		return 1
	return 0

/obj
	var/list/datum/extension/extensions = list()

/obj/Destroy()
	for(var/expansion_key in extensions)
		var/list/expansion = extensions[expansion_key]
		if(islist(expansion))
			expansion.Cut()
		else
			qdel(expansion)
	extensions.Cut()
	return ..()

/obj/ResetVars(var/list/exclude = list())
	exclude += "extensions"
	..(exclude)
	//extensions = list()

/proc/set_extension(var/obj/source, var/base_type, var/expansion_type, var/list/arguments = list())
	source.extensions[base_type] = list(expansion_type, arguments)

/proc/get_extension(var/obj/source, var/base_type)
	var/list/expansion = source.extensions[base_type]
	if(!expansion)
		return
	if(istype(expansion))
		var/expansion_type = expansion[1]
		var/expansion_arguments = expansion[2]
		expansion = new expansion_type(source, expansion_arguments)
		source.extensions[base_type] = expansion
	return expansion
