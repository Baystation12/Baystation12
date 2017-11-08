//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/area/shuttle_area //can be both single area type or a list of areas
	var/obj/effect/shuttle_landmark/current_location

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = SHUTTLE_FLAGS_PROCESS
	var/category = /datum/shuttle

	var/ceiling_type = /turf/unsimulated/floor/shuttle_ceiling

	var/sound_takeoff = 'sound/effects/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttle_landing.ogg'

	var/knockdown = 1 //whether shuttle downs non-buckled people when it moves

/datum/shuttle/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	..()
	if(_name)
		src.name = _name

	var/list/areas = list()
	if(!islist(shuttle_area))
		shuttle_area = list(shuttle_area)
	for(var/T in shuttle_area)
		var/area/A = locate(T)
		if(!istype(A))
			CRASH("Shuttle \"[name]\" couldn't locate area [T].")
		areas += A
	shuttle_area = areas

	if(initial_location)
		current_location = initial_location
	else
		current_location = locate(current_location)
	if(!istype(current_location))
		CRASH("Shuttle \"[name]\" could not find its starting location.")

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

/datum/shuttle/proc/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP
	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return FALSE	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			return
			moving_status = SHUTTLE_IDLE

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		attempt_move(destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	if(moving_status != SHUTTLE_IDLE) return

	var/obj/effect/shuttle_landmark/start_location = current_location

	moving_status = SHUTTLE_WARMUP
	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			return
			moving_status = SHUTTLE_IDLE

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		if(attempt_move(interim))
			var/fwooshed = 0
			while (world.time < arrive_time)
				if(!fwooshed && (arrive_time - world.time) < 100)
					fwooshed = 1
					playsound(destination, sound_landing, 100, 0, 7)
				sleep(5)
			if(!attempt_move(destination))
				attempt_move(start_location) //try to go back to where we started. If that fails, I guess we're stuck in the interim location

		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in non-overmap shuttles (they have magic engines)

/datum/shuttle/proc/attempt_move(var/obj/effect/shuttle_landmark/destination)
	if(current_location == destination)
		return FALSE

	if(!destination.is_valid(src))
		return FALSE
	testing("[src] moving to [destination]. Areas are [english_list(shuttle_area)]")
	var/list/translation = list()
	for(var/area/A in shuttle_area)
		testing("Moving [A]")
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)
	shuttle_moved(destination, translation)
	return TRUE


//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. shuttle_moved() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump(), long_jump() or attempt_move()
/datum/shuttle/proc/shuttle_moved(var/obj/effect/shuttle_landmark/destination, var/list/turf_translation)

//	log_debug("move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination].")
//	log_degug("area_coming_from: [origin]")
//	log_debug("destination: [destination]")
	for(var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation[src_turf]
		if(src_turf.is_solid_structure()) //in case someone put a hole in the shuttle and you were lucky enough to be under it
			for(var/atom/movable/AM in dst_turf)
				if(!AM.simulated)
					continue
				if(isliving(AM))
					var/mob/living/bug = AM
					bug.gib()
				else
					qdel(AM) //it just gets atomized I guess? TODO throw it into space somewhere, prevents people from using shuttles as an atom-smasher
	var/list/powernets = list()
	for(var/area/A in shuttle_area)
		// if there was a zlevel above our origin, erase our ceiling now we're leaving
		if(HasAbove(current_location.z))
			for(var/turf/TO in A.contents)
				var/turf/TA = GetAbove(TO)
				if(istype(TA, ceiling_type))
					TA.ChangeTurf(get_base_turf_by_area(TA), 1, 1)
		if(knockdown)
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

		for(var/obj/structure/cable/C in A)
			powernets |= C.powernet

	translate_turfs(turf_translation, current_location.base_area, current_location.base_turf)
	current_location = destination

	// if there's a zlevel above our destination, paint in a ceiling on it so we retain our air
	if(HasAbove(current_location.z))
		for(var/area/A in shuttle_area)
			for(var/turf/TD in A.contents)
				var/turf/TA = GetAbove(TD)
				if(istype(TA, get_base_turf_by_area(TA)) || istype(TA, /turf/simulated/open))
					TA.ChangeTurf(ceiling_type, 1, 1)

	// Remove all powernets that were affected, and rebuild them.
	var/list/cables = list()
	for(var/datum/powernet/P in powernets)
		cables |= P.cables
		qdel(P)
	for(var/obj/structure/cable/C in cables)
		if(!C.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(C)
			propagate_network(C,C.powernet)

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)
