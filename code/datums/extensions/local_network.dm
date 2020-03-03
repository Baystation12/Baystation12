/datum/extension/local_network_member
	base_type = /datum/extension/local_network_member
	var/id_tag

/datum/extension/local_network_member/Destroy()
	if(holder)
		var/datum/local_network/lan = get_local_network()
		if(lan)
			lan.remove_device(holder)
	. = ..()

/datum/extension/local_network_member/proc/set_tag(var/mob/user, var/new_ident)
	if(id_tag == new_ident)
		to_chat(user, SPAN_WARNING("\The [holder] is already part of the [new_ident] local network."))
		return FALSE

	if(id_tag)
		var/datum/local_network/old_lan = GLOB.local_networks[id_tag]
		if(old_lan)
			if(!old_lan.remove_device(holder))
				to_chat(user, SPAN_WARNING("You encounter an error when trying to unregister \the [holder] from the [id_tag] local network."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You unregister \the [holder] from the [id_tag] local network."))

	var/datum/local_network/lan = GLOB.local_networks[new_ident]
	if(!lan)
		lan = new(new_ident)
		lan.add_device(holder)
		to_chat(user, SPAN_NOTICE("You create a new [new_ident] local network and register \the [holder] with it."))
	else if(lan.within_radius(holder))
		lan.add_device(holder)
		to_chat(user, SPAN_NOTICE("You register \the [holder] with the [new_ident] local network."))
	else
		to_chat(user, SPAN_WARNING("\The [holder] is out of range of the [new_ident] local network."))
		return FALSE
	id_tag = new_ident
	return TRUE

/datum/extension/local_network_member/proc/get_local_network()
	var/datum/local_network/lan = id_tag ? GLOB.local_networks[id_tag] : null
	if(lan && !lan.within_radius(holder))
		lan.remove_device(holder)
		id_tag = null
		lan = null
	return lan

/datum/extension/local_network_member/nano_host()
	if(holder)
		return holder.nano_host()
	. = ..()

/datum/extension/local_network_member/proc/get_new_tag(var/mob/user)
	var/new_ident = input(user, "Enter a new ident tag.", "[holder]", id_tag) as null|text
	if(new_ident && holder && user.Adjacent(holder) && CanPhysicallyInteract(user))
		return set_tag(user, new_ident)

//

/datum/extension/local_network_member/multilevel/set_tag(var/mob/user, var/new_ident)
	if(id_tag == new_ident)
		to_chat(user, SPAN_WARNING("\The [holder] is already part of the [new_ident] local network."))
		return FALSE

	if(id_tag)
		var/datum/local_network/multilevel/old_lan = GLOB.multilevel_local_networks[id_tag]
		if(old_lan)
			if(!old_lan.remove_device(holder))
				to_chat(user, SPAN_WARNING("You encounter an error when trying to unregister \the [holder] from the [id_tag] local network."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You unregister \the [holder] from the [id_tag] local network."))

	var/datum/local_network/multilevel/lan = GLOB.multilevel_local_networks[new_ident]
	if(!lan)
		lan = new(new_ident)
		lan.add_device(holder)
		to_chat(user, SPAN_NOTICE("You create a new [new_ident] local network and register \the [holder] with it."))
	else if(lan.within_radius(holder))
		lan.add_device(holder)
		to_chat(user, SPAN_NOTICE("You register \the [holder] with the [new_ident] local network."))
	else
		to_chat(user, SPAN_WARNING("\The [holder] is out of range of the [new_ident] local network."))
		return FALSE
	id_tag = new_ident
	return TRUE

/datum/extension/local_network_member/multilevel/get_local_network()
	var/datum/local_network/multilevel/lan = id_tag ? GLOB.multilevel_local_networks[id_tag] : null
	if(lan && !lan.within_radius(holder))
		lan.remove_device(holder)
		id_tag = null
		lan = null
	return lan