/obj/machinery/modular_computer/console/
	name = "console"
	desc = "A stationary computer."
	enabled = 1

	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	screen_icon_state_menu = "menu"
	keyboard_icon_state_menu = "kb_menu"
	hardware_flag = PROGRAM_CONSOLE
	anchored = 1
	density = 1

/obj/machinery/modular_computer/console/New()
	battery = null
	network_card = new/datum/computer_hardware/network_card/wired(src)
	tesla_link = new/datum/computer_hardware/tesla_link(src)
	tesla_link.enabled = 1
	tesla_link.critical = 1 // Consoles don't usually come with cells, and this prevents people from disabling their only power source, as they wouldn't be able to enable it again.
	hard_drive = new/datum/computer_hardware/hard_drive/super(src) // Consoles generally have better HDDs due to lower space limitations
	..()
	update_icon()