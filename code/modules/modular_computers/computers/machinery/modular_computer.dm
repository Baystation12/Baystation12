// Modular Computer - device that runs various programs and operates with hardware
// DO NOT SPAWN THIS TYPE. Use /laptop/ or /console/ instead.
/obj/machinery/modular_computer/
	name = "modular computer"
	desc = "An advanced computer"

	var/open = 1											// Whether the computer is open. (0 = "low power" mode)
	var/enabled = 1											// Whether the computer is turned on.
	var/datum/computer_file/program/active_program = null	// A currently active program running on the computer.
	var/battery_powered = 0									// Whether computer should be battery powered. It is set automatically
	use_power = 0
	var/hardware_flag = 0									// A flag that describes this device type
	var/last_power_usage = 0								// Power usage during last tick

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon = null
	icon_state = null
	var/icon_state_unpowered = null							// Icon state when the computer is turned off
	var/screen_icon_state_menu = "menu"						// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/keyboard_icon_state_menu = "keyboard1"				// Keyboard's icon state overlay when the computer is turned on and no program is loaded

	// Important hardware (must be installed for computer to work)
	var/datum/computer_hardware/network_card/network_card	// Network Card component of this computer. Allows connection to NTNet
	var/datum/computer_hardware/hard_drive/hard_drive		// Hard Drive component of this computer. Stores programs and files.
	var/obj/item/weapon/cell/battery = null					// Battery component of this computer. Powers the computer. Áll computers can have batteries.
	// Optional hardware (improves functionality, but is not critical for computer to work)
	var/datum/computer_hardware/tesla_link/tesla_link		// Tesla Link component of this computer. Allows remote charging from nearest APC.
	var/datum/computer_hardware/card_slot/card_slot			// ID Card slot component of this computer. Mostly for HoP modification console that needs ID slot for modification.
	var/datum/computer_hardware/nano_printer/nano_printer	// Nano Printer component of this computer, for your everyday paperwork needs.

	var/obj/item/modular_computer/processor/cpu = null		// CPU that handles most logic while this type only handles power and other specific things.

/obj/machinery/modular_computer/update_icon()
	icon_state = icon_state_unpowered
	overlays.Cut()

	if(!enabled)
		return
	if(cpu && cpu.active_program)
		overlays.Add(cpu.active_program.program_icon_state ? cpu.active_program.program_icon_state : screen_icon_state_menu)
		overlays.Add(cpu.active_program.keyboard_icon_state ? cpu.active_program.keyboard_icon_state : keyboard_icon_state_menu)
	else
		overlays.Add(screen_icon_state_menu)
		overlays.Add(keyboard_icon_state_menu)

// Eject ID card from computer, if it has ID slot with card inside.
/obj/machinery/modular_computer/verb/eject_id()
	set name = "Eject ID"
	set category = "Object"
	set src in view(1)

	cpu.eject_id()

// Called after the computer is completed (in case it is created step by step, for example via laptop fabricator)
// This allows the device to work and creates processor object that handles most logic.
// ALWAYS CALL THIS ONCE ALL OTHER VARIABLES ARE SET, NOT BEFORE. IT MAY BE ONLY CALLED ONCE.
/obj/machinery/modular_computer/proc/shift_to_cpu()
	if(cpu) // We already called this. Abort.
		return
	new/obj/item/modular_computer/processor(src) // It automatically handles everything in New()


/obj/machinery/modular_computer/New()
	..()
	install_default_programs()

// Installs programs necessary for computer function.
// TODO: Implement program for downloading of other programs, and replace hardcoded program addition here
/obj/machinery/modular_computer/proc/install_default_programs()
	if(cpu && cpu.hard_drive)
		cpu.hard_drive.store_file(new/datum/computer_file/program/computerconfig(src)) // Computer configuration utility, allows hardware control and displays more info than status bar

		//TODO: Remove once downloading is implemented
		cpu.hard_drive.store_file(new/datum/computer_file/program/alarm_monitor(src))
		cpu.hard_drive.store_file(new/datum/computer_file/program/power_monitor(src))
		cpu.hard_drive.store_file(new/datum/computer_file/program/atmos_control(src))
		cpu.hard_drive.store_file(new/datum/computer_file/program/rcon_console(src))
		cpu.hard_drive.store_file(new/datum/computer_file/program/suit_sensors(src))
	else if(hard_drive)
		hard_drive.store_file(new/datum/computer_file/program/computerconfig(src)) // Computer configuration utility, allows hardware control and displays more info than status bar

		//TODO: Remove once downloading is implemented
		hard_drive.store_file(new/datum/computer_file/program/alarm_monitor(src))
		hard_drive.store_file(new/datum/computer_file/program/power_monitor(src))
		hard_drive.store_file(new/datum/computer_file/program/atmos_control(src))
		hard_drive.store_file(new/datum/computer_file/program/rcon_console(src))
		hard_drive.store_file(new/datum/computer_file/program/suit_sensors(src))

// Operates NanoUI
/obj/machinery/modular_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(cpu)
		cpu.ui_interact(user, ui_key, ui, force_open)

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/machinery/modular_computer/attack_hand(mob/user)
	if(!cpu) // If people started clicking us we're probably spawned for a while now. Generate the CPU datum.
		shift_to_cpu()
		if(!cpu) // Still no CPU? Something is very bad. Abort.
			return
	if(cpu.enabled)
		ui_interact(user)
	else if((cpu.battery && cpu.battery.charge > 0) || (!cpu.battery && powered())) // Battery-run and charged or non-battery but powered by APC.
		user << "You press the power button and start up \the [src]"
		cpu.enabled = 1
		update_icon()
		ui_interact(user)
	else // Unpowered
		user << "You press the power button but \the [src] does not respond."

// Process currently calls handle_power(), may be expanded in future if more things are added.
/obj/machinery/modular_computer/process()
	if(!cpu.enabled) // The computer is turned off
		use_power = 0
		last_power_usage = 0
		return 0

	if(!cpu) // The computer lacks CPU object
		return 0

	if(cpu.active_program && cpu.active_program.requires_ntnet && !cpu.get_ntnet_status(cpu.active_program.requires_ntnet_feature)) // Active program requires NTNet to run but we've just lost connection. Crash.
		cpu.kill_program(1)
		visible_message("<span class='danger'>\The [src]'s screen briefly freezes and then shows \"NETWORK ERROR - NTNet connection lost. Please retry. If problem persists contact your system administrator.\" error.</span>")

	battery_powered = battery ? 1 : 0

	handle_power() // Handles all computer power interaction

// Function used by NanoUI's to obtain data for header. All relevant entries begin with "PC_"
/obj/machinery/modular_computer/proc/get_header_data()
	if(cpu)
		return cpu.get_header_data()
	else
		return list()


// Relays kill program request to currently active program. Use this to quit current program.
/obj/machinery/modular_computer/proc/kill_program(var/forced = 0)
	if(cpu)
		cpu.kill_program(forced)
	update_icon()

// Returns 0 for No Signal, 1 for Low Signal and 2 for Good Signal. 3 is for wired connection (always-on)
/obj/machinery/modular_computer/proc/get_ntnet_status(var/specific_action = 0)
	if(cpu)
		cpu.get_ntnet_status(specific_action)

// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null
/obj/machinery/modular_computer/proc/find_hardware_by_name(var/N)
	if(tesla_link && (tesla_link.name == N))
		return tesla_link
	return null

// Handles user's GUI input
/obj/machinery/modular_computer/Topic(href, href_list)
	if(..())
		return 1
	if(cpu)
		return cpu.Topic(href, href_list)


// Used in following function to reduce copypaste
/obj/machinery/modular_computer/proc/power_failure()
	if(cpu && cpu.enabled) // Shut down the computer
		visible_message("<span class='danger'>\The [src]'s screen flickers [battery ? "\"BATTERY CRITICAL\"" : "\"EXTERNAL POWER LOSS\""] warning as it shuts down unexpectedly.</span>")
		kill_program(1)
		enabled = 0
		update_icon()
	stat |= NOPOWER

// Handles power-related things, such as battery interaction, recharging, shutdown when it's discharged, NOPOWER flag, etc.
/obj/machinery/modular_computer/proc/handle_power()
	if(!cpu)
		return 0
	if(cpu.battery && cpu.battery.charge <= 0) // Battery-run but battery is depleted.
		power_failure()
		return 0
	else if(!cpu.battery && (!powered() || !tesla_link || !tesla_link.enabled)) // Not battery run, but lacking APC connection.
		power_failure()
		return 0
	else if(stat & NOPOWER)
		stat &= ~NOPOWER

	var/power_usage = open ? 300 : 25 // 300W when it's open and only 25W when closed (sleep mode)? Screen probably uses a lot.
	if(cpu.network_card && cpu.network_card.enabled)
		power_usage += cpu.network_card.power_usage

	if(cpu.hard_drive && cpu.hard_drive.enabled)
		power_usage += cpu.hard_drive.power_usage

	if(cpu.nano_printer && cpu.nano_printer.enabled)
		power_usage += cpu.nano_printer.power_usage

	if(cpu.card_slot && cpu.card_slot.enabled)
		power_usage += cpu.card_slot.power_usage

	// Wireless APC connection exists.
	if(tesla_link && tesla_link.enabled)
		idle_power_usage = power_usage
		active_power_usage = idle_power_usage + 100 	// APCLink only charges at 100W rate, but covers any power usage.
		use_power = 1
		// Battery is not fully charged. Begin slowly recharging.
		if(cpu.battery && cpu.battery.charge < cpu.battery.maxcharge)
			use_power = 2

		if(cpu.battery && powered() && (use_power == 2)) // Battery charging itself
			cpu.battery.give(100 * CELLRATE)
		else if(cpu.battery && !powered()) // Unpowered, but battery covers the usage.
			cpu.battery.use(idle_power_usage * CELLRATE)

	else	// No wireless connection run only on battery.
		use_power = 0
		if (cpu.battery)
			cpu.battery.use(power_usage * CELLRATE)
	cpu.last_power_usage = power_usage

// Modular computers can have battery in them, we handle power in previous proc, so prevent this from messing it up for us.
/obj/machinery/modular_computer/power_change()
	if(battery_powered)
		return
	else
		..()

/obj/machinery/modular_computer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id)) // ID Card, try to insert it.
		var/obj/item/weapon/card/id/I = W
		if(!cpu.card_slot)
			user << "You try to insert \the [I] into \the [src], but it does not have an ID card slot installed."
			return

		if(cpu.card_slot.stored_card)
			user << "You try to insert \the [I] into \the [src], but it's ID card slot is occupied."
			return

		cpu.card_slot.stored_card = I
		I.forceMove(src)
		user << "You insert \the [I] into \the [src]."
		return

	..()
