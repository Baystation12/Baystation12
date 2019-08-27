
/datum/shuttle/autodock/ferry/geminus_innie_transport
	name = "Rabbit Hole Base Transport Shuttle"
	shuttle_area = /area/shuttle/innie_shuttle_transport
	warmup_time = 0.5 SECOND
	move_time = 0
	location = 0
	flags = SHUTTLE_FLAGS_PROCESS

	var/fuel_left = 100
	var/fuel_max = 100
	var/fuel_efficiency = 1000
	var/atmos_speed = 120000
	var/fake_launch = 0

	waypoint_station = "geminus_innie_transport"
	waypoint_offsite = "offsite_innie_transport"

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/geminus_innie_transport/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/600,1))

/datum/shuttle/autodock/ferry/geminus_innie_transport/proc/eta_seconds()
	var/ticksleft = arrive_time - world.time
	return max(0, round(ticksleft/10,1))

/datum/shuttle/autodock/ferry/geminus_innie_transport/proc/fake_launch(var/user)
	fake_launch = 1
	launch(user)

/datum/shuttle/autodock/ferry/geminus_innie_transport/attempt_move(var/obj/effect/shuttle_landmark/destination)

	next_location.load_quest_instance(next_location.quest)
	if(fake_launch)
		testing("[src] moving to [destination]. This move is a fake launch.")
		for(var/area/A in shuttle_area)
			for(var/mob/M in A)
				if(M.client)
					spawn(0)
						if(M.buckled)
							to_chat(M, "<span class='warning'>Sudden acceleration presses you into your chair!</span>")
							shake_camera(M, 3, 1)
						else
							to_chat(M, "<span class='warning'>The floor lurches beneath you!</span>")
							shake_camera(M, 10, 1)
				if(istype(M, /mob/living/carbon))
					if(!M.buckled)
						M.Weaken(3)
		fake_launch = 0

		return TRUE
	else
		return ..()
