//This is the generic parent class, which doesn't actually do anything.

/obj/item/weapon/stock_parts/computer/scanner
	name = "scanner module"
	desc = "A generic scanner module. This one doesn't seem to do anything."
	power_usage = 50
	icon_state = "printer"
	hardware_size = 1
	critical = 0
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	var/datum/computer_file/program/scanner/driver_type = /datum/computer_file/program/scanner		// A program type that the scanner interfaces with and attempts to install on insertion.
	var/datum/computer_file/program/scanner/driver		 		// A driver program which has been set up to interface with the scanner.
	var/can_run_scan = 0	//Whether scans can be run from the program directly.
	var/can_view_scan = 1	//Whether the scan output can be viewed in the program.
	var/can_save_scan = 1	//Whether the scan output can be saved to disk.

/obj/item/weapon/stock_parts/computer/scanner/Destroy()
	do_before_uninstall()
	. = ..()

/obj/item/weapon/stock_parts/computer/scanner/proc/do_after_install(user, atom/device)
	var/datum/extension/interactive/ntos/os = get_extension(device, /datum/extension/interactive/ntos)
	if(!driver_type || !device || !os)
		return 0
	if(!os.has_component(PART_HDD))
		to_chat(user, "Driver installation for \the [src] failed: \the [device] lacks a hard drive.")
		return 0
	var/datum/computer_file/program/scanner/old_driver = os.get_file(initial(driver_type.filename))
	if(istype(old_driver))
		to_chat(user, "Drivers found on \the [device]; \the [src] has been installed.")
		old_driver.connect_scanner()
		return 1
	var/datum/computer_file/program/scanner/driver_file = new driver_type
	if(!os.store_file(driver_file))
		to_chat(user, "Driver installation for \the [src] failed: file could not be written to the hard drive.")
		return 0
	to_chat(user, "Driver software for \the [src] has been installed on \the [device].")
	driver_file.computer = os
	driver_file.connect_scanner()
	return 1

/obj/item/weapon/stock_parts/computer/scanner/proc/do_before_uninstall()
	if(driver)
		driver.disconnect_scanner()
	if(driver)	//In case the driver doesn't find it.
		driver = null

/obj/item/weapon/stock_parts/computer/scanner/proc/run_scan(mob/user, datum/computer_file/program/scanner/program) //For scans done from the software.

/obj/item/weapon/stock_parts/computer/scanner/proc/do_on_afterattack(mob/user, atom/target, proximity)

/obj/item/weapon/stock_parts/computer/scanner/attackby(obj/W, mob/living/user)
	do_on_attackby(user, W)

/obj/item/weapon/stock_parts/computer/scanner/proc/do_on_attackby(mob/user, atom/target)

/obj/item/weapon/stock_parts/computer/scanner/proc/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!check_functionality())
		return 0
	if(user.incapacitated())
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(!proximity)
		return 0
	return 1