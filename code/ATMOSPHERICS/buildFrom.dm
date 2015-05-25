/*
/obj/machinery/atmospherics/proc/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	error("[src] does not define a buildFrom!")
	return FALSE
*/


/obj/machinery/atmospherics/pipe/buildFrom(var/mob/user,var/obj/item/pipe/pipe)
/*
	for(var/obj/machinery/atmospherics/M in src.loc)

		var/list/A = generate_initialize_directions(init_dirs)
		var/list/B = generate_initialize_directions(M.init_dirs)

		var/find = 0

		for(var/DA in A)
			if(find == 0)
				for(var/DB in B)
					if(DB == DA && find == 0)
						find = 1

		if((find != 0) && M.check_connect_types(M,src))	// matches at least one direction on either type of pipe & same connection type
			user << "\red There is already a pipe of the same type at this location."
			return 0
*/
	color = pipe.color
	pipe_color = pipe.color
	set_dir(pipe.dir)
	if (pipe.pipename)
		name = pipe.pipename
	var/turf/T = pipe.loc
	level = T.intact ? 2 : 1
	return 1


/obj/machinery/atmospherics/pipe/simple/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/simple/hidden/supply/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/universal/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/simple/heat_exchanging/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	set_dir(pipe.dir)
	return 1


/obj/machinery/atmospherics/unary/portables_connector/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/manifold/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/manifold/hidden/supply/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/manifold4w/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/unary/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/unary/portables_connector/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/unary/vent_pump/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/binary/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/binary/valve/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/binary/pump/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/trinary/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/trinary/filter/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/trinary/mixer/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/trinary/filter/m_filter/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/trinary/mixer/t_mixer/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/trinary/mixer/m_mixer/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/unary/vent_scrubber/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/simple/insulated/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/trinary/tvalve/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/tvalve/mirrored/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/cap/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/cap/hidden/supply/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/binary/passive_gate/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/binary/pump/high_power/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/unary/heat_exchanger/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/zpipe/up/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/zpipe/down/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/zpipe/up/supply/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/zpipe/down/supply/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/zpipe/up/scrubbers/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/pipe/zpipe/down/scrubbers/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/omni/mixer/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/omni/mixer/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()


/obj/machinery/atmospherics/omni/filter/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	return ..()