
/obj/effect/overmap/ship/faction_base //It's a /ship to ensure that it is attacked by overmap weapons like a ship would.
	vessel_mass = 999
	faction = "faction_base" //This should be changed for each faction base overmap object.
	var/spawn_defenses_amount = 4
	var/spawn_defenses_maxrange = 1
	var/obj/effect/overmap/ship/npc_ship/automated_defenses/defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses

/obj/effect/overmap/ship/faction_base/Initialize()
	. = ..()
	var/list/spawn_locs = range(spawn_defenses_maxrange,src)
	var/iter = 0
	for(iter = 0; iter <= spawn_defenses_amount;iter++)
		var/loc_spawnat = pick(spawn_locs)
		spawn_locs -= loc_spawnat
		var/obj/effect/overmap/spawned = new defense_type (loc_spawnat)
		spawned.faction = faction