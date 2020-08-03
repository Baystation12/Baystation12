
#define FLEET_BASE_AMOUNT 5
#define FLEET_SCALING_AMOUNT 1
#define FLEET_PERFACTION_MAXSIZE 30

/datum/faction
	var/fleet_spawn_at = 0
	var/fleet_delay_min = 90 MINUTES
	var/fleet_delay_max = 90 MINUTES
	var/fleets_max = 0
	var/list/npc_fleets = list()
/*
/datum/faction/proc/fleet_destroyed(var/datum/npc_fleet)
	//let empty fleets exist tracked for now to handle difficulty scaling
	GLOB.processing_objects -= npc_fleet
	//npc_fleets -= npc_fleet)
	//qdel(npc_fleet)
*/
/datum/faction/proc/announce_fleet(var/datum/npc_fleet/new_fleet)
	var/obj/effect/overmap/ship/npc_ship/scout = new_fleet.ships_infleet[1]
	scout.radio_message("Slipspace manouver complete. Fleet reporting in at [scout.x],[scout.y].")

/datum/faction/unsc/announce_fleet(var/datum/npc_fleet/new_fleet)
	for(var/z = 1,z<=world.maxz,z++)
		playsound(locate(1,1,z), 'code/modules/halo/sounds/OneProblemAtATime.ogg', 50, 0,0,0,1)

	var/fleetname = pick("1st","2nd","3rd","4th","5th","6th","7th","8th","9th")
	GLOB.UNSC.AnnounceCommand("Reinforcements from the [fleetname] Fleet have arrived in the system. Hold out for just a little longer, marines.")
	GLOB.COVENANT.AnnounceCommand("An overwhelming human fleet has jumped insystem. Survival is not guaranteed.")

	//unlock some new job slots after a short delay
	spawn(30)
		GLOB.UNSC.unlock_special_job()
		GLOB.COVENANT.unlock_special_job()

	. = ..()

/datum/faction/proc/set_endless_fleets()
	fleets_max = -1
	fleet_spawn_at = world.time + rand(fleet_delay_min, fleet_delay_max)
	start_processing()

/datum/faction/proc/fleet_find_target(var/datum/npc_fleet/new_fleet)
	for(var/enemy in src.enemy_faction_names)
		var/datum/faction/f_enemy = GLOB.factions_by_name[enemy]
		var/list/targets = list()
		if(f_enemy)
			//valid enemy targets
			targets += f_enemy.npc_ships
			if(f_enemy.flagship)
				targets |= f_enemy.flagship
			if(f_enemy.base)
				targets |= f_enemy.base

			//Fallback, go on the defensive.
			if(!targets.len)
				targets += src.flagship
				targets += src.base

			//not a valid enemy faction
			if(!targets.len)
				continue

			//send in the fleet
			new_fleet.assign_target(pick(targets))
			break


/datum/faction/proc/handle_fleet()
	. = 0

	if(fleet_spawn_at > 0)
		. = 1

		if(world.time >= fleet_spawn_at)
			if(npc_fleets.len < fleets_max || fleets_max < 0)
				fleet_spawn_at = world.time + rand(fleet_delay_min, fleet_delay_max)

			//how many ships should spawn?
			var/num_spawn = FLEET_BASE_AMOUNT + (FLEET_SCALING_AMOUNT * npc_fleets.len)
			var/available = max(FLEET_PERFACTION_MAXSIZE - npc_ships.len, 0)
			if(num_spawn > available)
				num_spawn = available

			if(!num_spawn)
				return

			spawn_fleet(num_spawn)

/datum/faction/proc/spawn_fleet(var/num_spawn = FLEET_BASE_AMOUNT)

		//create the fleet
		var/datum/npc_fleet/new_fleet = new
		npc_fleets.Add(new_fleet)

		//spawn the ships in the fleet
		var/list/spawned_ships = shipmap_handler.spawn_ship(src, num_spawn, overpowered = 1)
		new_fleet.add_ships(spawned_ships)

		//give the fleet it's first objective objective
		fleet_find_target(new_fleet)

		//tell the players what is happening
		announce_fleet(new_fleet)

		/*
		var/fleet_size = FLEET_BASE_AMOUNT
		faction_fleet += spawned_ships
		for(var/s in spawned_ships) //Reset our spawned ships to nullspace, so they don't immediately just jump there.
			var/obj/ship = s
			ship.forceMove(null)
		if(faction_fleet.len > FLEET_BASE_AMOUNT)
			fleet_size = faction_fleet.len/2
		for(var/s in faction_fleet)
			if(isnull(s))
				faction_fleet -= s
				continue
			var/obj/effect/overmap/ship/npc_ship/combat/ship = s
			if(ship.our_fleet)
				var/obj/effect/overmap/ship/lead = ship.our_fleet.leader_ship
				var/obj/effect/overmap/ship/npc_ship/lead_npc = lead
				if((istype(lead) && (lead.flagship || lead.base)) || (lead_npc && lead_npc.is_player_controlled()))
					continue

			if(ship.hull <= initial(ship.hull)/4)
				ship.lose_to_space()
				faction_fleet -= ship
				continue
			if(ship.hull == initial(ship.hull))
				continue

			ship.last_radio_time = 0
			if(ship.loc != null)
				ship.radio_message("I'm pulling out to regroup.")
				ship.last_radio_time = 0
				ship.slipspace_to_nullspace(1)
				ship.hull = initial(ship.hull)
				var/datum/npc_fleet/curr_fleet = ship.our_fleet
				if(curr_fleet.leader_ship == ship)
					if(curr_fleet.ships_infleet.len > 1)
						curr_fleet.ships_infleet -= ship
				sleep(2) //wait a little here, so there's less radio spam from all ships pulling out at the same time.
			//Ones that jumped to slipspace will now be nullspace'd, so we need to do this to include them.
			if(ship.loc == null)
				if(new_fleet.ships_infleet.len >= fleet_size)
					new_fleet = new

				if(isnull(new_fleet.leader_ship))
					new_fleet.assign_leader(ship)
				else
					new_fleet.add_tofleet(ship)

				if(new_fleet.leader_ship == ship)
					var/list/targets = list()
					for(var/enemy in F.enemy_faction_names)
						var/datum/faction/f_enemy = GLOB.factions_by_name[enemy]
						if(f_enemy && f_enemy in factions)
							targets += f_enemy.npc_ships
							if(f_enemy.flagship)
								targets += f_enemy.flagship
							if(f_enemy.base)
								targets += f_enemy.base
						if(targets.len == 0) //Fallback, go on the defensive.
							targets += F.flagship
							targets += F.base
						ship.slipspace_to_location(pick(trange(7,pick(targets))))
						ship.radio_message("Slipspace manouver complete. Fleet leader reporting at [ship.loc.x],[ship.loc.y].")

					if(targets.len == 0)
						message_admins("An NPC ship tried to spawn without hostile factions, causing it to have no place to spawn, Report this.")
						break

				else
					var/obj/effect/overmap/ship/npc_ship/leader_ship = new_fleet.leader_ship
					ship.target_loc = leader_ship.target_loc
					ship.slipspace_to_location(leader_ship.loc)
					if(!isnull(ship.loc))
						ship.radio_message("Slipspace manouver successful. Redevouz'd with leader at [ship.loc.x],[ship.loc.y].")
				for(var/z = 1,z<=world.maxz,z++)
					playsound(locate(1,1,z), 'code/modules/halo/sounds/slip_rupture_detected.ogg', 50, 0,0,0,1)

				sleep(5)
				*/

#undef FLEET_PERFACTION_MAXSIZE
#undef FLEET_SCALING_AMOUNT