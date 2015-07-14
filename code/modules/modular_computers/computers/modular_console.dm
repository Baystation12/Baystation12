/obj/machinery/modular_computer/console/
	name = "console"
	desc = "A stationary computer."
	enabled = 1
	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	icon_state_menu = "menu"
	var/keyboard_icon_state_menu = "keyboard13"
	battery_powered = 0
	anchored = 1
	density = 1

/obj/machinery/modular_computer/console/New()
	..()
	battery = null
	tesla_link = new/datum/computer_hardware/tesla_link(src)
	tesla_link.enabled = 1
	hard_drive = new/datum/computer_hardware/hard_drive/super(src) // Consoles generally have better HDDs due to lower space limitations


/obj/machinery/modular_computer/console/update_icon()
	icon_state = icon_state_unpowered

	overlays.Cut()
	if(!enabled)
		return
	if(active_program)
		overlays.Add(active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
		overlays.Add(active_program.keyboard_icon_state ? active_program.keyboard_icon_state : keyboard_icon_state_menu)
	else
		overlays.Add(icon_state_menu)