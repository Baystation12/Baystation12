
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
	var/obj/item/fusion_fuel/held_fuel
	var/fuel_efficiency = 1000
	var/atmos_speed = 120000
	var/fake_launch = 0

	var/next_distance = 0
	var/next_name = ""
	var/current_name = ""

	waypoint_station = "geminus_innie_transport"
	waypoint_offsite = "offsite_innie_transport"
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

	shuttle_instance = locate() in world
	shuttle_instance.load_instance(instance_quest)

	//relocate the instance
	waypoint_offsite = locate("offsite_innie_transport")
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

/obj/machinery/shuttle_fuel
	name = "thruster fuel loader"
	desc = "An automated loading device for a fusion thruster to insert and remove deuterium fuel packets."
	icon = 'code/modules/halo/overmap/fusion_thruster.dmi'
	icon_state = "loader"
	anchored = 1
	var/obj/item/fusion_fuel/held_fuel
	var/datum/shuttle/autodock/ferry/geminus_innie_transport/my_shuttle

/obj/machinery/shuttle_fuel/New()
	. = ..()
	held_fuel = new(src)

/obj/machinery/shuttle_fuel/attack_hand(var/mob/user)
	if(isliving(user))
		if(held_fuel)
			src.visible_message("<span class='info'>[src] ejects it's spent [held_fuel].</span>")
			held_fuel.loc = src.loc
			held_fuel = null
			//icon_state = "nozzle0"
			if(my_shuttle)
				my_shuttle.held_fuel = null
		else
			to_chat(user, "<span class='notice'>[src] does not contain a deuterium fuel packet!</span>")

/obj/machinery/shuttle_fuel/attackby(var/obj/I, var/mob/user)
	if(isliving(user))
		if(istype(I, /obj/item/fusion_fuel))
			user.drop_item()
			I.loc = src
			held_fuel = I
			if(my_shuttle)
				my_shuttle.held_fuel = held_fuel
			//icon_state = "nozzle1"
			to_chat(user, "<span class='info'>You insert [I] into [src].</span>")
