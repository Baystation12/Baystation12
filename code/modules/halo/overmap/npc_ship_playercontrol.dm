//Clears an NPC ship's requests list and replaces it with a request that will cause the npc ship to do nothing besides sit still.
/obj/effect/overmap/ship/npc_ship/proc/make_player_controlled()
	for(var/datum/request in available_ship_requests)
		qdel(request)
	available_ship_requests.Cut()
	available_ship_requests = list(new /datum/npc_ship_request/player_controlled)
	load_mapfile()
	if(my_faction)
		my_faction.player_ships += src
		my_faction.npc_ships -= src
