// Console itself
/obj/machinery/modular_computer/console/
	name = "console"
	desc = "A stationary computer."
	enabled = 1
	icon = 'icons/obj/computer3.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	icon_state_menu = "menu"
	battery_powered = 0
	anchored = 1
	density = 1

/obj/machinery/modular_computer/console/New()
	..()
	battery = null
	tesla_link.enabled = 1

/obj/machinery/modular_computer/console/update_icon()
	icon_state = icon_state_unpowered

	overlays.Cut()
	if(!enabled)
		return
	if(active_program)
		overlays.Add(active_program.laptop_icon_state ? active_program.laptop_icon_state : icon_state_menu)
	else
		overlays.Add(icon_state_menu)