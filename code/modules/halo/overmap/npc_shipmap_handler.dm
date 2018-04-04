var/datum/npc_ship_map_handler/shipmap_handler = new

/datum/npc_ship_map_handler

	var/list/ship_map_zs = list()

	var/list/free_ship_map_zs = list()

/datum/npc_ship_map_handler/proc/free_map(var/z_to_free)
	ship_map_zs -= z_to_free
	free_ship_map_zs += z_to_free

/datum/npc_ship_map_handler/proc/un_free_map(var/z_to_un_free)
	if(z_to_un_free in free_ship_map_zs)
		free_ship_map_zs -= z_to_un_free
	ship_map_zs += z_to_un_free

/datum/npc_ship_map_handler/proc/get_next_usable_z()
	if(free_ship_map_zs.len > 0)
		return pick(free_ship_map_zs)
	else
		return world.maxz + 1
