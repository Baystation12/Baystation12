/datum/map
	var/list/high_secure_areas
	var/list/secure_areas
	var/lockdown = FALSE

/datum/map/proc/area_lockdown(a)
	var/area/area = get_area_name(a)
	for(var/obj/machinery/door/airlock/airlock in area)
		airlock.command("secure_close")

/datum/map/proc/area_unlock(a)
	var/area/area = get_area_name(a)
	for(var/obj/machinery/door/airlock/airlock in area)
		airlock.command("unlock")

/datum/map/proc/lock_secure_areas()
	if(secure_areas)
		for(var/area in secure_areas)
			area_lockdown(area)

/datum/map/proc/unlock_secure_areas()
	if(secure_areas)
		for(var/area in secure_areas)
			area_unlock(area)

/datum/map/proc/lock_high_secure_areas()
	if(high_secure_areas)
		for(var/area in high_secure_areas)
			area_lockdown(area)

/datum/map/proc/unlock_high_secure_areas()
	if(high_secure_areas)
		for(var/area in high_secure_areas)
			area_unlock(area)

/datum/map/proc/lockdown(force)
	lockdown = !lockdown
	if(force && force == "close")
		lockdown = TRUE
	else if(force && force == "open")
		lockdown = FALSE

	if(!lockdown)
		for(var/obj/machinery/door/blast/regular/lockdown/door as anything in SSmachines.get_machinery_of_type(/obj/machinery/door/blast/regular/lockdown))
			door.autoclose = FALSE
			invoke_async(door, TYPE_PROC_REF(/obj/machinery/door, open))
	else
		for(var/obj/machinery/door/blast/regular/lockdown/door as anything in SSmachines.get_machinery_of_type(/obj/machinery/door/blast/regular/lockdown))
			door.autoclose = TRUE
			invoke_async(door, TYPE_PROC_REF(/obj/machinery/door/blast, delayed_close))

	return lockdown
