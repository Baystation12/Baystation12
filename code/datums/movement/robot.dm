/*********
* /robot *
*********/
/datum/movement_handler/robot
	expected_host_type = /mob/living/silicon/robot
	var/mob/living/silicon/robot/robot

/datum/movement_handler/robot/New(var/host)
	..()
	src.robot = host

/datum/movement_handler/robot/Destroy()
	robot = null
	. = ..()

// Use power while moving.
/datum/movement_handler/robot/use_power/DoMove()
	var/datum/robot_component/actuator/A = robot.get_component("actuator")
	if(!robot.cell_use_power(A.active_usage * robot.power_efficiency))
		return MOVEMENT_HANDLED

/datum/movement_handler/robot/use_power/MayMove()
	return robot.is_component_functioning("actuator") ? MOVEMENT_PROCEED : MOVEMENT_STOP
