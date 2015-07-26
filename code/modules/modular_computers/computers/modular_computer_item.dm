// Modular microcomputer, currently only for tablets.
// This is mostly modified copypaste of modular_computer.dm. It is necessary as
// modular_computer MUST stay as machinery subtype, while this must be an item subtype
// as it's portable.

/obj/item/modular_computer
	name = "Modular Microcomputer"
	desc = "A small portable microcomputer"

	var/enabled = 1											// Whether the computer is turned on.
	var/open = 1											// Whether the computer is active/opened/it's screen is on.
	var/datum/computer_file/program/active_program = null	// A currently active program running on the computer.

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon = 'icons/obj/computer.dmi'
	icon_state = "laptop-open"
	var/icon_state_unpowered = null							// Icon state when the computer is turned off
	var/icon_state_menu = "menu"							// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.

	// Important hardware (must be installed for computer to work)
	var/datum/computer_hardware/network_card/network_card	// Network Card component of this computer. Allows connection to NTNet
	var/datum/computer_hardware/hard_drive/hard_drive		// Hard Drive component of this computer. Stores programs and files.
	var/obj/item/weapon/cell/battery = null					// Battery component of this computer. Powers the computer. Áll computers can have batteries.
	// Optional hardware (improves functionality, but is not critical for computer to work)
	var/datum/computer_hardware/card_slot/card_slot			// ID Card slot component of this computer. Mostly for HoP modification console that needs ID slot for modification.
	var/datum/computer_hardware/nano_printer/nano_printer	// Nano Printer component of this computer, for your everyday paperwork needs.

// Eject ID card from computer, if it has ID slot with card inside.
/obj/item/modular_computer/verb/eject_id()
	set name = "Eject ID"
	set category = "Object"
	set src in view(1)

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		usr << "<span class='warning'>You can't do that.</span>"
		return

	if(!Adjacent(usr))
		usr << "<span class='warning'>You can't reach it.</span>"
		return

	proc_eject_id(usr)

/obj/item/modular_computer/proc/proc_eject_id(mob/user)
	if(!user)
		user = usr

	if(!card_slot)
		user << "\The [src] does not have an ID card slot"
		return

	if(!card_slot.stored_card)
		user << "There is no card in \the [src]"
		return

	card_slot.stored_card.loc = src.loc
	card_slot.stored_card = null
	user << "You remove the card from \the [src]"

// TODO: Convert hardware creation specific stuff to vending machine that handles laptops.
/obj/item/modular_computer/New()
	network_card = new(src)
	hard_drive = new(src)
	battery = new(src)
	battery.maxcharge = 1000
	battery.charge = 1000

	hard_drive.stored_files.Add(new/datum/computer_file/program/alarm_monitor(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/power_monitor(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/atmos_control(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/rcon_console(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/suit_sensors(src))
	update_icon()
	..()

// Operates NanoUI
/obj/item/modular_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!open || !enabled)
		if(ui)
			ui.close()
		return 0
	if(!battery || !battery.charge)
		if(ui)
			ui.close()
		return 0

	// If we have an active program switch to it now.
	if(active_program)
		if(ui) // This is the main laptop screen. Since we are switching to program's UI close it for now.
			ui.close()
		active_program.ui_interact(user)
		return

	// We are still here, that means there is no program loaded. Load the BIOS/ROM/OS/whatever you want to call it.
	// This screen simply lists available programs and user may select them.
	if(!hard_drive || !hard_drive.stored_files || !hard_drive.stored_files.len)
		visible_message("\The [src] beeps three times, it's screen displaying \"DISK ERROR\" warning.")
		return // No HDD, No HDD files list or no stored files. Something is very broken.

	var/list/data = get_header_data()

	var/list/programs = list()
	for(var/datum/computer_file/program/P in hard_drive.stored_files)
		var/list/program = list()
		program["name"] = P.filename
		program["desc"] = P.filedesc
		programs.Add(list(program))

	data["programs"] = programs
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "laptop_mainscreen.tmpl", "NTOS-M Main Menu", 400, 500)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/item/modular_computer/attack_hand(mob/user)
	if(enabled)
		ui_interact(user)
	else if(battery && battery.charge) // Battery-run and charged or non-battery but powered by APC.
		user << "You press the power button and start up \the [src]"
		enabled = 1
		update_icon()
		ui_interact(user)
	else // Unpowered
		user << "You press the power button but \the [src] does not respond."

// Process currently calls handle_power(), may be expanded in future if more things are added.
/obj/item/modular_computer/process()
	if(!enabled) // The computer is turned off
		return 0

	if(active_program && active_program.requires_ntnet && !get_ntnet_status(active_program.requires_ntnet_feature)) // Active program requires NTNet to run but we've just lost connection. Crash.
		kill_program(1)
		visible_message("<span class='danger'>\The [src]'s screen briefly freezes and then shows \"NETWORK ERROR - NTNet connection lost. Please retry. If problem persists contact your system administrator.\" error.</span>")

	handle_power() // Handles all computer power interaction

// Function used by NanoUI's to obtain data for header. All relevant entries begin with "PC_"
/obj/item/modular_computer/proc/get_header_data()
	var/list/data = list()

	if(battery)
		switch(battery.percent())
			if(80 to 200) // 100 should be maximal but just in case..
				data["PC_batteryicon"] = "batt_100.gif"
			if(60 to 80)
				data["PC_batteryicon"] = "batt_80.gif"
			if(40 to 60)
				data["PC_batteryicon"] = "batt_60.gif"
			if(20 to 40)
				data["PC_batteryicon"] = "batt_40.gif"
			if(5 to 20)
				data["PC_batteryicon"] = "batt_20.gif"
			else
				data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "[round(battery.percent())] %"
		data["PC_showbatteryicon"] = 1
	else // Computer without battery shouldn't work at all, but in case we implement computers without batteries in future that run solely on APC network, it's here.
		data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "N/C"
		data["PC_showbatteryicon"] = battery ? 1 : 0

	switch(get_ntnet_status())
		if(0)
			data["PC_ntneticon"] = "sig_none.gif"
		if(1)
			data["PC_ntneticon"] = "sig_low.gif"
		if(2)
			data["PC_ntneticon"] = "sig_high.gif"

	data["PC_stationtime"] = worldtime2text()
	data["PC_hasheader"] = 1
	data["PC_showexitprogram"] = active_program ? 1 : 0 // Hides "Exit Program" button on mainscreen
	return data


// Relays kill program request to currently active program. Use this to quit current program.
/obj/item/modular_computer/proc/kill_program(var/forced = 0)
	if(active_program)
		active_program.kill_program(forced)
		active_program = null
	var/mob/user = usr
	if(user && istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.
	update_icon()

// Returns 0 for No Signal, 1 for Low Signal and 2 for Good Signal. 3 is for wired connection (always-on)
/obj/item/modular_computer/proc/get_ntnet_status(var/specific_action = 0)
	if(network_card)
		return network_card.get_signal(specific_action)
	else
		return 0

// Handles user's GUI input
/obj/item/modular_computer/Topic(href, href_list)
	if( href_list["PC_exit"] )
		kill_program()
		return
	if( href_list["PC_shutdown"] )
		kill_program(1)
		visible_message("\The [src] shuts down.")
		enabled = 0
		update_icon()
		return
	if( href_list["PC_runprogram"] )
		var/prog = href_list["PC_runprogram"]
		var/datum/computer_file/program/P = null
		var/mob/user = usr
		if(hard_drive)
			P = hard_drive.find_file_by_name(prog)

		if(!P || !istype(P)) // Program not found or it's not executable program.
			user << "<span class='danger'>\The [src]'s screen shows \"I/O ERROR - Unable to run program\" warning.</span>"
			return

		if(P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature)) // The program requires NTNet connection, but we are not connected to NTNet.
			user << "<span class='danger'>\The [src]'s screen shows \"NETWORK ERROR - Unable to connect to NTNet. Please retry. If problem persists contact your system administrator.\" warning.</span>"
			return
		if(P.run_program(user))
			active_program = P
			update_icon()
		return

// Used in following function to reduce copypaste
/obj/item/modular_computer/proc/power_failure()
	if(enabled) // Shut down the computer
		visible_message("<span class='danger'>\The [src]'s screen flickers \"BATTERY CRITICAL\" warning as it shuts down unexpectedly.</span>")
		kill_program(1)
		enabled = 0
		update_icon()

// Handles power-related things, such as battery interaction, recharging, shutdown when it's discharged
/obj/item/modular_computer/proc/handle_power()
	if(!battery || battery.charge <= 0) // Battery-run but battery is depleted.
		power_failure()
		return 0

	var/power_usage = open ? 50 : 5 // 50W when it's open and only 5W when closed (sleep mode)? Screen probably uses a lot.
	if(network_card && network_card.enabled)
		power_usage += network_card.power_usage

	if(hard_drive && hard_drive.enabled)
		power_usage += hard_drive.power_usage

	if(battery)
		battery.use(power_usage)

/obj/item/modular_computer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id)) // ID Card, try to insert it.
		var/obj/item/weapon/card/id/I = W
		if(!card_slot)
			user << "You try to insert \the [I] into \the [src], but it does not have an ID card slot installed."
			return

		if(card_slot.stored_card)
			user << "You try to insert \the [I] into \the [src], but it's ID card slot is occupied."
			return

		card_slot.stored_card = I
		I.loc = src
		user << "You insert \the [I] into \the [src]."
		return

	..()