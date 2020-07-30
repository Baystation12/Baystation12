
/obj/structure/shuttle_engine
	name = "Shuttle engine"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "propulsion"

/obj/structure/shuttle_heater
	name = "Shuttle heater"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "heater"

/obj/machinery/door/airlock/glass/cargo_shuttle
	door_color = COLOR_GOLD
	stripe_color = COLOR_SUN

/obj/machinery/door/airlock/glass/cargo_shuttle/unsc
	req_access = list(access_unsc_cargo)
