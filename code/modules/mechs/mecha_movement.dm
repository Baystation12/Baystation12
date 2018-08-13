/datum/movement_handler/mech

/mob/living/heavy_vehicle/movement_delay()
	return legs ? legs.move_delay : 3

/mob/living/heavy_vehicle/MayMove(var/mob/mover, var/is_external)

	world << "blorp"

	if(world.time < next_move)
		return FALSE

	if((mover != pilot && mover != src) || incapacitated() || mover.incapacitated())
		return FALSE

	if(!legs)
		to_chat(mover, "<span class='warning'>\The [src] has no means of propulsion!</span>")
		next_move = world.time + 3 // Just to stop them from getting spammed with messages.
		return FALSE

	if(!legs.motivator || !legs.motivator.is_functional())
		to_chat(mover, "<span class='warning'>Your motivators are damaged! You can't move!</span>")
		next_move = world.time + 15
		return FALSE

	if(maintenance_protocols)
		to_chat(mover, "<span class='warning'>Maintenance protocols are in effect.</span>")
		return FALSE

	if(!check_solid_ground())
		var/allowmove = Allow_Spacemove(0)
		if(!allowmove)
			return FALSE
		else if(allowmove == -1 && handle_spaceslipping())
			return FALSE
		else
			inertia_dir = 0

	var/direction = dir
	if(emp_damage >= EMP_MOVE_DISRUPT && prob(30))
		direction = pick(GLOB.cardinal)

	if(dir == direction)
		var/turf/target_loc = get_step(src, direction)
		if(!legs.can_move_on(loc, target_loc))
			return FALSE
	else
		playsound(src.loc,mech_turn_sound,40,1)
		set_dir(direction)
		return FALSE

	next_move = world.time + movement_delay()

	return TRUE

/mob/living/heavy_vehicle/DoMove(var/direction, var/mob/mover, var/is_external)
	world << "florp"
	return MOVEMENT_HANDLED

/mob/living/heavy_vehicle/Move()
	. = ..()
	if(. && !istype(loc, /turf/space))
		playsound(src.loc, mech_step_sound, 40, 1)
