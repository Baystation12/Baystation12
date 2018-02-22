/obj/machinery/atmospherics/proc/get_internal_pressure()
	var/datum/gas_mixture/int_air = return_air()
	return int_air.return_pressure()

/obj/machinery/atmospherics/proc/Unsecure(var/obj/item/weapon/W, var/mob/user)
	if(!isWrench(W) && !isJack(W))
		return 0
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((get_internal_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it is too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		if(isJack(W))
			to_chat(user, "<span class='warning'>But you try it anyways..</span>")
		else
			return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, STANDARD_UNWRENCH_DELAY, src))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)
	return 1
