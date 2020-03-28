
/datum/npc_fleet

	var/obj/leader_ship

	var/list/ships_infleet = list()

/datum/npc_fleet/New(var/creator)
	. = ..()
	if(creator)
		assign_leader(creator)
	GLOB.processing_objects += src

/datum/npc_fleet/Destroy()
	GLOB.processing_objects -= src
	. = ..()

/datum/npc_fleet/proc/clear_target_locs()
	for(var/obj/effect/overmap/ship/npc_ship/ship in ships_infleet)
		ship.target_loc = ship.loc

/datum/npc_fleet/proc/add_tofleet(var/obj/effect/overmap/ship/add_to)
	ships_infleet |= add_to
	add_to.our_fleet = src
	clear_target_locs()

/datum/npc_fleet/proc/assign_leader(var/obj/effect/overmap/ship/leader)
	leader_ship = leader
	if(istype(leader))
		leader.our_fleet = src
	add_tofleet(leader)
	clear_target_locs()

/datum/npc_fleet/proc/process()
	for(var/entry in ships_infleet)
		if(isnull(entry))
			ships_infleet -= entry
	if(isnull(leader_ship) && ships_infleet.len > 0)
		assign_leader(pick(ships_infleet))