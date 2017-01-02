/obj/machinery/door/airlock/lift
	name = "Elevator Door"
	desc = "Ding."
	req_access = list(access_maint_tunnels)
	opacity = 0
	autoclose = 0
	glass = 1
	icon = 'icons/obj/doors/doorlift.dmi'

	var/datum/turbolift/lift
	var/datum/turbolift_floor/floor

/obj/machinery/door/airlock/lift/Destroy()
	if(lift)
		lift.doors -= src
	if(floor)
		floor.doors -= src
	return ..()

/obj/machinery/door/airlock/lift/bumpopen(var/mob/user)
	return // No accidental sprinting into open elevator shafts.

/obj/machinery/door/airlock/lift/allowed(mob/M)
	return FALSE //only the lift machinery is allowed to operate this door