/turf/unsimulated
	name = "command"
	initial_gas = list("oxygen" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)

/turf/unsimulated/proc/can_build_cable(var/mob/user)
	return 0

/turf/unsimulated/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/stack/cable_coil) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = thing
		coil.turf_place(src, user)
		return
	return ..()
