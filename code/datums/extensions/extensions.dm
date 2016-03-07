/datum/extension
	var/datum/holder = null // The holder
	var/list/host_predicates
	var/list/user_predicates
	var/expected_type = /datum

/datum/extension/New(var/datum/holder, var/host_predicates = list(), var/user_predicates = list(), var/additional_arguments = list())
	if(!istype(holder, expected_type))
		CRASH("Invalid holder type. Expected [expected_type], was [holder.type]")
	src.holder = holder
	..()

	src.host_predicates = host_predicates ? host_predicates : list()
	src.user_predicates = user_predicates ? user_predicates : list()

/datum/extension/Destroy()
	holder = null
	host_predicates.Cut()
	user_predicates.Cut()
	return ..()

/datum/extension/proc/extension_status(var/mob/user)
	if(!holder || !user)
		return STATUS_CLOSE
	if(!all_predicates_true(list(holder), host_predicates))
		return STATUS_CLOSE
	if(!all_predicates_true(list(user), user_predicates))
		return STATUS_CLOSE
	if(holder.CanUseTopic(usr, default_state) != STATUS_INTERACTIVE)
		return STATUS_CLOSE

	return STATUS_INTERACTIVE

/datum/extension/proc/extension_act(var/href, var/list/href_list, var/mob/user)
	return extension_status(user) == STATUS_CLOSE

/datum/extension/Topic(var/href, var/list/href_list)
	if(..())
		return TRUE
	return extension_act(href, href_list, usr)

/datum
	var/list/datum/extension/extensions

/datum/Destroy()
	if(extensions)
		for(var/expansion_key in extensions)
			var/list/expansion = extensions[expansion_key]
			if(islist(expansion))
				expansion.Cut()
			else
				qdel(expansion)
		extensions.Cut()
	return ..()

/datum/ResetVars(var/list/exclude = list())
	exclude += "extensions"
	..(exclude)
	//extensions = list()

/proc/set_extension(var/datum/source, var/base_type, var/expansion_type, var/host_predicates, var/user_predicates, var/list/additional_argments)
	if(!source.extensions)
		source.extensions = list()
	source.extensions[base_type] = list(expansion_type, host_predicates, user_predicates, additional_argments)

/proc/get_extension(var/datum/source, var/base_type)
	if(!source.extensions)
		return
	var/list/expansion = source.extensions[base_type]
	if(!expansion)
		return
	if(istype(expansion))
		var/expansion_type = expansion[1]
		expansion = new expansion_type(source, expansion[2], expansion[3], expansion[4])
		source.extensions[base_type] = expansion
	return expansion
