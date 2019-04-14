var/global/datum/npc_ship_map_handler/shipmap_handler = new

/datum/npc_ship_map_handler

	var/list/ship_map_zs = list()

	var/list/free_ship_map_zs = list()

	var/max_z_cached = 0

/datum/npc_ship_map_handler/New()
	. = ..()

/datum/npc_ship_map_handler/proc/free_map(var/z_to_free)
	if(z_to_free in free_ship_map_zs)
		return
	ship_map_zs -= z_to_free
	free_ship_map_zs += z_to_free
	clear_z(z_to_free)

/datum/npc_ship_map_handler/proc/clear_z(var/z_level)
	set background = 1
	if(isnull(z_level))
		return
	message_admins("Clearing unused ship-z level:[z_level]. This may lag.")
	sleep(10)//Ensure above message is shown.
	var/list/z_level_toclear = block(locate(1,1,z_level),locate(255,255,z_level))
	for(var/turf/to_clear in z_level_toclear)
		for(var/obj/obj_to_clear in to_clear.contents)
			obj_to_clear.loc = null
			GLOB.processing_objects -= obj_to_clear
			qdel(obj_to_clear)
		new /turf/space (to_clear)

/datum/npc_ship_map_handler/proc/un_free_map(var/z_to_un_free)
	if(z_to_un_free in free_ship_map_zs)
		free_ship_map_zs -= z_to_un_free
	ship_map_zs += z_to_un_free

/datum/npc_ship_map_handler/proc/get_next_usable_z()
	if(free_ship_map_zs.len > 0)
		return pick(free_ship_map_zs)
	else
		max_z_cached += 1
		return max_z_cached
