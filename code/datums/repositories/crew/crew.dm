var/global/datum/repository/crew/crew_repository = new()

/datum/repository/crew
	var/list/cache_data
	var/list/modifier_queues
	var/list/modifier_queues_by_type

/datum/repository/crew/New()
	cache_data = list()
	var/PriorityQueue/general_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/binary_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/vital_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/tracking_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)

	general_modifiers.Enqueue(new/crew_sensor_modifier/general())
	binary_modifiers.Enqueue(new/crew_sensor_modifier/binary())
	vital_modifiers.Enqueue(new/crew_sensor_modifier/vital())
	tracking_modifiers.Enqueue(new/crew_sensor_modifier/tracking())

	modifier_queues = list()
	modifier_queues[general_modifiers] = 0
	modifier_queues[binary_modifiers] = SUIT_SENSOR_BINARY
	modifier_queues[vital_modifiers] = SUIT_SENSOR_VITAL
	modifier_queues[tracking_modifiers] = SUIT_SENSOR_TRACKING

	modifier_queues_by_type = list()
	modifier_queues_by_type[/crew_sensor_modifier/general] = general_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/binary] = binary_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/vital] = vital_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/tracking] = tracking_modifiers

	..()

/datum/repository/crew/proc/health_data(var/z_level)
	var/list/crewmembers = list()
	if(!z_level)
		return crewmembers

	var/datum/cache_entry/cache_entry = cache_data[num2text(z_level)]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[num2text(z_level)] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

	var/tracked = scan()
	for(var/obj/item/clothing/under/C in tracked)
		var/turf/pos = get_turf(C)
		if(C.has_sensor && pos && pos.z == z_level && C.sensor_mode != SUIT_SENSOR_OFF)
			if(istype(C.loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = C.loc
				if(H.w_uniform != C)
					continue
				var/list/crewmemberData = list("sensor_type" = C.sensor_mode, "dead"=0, "oxy"=-1, "tox"=-1, "fire"=-1, "brute"=-1, "area"="", "x"=-1, "y"=-1, "z"=-1, "ref" = "\ref[H]")
				if(!(run_queues(H, C, pos, crewmemberData) & MOD_SUIT_SENSORS_REJECTED))
					crewmembers[++crewmembers.len] = crewmemberData

	crewmembers = sortByKey(crewmembers, "name")
	cache_entry.timestamp = world.time + 5 SECONDS
	cache_entry.data = crewmembers

	return crewmembers

/datum/repository/crew/proc/scan()
	var/list/tracked = list()
	for(var/mob/living/carbon/human/H in mob_list)
		if(istype(H.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/C = H.w_uniform
			if (C.has_sensor)
				tracked |= C
	return tracked


/datum/repository/crew/proc/run_queues(H, C, pos, crewmemberData)
	for(var/modifier_queue in modifier_queues)
		if(crewmemberData["sensor_type"] >= modifier_queues[modifier_queue])
			. = process_crew_data(modifier_queue, H, C, pos, crewmemberData)
			if(. & MOD_SUIT_SENSORS_REJECTED)
				return

/datum/repository/crew/proc/process_crew_data(var/PriorityQueue/modifiers, var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	var/current_priority = INFINITY
	var/list/modifiers_of_this_priority = list()

	for(var/crew_sensor_modifier/csm in modifiers.L)
		if(csm.priority < current_priority)
			. = check_queue(modifiers_of_this_priority, H, C, pos, crew_data)
			if(. != MOD_SUIT_SENSORS_NONE)
				return
		current_priority = csm.priority
		modifiers_of_this_priority += csm
	return check_queue(modifiers_of_this_priority, H, C, pos, crew_data)

/datum/repository/crew/proc/check_queue(var/list/modifiers_of_this_priority, H, C, pos, crew_data)
	while(modifiers_of_this_priority.len)
		var/crew_sensor_modifier/pcsm = pick(modifiers_of_this_priority)
		modifiers_of_this_priority -= pcsm
		if(pcsm.may_process_crew_data(H, C, pos))
			. = pcsm.process_crew_data(H, C, pos, crew_data)
			if(. != MOD_SUIT_SENSORS_NONE)
				return
	return MOD_SUIT_SENSORS_NONE

/datum/repository/crew/proc/add_modifier(var/base_type, var/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor modifier was not of the given base type.")
	var/PriorityQueue/pq = modifier_queues_by_type[base_type]
	if(!pq)
		CRASH("The given base type was not a valid base type.")
	if(csm in pq.L)
		CRASH("This crew sensor modifier has already been supplied.")
	pq.Enqueue(csm)
	return TRUE

/datum/repository/crew/proc/remove_modifier(var/base_type, var/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor modifier was not of the given base type.")
	var/PriorityQueue/pq = modifier_queues_by_type[base_type]
	if(!pq)
		CRASH("The given base type was not a valid base type.")
	return pq.Remove(csm)
