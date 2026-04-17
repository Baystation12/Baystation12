/mob/living/silicon/robot/slip_chance(prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Check_Shoegrip()
	if(module && module.no_slip)
		return 1
	return 0

/mob/living/silicon/robot/Process_Spacemove(allow_movement)
	if (!module)
		return ..()

	for (var/obj/item/tank/jetpack/jetpack in module.equipment)
		if (jetpack?.allow_thrust(0.01))
			return TRUE

	return ..()


/mob/living/silicon/robot/movement_delay(singleton/move_intent/using_intent = move_intent)
	var/tally = ..()

	// Subtract 1 to match Human base movement_delay of -1
	tally -= 1

	if (vtec)
		tally -= 1

	var/obj/item/module_active = get_active_module()
	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally -= 3

	return tally
