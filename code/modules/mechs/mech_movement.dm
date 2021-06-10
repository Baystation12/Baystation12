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
		playsound(src.loc, mech_step_sound, 40, 1)

/mob/living/exosuit/can_ztravel()
	if(Allow_Spacemove()) //Handle here 
		return TRUE

/mob/living/exosuit/Allow_Spacemove(check_drift)
	. = ..()
	if(.)
		return

	//Regardless of modules, emp prevents control
	if(emp_damage >= EMP_MOVE_DISRUPT && prob(25))
		return FALSE

	var/obj/item/mech_equipment/ionjets/J = hardpoints[HARDPOINT_BACK]
	if(istype(J))
		if(((!check_drift) || (check_drift && J.stabilizers)) && J.allowSpaceMove())
			inertia_dir = 0
			return TRUE

//Inertia drift making us face direction makes exosuit flight a bit difficult, plus newtonian flight model yo
/mob/living/exosuit/set_dir(ndir)
	if(inertia_dir && inertia_dir == ndir)
		return ..(dir)
	return ..(ndir)

/mob/living/exosuit/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = src.loc)
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

/datum/movement_handler/mob/exosuit/MayMove(var/mob/mover, var/is_external)
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

/datum/movement_handler/mob/exosuit/DoMove(var/direction, var/mob/mover, var/is_external)
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
		playsound(exosuit.loc, exosuit.mech_turn_sound, 40,1)
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

// Space movement
/datum/movement_handler/mob/space/exosuit/DoMove(var/direction, var/mob/mover)

	if(!mob.check_solid_ground())
		mob.anchored = FALSE
		var/allowmove = mob.Allow_Spacemove(0)
		if(!allowmove)
			return MOVEMENT_HANDLED
		else if(allowmove == -1 && mob.handle_spaceslipping()) //Check to see if we slipped
			return MOVEMENT_HANDLED
		else
			mob.inertia_dir = 0 //If not then we can reset inertia and move
	else 
		mob.anchored = TRUE
		mob.inertia_dir = 0 //Reset inertia values as we are not going to be treated as floating

/datum/movement_handler/mob/space/exosuit/MayMove(var/mob/mover, var/is_external)
	if((mover != host) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.check_solid_ground())
		if(!mob.Allow_Spacemove(0))
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/mob/living/exosuit/lost_in_space()
	for(var/atom/movable/AM in contents)
		if(!AM.lost_in_space())
			return FALSE
	return !length(pilots)

/mob/living/exosuit/fall_damage()
	return 175 //Exosuits are big and heavy

/mob/living/exosuit/handle_fall_effect(var/turf/landing)
	// Return here if for any reason you shouldn´t take damage
	..()
	if(legs)
		legs.handle_vehicle_fall()
