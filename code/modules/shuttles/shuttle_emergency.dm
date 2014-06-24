

/datum/shuttle/ferry/emergency
	var/jump_time = null	//the time at which the shuttle last jumped. Used for ETAs

/datum/shuttle/ferry/emergency/arrived()
	emergency_shuttle.shuttle_arrived()

/datum/shuttle/ferry/emergency/move(var/area/origin,var/area/destination)
	if (destination == area_transition)
		jump_time = world.time
	else
		jump_time = null
	
	if (!location)	//leaving the station
		emergency_shuttle.departed = 1
		captain_announce("The Emergency Shuttle has left the station. Estimate [round(emergency_shuttle.estimate_arrival_time()/60,1)] minutes until the shuttle docks at Central Command.")
	..(origin, destination)


/datum/shuttle/ferry/escape_pod
	//pass

/datum/shuttle/ferry/escape_pod/can_launch()
	if(location)
		return 0	//it's a one-way trip.
	return ..()

/datum/shuttle/ferry/escape_pod/can_force()
	return 0

/datum/shuttle/ferry/escape_pod/can_cancel()
	return 0

//TODO replace this with proper door controllers
/datum/shuttle/ferry/escape_pod/move(var/area/origin,var/area/destination)
	for(var/obj/machinery/door/D in origin)
		spawn(0)
			D.close()
	
	..(origin, destination)
	
	for(var/obj/machinery/door/D in destination)
		spawn(0)
			D.open()