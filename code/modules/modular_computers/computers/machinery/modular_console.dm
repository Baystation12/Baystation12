/obj/machinery/modular_computer/console/
	name = "console"
	desc = "A stationary computer."
	enabled = 1

	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	screen_icon_state_menu = "menu"
	keyboard_icon_state_menu = "kb_menu"
	anchored = 1
	density = 1

/obj/machinery/modular_computer/console/New()
	..()
	battery = null
	network_card = new/datum/computer_hardware/network_card/wired(src)
	tesla_link = new/datum/computer_hardware/tesla_link(src)
	tesla_link.enabled = 1
	hard_drive = new/datum/computer_hardware/hard_drive/super(src) // Consoles generally have better HDDs due to lower space limitations
	install_default_programs() // Consoles come with set of department-specific programs when constructed.