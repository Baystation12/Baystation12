/obj/machinery/atmospherics/unary/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	var/volume = 10000 //in liters, 1 meters by 1 meters by 2 meters ~tweaked it a little to simulate a pressure tank without needing to recode them yet
	var/start_pressure = 25*ONE_ATMOSPHERE
	var/filling // list of gas ratios to use.

	var/datum/gas_mixture/air_temporary // used when reconstructing a pipeline that broke
	var/datum/pipeline/parent

	level = 1
	dir = 2
	initialize_directions = 2
	density = 1
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	pipe_class = PIPE_CLASS_UNARY

	build_icon = 'icons/atmos/tank.dmi'
	build_icon_state = "air"

/obj/machinery/atmospherics/unary/tank/New()
	if(filling)
		air_temporary = new
		air_temporary.volume = volume
		air_temporary.temperature = T20C

		var/list/gases = list()
		for(var/gas in filling)
			gases += gas
			gases += start_pressure * filling[gas] * (air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)
		air_temporary.adjust_multi(arglist(gases))
		update_icon()
	..()

/obj/machinery/atmospherics/unary/tank/set_initial_level()
	level = 1 // Always on top, apparently.

/obj/machinery/atmospherics/unary/tank/Initialize()
	atmos_init()
	build_network()
	if(node)
		node.atmos_init()
		node.build_network()

	. = ..()

/obj/machinery/atmospherics/unary/tank/Process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/unary/tank/Destroy()
	if(node)
		node.disconnect(src)

	. = ..()

/obj/machinery/atmospherics/unary/tank/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/unary/tank/hide()
	update_underlays()

/obj/machinery/atmospherics/unary/tank/atmos_init()
	..()
	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node = target
				break

	update_underlays()

/obj/machinery/atmospherics/unary/tank/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node)
		if(istype(node, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node = null

	update_underlays()

	return null

/obj/machinery/atmospherics/unary/tank/return_air()
	return air_contents

/obj/machinery/atmospherics/unary/tank/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/device/pipe_painter))
		return

	if(isWrench(W))		
		if (air_contents.return_pressure() > 2*ONE_ATMOSPHERE)
			to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it is too exerted due to internal pressure.</span>")
			add_fingerprint(user)
			return 1

		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")

		if (do_after(user, 40, src))
			user.visible_message("<span class='notice'>\The [user] unfastens \the [src].</span>", "<span class='notice'>You have unfastened \the [src].</span>", "You hear a ratchet.")		
			new /obj/item/pipe(src, src)
			qdel(src)

/obj/machinery/atmospherics/unary/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air"
	filling = list("oxygen" = O2STANDARD, "nitrogen" = N2STANDARD)

/obj/machinery/atmospherics/unary/tank/oxygen
	name = "Pressure Tank (Oxygen)"
	icon_state = "o2"
	filling = list("oxygen" = 1)

/obj/machinery/atmospherics/unary/tank/nitrogen
	name = "Pressure Tank (Nitrogen)"
	icon_state = "n2"
	filling = list("nitrogen" = 1)

/obj/machinery/atmospherics/unary/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2"
	filling = list("carbon_dioxide" = 1)

/obj/machinery/atmospherics/unary/tank/phoron
	name = "Pressure Tank (Phoron)"
	icon_state = "phoron"
	filling = list("phoron" = 1)

/obj/machinery/atmospherics/unary/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o"
	filling = list("sleeping_agent" = 1)

/obj/machinery/atmospherics/unary/tank/hydrogen
	name = "Pressure Tank (Hydrogen)"
	icon_state = "h2"
	filling = list("hydrogen" = 1)

/obj/item/pipe/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air"
	name =  "Pressure Tank"
	desc = "A large vessel containing pressurized gas."
	color =  PIPE_COLOR_WHITE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL	
	w_class = ITEM_SIZE_HUGE
	level = 1
	dir = SOUTH
	constructed_path = /obj/machinery/atmospherics/unary/tank
	pipe_class = PIPE_CLASS_UNARY