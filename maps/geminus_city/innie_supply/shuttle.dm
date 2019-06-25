
/datum/shuttle/autodock/ferry/geminus_innie
	name = "Geminus Innie Supply Shuttle"
	shuttle_area = /area/shuttle/innie_shuttle
	//dock_target = "innie_shuttle"
	warmup_time = 0
	var/warmup_length = 5 SECONDS
	move_time = 0
	location = 0
	flags = SHUTTLE_FLAGS_PROCESS

	//category = /datum/shuttle/autodock/ferry/geminus_innie

	waypoint_station = "geminus_innie_supply"
	waypoint_offsite = "offsite_innie_supply"

/datum/shuttle/autodock/ferry/geminus_innie/New()
	. = ..()
	GLOB.innie_factions_controller.geminus_supply_shuttle = src

/datum/shuttle/autodock/ferry/geminus_innie/proc/at_station()
	return (!location)

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/autodock/ferry/geminus_innie/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send forbidden atoms on the supply shuttle from centcom we don't care

	for(var/area/A in shuttle_area)
		if(GLOB.innie_factions_controller.forbidden_atoms_check(A))
			return 1

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/geminus_innie/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/600,1))

/datum/shuttle/autodock/ferry/geminus_innie/proc/eta_seconds()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/10,1))

/datum/shuttle/autodock/ferry/geminus_innie/short_jump()

	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	warmup_time = world.time + warmup_length

/datum/shuttle/autodock/ferry/geminus_innie/process()
	. = ..()
	switch(moving_status)
		if(SHUTTLE_IDLE)

		if(SHUTTLE_WARMUP)
			if(world.time >= warmup_time)
				if (at_station() && forbidden_atoms_check())
					//cancel the launch because of forbidden atoms. announce over supply channel?
					moving_status = SHUTTLE_IDLE
					return

				if (!at_station())	//at centcom
					GLOB.innie_factions_controller.shuttle_buy()

				//We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
				var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(1)
				moving_status = SHUTTLE_INTRANSIT

				//If we are at the away_landmark then we are just pretending to move, otherwise actually do the move
				if (next_location == away_waypoint)
					attempt_move(away_waypoint)

				//wait ETA here.
				arrive_time = world.time + move_time

		if(SHUTTLE_INTRANSIT)
			if(world.time >= arrive_time)

				var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(1)
				if (next_location != away_waypoint)
					//late
					/*if (prob(late_chance))
						sleep(rand(0,max_late_time))*/

					attempt_move(next_location)

				moving_status = SHUTTLE_IDLE

				if (!at_station())	//at centcom
					GLOB.innie_factions_controller.shuttle_sell(in_use)
