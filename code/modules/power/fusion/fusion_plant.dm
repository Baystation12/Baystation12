GLOBAL_LIST_INIT(fusion_plants, new)

/client/verb/debug_fusion_plants()
	set name = "Debug Fusion Plants"
	set category = "Debug"

	if(LAZYLEN(GLOB.fusion_plants))
		for(var/i = 1 to LAZYLEN(GLOB.fusion_plants))
			to_chat(src, "Fusion plant #[i]:")
			var/datum/fusion_plant/plant = GLOB.fusion_plants[GLOB.fusion_plants[i]]
			to_chat(src, "Id: [plant.id_tag]")
			to_chat(src, "Obj: [LAZYLEN(plant.all_objects)]")
			to_chat(src, "Cores: [LAZYLEN(plant.fusion_cores)]")
			to_chat(src, "Injectors: [LAZYLEN(plant.fuel_injectors)]")
			to_chat(src, "Gyrotrons: [LAZYLEN(plant.gyrotrons)]")
	else
		to_chat(src, "No fusion plants exist.")

/datum/fusion_plant
	var/id_tag
	var/list/fusion_cores =   list()
	var/list/fuel_injectors = list()
	var/list/all_objects =    list()
	var/list/gyrotrons =      list()
	var/network_size = 10

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
	if(LAZYLEN(all_objects) <= 0)
		qdel(src)
	return isnull(all_objects[device])
