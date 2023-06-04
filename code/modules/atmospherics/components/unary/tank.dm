/obj/machinery/atmospherics/unary/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	var/volume = 10000 //in liters, 1 meters by 1 meters by 2 meters ~tweaked it a little to simulate a pressure tank without needing to recode them yet
	var/start_pressure = 25*ONE_ATMOSPHERE
	var/filling // list of gas ratios to use.

	level = ATOM_LEVEL_UNDER_TILE
	dir = 2
	initialize_directions = 2
	density = TRUE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	pipe_class = PIPE_CLASS_UNARY

	build_icon = 'icons/atmos/tank.dmi'
	build_icon_state = "air"
	colorable = TRUE
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED

/obj/machinery/atmospherics/unary/tank/Initialize()
	. = ..()

	air_contents.volume = volume

	if(filling)
		air_contents.temperature = T20C

		var/list/gases = list()
		for(var/gas in filling)
			gases += gas
			gases += start_pressure * filling[gas] * (air_contents.volume)/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
		air_contents.adjust_multi(arglist(gases))
		update_icon()

/obj/machinery/atmospherics/unary/tank/set_initial_level()
	level = ATOM_LEVEL_UNDER_TILE // Always on top, apparently.

// required for paint sprayers to work due to an override in pipes.dm
/obj/machinery/atmospherics/unary/tank/set_color(new_color)
	color = new_color
	icon_state = "air"

/obj/machinery/atmospherics/unary/tank/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/unary/tank/hide()
	update_underlays()

/obj/machinery/atmospherics/unary/tank/return_air()
	return air_contents

/obj/machinery/atmospherics/unary/tank/attackby(obj/item/W as obj, mob/user as mob)
	if(isWrench(W))
		if (air_contents.return_pressure() > 2*ONE_ATMOSPHERE)
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
			add_fingerprint(user)
			return 1

		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))

		if (do_after(user, (W.toolspeed * 4) SECONDS, src, DO_REPAIR_CONSTRUCT))
			user.visible_message(SPAN_NOTICE("\The [user] unfastens \the [src]."), SPAN_NOTICE("You have unfastened \the [src]."), "You hear a ratchet.")
			new /obj/item/pipe/tank(loc, src)
			qdel(src)

/obj/machinery/atmospherics/unary/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air"
	filling = list(GAS_OXYGEN = O2STANDARD, GAS_NITROGEN = N2STANDARD)

/obj/machinery/atmospherics/unary/tank/oxygen
	name = "Pressure Tank (Oxygen)"
	icon_state = "o2"
	filling = list(GAS_OXYGEN = 1)

/obj/machinery/atmospherics/unary/tank/nitrogen
	name = "Pressure Tank (Nitrogen)"
	icon_state = "n2"
	filling = list(GAS_NITROGEN = 1)

/obj/machinery/atmospherics/unary/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2"
	filling = list(GAS_CO2 = 1)

/obj/machinery/atmospherics/unary/tank/phoron
	name = "Pressure Tank (Phoron)"
	icon_state = "phoron"
	filling = list(GAS_PHORON = 1)

/obj/machinery/atmospherics/unary/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o"
	filling = list(GAS_N2O = 1)

/obj/machinery/atmospherics/unary/tank/hydrogen
	name = "Pressure Tank (Hydrogen)"
	icon_state = "h2"
	filling = list(GAS_HYDROGEN = 1)

/obj/item/pipe/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air"
	name =  "Pressure Tank"
	desc = "A large vessel containing pressurized gas."
	color =  PIPE_COLOR_WHITE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	w_class = ITEM_SIZE_HUGE
	level = ATOM_LEVEL_UNDER_TILE
	dir = SOUTH
	constructed_path = /obj/machinery/atmospherics/unary/tank
	pipe_class = PIPE_CLASS_UNARY
