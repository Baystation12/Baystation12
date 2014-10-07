/mob/living/silicon/robot/Process_Spaceslipping(var/prob_slip)
	if(module && (istype(module,/obj/item/weapon/robot_module/construction) || istype(module,/obj/item/weapon/robot_module/drone)))
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Process_Spacemove()
	if(module)
		for(var/obj/item/weapon/tank/jetpack/J in module.modules)
			if(J && istype(J, /obj/item/weapon/tank/jetpack))
				if(J.allow_thrust(0.01))	return 1
	if(..())	return 1
	return 0

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally-=3

	return tally+config.robot_delay

// NEW: Use power while moving.
/mob/living/silicon/robot/Move()
	if (!is_component_functioning("actuator"))
		return

	var/datum/robot_component/actuator/A = get_component("actuator")
	if (cell_use_power(A.active_usage))
		..()