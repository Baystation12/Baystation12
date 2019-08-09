
/datum/npc_fleet

	var/obj/leader_ship

	var/list/ships_infleet = list()

/datum/npc_fleet/New(var/creator)
	. = ..()
	assign_leader(creator)

/datum/npc_fleet/proc/clear_target_locs()
	for(var/obj/effect/overmap/ship/npc_ship/ship in ships_infleet)
		ship.target_loc = ship.loc

/datum/npc_fleet/proc/add_tofleet(var/obj/effect/overmap/ship/add_to)
	ships_infleet |= add_to
	if(add_to.our_fleet.ships_infleet.len == 1 && leader_ship == add_to)
		var/fleet_holder = add_to.our_fleet
		add_to.our_fleet = null
		qdel(fleet_holder)
	add_to.our_fleet = src
	clear_target_locs()

/datum/npc_fleet/proc/assign_leader(var/leader)
	leader_ship = leader
	ships_infleet |= leader
	clear_target_locs()
