

/*
/proc/start_events()
	//changed to a while(1) loop since they are more efficient.
	//Moved the spawn in here to allow it to be called with advance proc call if it crashes.
	//and also to stop spawn copying variables from the game ticker
	spawn(3000)
		while(1)
			if(prob(50))//Every 120 seconds and prob 50 2-4 weak spacedusts will hit the station
				spawn(1)
					dust_swarm("weak")
			if(!event)
				//CARN: checks to see if random events are enabled.
				if(config.allow_random_events)
					if(prob(eventchance))
						event()
						hadevent = 1
					else
						Holiday_Random_Event()
			else
				event = 0
			sleep(1200)
*/
/*
/proc/event()
	event = 1

	var/eventNumbersToPickFrom = list(1,2,4,5,6,7,8,9,10,11,12,13,14, 15) //so ninjas don't cause "empty" events.

	if((world.time/10)>=3600 && toggle_space_ninja && !sent_ninja_to_station)//If an hour has passed, relatively speaking. Also, if ninjas are allowed to spawn and if there is not already a ninja for the round.
		eventNumbersToPickFrom += 3
	switch(pick(eventNumbersToPickFrom))
		if(1)
			command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player))
					M << sound('sound/AI/meteors.ogg')
			spawn(100)
				meteor_wave()
				spawn_meteors()
			spawn(700)
				meteor_wave()
				spawn_meteors()

		if(3)
			if((world.time/10)>=3600 && toggle_space_ninja && !sent_ninja_to_station)//If an hour has passed, relatively speaking. Also, if ninjas are allowed to spawn and if there is not already a ninja for the round.
				space_ninja_arrival()//Handled in space_ninja.dm. Doesn't announce arrival, all sneaky-like.
		if(4)
			mini_blob_event()

		if(5)
			high_radiation_event()
		if(6)
			viral_outbreak()
		if(7)
			alien_infestation()
		if(8)
			prison_break()
		if(9)
			carp_migration()
		if(10)
			immovablerod()
		if(11)
			lightsout(1,2)
		if(12)
			appendicitis()
		if(13)
			IonStorm()
		if(14)
			spacevine_infestation()
		if(15)
			communications_blackout()
*/

/proc/power_failure()
	command_alert("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure")
	for(var/mob/M in player_list)
		M << sound('sound/AI/poweroff.ogg')
	for(var/obj/machinery/power/smes/S in world)
		if(istype(get_area(S), /area/turret_protected) || S.z != 1)
			continue
		S.charge = 0
		S.output = 0
		S.online = 0
		S.updateicon()
		S.power_change()

	var/list/skipped_areas = list(/area/engine/engineering, /area/turret_protected/ai)

	for(var/area/A in world)
		if( !A.requires_power || A.always_unpowered )
			continue

		var/skip = 0
		for(var/area_type in skipped_areas)
			if(istype(A,area_type))
				skip = 1
				break
		if(A.contents)
			for(var/atom/AT in A.contents)
				if(AT.z != 1) //Only check one, it's enough.
					skip = 1
				break
		if(skip) continue
		A.power_light = 0
		A.power_equip = 0
		A.power_environ = 0
		A.power_change()

	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z == 1)
			var/area/A = get_area(C)

			var/skip = 0
			for(var/area_type in skipped_areas)
				if(istype(A,area_type))
					skip = 1
					break
			if(skip) continue

			C.cell.charge = 0

/proc/power_restore()

	command_alert("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal")
	for(var/mob/M in player_list)
		M << sound('sound/AI/poweron.ogg')
	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z == 1)
			C.cell.charge = C.cell.maxcharge
	for(var/obj/machinery/power/smes/S in world)
		if(S.z != 1)
			continue
		S.charge = S.capacity
		S.output = 200000
		S.online = 1
		S.updateicon()
		S.power_change()
	for(var/area/A in world)
		if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Chemical Lab Test Chamber" && A.name != "space" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
			A.power_light = 1
			A.power_equip = 1
			A.power_environ = 1
			A.power_change()

/proc/power_restore_quick()

	command_alert("All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal")
	for(var/mob/M in player_list)
		M << sound('sound/AI/poweron.ogg')
	for(var/obj/machinery/power/smes/S in world)
		if(S.z != 1)
			continue
		S.charge = S.capacity
		S.output = 200000
		S.online = 1
		S.updateicon()
		S.power_change()

