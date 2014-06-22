


/datum/shuttle/ferry/emergency
	//pass

/datum/shuttle/ferry/emergency/arrived()
	emergency_shuttle.shuttle_arrived()

/*
/datum/shuttle/ferry/emergency/move()
	if (!location)	//leaving the station
		emergency_shuttle.departed = 1
	..()
*/

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
	
	..(origin, destination)	//might need to adjust shuttle/move so that it can take into account the direction argument to area/move_contents_to, I dunno.
	
	for(var/obj/machinery/door/D in destination)
		spawn(0)
			D.open()