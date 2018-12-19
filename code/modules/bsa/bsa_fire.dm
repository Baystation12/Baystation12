/obj/machinery/computer/ship/bsa/proc/fire(mob/user)
	log_and_message_admins("attempted to launch an artillery strike.")
	if(!link_parts())
		return FALSE //no bsa, no service
	if(!front.powered() || !middle.powered() || !back.powered())
		return FALSE //no power, no boom boom
	var/chargetype = get_charge_type()
	if(chargetype <= 0)
		return FALSE //no dear, you cannot fire the captain out of a cannon... unless  you put him in a box of course

	var/atom/movable/atomcharge = get_charge()

	var/turf/start = front
	var/direction = front.dir

	var/distance = 0
	for(var/turf/T in getline(get_step(front,front.dir),get_target_turf(start, direction)))
		distance++
		if(T.density)
			if(distance < 7)
				explosion(T,1,2,3)
				continue
			else
				T.ex_act(1)
		for(var/atom/A in T)
			if(A.density)
				if(distance < 7)
					explosion(A,1,2,3)
					break
				else
					A.ex_act(1)

	var/list/relevant_z = GetConnectedZlevels(start.z)
	for(var/mob/M in GLOB.player_list)
		var/turf/T = get_turf(M)
		if(!T || !(T.z in relevant_z))
			continue
		shake_camera(M, 25)
		if(!isdeaf(M))
			sound_to(M, sound('sound/effects/explosionfar.ogg', volume=10))

	if(front) //Meanwhile front might have exploded
		front.layer = ABOVE_OBJ_LAYER //So the beam goes below us. Looks a lot better
	playsound(start, 'sound/machines/bsa_fire.ogg', 100, 1)
	handle_beam(start, direction)
	handle_overbeam()

	//Some moron disregarded the cooldown warning. Let's blow in their face.
	if(prob(cool_failchance()))
		message_admins("[cool_failchance()]")
		explosion(middle,rand(1,2),rand(2,3),rand(3,4))
	next_shot = coolinterval + world.time

	//Success, but we missed.
	if(prob(100 - cal_accuracy()))
		if(chargetype == BSA_DROPPOD)
			atomcharge.forceMove(locate(rand(1,world.maxx),rand(1,world.maxy), GLOB.using_map.get_empty_zlevel())) //Remove it in case it's a droppod.
		return TRUE

	reset_calibration()

	var/turf/overmaptarget = get_step(linked, overmapdir)
	var/list/candidates = list()
	//Prioritize events. Thus you can hide in meteor showers in exchange for protection from the BSA.
	for(var/obj/effect/overmap_event/O in overmaptarget)
		candidates += O
	//Next we see if there are any ships around. Logically they are between us and the sector if one exists.
	if(!length(candidates))
		for(var/obj/effect/overmap/ship/S in overmaptarget)
			if(S == linked)
				continue //Why are you shooting yourself?
			candidates += S

	//No events, no ships, the last thing to check is a sector.
	if(!length(candidates))
		for(var/obj/effect/overmap/O in overmaptarget)
			if(O == linked)
				continue //Why are you shooting yourself?
			candidates += O

	//Way to waste a charge
	if(!length(candidates))
		return TRUE

	var/obj/effect/overmap/finaltarget = pick(candidates)
	message_admins("A type [chargetype] artillery strike was launched at [finaltarget]; overmap coordinates [finaltarget.x],[finaltarget.y],[finaltarget.z] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[finaltarget.x];Y=[finaltarget.y];Z=[finaltarget.z]'>JMP</a>).")

	//Deletion of the overmap effect and the actual event trigger. Bye bye pesky meteors.
	if(istype(finaltarget, /obj/effect/overmap_event))
		fire_at_event(finaltarget, chargetype)
		qdel(atomcharge)
	//After this point ships act basically as sectors so we stop taking care of differences
	else
		fire_at_sector(finaltarget, atomcharge, chargetype)
	return TRUE

/obj/machinery/computer/ship/bsa/proc/fire_at_event(obj/effect/overmap_event/finaltarget, chargetype)
	var/list/events_by_turf = overmap_event_handler.get_event_turfs_by_z_level(linked.z)
	var/datum/overmap_event/tokill = events_by_turf[get_turf(finaltarget)]
	if(chargetype & tokill.weaknesses)
		qdel(finaltarget)

/obj/machinery/computer/ship/bsa/proc/fire_at_sector(obj/effect/overmap/finaltarget, obj/structure/ship_munition/bsa_charge/charge, chargetype)
	var/list/targetareas = finaltarget.get_areas()
	targetareas -= locate(/area/space)
	var/area/finalarea = pick(targetareas)
	var/turf/targetturf = pick_area_turf(finalarea.type, list(/proc/is_not_space_turf))

	message_admins("Aforementioned artillery strike hit sector at [get_area(targetturf)]: [targetturf.x],[targetturf.y],[targetturf.z] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[targetturf.x];Y=[targetturf.y];Z=[targetturf.z]'>JMP</a>).")
	if(chargetype == BSA_DROPPOD)
		if(targetturf.density)
			targetturf.ex_act(1)
		for(var/atom/A in targetturf)
			A.ex_act(3)
		charge.forceMove(targetturf)
		//The BSA is not a taxi
		for(var/mob/living/L in charge)
			to_chat(L, "As you pass through bluespace above the speed of light, you suddenly ram into the fourth wall.")
			L.forceMove(targetturf)
			L.ex_act(1)
	else
		charge.fire(targetturf, strength, range)
		qdel(charge)

/obj/machinery/computer/ship/bsa/proc/handle_beam(turf/start, direction)
	set waitfor = FALSE
	start.Beam(get_target_turf(start, direction), "bsa_beam", time = 50, maxdistance = world.maxx)
	if(front)
		front.layer = initial(front.layer)

/obj/machinery/computer/ship/bsa/proc/handle_overbeam()
	set waitfor = FALSE
	linked.Beam(get_step(linked, overmapdir), "bsa_beam", time = 150, maxdistance = world.maxx)

/obj/machinery/computer/ship/bsa/proc/get_target_turf(turf/start, direction)
	switch(direction)
		if(NORTH)
			return locate(start.x,world.maxy,start.z)
		if(SOUTH)
			return locate(start.x,1,start.z)
		if(WEST)
			return locate(1,start.y,start.z)
		if(EAST)
			return locate(world.maxx,start.y,start.z)