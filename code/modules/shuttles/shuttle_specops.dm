/obj/machinery/computer/shuttle_control/specops
	name = "special operations shuttle console"
	shuttle_tag = "Special Operations"
	req_access = list(access_cent_specops)

/obj/machinery/computer/shuttle_control/specops/attack_ai(user as mob)
	to_chat(user, "<span class='warning'>Access Denied.</span>")
	return 1

//for shuttles that may use a different docking port at each location
/datum/shuttle/ferry/multidock
	var/docking_controller_tag_station
	var/docking_controller_tag_offsite
	var/datum/computer/file/embedded_program/docking/docking_controller_station
	var/datum/computer/file/embedded_program/docking/docking_controller_offsite
	category = /datum/shuttle/ferry/multidock

/datum/shuttle/ferry/multidock/init_docking_controllers()
	if(docking_controller_tag_station)
		docking_controller_station = locate(docking_controller_tag_station)
		if(!istype(docking_controller_station))
			warning("Shuttle with docking tag [docking_controller_station] could not find it's controller!")
	if(docking_controller_tag_offsite)
		docking_controller_offsite = locate(docking_controller_tag_offsite)
		if(!istype(docking_controller_offsite))
			warning("Shuttle with docking tag [docking_controller_offsite] could not find it's controller!")
	if (!location)
		docking_controller = docking_controller_station
	else
		docking_controller = docking_controller_offsite

/datum/shuttle/ferry/multidock/move(var/area/origin,var/area/destination)
	..(origin, destination)
	if (!location)
		docking_controller = docking_controller_station
	else
		docking_controller = docking_controller_offsite

/datum/shuttle/ferry/multidock/specops
	var/specops_return_delay = 6000		//After moving, the amount of time that must pass before the shuttle may move again
	var/specops_countdown_time = 600	//Length of the countdown when moving the shuttle

	var/obj/item/device/radio/intercom/announcer = null
	var/reset_time = 0	//the world.time at which the shuttle will be ready to move again.
	var/launch_prep = 0
	var/cancel_countdown = 0
	category = /datum/shuttle/ferry/multidock/specops

/datum/shuttle/ferry/multidock/specops/New()
	..()
	announcer = new /obj/item/device/radio/intercom(null)//We need a fake AI to announce some stuff below. Otherwise it will be wonky.
	announcer.config(list("Response Team" = 0))

/datum/shuttle/ferry/multidock/specops/proc/radio_announce(var/message)
	if(announcer)
		announcer.autosay(message, "A.L.I.C.E.", "Response Team")


/datum/shuttle/ferry/multidock/specops/launch(var/user)
	if (!can_launch())
		return

	if (istype(user, /obj/machinery/computer))
		var/obj/machinery/computer/C = user

		if(world.time <= reset_time)
			C.visible_message("<span class='notice'>[using_map.boss_name] will not allow the Special Operations shuttle to launch yet.</span>")
			if (((world.time - reset_time)/10) > 60)
				C.visible_message("<span class='notice'>[-((world.time - reset_time)/10)/60] minutes remain!</span>")
			else
				C.visible_message("<span class='notice'>[-(world.time - reset_time)/10] seconds remain!</span>")
			return

		C.visible_message("<span class='notice'>The Special Operations shuttle will depart in [(specops_countdown_time/10)] seconds.</span>")

	if (location)	//returning
		radio_announce("THE SPECIAL OPERATIONS SHUTTLE IS PREPARING TO RETURN")
	else
		radio_announce("THE SPECIAL OPERATIONS SHUTTLE IS PREPARING FOR LAUNCH")

	sleep_until_launch()

	if (location)
		var/obj/machinery/light/small/readylight/light = locate() in get_location_area()
		if(light) light.set_state(0)

	//launch
	radio_announce("ALERT: INITIATING LAUNCH SEQUENCE")
	..(user)

/datum/shuttle/ferry/multidock/specops/move(var/area/origin,var/area/destination)
	..(origin, destination)

	spawn(20)
		if (!location)	//just arrived home
			for(var/turf/T in get_area_turfs(destination))
				var/mob/M = locate(/mob) in T
				to_chat(M, "<span class='danger'>You have arrived at [using_map.boss_name]. Operation has ended!</span>")
		else	//just left for the station
			launch_mauraders()
			for(var/turf/T in get_area_turfs(destination))
				var/mob/M = locate(/mob) in T
				to_chat(M, "<span class='danger'>You have arrived at [using_map.station_name]. Commence operation!</span>")

				var/obj/machinery/light/small/readylight/light = locate() in T
				if(light) light.set_state(1)

/datum/shuttle/ferry/multidock/specops/cancel_launch()
	if (!can_cancel())
		return

	cancel_countdown = 1
	radio_announce("ALERT: LAUNCH SEQUENCE ABORTED")
	if (istype(in_use, /obj/machinery/computer))
		var/obj/machinery/computer/C = in_use
		C.visible_message("<span class='warning'>Launch sequence aborted.</span>")
	..()



/datum/shuttle/ferry/multidock/specops/can_launch()
	if(launch_prep)
		return 0
	return ..()

//should be fine to allow forcing. process_state only becomes WAIT_LAUNCH after the countdown is over.
///datum/shuttle/ferry/multidock/specops/can_force()
//	return 0

/datum/shuttle/ferry/multidock/specops/can_cancel()
	if(launch_prep)
		return 1
	return ..()

/datum/shuttle/ferry/multidock/specops/proc/sleep_until_launch()
	var/message_tracker[] = list(0,1,2,3,5,10,30,45)//Create a a list with potential time values.

	var/launch_time = world.time + specops_countdown_time
	var/time_until_launch

	cancel_countdown = 0
	launch_prep = 1
	while(!cancel_countdown && (launch_time - world.time) > 0)
		var/ticksleft = launch_time - world.time

		//if(ticksleft > 1e5)
		//	launch_time = world.timeofday + 10	// midnight rollover
		time_until_launch = (ticksleft / 10)

		//All this does is announce the time before launch.
		var/rounded_time_left = round(time_until_launch)//Round time so that it will report only once, not in fractions.
		if(rounded_time_left in message_tracker)//If that time is in the list for message announce.
			radio_announce("ALERT: [rounded_time_left] SECOND[(rounded_time_left!=1)?"S":""] REMAIN")
			message_tracker -= rounded_time_left//Remove the number from the list so it won't be called again next cycle.
			//Should call all the numbers but lag could mean some issues. Oh well. Not much I can do about that.

		sleep(5)

	launch_prep = 0


/proc/launch_mauraders()
	var/area/centcom/specops/special_ops = locate()//Where is the specops area located?
	//Begin Marauder launchpad.
	spawn(0)//So it parallel processes it.
		for(var/obj/machinery/door/blast/M in special_ops)
			switch(M.id)
				if("ASSAULT0")
					spawn(10)//1 second delay between each.
						M.open()
				if("ASSAULT1")
					spawn(20)
						M.open()
				if("ASSAULT2")
					spawn(30)
						M.open()
				if("ASSAULT3")
					spawn(40)
						M.open()

		sleep(10)

		var/spawn_marauder[] = new()
		for(var/obj/effect/landmark/L in world)
			if(L.name == "Marauder Entry")
				spawn_marauder.Add(L)
		for(var/obj/effect/landmark/L in world)
			if(L.name == "Marauder Exit")
				var/obj/effect/portal/P = new(L.loc)
				P.invisibility = 101//So it is not seen by anyone.
				P.failchance = 0//So it has no fail chance when teleporting.
				P.target = pick(spawn_marauder)//Where the marauder will arrive.
				spawn_marauder.Remove(P.target)

		sleep(10)

		for(var/obj/machinery/mass_driver/M in special_ops)
			switch(M.id)
				if("ASSAULT0")
					spawn(10)
						M.drive()
				if("ASSAULT1")
					spawn(20)
						M.drive()
				if("ASSAULT2")
					spawn(30)
						M.drive()
				if("ASSAULT3")
					spawn(40)
						M.drive()

		sleep(50)//Doors remain open for 5 seconds.

		for(var/obj/machinery/door/blast/M in special_ops)
			switch(M.id)//Doors close at the same time.
				if("ASSAULT0")
					spawn(0)
						M.close()
				if("ASSAULT1")
					spawn(0)
						M.close()
				if("ASSAULT2")
					spawn(0)
						M.close()
				if("ASSAULT3")
					spawn(0)
						M.close()
		special_ops.readyreset()//Reset firealarm after the team launched.
	//End Marauder launchpad.

/obj/machinery/light/small/readylight
	brightness_range = 5
	brightness_power = 1
	brightness_color = "#DA0205"
	var/state = 0

/obj/machinery/light/small/readylight/proc/set_state(var/new_state)
	state = new_state
	if(state)
		brightness_color = "00FF00"
	else
		brightness_color = initial(brightness_color)
	update()
