
/obj/machinery/slipspace_gen
	name = "Slipspace Generator"
	desc = "A device for thrusting the ship into the slipspace dimension."
	icon = 'code/modules/halo/icons/machinery/engine2.dmi'
	icon_state = "Still_Off"
	density = 1
	anchored = 1
	bound_x = 64
	bound_y = 64

/obj/machinery/slipspace_gen/New()
	. = ..()
	power_change()

/obj/machinery/slipspace_gen/power_change()
	. = ..()
	if(stat & NOPOWER)
		icon_state = "Still_Off"
	else if(stat & BROKEN)
		icon_state = "Destroyed"
	else
		icon_state = "Animated_On"
