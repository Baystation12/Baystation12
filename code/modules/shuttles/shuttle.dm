//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/area/shuttle_area
	var/atom/current_location

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = SHUTTLE_FLAGS_PROCESS
	var/category = /datum/shuttle

	var/ceiling_type = /turf/unsimulated/floor/shuttle_ceiling

/datum/shuttle/New(_name, var/atom/initial_location)
	..()
	if(_name)
		src.name = _name

	shuttle_area = locate(shuttle_area)
	if(!istype(shuttle_area))
		CRASH("Shuttle \"[name]\" has no area.")

	current_location = initial_location
	if(!istype(current_location))
		CRASH("Shuttle \"[name]\" has no starting location.")

	if(src.name in shuttle_controller.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	shuttle_controller.shuttles[src.name] = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		shuttle_controller.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(supply_controller.shuttle)
			CRASH("A supply shuttle is already defined.")
		supply_controller.shuttle = src

/datum/shuttle/Destroy()
	current_location = null

	shuttle_controller.shuttles -= src.name
	shuttle_controller.process_shuttles -= src
	if(supply_controller.shuttle == src)
		supply_controller.shuttle = null

	. = ..()

/datum/shuttle/proc/short_jump(var/destination)
	if(moving_status != SHUTTLE_IDLE) return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		move(destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/destination, var/interim, var/travel_time)
//	log_debug("shuttle/long_jump: departing=[departing], destination=[destination], interim=[interim], travel_time=[travel_time]")

	if(moving_status != SHUTTLE_IDLE) return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		move(interim)


		while (world.time < arrive_time)
			sleep(5)

		move(destination)
		moving_status = SHUTTLE_IDLE

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. move() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump() or long_jump()
/datum/shuttle/proc/move(var/atom/destination)

//	log_debug("move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination].")
//	log_degug("area_coming_from: [origin]")
//	log_debug("destination: [destination]")

	if(current_location == destination)
//		log_debug("cancelling move, shuttle will overlap.")

		return //TODO more complete check for overlap

	//TODO
	/*
	var/list/dstturfs = list()
	var/throwy = world.maxy

	for(var/turf/T in destination)
		dstturfs += T
		if(T.y < throwy)
			throwy = T.y

	for(var/turf/T in dstturfs)
		var/turf/D = locate(T.x, throwy - 1, 1)
		for(var/atom/movable/AM in T)
			if(AM.simulated)
				AM.Move(D)

	for(var/mob/living/bug in destination)
		var/turf/T = get_turf(bug)
		if(!T || T.is_solid_structure())
			bug.gib()
	*/

	/*
	// if there's a zlevel above our destination, paint in a ceiling on it so we retain our air
	var/turf/some_dest_turf = locate() in destination
	if (HasAbove(some_dest_turf.z))
		for (var/turf/TD in dstturfs)
			var/turf/TA = GetAbove(TD)
			if (istype(TA, get_base_turf_by_area(TA)))
				TA.ChangeTurf(ceiling_type, 1, 1)
	*/

	var/list/shuttle_turfs = get_area_turfs("\ref[shuttle_area]")
	translate_turfs(get_turf(current_location), get_turf(destination), shuttle_turfs)
	current_location = destination

	// if there was a zlevel above our origin, erase our ceiling now we're gone
	var/turf/some_origin_turf = shuttle_turfs[1]
	if (HasAbove(some_origin_turf.z))
		for (var/turf/TO in shuttle_turfs)
			var/turf/TA = GetAbove(TO)
			if (istype(TA, ceiling_type))
				TA.ChangeTurf(get_base_turf_by_area(TA), 1, 1)

	for(var/mob/M in destination)
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

	//TODO replace these with locate() in destination
	// Power-related checks. If shuttle contains power related machinery, update powernets.
	var/update_power = 0
	for(var/obj/machinery/power/P in destination)
		update_power = 1
		break

	for(var/obj/structure/cable/C in destination)
		update_power = 1
		break

	if(update_power)
		makepowernets()
	return

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)
