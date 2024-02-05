GLOBAL_VAR(station_gravity_generator)
/obj/machinery/gravity_generator/main/station/Initialize(mapload, ...)
	. = ..()
	GLOB.station_gravity_generator = src
	if(!mapload)
		update_connectected_areas_gravity()


/obj/machinery/gravity_generator/main/station/Destroy()
	if(GLOB.station_gravity_generator == src)
		GLOB.station_gravity_generator = null
	return ..()
