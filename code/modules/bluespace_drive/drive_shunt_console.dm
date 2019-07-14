/obj/machinery/power/shunt/console
	name = "access console"
	desc = "An access console integrated into a bluespace drive power shunt."
	icon_state = "drive_console"

/obj/machinery/power/shunt/console/proc/check_can_jump(var/mob/user, var/x_target, var/y_target, var/silent = FALSE)
	if(!drive)
		if(!silent)
			to_chat(user, SPAN_WARNING("\The [src] is not connected to a drive core. Jumps are not possible."))
		return FALSE
	var/obj/effect/overmap/our_object = map_sectors["[z]"]
	if(!our_object)
		if(!silent)
			to_chat(user, SPAN_WARNING("The ship must be in open space to begin plotting a jump."))
		return FALSE
	if(x_target && y_target)
		var/turf/T = locate(x_target, y_target, our_object.z)
		if(!istype(T))
			if(!silent)
				to_chat(user, SPAN_WARNING("The ship must be in open space to begin plotting a jump."))
			return FALSE
	return TRUE

/obj/machinery/power/shunt/console/attack_hand(mob/user)
	if(!check_can_jump(user))
		return
	var/x_target = input(user, "Enter x coord.", "Plot Jump") as num|null
	if(!x_target)
		return
	var/y_target = input(user, "Enter y coord.", "Plot Jump") as num|null
	if(!y_target)
		return
	if(!check_can_jump(user, x_target, y_target))
		return
	//drive.begin_jump(x_target, y_target)
