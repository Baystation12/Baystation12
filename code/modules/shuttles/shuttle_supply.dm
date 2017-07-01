/datum/shuttle/autodock/ferry/supply
	var/away_location = 1	//the location to hide at while pretending to be in-transit
	var/late_chance = 80
	var/max_late_time = (30 SECONDS)
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	category = /datum/shuttle/autodock/ferry/supply

/datum/shuttle/autodock/ferry/supply/short_jump(var/area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if (at_station() && forbidden_atoms_check())
			//cancel the launch because of forbidden atoms. announce over supply channel?
			moving_status = SHUTTLE_IDLE
			return

		if (!at_station())	//at centcom
			supply_controller.buy()

		//We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
		var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(away_location)
		moving_status = SHUTTLE_INTRANSIT

		//If we are at the away_landmark then we are just pretending to move, otherwise actually do the move
		if (next_location == away_waypoint)
			attempt_move(away_waypoint)

		//wait ETA here.
		arrive_time = world.time + supply_controller.movetime
		while (world.time <= arrive_time)
			sleep(5)

		if (next_location != away_waypoint)
			//late
			if (prob(late_chance))
				sleep(rand(0,max_late_time))

			attempt_move(destination)

		moving_status = SHUTTLE_IDLE

		if (!at_station())	//at centcom
			supply_controller.sell()

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/autodock/ferry/supply/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send forbidden atoms on the supply shuttle from centcom we don't care

	return supply_controller.forbidden_atoms_check(shuttle_area)

/datum/shuttle/autodock/ferry/supply/proc/at_station()
	return (!location)

//returns 1 if the shuttle is idle and we can still mess with the cargo shopping list
/datum/shuttle/autodock/ferry/supply/proc/idle()
	return (moving_status == SHUTTLE_IDLE)

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/supply/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/600,1))

/datum/shuttle/autodock/ferry/supply/proc/eta_seconds()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/10,1))
