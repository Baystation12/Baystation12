
/obj/machinery/slipspace_engine_longrange
	name = "Long Range Slipspace Traversal Drive"
	desc = "A device for thrusting the ship into the slipspace dimension to travel to distant star systems."
	icon = 'code/modules/halo/icons/machinery/covenant/slipspace_drive.dmi'
	icon_state = "slipspace"
	bounds = "64,64"
	icon_state = "Still_Off"
	density = 1
	anchored = 1
	bound_x = 64
	bound_y = 64

/obj/machinery/slipspace_engine_longrange/New()
	. = ..()
	power_change()

/obj/machinery/slipspace_engine_longrange/power_change()
	. = ..()
	if(stat & NOPOWER)
		icon_state = "Still_Off"
	else if(stat & BROKEN)
		icon_state = "Destroyed"
	else
		icon_state = "Animated_On"
