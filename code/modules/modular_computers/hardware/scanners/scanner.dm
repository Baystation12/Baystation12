//This is the generic parent class, which doesn't actually do anything.

/obj/item/weapon/computer_hardware/scanner
	name = "scanner module"
	desc = "A generic scanner module. This one doesn't seem to do anything."
	power_usage = 50
	icon_state = "printer"
	hardware_size = 1
	critical = 0
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	var/driver_type = /datum/computer_file/program/scanner		// A program type that the scanner interfaces with and attempts to install on insertion.
	var/datum/computer_file/program/scanner/driver		 		// A driver program which has been set up to interface with the scanner.
	var/can_run_scan = 0	//Whether scans can be run from the program directly.
	var/can_view_scan = 1	//Whether the scan output can be viewed in the program.
	var/can_save_scan = 1	//Whether the scan output can be saved to disk.

/obj/item/weapon/computer_hardware/scanner/Destroy()
	do_before_uninstall()
	. = ..()

/obj/item/weapon/computer_hardware/scanner/proc/do_after_install(user, obj/item/modular_computer/device)
	if(!driver_type || !device)
		return 0
	if(!device.hard_drive)
		to_chat(user, "Driver installation for \the [src] failed: \the [device] lacks a hard drive.")
		return 0
	var/datum/computer_file/program/scanner/driver_file = new driver_type
	var/datum/computer_file/program/scanner/old_driver = device.hard_drive.find_file_by_name(driver_file.filename)
	if(istype(old_driver))
		to_chat(user, "Drivers found on \the [device]; \the [src] has been installed.")
		old_driver.connect_scanner()
		return 1
	if(!device.hard_drive.store_file(driver_file))
		to_chat(user, "Driver installation for \the [src] failed: file could not be written to \the [device.hard_drive].")
		return 0
	to_chat(user, "Driver software for \the [src] has been installed on \the [device].")
	driver_file.computer = device
	driver_file.connect_scanner()
	return 1

/obj/item/weapon/computer_hardware/scanner/proc/do_before_uninstall()
	if(driver)
		driver.disconnect_scanner()
	if(driver)	//In case the driver doesn't find it.
		driver = null

/obj/item/weapon/computer_hardware/scanner/proc/run_scan(mob/user, datum/computer_file/program/scanner/program) //For scans done from the software.

/obj/item/weapon/computer_hardware/scanner/proc/do_on_afterattack(mob/user, atom/target, proximity)

/obj/item/weapon/computer_hardware/scanner/proc/do_on_attackby(mob/user, atom/target)

/obj/item/weapon/computer_hardware/scanner/proc/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!check_functionality())
		return 0
	if(user.incapacitated())
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(!proximity)
		return 0
	return 1