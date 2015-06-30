// Portable item-based laptop

/obj/item/laptop
	name		= "laptop computer"
	desc		= "A portable computer. It is closed."
	icon		= 'icons/obj/computer3.dmi' // Let's recycle the icons from computer3, they are decent.
	icon_state	= "laptop-closed"
	item_state	= "laptop-inhand"
	w_class		= 3
	var/obj/machinery/modular_computer/laptop/stored_computer = null

/obj/item/laptop/verb/open_computer()
	set name = "Open Laptop"
	set category = "Object"
	set src in view(1)

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		usr << "<span class='warning'>You can't do that.</span>"
		return

	if(!Adjacent(usr))
		usr << "You can't reach it."
		return

	if(!istype(loc,/turf))
		usr << "[src] is too bulky!  You'll have to set it down."
		return

	if(!stored_computer)
		if(contents.len)
			for(var/obj/O in contents)
				O.loc = loc
		usr << "\The [src] crumbles to pieces."
		spawn(5)
			qdel(src)
		return

	stored_computer.loc = loc
	stored_computer.stat &= ~MAINT
	stored_computer.update_icon()
	stored_computer.open = 1
	loc = stored_computer
	usr << "You open \the [src]."


/obj/item/laptop/AltClick()
	if(Adjacent(usr))
		open_computer()


// Laptop itself

// Defaults in here are for laptops, and are overriden for stationbound consoles.
/obj/machinery/modular_computer/
	name = "laptop computer"
	desc = "A portable computer."
	var/open = 1											// Whether the laptop is open.
	var/enabled = 1											// Whether the laptop is turned on.
	var/datum/computer_file/program/active_program = null	// A currently active program running on the computer.
	var/obj/item/laptop/portable = null						// Portable version of this computer, dropped on alt-click to allow transport. Used by laptops.
	use_power = 0

	icon = 'icons/obj/computer3.dmi'
	icon_state = "laptop-open"
	var/icon_state_unpowered = "laptop-open"				// Icon state when the computer is turned off
	var/icon_state_menu = "menu"							// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.

	// Important hardware (must be installed for computer to work)
	var/datum/computer_hardware/network_card/network_card	// Network Card component of this computer. Allows connection to NTNet
	var/datum/computer_hardware/hard_drive/hard_drive		// Hard Drive component of this computer. Stores programs and files.
	var/obj/item/weapon/cell/battery = null					// Battery component of this computer. Powers the computer. Áll computers can have batteries.
	// Optional hardware (improves functionality, but is not critical for computer to work)
	var/datum/computer_hardware/tesla_link/tesla_link		// Tesla Link component of this computer. Allows remote charging from nearest APC.
	var/datum/computer_hardware/card_slot/card_slot			// ID Card slot component of this computer. Mostly for HoP modification console that needs ID slot for modification.

/obj/machinery/modular_computer/laptop/update_icon()
	icon_state = icon_state_unpowered

	overlays.Cut()
	if(!enabled)
		return
	if(active_program)
		overlays.Add(active_program.laptop_icon_state ? active_program.laptop_icon_state : icon_state_menu)
	else
		overlays.Add(icon_state_menu)

// Close the computer. collapsing it into movable item that can't be used.
/obj/machinery/modular_computer/laptop/verb/close_computer()
	set name = "Close Laptop"
	set category = "Object"
	set src in view(1)

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		usr << "<span class='warning'>You can't do that.</span>"
		return

	if(!Adjacent(usr))
		usr << "<span class='warning'>You can't reach it.</span>"
		return

	close_laptop(usr)

/obj/machinery/modular_computer/laptop/proc/close_laptop(mob/user = null)
	if(istype(loc,/obj/item/laptop))
		return
	if(!istype(loc,/turf))
		return

	if(!portable)
		portable=new
		portable.stored_computer = src

	portable.loc = loc
	loc = portable
	stat |= MAINT
	if(user)
		user << "You close \the [src]."
	open = 0

/obj/machinery/modular_computer/laptop/AltClick()
	if(Adjacent(usr))
		close_laptop()

// Eject ID card from computer, if it has ID slot with card inside.
/obj/machinery/modular_computer/verb/eject_id()
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

/obj/machinery/modular_computer/proc/proc_eject_id(mob/user)
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
/obj/machinery/modular_computer/New()
	network_card = new(src)
	hard_drive = new(src)
	tesla_link = new(src)
	battery = new(src)
	battery.maxcharge = 500
	battery.charge = 500

	hard_drive.stored_files.Add(new/datum/computer_file/program/alarm_monitor(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/power_monitor(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/atmos_control(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/rcon_console(src))
	hard_drive.stored_files.Add(new/datum/computer_file/program/suit_sensors(src))
	update_icon()
	..()

// Operates NanoUI
/obj/machinery/modular_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!open || !enabled)
		if(ui)
			ui.close()
		return 0
	if(stat & (BROKEN | NOPOWER | MAINT))
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
		program["icon_link"] = P.fileicon
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
/obj/machinery/modular_computer/attack_hand(mob/user)
	if(enabled)
		ui_interact(user)
	else if((battery && battery.charge > 0) || (!battery && powered())) // Battery-run and charged or non-battery but powered by APC.
		user << "You press the power button and start up \the [src]"
		enabled = 1
		update_icon()

// Process currently calls handle_power(), may be expanded in future if more things are added.
/obj/machinery/modular_computer/process()
	if(!enabled) // The computer is turned off
		use_power = 0
		return 0

	if(active_program && active_program.requires_ntnet && !get_ntnet_status(active_program.requires_ntnet_feature)) // Active program requires NTNet to run but we've just lost connection. Crash.
		kill_program(1)
		visible_message("<span class='danger'>\The [src]'s screen briefly freezes and then shows \"NETWORK ERROR - NTNet connection lost. Please retry. If problem persists contact your system administrator.\" error.</span>")

	handle_power() // Handles all computer power interaction

// Function used by NanoUI's to obtain data for header. All relevant entries begin with "PC_"
/obj/machinery/modular_computer/proc/get_header_data()
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
	else // Computer without battery shouldn't work at all, but in case we implement computers without batteries in future that run solely on APC network, it's here.
		data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "N/C"

	switch(get_ntnet_status())
		if(0)
			data["PC_ntneticon"] = "sig_none.gif"
		if(1)
			data["PC_ntneticon"] = "sig_low.gif"
		if(2)
			data["PC_ntneticon"] = "sig_high.gif"

	if(tesla_link && tesla_link.enabled && powered())
		data["PC_apclinkicon"] = "charging.gif"

	data["PC_stationtime"] = worldtime2text()
	data["PC_hasheader"] = 1
	return data


// Relays kill program request to currently active program. Use this to quit current program.
/obj/machinery/modular_computer/proc/kill_program(var/forced = 0)
	if(active_program)
		active_program.kill_program(forced)
		active_program = null
	var/mob/user = usr
	if(user && istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.
	update_icon()

// Returns 0 for No Signal, 1 for Low Signal and 2 for Good Signal. 3 is for wired connection (always-on)
/obj/machinery/modular_computer/proc/get_ntnet_status(var/specific_action = 0)
	if(network_card)
		return network_card.get_signal(specific_action)
	else
		return 0

// Handles user's GUI input
/obj/machinery/modular_computer/Topic(href, href_list)
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
/obj/machinery/modular_computer/proc/power_failure()
	if(enabled) // Shut down the computer)
		visible_message("<span class='danger'>\The [src]'s screen flickers \"BATTERY CRITICAL\" warning as it shuts down unexpectedly.</span>")
		kill_program(1)
		enabled = 0
		update_icon()
	stat |= NOPOWER
// Handles power-related things, such as battery interaction, recharging, shutdown when it's discharged, NOPOWER flag, etc.
/obj/machinery/modular_computer/proc/handle_power()
	if(battery && battery.charge <= 0) // Battery-run but battery is depleted.
		power_failure()
		return 0
	else if(!battery && (!powered() || !tesla_link || !tesla_link.enabled)) // Not battery run, but lacking APC connection.
		power_failure()
		return 0
	else if(stat & NOPOWER)
		stat &= ~NOPOWER

	var/power_usage = open ? 300 : 25 // 300W when it's open and only 25W when closed (sleep mode)? Screen probably uses a lot.
	if(network_card && network_card.enabled)
		power_usage += network_card.power_usage

	if(hard_drive && hard_drive.enabled)
		power_usage += hard_drive.power_usage

	// Wireless APC connection exists.
	if(tesla_link && tesla_link.enabled)
		idle_power_usage = power_usage
		active_power_usage = idle_power_usage + 100 	// APCLink only charges at 100W rate, but covers any power usage.
		use_power = 1
		// Battery is not fully charged. Begin slowly recharging.
		if(battery && battery.charge < battery.maxcharge)
			use_power = 2

		if(battery && powered() && (use_power == 2)) // Battery charging itself
			battery.give(100 * CELLRATE)
		else if(battery && !powered()) // Unpowered, but battery covers the usage.
			battery.use(idle_power_usage * CELLRATE)

	else	// No wireless connection run only on battery.
		use_power = 0
		if (battery)
			battery.use(power_usage * CELLRATE)

// Modular computers can have battery in them, we handle power in previous proc, so prevent this from messing it up for us.
/obj/machinery/modular_computer/power_change()
	return

/obj/machinery/modular_computer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
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
