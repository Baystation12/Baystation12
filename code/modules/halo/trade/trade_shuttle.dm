#define SHUTTLE_FLAGS_NONE 0
#define SHUTTLE_FLAGS_PROCESS 1
#define SHUTTLE_FLAGS_SUPPLY 2
#define SHUTTLE_FLAGS_TRADE 4
#define SHUTTLE_FLAGS_ALL (~SHUTTLE_FLAGS_NONE)

/datum/shuttle/autodock/ferry/trade
	name = "Trade Shuttle"
	category = /datum/shuttle/autodock/ferry/trade
	warmup_time = 0
	var/warmup_length = 5 SECONDS
	move_time = 0
	location = 0
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_TRADE
	var/datum/money_account/money_account
	var/list/all_exports = list()
	var/list/exports_formatted = list()
	var/list/export_credits = 0
	//
	var/list/requestlist = list()
	var/list/shoppinglist = list()
	//
	var/spawn_trader_type = /mob/living/simple_animal/npc/colonist/weapon_smuggler

/datum/shuttle/autodock/ferry/trade/proc/at_station()
	return (!location)

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/autodock/ferry/trade/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send forbidden atoms on the supply shuttle from centcom we don't care

	. = 0
	for(var/area/A in shuttle_area)
		for(var/atom/movable/AM in A)
			if(check_forbidden_atom(AM))
				return 1

/datum/shuttle/autodock/ferry/trade/proc/check_forbidden_atom(var/atom/A)
	if(istype(A,/mob/living))
		if(!istype(A,/mob/living/simple_animal))
			return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/trade/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/600,1))

/datum/shuttle/autodock/ferry/trade/proc/eta_seconds()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/10,1))

/datum/shuttle/autodock/ferry/trade/short_jump()

	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	warmup_time = world.time + warmup_length

/datum/shuttle/autodock/ferry/trade/process()
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
					shuttle_buy()

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
					//GLOB.innie_factions_controller.shuttle_sell(in_use)
					shuttle_sell()

#undef SHUTTLE_FLAGS_PROCESS