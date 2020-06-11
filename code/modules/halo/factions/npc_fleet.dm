
/datum/npc_fleet
	var/obj/effect/overmap/ship/leader_ship

	var/list/ships_infleet = list()
	var/datum/faction/my_faction

	var/atom/fleet_target

/datum/npc_fleet/proc/add_ships(var/list/new_ships)
	if(new_ships && new_ships.len)
		ships_infleet += new_ships

		for(var/obj/effect/overmap/ship/new_ship in new_ships)
			new_ship.our_fleet = src

		if(!leader_ship)
			pick_new_leader()

/datum/npc_fleet/proc/add_ship(var/obj/effect/overmap/ship/new_ship)
	ships_infleet += new_ship
	new_ship.our_fleet = src
	if(!leader_ship)
		pick_new_leader()

/datum/npc_fleet/proc/pick_new_leader()
	if(ships_infleet.len)
		leader_ship = locate() in ships_infleet
		return 1
	return 0

/datum/npc_fleet/proc/assign_leader(var/obj/effect/overmap/ship/new_leader)
	leader_ship = new_leader

/datum/npc_fleet/proc/assign_target(var/atom/new_target)
	fleet_target = new_target
