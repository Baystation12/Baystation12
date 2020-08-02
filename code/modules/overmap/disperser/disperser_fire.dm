#define QUICK_TO_STANDING      5  //How much time after standing still after running we will use STANDING_FALL_PROB instead of RUNNING_FALL_PROB
#define DELIBERATE_TO_STANDING 3  //How much time after standing still after walking we will use STANDING_FALL_PROB instead of WALKING_FALL_PROB
#define RUNNING_FALL_PROB      75
#define WALKING_FALL_PROB      50
#define STANDING_FALL_PROB     20


/obj/machinery/computer/ship/disperser/proc/fire(mob/user)
	log_and_message_admins("attempted to launch a disperser beam.")
	if(!link_parts())
		return FALSE //no disperser, no service
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

		if(M.can_be_floored())
			var/shouldstumble = FALSE
			var/sincelastmove = world.time - M.l_move_time

			if(sincelastmove > QUICK_TO_STANDING SECONDS) //We are standing still
				shouldstumble = prob(STANDING_FALL_PROB)
			else if(sincelastmove > DELIBERATE_TO_STANDING) //We are either standing still after running or standing still after walking/creeping
				shouldstumble = MOVING_QUICKLY(M) ? prob(RUNNING_FALL_PROB) : prob(STANDING_FALL_PROB)
			else //We are either currently running or currently walking/creeping
				shouldstumble = MOVING_QUICKLY(M) ? prob(RUNNING_FALL_PROB) : prob(WALKING_FALL_PROB)

			if(shouldstumble)
				to_chat(M, SPAN_DANGER("You stumble onto the floor from the shaking!"))
				M.AdjustStunned(2)
				M.AdjustWeakened(2)

	if(front) //Meanwhile front might have exploded
		front.layer = ABOVE_OBJ_LAYER //So the beam goes below us. Looks a lot better
	playsound(start, 'sound/machines/disperser_fire.ogg', 100, 1)
	handle_beam(start, direction)
	handle_overbeam()
	qdel(atomcharge)

	//Some moron disregarded the cooldown warning. Let's blow in their face.
	if(prob(cool_failchance()))
		explosion(middle,rand(1,2),rand(2,3),rand(3,4))
	next_shot = coolinterval + world.time

	//Success, but we missed.
	if(prob(100 - cal_accuracy()))
		return TRUE

	reset_calibration()

	var/list/candidates = list()

	for(var/obj/effect/overmap/event/O in get_step(linked, overmapdir))
		candidates += O

	//Way to waste a charge
	if(!length(candidates))
		return TRUE

	var/obj/effect/overmap/event/finaltarget = pick(candidates)
	log_and_message_admins("A type [chargetype] disperser beam was launched at [finaltarget].", location=finaltarget)

	fire_at_event(finaltarget, chargetype)
	return TRUE

/obj/machinery/computer/ship/disperser/proc/fire_at_event(obj/effect/overmap/event/finaltarget, chargetype)
	if(chargetype & finaltarget.weaknesses)
		var/turf/T = finaltarget.loc
		qdel(finaltarget)
		overmap_event_handler.update_hazards(T)

/obj/machinery/computer/ship/disperser/proc/handle_beam(turf/start, direction)
	set waitfor = FALSE
	start.Beam(get_target_turf(start, direction), "disperser_beam", time = 50, maxdistance = world.maxx)
	if(front)
		front.layer = initial(front.layer)

/obj/machinery/computer/ship/disperser/proc/handle_overbeam()
	set waitfor = FALSE
	linked.Beam(get_step(linked, overmapdir), "disperser_beam", time = 150, maxdistance = world.maxx)

/obj/machinery/computer/ship/disperser/proc/get_target_turf(turf/start, direction)
	switch(direction)
		if(NORTH)
			return locate(start.x,world.maxy,start.z)
		if(SOUTH)
			return locate(start.x,1,start.z)
		if(WEST)
			return locate(1,start.y,start.z)
		if(EAST)
			return locate(world.maxx,start.y,start.z)

#undef QUICK_TO_STANDING
#undef DELIBERATE_TO_STANDING
#undef RUNNING_FALL_PROB
#undef WALKING_FALL_PROB
#undef STANDING_FALL_PROB
