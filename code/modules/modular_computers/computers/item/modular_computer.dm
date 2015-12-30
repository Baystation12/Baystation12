// This is the base type that does all the hardware stuff.
// Other types expand it - tablets use a direct subtypes, and
// consoles and laptops use "procssor" item that is held inside machinery piece
/obj/item/modular_computer
	name = "Modular Microcomputer"
	desc = "A small portable microcomputer"

	var/enabled = 0											// Whether the computer is turned on.
	var/screen_on = 1										// Whether the computer is active/opened/it's screen is on.
	var/datum/computer_file/program/active_program = null	// A currently active program running on the computer.
	var/hardware_flag = 0									// A flag that describes this device type
	var/last_power_usage = 0
	var/computer_emagged = 0								// Whether the computer is emagged.

	var/base_active_power_usage = 50						// Power usage when the computer is open (screen is active) and can be interacted with. Remember hardware can use power too.
	var/base_idle_power_usage = 5							// Power usage when the computer is idle and screen is off (currently only applies to laptops)

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon = 'icons/obj/computer.dmi'
	icon_state = "laptop-open"
	var/icon_state_unpowered = null							// Icon state when the computer is turned off
	var/icon_state_menu = "menu"							// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/max_hardware_size = 0								// Maximal hardware size. Currently, tablets have 1, laptops 2 and consoles 3. Limits what hardware types can be installed.
	var/steel_sheet_cost = 5								// Amount of steel sheets refunded when disassembling an empty frame of this computer.


	// Important hardware (must be installed for computer to work)
	var/obj/item/weapon/computer_hardware/network_card/network_card					// Network Card component of this computer. Allows connection to NTNet
	var/obj/item/weapon/computer_hardware/hard_drive/hard_drive						// Hard Drive component of this computer. Stores programs and files.
	var/obj/item/weapon/computer_hardware/battery_module/battery_module				// An internal power source for this computer. Can be recharged.
	// Optional hardware (improves functionality, but is not critical for computer to work)
	var/obj/item/weapon/computer_hardware/card_slot/card_slot						// ID Card slot component of this computer. Mostly for HoP modification console that needs ID slot for modification.
	var/obj/item/weapon/computer_hardware/nano_printer/nano_printer					// Nano Printer component of this computer, for your everyday paperwork needs.
	var/obj/item/weapon/computer_hardware/hard_drive/portable/portable_drive		// Portable data storage


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

	card_slot.stored_card.forceMove(get_turf(src))
	card_slot.stored_card = null
	user << "You remove the card from \the [src]"

/obj/item/modular_computer/emag_act(var/remaining_charges, var/mob/user)
	if(computer_emagged)
		user << "\The [src] was already emagged."
		return NO_EMAG_ACT
	else
		computer_emagged = 1
		user << "You emag \the [src]. It's screen briefly shows a \"OVERRIDE ACCEPTED: New software downloads available.\" message."
		return 1

/obj/item/modular_computer/New()
	processing_objects.Add(src)
	update_icon()
	..()

/obj/item/modular_computer/Destroy()
	kill_program(1)
	processing_objects.Remove(src)
	for(var/obj/item/weapon/computer_hardware/CH in src.get_all_components())
		qdel(CH)
	..()

/obj/item/modular_computer/update_icon()
	icon_state = icon_state_unpowered

	overlays.Cut()
	if(!enabled)
		return
	if(active_program)
		overlays.Add(active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
	else
		overlays.Add(icon_state_menu)

// Used by child types if they have other power source than battery
/obj/item/modular_computer/proc/check_power_override()
	return 0

// Operates NanoUI
/obj/item/modular_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!screen_on || !enabled)
		if(ui)
			ui.close()
		return 0
	if((!battery_module || !battery_module.battery.charge) && !check_power_override())
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
		ui = new(user, src, ui_key, "laptop_mainscreen.tmpl", "NTOS Main Menu", 400, 500)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/item/modular_computer/attack_self(mob/user)
	if(enabled)
		ui_interact(user)
	else if((battery_module && battery_module.battery.charge) || check_power_override()) // Battery-run and charged or non-battery but powered by APC.
		user << "You press the power button and start up \the [src]"
		enabled = 1
		update_icon()
		ui_interact(user)
	else // Unpowered
		user << "You press the power button but \the [src] does not respond."

// Process currently calls handle_power(), may be expanded in future if more things are added.
/obj/item/modular_computer/process()
	if(!enabled) // The computer is turned off
		last_power_usage = 0
		return 0

	if(active_program && active_program.requires_ntnet && !get_ntnet_status(active_program.requires_ntnet_feature)) // Active program requires NTNet to run but we've just lost connection. Crash.
		kill_program(1)
		visible_message("<span class='danger'>\The [src]'s screen briefly freezes and then shows \"NETWORK ERROR - NTNet connection lost. Please retry. If problem persists contact your system administrator.\" error.</span>")

	if(active_program)
		active_program.process_tick()
		active_program.ntnet_status = get_ntnet_status()
		active_program.computer_emagged = computer_emagged

	handle_power() // Handles all computer power interaction

// Function used by NanoUI's to obtain data for header. All relevant entries begin with "PC_"
/obj/item/modular_computer/proc/get_header_data()
	var/list/data = list()

	if(battery_module)
		switch(battery_module.battery.percent())
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
		data["PC_batterypercent"] = "[round(battery_module.battery.percent())] %"
		data["PC_showbatteryicon"] = 1
	else
		data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "N/C"
		data["PC_showbatteryicon"] = battery_module ? 1 : 0

	switch(get_ntnet_status())
		if(0)
			data["PC_ntneticon"] = "sig_none.gif"
		if(1)
			data["PC_ntneticon"] = "sig_low.gif"
		if(2)
			data["PC_ntneticon"] = "sig_high.gif"
		if(3)
			data["PC_ntneticon"] = "sig_lan.gif"

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

/obj/item/modular_computer/proc/add_log(var/text)
	if(!get_ntnet_status())
		return 0
	return ntnet_global.add_log(text, network_card)

/obj/item/modular_computer/proc/shutdown_computer()
	kill_program(1)
	visible_message("\The [src] shuts down.")
	enabled = 0
	update_icon()
	return

// Handles user's GUI input
/obj/item/modular_computer/Topic(href, href_list)
	if(..())
		return 1
	if( href_list["PC_exit"] )
		kill_program()
		return
	if( href_list["PC_enable_component"] )
		var/obj/item/weapon/computer_hardware/H = find_hardware_by_name(href_list["PC_enable_component"])
		if(H && istype(H) && !H.enabled)
			H.enabled = 1
		return
	if( href_list["PC_disable_component"] )
		var/obj/item/weapon/computer_hardware/H = find_hardware_by_name(href_list["PC_disable_component"])
		if(H && istype(H) && H.enabled)
			H.enabled = 0
		return
	if( href_list["PC_shutdown"] )
		shutdown_computer()
		return
	if( href_list["PC_runprogram"] )
		var/prog = href_list["PC_runprogram"]
		var/datum/computer_file/program/P = null
		var/mob/user = usr
		if(hard_drive)
			P = hard_drive.find_file_by_name(prog)
			P.computer = src

		if(!P || !istype(P)) // Program not found or it's not executable program.
			user << "<span class='danger'>\The [src]'s screen shows \"I/O ERROR - Unable to run program\" warning.</span>"
			return

		if(!P.is_supported_by_hardware(hardware_flag, 1, user))
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
	if(!battery_module || battery_module.battery.charge <= 0) // Battery-run but battery is depleted.
		power_failure()
		return 0

	var/power_usage = screen_on ? base_active_power_usage : base_idle_power_usage
	if(network_card && network_card.enabled)
		power_usage += network_card.power_usage

	if(hard_drive && hard_drive.enabled)
		power_usage += hard_drive.power_usage

	if(battery_module)
		battery_module.battery.use(power_usage * CELLRATE)
	last_power_usage = power_usage

/obj/item/modular_computer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id)) // ID Card, try to insert it.
		var/obj/item/weapon/card/id/I = W
		if(!card_slot)
			user << "You try to insert \the [I] into \the [src], but it does not have an ID card slot installed."
			return

		if(card_slot.stored_card)
			user << "You try to insert \the [I] into \the [src], but it's ID card slot is occupied."
			return
		user.drop_from_inventory(I)
		card_slot.stored_card = I
		I.forceMove(src)
		user << "You insert \the [I] into \the [src]."
		return
	if(istype(W, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/P = W
		if(!nano_printer)
			return
		nano_printer.load_paper(P)
	if(istype(W, /obj/item/weapon/computer_hardware))
		var/obj/item/weapon/computer_hardware/C = W
		if(C.hardware_size <= max_hardware_size)
			try_install_component(user, C)
		else
			user << "This component is too large for \the [src]."
	if(istype(W, /obj/item/weapon/wrench))
		var/list/components = get_all_components()
		if(components.len)
			user << "Remove all components from \the [src] before disassembling it."
			return
		new /obj/item/stack/material/steel( get_turf(src.loc), steel_sheet_cost )
		src.visible_message("\The [src] has been disassembled by [user].")
		relay_qdel()
		qdel(src)
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		var/list/all_components = get_all_components()
		if(!all_components.len)
			user << "This device doesn't have any components installed."
			return
		var/list/component_names = list()
		for(var/obj/item/weapon/computer_hardware/H in all_components)
			component_names.Add(H.name)

		var/choice = input(usr, "Which component do you want to uninstall?", "Computer maintenance", null) as null|anything in component_names

		if(!choice)
			return

		if(!Adjacent(usr))
			return

		var/obj/item/weapon/computer_hardware/H = find_hardware_by_name(choice)

		if(!H)
			return

		uninstall_component(user, H)

		return

	..()

// Used by processor to relay qdel() to machinery type.
/obj/item/modular_computer/proc/relay_qdel()
	return

// Attempts to install the hardware into apropriate slot.
/obj/item/modular_computer/proc/try_install_component(var/mob/living/user, var/obj/item/weapon/computer_hardware/H, var/found = 0)
	// "USB" flash drive.
	if(istype(H, /obj/item/weapon/computer_hardware/hard_drive/portable))
		if(portable_drive)
			user << "This computer's portable drive slot is already occupied by \the [portable_drive]."
			return
		found = 1
		portable_drive = H
	else if(istype(H, /obj/item/weapon/computer_hardware/hard_drive))
		if(hard_drive)
			user << "This computer's hard drive slot is already occupied by \the [hard_drive]."
			return
		found = 1
		hard_drive = H
	else if(istype(H, /obj/item/weapon/computer_hardware/network_card))
		if(network_card)
			user << "This computer's network card slot is already occupied by \the [network_card]."
			return
		found = 1
		network_card = H
	else if(istype(H, /obj/item/weapon/computer_hardware/nano_printer))
		if(nano_printer)
			user << "This computer's nano printer slot is already occupied by \the [nano_printer]."
			return
		found = 1
		nano_printer = H
	else if(istype(H, /obj/item/weapon/computer_hardware/card_slot))
		if(card_slot)
			user << "This computer's card slot is already occupied by \the [card_slot]."
			return
		found = 1
		card_slot = H
	else if(istype(H, /obj/item/weapon/computer_hardware/battery_module))
		if(battery_module)
			user << "This computer's battery slot is already occupied by \the [battery_module]."
			return
		found = 1
		battery_module = H
	if(found)
		user << "You install \the [H] into \the [src]"
		H.holder2 = src
		user.drop_from_inventory(H)
		H.forceMove(src)

// Uninstalls component. Found and Critical vars may be passed by parent types, if they have additional hardware.
/obj/item/modular_computer/proc/uninstall_component(var/mob/living/user, var/obj/item/weapon/computer_hardware/H, var/found = 0, var/critical = 0)
	if(portable_drive == H)
		portable_drive = null
		found = 1
	if(hard_drive == H)
		hard_drive = null
		found = 1
		critical = 1
	if(network_card == H)
		network_card = null
		found = 1
	if(nano_printer == H)
		nano_printer = null
		found = 1
	if(card_slot == H)
		card_slot = null
		found = 1
	if(battery_module == H)
		battery_module = null
		found = 1
	if(found)
		user << "You remove \the [H] from \the [src]."
		H.forceMove(get_turf(src))
		H.holder2 = null
	if(critical)
		user << "<span class='danger'>\The [src]'s screen freezes for few seconds and then displays an \"HARDWARE ERROR: Critical component disconnected. Please verify component connection and reboot the device. If the problem persists contact technical support for assistance.\" warning.</span>"
		kill_program(1)
		enabled = 0
		update_icon()


// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null
/obj/item/modular_computer/proc/find_hardware_by_name(var/name)
	if(portable_drive && (portable_drive.name == name))
		return portable_drive
	if(hard_drive && (hard_drive.name == name))
		return hard_drive
	if(network_card && (network_card.name == name))
		return network_card
	if(nano_printer && (nano_printer.name == name))
		return nano_printer
	if(card_slot && (card_slot.name == name))
		return card_slot
	if(battery_module && (battery_module.name == name))
		return battery_module
	return null

// Returns list of all components
/obj/item/modular_computer/proc/get_all_components()
	var/list/all_components = list()
	if(hard_drive)
		all_components.Add(hard_drive)
	if(network_card)
		all_components.Add(network_card)
	if(portable_drive)
		all_components.Add(portable_drive)
	if(nano_printer)
		all_components.Add(nano_printer)
	if(card_slot)
		all_components.Add(card_slot)
	if(battery_module)
		all_components.Add(battery_module)
	return all_components