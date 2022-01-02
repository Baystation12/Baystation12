/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Check_Shoegrip()
	if(module && module.no_slip)
		return 1
	return 0

/mob/living/silicon/robot/Allow_Spacemove()
	if(module)
		for(var/obj/item/tank/jetpack/J in module.equipment)
			if(J && J.allow_thrust(0.01))
				return 1
	. = ..()


/mob/living/silicon/robot/movement_delay()
	var/tally = ..()

	// Subtract 1 to match Human base movement_delay of -1
	tally -= 1

	if (vtec)
		tally -= 1

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally -= 3

	return tally
