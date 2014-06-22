


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

//Escape pod garbage, copied from the controller
/*
							//pods
					start_location = locate(/area/shuttle/escape_pod1/station)
					end_location = locate(/area/shuttle/escape_pod1/transit)
					end_location = locate(/area/shuttle/escape_pod1/centcom)
					start_location.move_contents_to(end_location, null, NORTH)

				start_location = locate(/area/shuttle/escape_pod2/station)
				end_location = locate(/area/shuttle/escape_pod2/transit)
					end_location = locate(/area/shuttle/escape_pod2/centcom)
					start_location.move_contents_to(end_location, null, NORTH)

				start_location = locate(/area/shuttle/escape_pod3/station)
				end_location = locate(/area/shuttle/escape_pod3/transit)
					end_location = locate(/area/shuttle/escape_pod3/centcom)
					start_location.move_contents_to(end_location, null, NORTH)

				//There is no pod 4, apparently.
				
				start_location = locate(/area/shuttle/escape_pod5/station)
				end_location = locate(/area/shuttle/escape_pod5/transit)
					end_location = locate(/area/shuttle/escape_pod5/centcom)
					start_location.move_contents_to(end_location, null, EAST)


*/