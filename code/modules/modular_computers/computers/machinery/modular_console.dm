/obj/machinery/modular_computer/console/
	name = "console"
	desc = "A stationary computer."

	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	screen_icon_state_menu = "menu"
	keyboard_icon_state_menu = "kb_menu"
	hardware_flag = PROGRAM_CONSOLE
	var/console_department = "" // Used in New() to set network tag according to our area.
	anchored = 1
	density = 1
	base_idle_power_usage = 100
	base_active_power_usage = 500

/obj/machinery/modular_computer/console/New()
	..()
	battery = null
	cpu.network_card = new/datum/computer_hardware/network_card/wired(src)
	tesla_link = new/datum/computer_hardware/tesla_link(src)
	tesla_link.enabled = 1
	tesla_link.critical = 1 // Consoles don't usually come with cells, and this prevents people from disabling their only power source, as they wouldn't be able to enable it again.
	cpu.hard_drive = new/datum/computer_hardware/hard_drive/super(src) // Consoles generally have better HDDs due to lower space limitations
	var/area/A = get_area(src)
	// Attempts to set this console's tag according to our area. Since some areas have stuff like "XX - YY" in their names we try to remove that too.
	if(A && console_department)
		cpu.network_card.identification_string = replacetext(replacetext(replacetext("[A.name] [console_department] Console", " ", "_"), "-", ""), "__", "_") // Replace spaces with "_"
	else if(A)
		cpu.network_card.identification_string = replacetext(replacetext(replacetext("[A.name] Console", " ", "_"), "-", ""), "__", "_")
	else if(console_department)
		cpu.network_card.identification_string = replacetext(replacetext(replacetext("[console_department] Console", " ", "_"), "-", ""), "__", "_")
	else
		cpu.network_card.identification_string = "Unknown Console"
	if(cpu)
		cpu.screen_on = 1
		cpu.enabled = 1
	install_default_programs()
	update_icon()

/obj/machinery/modular_computer/console/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/cell)) // Power Cell. Try to insert it into the console, if it doesn't have cell installed.
		if(!cpu || (stat & (BROKEN|MAINT)))
			user << "\The [cpu] seems to be broken."
			return
		if(cpu.battery)
			user << "You try to insert \the [W] into \the [cpu], but it't battery slot is occupied."
			return
		cpu.battery = W
		user.drop_from_inventory(W)
		W.forceMove(src)
		user << "You insert \the [W] into \the [cpu]'s battery slot."
		return
	if(istype(W, /obj/item/weapon/screwdriver)) // TODO: Screwdriver - begin deconstructing the computer.
		return
	if(istype(W, /obj/item/weapon/crowbar)) // Crowbar, remove power cell, if it has one.
		if(!cpu || (stat & (BROKEN|MAINT)))
			user << "\The [cpu] seems to be broken."
			return
		if(!cpu.battery)
			user << "\The [cpu] doesn't seem to have battery installed."
			return
		user << "You begin removing \the [cpu.battery] from \the [cpu]."
		if(do_after(user, 20))
			cpu.battery.forceMove(get_turf(src))
			user << "You crowbar \the [cpu.battery] from \the [cpu]."
			cpu.battery = null
			battery_powered = 0
			power_change()
		return
	return ..()