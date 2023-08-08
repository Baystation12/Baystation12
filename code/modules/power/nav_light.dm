/obj/machinery/nav_light
	name = "navigation light"
	desc = "A navigation light."
	icon = 'icons/obj/structures/nav_light.dmi'
	icon_state = "nav_light"
	color = "#f0f0f0"
	anchored = TRUE


/obj/machinery/nav_light/Initialize()
	. = ..()
	set_light(0.95, 2, 8, 2.5, color)


/obj/machinery/nav_light/powered()
	return TRUE


/obj/machinery/nav_light/port
	color = "#f02020"


/obj/machinery/nav_light/starboard
	color = "#20f020"


/obj/machinery/nav_light/dorsal
	color = "#2020f0"


/obj/machinery/nav_light/ventral
	color = "#e0c020"
