/datum/extension/fusion_plant_member
	var/id_tag

/datum/extension/fusion_plant_member/Destroy()
	if(holder)
		var/datum/fusion_plant/plant = get_fusion_plant()
		if(plant)
			plant.remove_device(holder)
	. = ..()

/datum/extension/fusion_plant_member/proc/set_tag(var/mob/user, var/new_ident)
	if(id_tag == new_ident)
		to_chat(user, SPAN_WARNING("\The [holder] is already part of the [new_ident] network."))
		return FALSE

	if(id_tag)
		var/datum/fusion_plant/old_plant = GLOB.fusion_plants[id_tag]
		if(old_plant)
			if(!old_plant.remove_device(holder))
				to_chat(user, SPAN_WARNING("You encounter an error when trying to unregister \the [holder] from the [id_tag] network."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You unregister \the [holder] from the [id_tag] network."))

	var/datum/fusion_plant/plant = GLOB.fusion_plants[new_ident]
	if(!plant)
		plant = new(new_ident)
		plant.add_device(holder)
		to_chat(user, SPAN_NOTICE("You create a new [new_ident] network and register \the [holder] with it."))
	else if(plant.within_radius(holder))
		plant.add_device(holder)
		to_chat(user, SPAN_NOTICE("You register \the [holder] with the [new_ident] network."))
	else
		to_chat(user, SPAN_WARNING("\The [holder] is out of range of the [new_ident] network."))
		return FALSE
	id_tag = new_ident
	return TRUE

/datum/extension/fusion_plant_member/proc/get_fusion_plant()
	var/datum/fusion_plant/plant = id_tag ? GLOB.fusion_plants[id_tag] : null
	if(plant && !plant.within_radius(holder))
		plant.remove_device(holder)
		id_tag = null
		plant = null
	return plant

/datum/extension/fusion_plant_member/proc/get_new_tag(var/mob/user)
	var/new_ident = input(user, "Enter a new ident tag.", "[holder]", id_tag) as null|text
	if(new_ident && user.Adjacent(holder))
		return set_tag(user, new_ident)
		