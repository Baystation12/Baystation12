/obj/item/device/assembly/meter
	name = "pressure metre"
	desc = "A device capable of meauring pressure in a pipe."
	icon_state = "speaker"
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "waste" = 100)
	origin_tech = "magnets=2"

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

	var/obj/machinery/atmospherics/pipe/target = null

	activate()
		var/datum/gas_mixture/environment
		if(target)
			environment = target.return_air()
		else
			var/turf/T = get_turf(src.loc)
			if(T) environment = T.return_air()
		if(!environment)
			return 0

		var/env_pressure = environment.return_pressure()
		return send_data(list(env_pressure))

	anchored(var/anchored = 0)
		if(anchored)
			for(var/obj/machinery/atmospherics/pipe/P in src.loc)
			target = locate(/obj/machinery/atmospherics/pipe) in get_turf(src)
		else if(target)
			target = null
		return 1

