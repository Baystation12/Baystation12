
/datum/shuttle/autodock/ferry/geminus_innie_transport
	name = "Rabbit Hole Base Transport Shuttle"
	shuttle_area = /area/shuttle/innie_shuttle_transport
	warmup_time = 0.5 SECOND
	move_time = 0
	location = 0
	flags = SHUTTLE_FLAGS_PROCESS

	/*
	var/fuel_left = 100
	var/fuel_max = 100
	*/
	var/fuel_efficiency = 10
	var/atmos_speed = 120000
	var/fake_launch = 0

	var/next_distance = 0
	var/next_name = ""
	var/current_name = ""

	waypoint_station = "innie_berth_transport"
	waypoint_offsite = "offsite_berth_transport"
	var/obj/effect/shuttle_instance/shuttle_instance
	var/datum/npc_quest/instance_quest

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

	//load the quest instance... if we arent in it
	if(get_location_waypoint(location) != waypoint_offsite)
		shuttle_instance = locate() in world
		shuttle_instance.load_instance(instance_quest)

	//relocate the instance
	waypoint_offsite = locate(initial(waypoint_offsite))
	next_location = get_location_waypoint(!location)
	destination = next_location

	if(fake_launch)
		/*
		//unused for now
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
		*/

		return TRUE

	return ..(next_location)

/*
/datum/shuttle/autodock/ferry/geminus_innie_transport/process_launch()
	if(next_location.name != "Rabbit Hole Base")
		next_location.load_quest_instance(next_location.quest)

	. = ..()
*/
/datum/shuttle/autodock/ferry/geminus_innie_transport/process_arrived()
	. = ..()

	current_name = next_name
	if(current_name == "Rabbit Hole Base")
		next_name = null
		next_distance =  0
	else
		next_name = "Rabbit Hole Base"

/datum/shuttle/autodock/ferry/geminus_innie_transport/proc/get_fuel()
	if(held_fuel)
		return held_fuel.fuel_left
	return 0

/datum/shuttle/autodock/ferry/geminus_innie_transport/proc/use_fuel(var/fuel_used)
	if(held_fuel)
		held_fuel.fuel_left -= fuel_used
		held_fuel.fuel_left = max(held_fuel.fuel_left, 0)
