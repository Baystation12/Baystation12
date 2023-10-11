// How much time after standing still after running we will use STANDING_FALL_PROB instead of RUNNING_FALL_PROB
#define QUICK_TO_STANDING      5
// How much time after standing still after walking we will use STANDING_FALL_PROB instead of WALKING_FALL_PROB
#define DELIBERATE_TO_STANDING 3
#define RUNNING_FALL_PROB      75
#define WALKING_FALL_PROB      50
#define STANDING_FALL_PROB     20


/**
 * Main proc to fire shells.
 * Returns FALSE if power isn't present, charge isn't present, or fired under cooldown.
 * Blows up if there's an obstruction.
 * Also handles stumbling during firing of the OFD on the firing vessel.
 * Finally checks type of target to fire the specific proc (event, ship, empty).
 */
/obj/machinery/computer/ship/disperser/proc/fire(mob/user)
	log_and_message_admins("attempted to launch a disperser beam.")
	if(!link_parts())
		return FALSE
	if(!front.powered() || !middle.powered() || !back.powered())
		return FALSE
	var/chargetype = get_charge_type()
	if(chargetype <= 0)
		return FALSE

	var/atom/movable/atomcharge = get_charge()

	var/turf/start = front
	var/direction = front.dir

	var/distance = 0
	for(var/turf/T in getline(get_step(front,front.dir),get_target_turf(start, direction)))
		distance++
		if(T.density)
			if(distance < 7)
				explosion(T, 6)
				continue
			else
				T.ex_act(EX_ACT_DEVASTATING)
		for(var/atom/A in T)
			if(A.density)
				if(distance < 7)
					explosion(A, 6)
					break
				else
					A.ex_act(EX_ACT_DEVASTATING)

	for(var/mob/M in GLOB.player_list)
		if(!AreConnectedZLevels(get_z(M), get_z(start)))
			continue
		shake_camera(M, 25)
		if(!isdeaf(M))
			sound_to(M, sound('sound/effects/explosionfar.ogg', volume=10))

		if(M.can_be_floored())
			var/shouldstumble = FALSE
			var/sincelastmove = world.time - M.l_move_time

			if(sincelastmove > QUICK_TO_STANDING SECONDS)
				shouldstumble = prob(STANDING_FALL_PROB)
			else if(sincelastmove > DELIBERATE_TO_STANDING)
				shouldstumble = MOVING_QUICKLY(M) ? prob(RUNNING_FALL_PROB) : prob(STANDING_FALL_PROB)
			else
				shouldstumble = MOVING_QUICKLY(M) ? prob(RUNNING_FALL_PROB) : prob(WALKING_FALL_PROB)

			if(shouldstumble)
				to_chat(M, SPAN_DANGER("You stumble onto the floor from the shaking!"))
				M.AdjustStunned(2)
				M.AdjustWeakened(2)

	if(front)
		front.layer = ABOVE_OBJ_LAYER
	playsound(start, 'sound/machines/disperser_fire.ogg', 100, 1)
	handle_beam(start, direction)
	handle_overbeam()

	if (chargetype != OVERMAP_WEAKNESS_DROPPOD)
		qdel(atomcharge)

	if(prob(cool_failchance()))
		explosion(middle, rand(6, 9))
	next_shot = coolinterval + world.time

	if(prob(100 - accuracy))
		if(chargetype == OVERMAP_WEAKNESS_DROPPOD)
			// Remove it in case it's a droppod.
			atomcharge.forceMove(locate(rand(1,world.maxx),rand(1,world.maxy), GLOB.using_map.get_empty_zlevel()))
		return TRUE

	reset_calibration()

	var/turf/overmaptarget = get_step(linked, overmapdir)
	var/list/candidates = list()

	// Prioritize events. Thus you can hide in meteor showers in exchange for protection from the disperser.
	for(var/obj/overmap/event/O in overmaptarget)
		candidates += O
	// Next we see if there are any ships around. Logically they are between us and the sector if one exists.
	if(!length(candidates))
		for(var/obj/overmap/visitable/ship/S in overmaptarget)
			if(S == linked)
				/// Why are you shooting yourself?
				continue
			candidates += S

	// No events, no ships, the last thing to check is a sector.
	if(!length(candidates))
		for(var/obj/overmap/O in overmaptarget)
			if(O == linked)
				// Why are you shooting yourself?
				continue
			candidates += O

	// Way to waste a charge
	if(!length(candidates))
		return TRUE

	var/obj/overmap/finaltarget = pick(candidates)
	log_and_message_admins("A type [chargetype] disperser beam was launched at [finaltarget].", location=finaltarget)

	// Deletion of the overmap effect and the actual event trigger. Bye bye pesky meteors.
	if(istype(finaltarget, /obj/overmap/event))
		fire_at_event(finaltarget, chargetype)
		qdel(atomcharge)
	// After this point ships act basically as sectors so we stop taking care of differences
	else
		fire_at_sector(finaltarget, atomcharge, chargetype)
	return TRUE

/**
 * Handles firing at events (storms, meteors, etc).
 * If the shot type and the event type's weakness match, it kills it.
 */
/obj/machinery/computer/ship/disperser/proc/fire_at_event(obj/overmap/event/finaltarget, chargetype)
	if(chargetype & finaltarget.weaknesses)
		var/turf/T = finaltarget.loc
		qdel(finaltarget)
		overmap_event_handler.update_hazards(T)

/**
 * Handles firing at sector, empty or with a map.
 * Has code to handle manual coordinate-based aiming, and random-aim.
 * If coordinates are put in, gun tries to hit at the inputted coordinates, else chooses a random area.
 */
/obj/machinery/computer/ship/disperser/proc/fire_at_sector(obj/overmap/visitable/finaltarget, obj/structure/ship_munition/disperser_charge/charge, chargetype)
	var/list/targetareas = finaltarget.get_areas()
	targetareas -= locate(/area/space)

	var/area/finalarea = pick(targetareas)
	var/turf/areaturf = pick_area_turf(finalarea.type)
	var/turf/targetturf

	if (tx > 0 && ty > 0)
		if (tz == 0 || !AreConnectedZLevels(tz, areaturf.z))
			tz = areaturf.z

		targetturf = locate(rand(tx + (100 - accuracy), tx - (100 - accuracy)), rand(ty + (100 - accuracy), ty - (100 - accuracy)), tz)

	else if (tx == 0 && ty == 0 && tz == 0)
		targetturf = areaturf

	log_and_message_admins("Disperser beam hit sector at [targetturf.loc.name].", location=targetturf)
	if(chargetype == OVERMAP_WEAKNESS_DROPPOD)
		if(targetturf.density)
			targetturf.ex_act(EX_ACT_DEVASTATING)
		for(var/atom/A in targetturf)
			A.ex_act(EX_ACT_LIGHT)

		for(var/mob/M in GLOB.player_list)
			if(!AreConnectedZLevels(get_z(M), get_z(targetturf)))
				continue
			shake_camera(M, 25)
			if(!isdeaf(M))
				sound_to(M, sound('sound/effects/explosionfar.ogg', volume=10))

			if(M.can_be_floored())
				var/shouldstumble = FALSE
				var/sincelastmove = world.time - M.l_move_time

				if(sincelastmove > QUICK_TO_STANDING SECONDS)
					shouldstumble = prob(STANDING_FALL_PROB)
				else if(sincelastmove > DELIBERATE_TO_STANDING)
					shouldstumble = MOVING_QUICKLY(M) ? prob(RUNNING_FALL_PROB) : prob(STANDING_FALL_PROB)
				else
					shouldstumble = MOVING_QUICKLY(M) ? prob(RUNNING_FALL_PROB) : prob(WALKING_FALL_PROB)

				if(shouldstumble)
					to_chat(M, SPAN_DANGER("You stumble onto the floor from the shaking!"))
					M.AdjustStunned(2)
					M.AdjustWeakened(2)

		charge.forceMove(targetturf)
		// The disperser is not a taxi
		for(var/mob/living/L in charge)
			to_chat(L, SPAN_DANGER("Your body shakes violently, immense and agonising forces tearing it apart."))
			L.forceMove(targetturf)
			L.ex_act(EX_ACT_DEVASTATING)
	else
		charge.fire(targetturf, strength, range)
		qdel(charge)

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
