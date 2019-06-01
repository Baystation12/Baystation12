
/obj/effect/overmap/ship/faction_base //It's a /ship to ensure that it is attacked by overmap weapons like a ship would.
	vessel_mass = 999
	desc = "The base of a faction."
	icon = 'code/modules/halo/icons/overmap/faction_bases.dmi'
	faction = "faction_base" //This should be changed for each faction base overmap object.
	var/do_ship_relocates = 1
	var/spawn_defenses_amount = 4
	var/spawn_defenses_maxrange = 2
	var/list/ships_spawnnear = list() //Exact typepath of the ship
	var/obj/effect/overmap/ship/npc_ship/automated_defenses/defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses
	block_slipspace = 1

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

/obj/effect/overmap/ship/faction_base/process()
	. = ..()
	if(do_ship_relocates)
		do_ship_relocates = 0
		for(var/name in ships_spawnnear)
			var/obj/effect/overmap/om = locate(name)
			if(isnull(om))
				continue
			var/list/spawn_locs = list()
			for(var/turf/t in range(1,loc))
				spawn_locs += t
			om.forceMove(pick(spawn_locs))

/obj/effect/overmap/ship/faction_base/cov
	name = "Vanguard's Mantle"
	icon_state = "base_cov"
	faction = "Covenant"
	defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses/cov
	ships_spawnnear = list("SDV Vindictive Infraction","Kig-Yar Raider","Kig-Yar Missionary Vessel")
	base = 1

/obj/effect/overmap/ship/faction_base/unsc
	name = "Deviance Station"
	icon_state = "base_unsc"
	faction = "UNSC"
	defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses/unsc
	ships_spawnnear = list("UNSC Bertels","UNSC Heavens Above")
	base = 1

/obj/effect/overmap/ship/faction_base/innie
	name = "Camp New Hope"
	icon_state = "base_innie"
	faction = "Insurrection"
	defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses/innie
	ships_spawnnear = list("URFS Thorn","URFS Avarice")
	base = 1