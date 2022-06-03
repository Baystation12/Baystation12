/obj/machinery/atmospherics/unary/heat_exchanger

	icon = 'icons/obj/atmospherics/heat_exchanger.dmi'
	icon_state = "intact"
	density = TRUE

	name = "Heat Exchanger"
	desc = "Exchanges heat between two input gases. Setup for fast heat transfer."

	var/obj/machinery/atmospherics/unary/heat_exchanger/partner = null
	var/update_cycle

	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "heunary"


/obj/machinery/atmospherics/unary/heat_exchanger/on_update_icon()
	if(node)
		icon_state = "intact"
	else
		icon_state = "exposed"


/obj/machinery/atmospherics/unary/heat_exchanger/atmos_init()
	..()
	if(!partner)
		var/partner_connect = turn(dir,180)
		for(var/obj/machinery/atmospherics/unary/heat_exchanger/target in get_step(src,partner_connect))
			if(target.dir & get_dir(src,target))
				partner = target
				partner.partner = src
				break
	..()


/obj/machinery/atmospherics/unary/heat_exchanger/Process()
	..()
	if(!partner)
		return 0

	if(SSair.times_fired <= update_cycle)
		return 0

	update_cycle = SSair.times_fired
	partner.update_cycle = SSair.times_fired

	var/air_heat_capacity = air_contents.heat_capacity()
	var/other_air_heat_capacity = partner.air_contents.heat_capacity()
	var/combined_heat_capacity = other_air_heat_capacity + air_heat_capacity

	var/old_temperature = air_contents.temperature
	var/other_old_temperature = partner.air_contents.temperature

	if(combined_heat_capacity > 0)
		var/combined_energy = partner.air_contents.temperature*other_air_heat_capacity + air_heat_capacity*air_contents.temperature

		var/new_temperature = combined_energy/combined_heat_capacity
		air_contents.temperature = new_temperature
		partner.air_contents.temperature = new_temperature

	if(network)
		if(abs(old_temperature-air_contents.temperature) > 1)
			network.update = 1

	if(partner.network)
		if(abs(other_old_temperature-partner.air_contents.temperature) > 1)
			partner.network.update = 1
	return 1


/obj/machinery/atmospherics/unary/heat_exchanger/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(!isWrench(W))
		return ..()
	var/turf/T = src.loc
	if (level==1 && isturf(T) && !T.is_plating())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it is too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, src)
		qdel(src)
