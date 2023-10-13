/mob/living/exosuit
	movement_handlers = list(
		/datum/movement_handler/mob/delay/exosuit,
		/datum/movement_handler/mob/space/exosuit,
		/datum/movement_handler/mob/multiz,
		/datum/movement_handler/mob/exosuit
	)

/mob/living/exosuit/Move()
	. = ..()
	if(. && !istype(loc, /turf/space))
		playsound(src.loc, legs.mech_step_sound, 40, 1)

/mob/living/exosuit/can_ztravel()
	if(Process_Spacemove()) //Handle here
		return TRUE

//Inertia drift making us face direction makes exosuit flight a bit difficult, plus newtonian flight model yo
/mob/living/exosuit/set_dir(ndir)
	if(inertia_dir && inertia_dir == ndir)
		return ..(dir)
	return ..(ndir)

/mob/living/exosuit/can_fall(anchor_bypass = FALSE, turf/location_override = src.loc)
	//mechs are always anchored, so falling should always ignore it
	if(..(TRUE, location_override))
		return !(can_overcome_gravity())

/mob/living/exosuit/can_float()
	return FALSE //Nope

/datum/movement_handler/mob/delay/exosuit
	expected_host_type = /mob/living/exosuit

/datum/movement_handler/mob/delay/exosuit/MayMove(mover, is_external)
	var/mob/living/exosuit/exosuit = host
	if(mover && (mover != exosuit) && (!(mover in exosuit.pilots)) && is_external)
		return MOVEMENT_PROCEED
	else if(world.time >= next_move)
		return MOVEMENT_PROCEED
	return MOVEMENT_STOP

/datum/movement_handler/mob/delay/exosuit/DoMove(direction, mover, is_external) //Delay must be handled by other handlers.
	return

/mob/living/exosuit/SetMoveCooldown(timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay/exosuit)
	if(delay)
		delay.SetDelay(timeout)

/mob/living/exosuit/ExtraMoveCooldown(timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay/exosuit)
	if(delay)
		delay.AddDelay(timeout)

/datum/movement_handler/mob/exosuit
	expected_host_type = /mob/living/exosuit

/datum/movement_handler/mob/exosuit/MayMove(mob/mover, is_external)
	var/mob/living/exosuit/exosuit = host
	if((!(mover in exosuit.pilots) && mover != exosuit) || exosuit.incapacitated() || mover.incapacitated())
		return MOVEMENT_STOP
	if(!exosuit.legs)
		to_chat(mover, SPAN_WARNING("\The [exosuit] has no means of propulsion!"))
		exosuit.SetMoveCooldown(3)
		return MOVEMENT_STOP
	if(!exosuit.legs.motivator || !exosuit.legs.motivator.is_functional())
		to_chat(mover, SPAN_WARNING("Your motivators are damaged! You can't move!"))
		exosuit.SetMoveCooldown(15)
		return MOVEMENT_STOP
	if(exosuit.maintenance_protocols)
		to_chat(mover, SPAN_WARNING("Maintenance protocols are in effect."))
		exosuit.SetMoveCooldown(3)
		return MOVEMENT_STOP
	var/obj/item/cell/C = exosuit.get_cell()
	if(!C || !C.check_charge(exosuit.legs.power_use * CELLRATE))
		to_chat(mover, SPAN_WARNING("The power indicator flashes briefly."))
		exosuit.SetMoveCooldown(3) //On fast exosuits this got annoying fast
		return MOVEMENT_STOP

	return MOVEMENT_PROCEED

/datum/movement_handler/mob/exosuit/DoMove(direction, mob/mover, is_external)
	var/mob/living/exosuit/exosuit = host
	var/moving_dir = direction

	var/failed = FALSE
	var/fail_prob = mover != host ? (mover.skill_check(SKILL_MECH, HAS_PERK) ? 0 : 25) : 0
	if(prob(fail_prob))
		to_chat(mover, SPAN_DANGER("You clumsily fumble with the exosuit joystick."))
		failed = TRUE
	else if(exosuit.emp_damage >= EMP_MOVE_DISRUPT && prob(30))
		failed = TRUE
	if(failed)
		moving_dir = pick(GLOB.cardinal - exosuit.dir)

	exosuit.get_cell()?.use(exosuit.legs.power_use * CELLRATE)

	if(direction & (UP|DOWN))
		var/txt_dir = direction & UP ? "upwards" : "downwards"
		exosuit.visible_message(SPAN_NOTICE("\The [exosuit] moves [txt_dir]."))

	if(exosuit.dir != moving_dir && !(direction & (UP|DOWN)))
		playsound(exosuit.loc, exosuit.legs.mech_turn_sound, 40,1)
		exosuit.set_dir(moving_dir)
		exosuit.SetMoveCooldown(exosuit.legs.turn_delay)
	else
		exosuit.SetMoveCooldown(exosuit.legs ? exosuit.legs.move_delay : 3)
		var/turf/target_loc = get_step(exosuit, direction)
		if(target_loc && exosuit.legs && exosuit.legs.can_move_on(exosuit.loc, target_loc) && exosuit.MayEnterTurf(target_loc))
			exosuit.Move(target_loc)
	return MOVEMENT_HANDLED
/datum/movement_handler/mob/space/exosuit
	expected_host_type = /mob/living/exosuit

/datum/movement_handler/mob/space/exosuit/MayMove(mob/mover, is_external)
	if((mover != host) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.has_gravity())
		allow_move = mob.Process_Spacemove(1)
		if(!allow_move)
			return MOVEMENT_STOP

	return MOVEMENT_PROCEED

/mob/living/exosuit/Check_Shoegrip()//mechs are always magbooting
	return TRUE

/mob/living/exosuit/Process_Spacemove(allow_movement)
	if(has_gravity() || throwing || !isturf(loc) || length(grabbed_by) || check_space_footing() || locate(/obj/structure/lattice) in range(1, get_turf(src)))
		anchored = TRUE
		return TRUE

	anchored = FALSE

	//Regardless of modules, emp prevents control
	if(emp_damage >= EMP_MOVE_DISRUPT && prob(25))
		return FALSE

	var/obj/item/mech_equipment/ionjets/J = hardpoints[HARDPOINT_BACK]
	if(istype(J))
		if(J.allowSpaceMove() && (allow_movement || J.stabilizers))
			return TRUE

/mob/living/exosuit/check_space_footing()//mechs can't push off things to move around in space, they stick to hull or float away
	for(var/thing in trange(1,src))
		var/turf/T = thing
		if(T.density || T.is_wall() || T.is_floor())
			return T

/mob/living/exosuit/space_do_move()
	return 1


/mob/living/exosuit/lost_in_space()
	for(var/atom/movable/AM in contents)
		if(!AM.lost_in_space())
			return FALSE
	return !length(pilots)

/mob/living/exosuit/fall_damage()
	return 175 //Exosuits are big and heavy

/mob/living/exosuit/handle_fall_effect(turf/landing)
	// Return here if for any reason you shouldn´t take damage
	..()
	if(legs)
		legs.handle_vehicle_fall()
