var/global/datum/npc_ship_map_handler/shipmap_handler = new

/datum/npc_ship_map_handler

	var/list/ship_map_zs = list()

	var/list/free_ship_map_zs = list()

/datum/npc_ship_map_handler/proc/free_map(var/z_to_free)
	if(z_to_free in free_ship_map_zs)
		return
	ship_map_zs -= z_to_free
	free_ship_map_zs += z_to_free
	clear_z(z_to_free)

/datum/npc_ship_map_handler/proc/clear_z(var/z_level)
	if(isnull(z_level))
		return
	to_world("Clearing unused ship-z level:[z_level]. This may lag.")
	sleep(10)//Ensure above message is shown.
	var/list/z_level_toclear = block(locate(1,1,z_level),locate(255,255,z_level))
	for(var/to_clear in z_level_toclear)
		var/turf/t = to_clear
		if(istype(t))
			new /turf/space (t)
		else
			var/obj/to_clear_obj = to_clear
			if(istype(to_clear_obj))
				to_clear_obj.loc = null
			GLOB.processing_objects -= to_clear
			qdel(to_clear)

/datum/npc_ship_map_handler/proc/un_free_map(var/z_to_un_free)
	if(z_to_un_free in free_ship_map_zs)
		free_ship_map_zs -= z_to_un_free
	ship_map_zs += z_to_un_free

/datum/npc_ship_map_handler/proc/get_next_usable_z()
	if(free_ship_map_zs.len > 0)
		return pick(free_ship_map_zs)
	else
		return world.maxz + 1
