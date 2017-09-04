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
		for(var/obj/item/weapon/tank/jetpack/J in module.modules)
			if(J && J.allow_thrust(0.01))
				return 1
	. = ..()


 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	var/tally = ..() //Incase I need to add stuff other than "speed" later

	tally += speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally-=3

	return tally+config.robot_delay

// NEW: Use power while moving.
/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if (!is_component_functioning("actuator"))
		return 0

	var/datum/robot_component/actuator/A = get_component("actuator")
	if (cell_use_power(A.active_usage))
		return ..()
