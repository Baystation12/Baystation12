
/area/faction_base
	name = "Faction Base"
	has_gravity = 1
	power_environ = 1
	power_light = 1
	poweralm = 1
	requires_power = 0

/obj/effect/overmap/ship/faction_base //It's a /ship to ensure that it is attacked by overmap weapons like a ship would.
	vessel_mass = 999
	desc = "The base of a faction."
	icon = 'code/modules/halo/icons/overmap/faction_bases.dmi'
	faction = "faction_base" //This should be changed for each faction base overmap object.
	var/spawn_defenses_amount = 4
	var/spawn_defenses_maxrange = 2
	var/obj/effect/overmap/ship/npc_ship/automated_defenses/defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses
	block_slipspace = 1
	anchored = 1

/obj/effect/overmap/ship/faction_base/Initialize()
	. = ..()
	var/list/spawn_locs = list()
	for(var/turf/t in range(spawn_defenses_maxrange,loc))
		spawn_locs += t
	var/iter = 0
	for(iter = 0; iter <= spawn_defenses_amount;iter++)
		var/loc_spawnat = pick(spawn_locs)
		spawn_locs -= loc_spawnat
		var/obj/effect/overmap/spawned = new defense_type (loc_spawnat)
		spawned.faction = faction
