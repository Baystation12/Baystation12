var/global/datum/npc_ship_map_handler/shipmap_handler = new

#define ROUNDSTART_COMBAT_SHIPS 9
#define ROUNDSTART_CIVVIE_SHIPS 3
#define ROUNDSTART_FLOOD_SHIP_CHANCE 10
#define ROUNDSTART_FLOOD_SHIP_NUM 2
#define COMBAT_SHIPS_UNSC list(/obj/effect/overmap/ship/npc_ship/combat/unsc/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/unsc/heavily_armed)
#define COMBAT_SHIPS_INNIE list(/obj/effect/overmap/ship/npc_ship/combat/innie/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/innie/heavily_armed)
#define COMBAT_SHIPS_COVIE list(/obj/effect/overmap/ship/npc_ship/combat/covenant/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/covenant/heavily_armed)

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
		world.maxz = max_z_cached
		return max_z_cached

/datum/npc_ship_map_handler/proc/spawn_roundstart_ships()
	if(prob(ROUNDSTART_FLOOD_SHIP_CHANCE))
		for(var/i = 0,i < ROUNDSTART_FLOOD_SHIP_NUM,i++)
			var/spawn_loc = pick(GLOB.overmap_tiles_uncontrolled)
			new /obj/effect/overmap/ship/npc_ship/combat/flood (spawn_loc)
	for(var/i = 0, i <ROUNDSTART_CIVVIE_SHIPS,i++)
		var/spawn_loc = pick(GLOB.overmap_tiles_uncontrolled)
		new /obj/effect/overmap/ship/npc_ship (spawn_loc)

	for(var/i = 0, i <ROUNDSTART_COMBAT_SHIPS,i++)
		var/spawn_loc = pick(GLOB.overmap_tiles_uncontrolled)
		var/list/pickfrom = COMBAT_SHIPS_UNSC
		if(i > ROUNDSTART_COMBAT_SHIPS/3)
			pickfrom = COMBAT_SHIPS_INNIE
		if(i > (ROUNDSTART_COMBAT_SHIPS/3)*2)
			pickfrom = COMBAT_SHIPS_COVIE
		var/picked_type = pick(pickfrom)
		new  picked_type (spawn_loc)

