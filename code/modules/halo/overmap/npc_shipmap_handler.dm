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
	spawn(-1)
		for(var/n_x = 1 to 255)
			for(var/n_y = 1 to 255)
				var/turf/to_remove = locate(n_x,n_y,z_level)
				for(var/atom/A in to_remove.contents)
					qdel(A)
				new /turf/space (to_remove)

/datum/npc_ship_map_handler/proc/un_free_map(var/z_to_un_free)
	if(z_to_un_free in free_ship_map_zs)
		free_ship_map_zs -= z_to_un_free
	ship_map_zs += z_to_un_free

/datum/npc_ship_map_handler/proc/get_next_usable_z()
	if(free_ship_map_zs.len > 0)
		return pick(free_ship_map_zs)
	else
		return world.maxz + 1
