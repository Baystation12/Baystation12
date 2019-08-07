
/datum/npc_fleet

	var/obj/leader_ship

	var/list/ships_infleet = list()

/datum/npc_fleet/New(var/creator)
	. = ..()
	assign_leader(creator)

/datum/npc_fleet/proc/assign_leader(var/leader)
	leader_ship = leader
	ships_infleet |= leader
