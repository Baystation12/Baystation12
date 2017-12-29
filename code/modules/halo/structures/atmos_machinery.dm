
/obj/machinery/atmospherics/unary/vent_pump/hangar_vent
	name = "Hangar Airlock Vent"
	power_rating = 200000
	//pump_efficiency = 1000		//default is 2.5 | Not entirely sure what this does. Causes errors though.

/obj/machinery/atmospherics/unary/vent_pump/hangar_vent/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800


/obj/machinery/atmospherics/pipe/tank/empty
	start_pressure = 0
