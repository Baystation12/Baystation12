// Same code as for a human clicking on a door
/obj/machinery/door/airlock/attack_robot(mob/user as mob)
	if(src.operating) return

	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return

	if(src.density)
		do_animate("deny")
	return