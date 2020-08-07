
/obj/machinery/slipspace_engine/proc/do_jump()
	next_jump_at = world.time + SLIPSPACE_ENGINE_JUMP_COOLDOWN
	stop_charging(TRUE)

	//clear out any ships following us
	linked_ships = list()

	/*
	//bring along any ships following us
	for(var/obj/effect/overmap/om in linked_ships + om_obj)
		if(isnull(overmap_jump_target))
			om.slipspace_to_nullspace(slipspace_target_status,jump_sound)
		else
			if(om.overmap_jump_target != null)
				linked_ships -= om
				continue
			om.slipspace_to_location(overmap_jump_target,slipspace_target_status,jump_sound)
			*/

	//apply a visual effect
	var/obj/effect/overmap/ship/ship = om_obj
	if(istype(ship))
		visible_message("<span class = 'notice'>[src] momentarily glows bright, then activates!</span>")

		//hard brake the ship to avoid visual bugs with the slipspace effect
		ship.speed = list(0,0)

		//play a sound effect
		play_jump_sound(ship.loc, jump_sound)

		if(overmap_jump_target)
			//play sound effect at our destination
			play_jump_sound(overmap_jump_target, jump_sound, TRUE)

			//create an exist visual effect
			new /obj/effect/slipspace_rupture(overmap_jump_target)
		else
			ship.slipspace_status = SLIPSPACE_OUTSYSTEM

		//dont block here, we're going to do some time sensitive stuff
		spawn(0)

			//where is our move path start?
			var/headingdir = angle2dir(ship.get_heading())
			if(!headingdir)
				headingdir = ship.dir
			var/turf/T = ship.loc
			for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
				var/turf/new_T = get_step(T,headingdir)
				if(new_T)
					T = new_T
				else
					break

			//create an entry visual effect
			new /obj/effect/slipspace_rupture(T)

			//rapidly move into the portal
			for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
				var/turf/new_T = get_step(ship.loc,headingdir)
				if(new_T)
					ship.loc = new_T
				else
					break
				sleep(1)

			//teleport the ship
			ship.loc = overmap_jump_target

			//are we going an existing turf aka somewhere in the system?
			if(overmap_jump_target)
				//rapidly move out of the portal
				for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
					var/turf/new_T = get_step(ship.loc,headingdir)
					if(new_T)
						ship.loc = new_T
					else
						break
					sleep(1)

	//tell the gamemode handler
	if(jump_type == SLIPSPACE_LONG && ticker.mode)
		ticker.mode.handle_slipspace_jump(om_obj)
