GLOBAL_LIST_INIT(fusion_plants, new)

/datum/fusion_plant
	var/id_tag
	var/list/fusion_cores =   list()
	var/list/fuel_injectors = list()
	var/list/all_objects =    list()
	var/list/gyrotrons =      list()
	var/const/network_size = 25

/datum/fusion_plant/New(var/_id)
	id_tag = _id
	GLOB.fusion_plants[id_tag] = src

/datum/fusion_plant/Destroy()
	gyrotrons.Cut()
	fusion_cores.Cut()
	fuel_injectors.Cut()
	all_objects.Cut()
	GLOB.fusion_plants -= src
	. = ..()

/datum/fusion_plant/proc/within_radius(var/atom/checking)
	for(var/thing in all_objects)
		if(get_dist(thing, checking) > network_size)
			return FALSE
	return TRUE

/datum/fusion_plant/proc/add_device(var/obj/machinery/device)
	if(!all_objects[device])
		all_objects[device] = TRUE
		if(istype(device, /obj/machinery/power/fusion_core))
			fusion_cores[device] = TRUE
		else if(istype(device, /obj/machinery/fusion_fuel_injector))
			fuel_injectors[device] = TRUE
		else if(istype(device, /obj/machinery/power/emitter/gyrotron))
			gyrotrons[device] = TRUE
	return all_objects[device]

/datum/fusion_plant/proc/remove_device(var/obj/machinery/device)
	if(all_objects[device])
		all_objects    -= device
		fusion_cores   -= device
		fuel_injectors -= device
		gyrotrons      -= device
	if(all_objects.len <= 0)
		qdel(src)
	return isnull(all_objects[device])
