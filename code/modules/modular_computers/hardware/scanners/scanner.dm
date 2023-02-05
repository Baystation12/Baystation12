/// This is the generic parent class, which doesn't actually do anything.
/obj/item/stock_parts/computer/scanner
	name = "scanner module"
	desc = "A generic scanner module. This one doesn't seem to do anything."
	power_usage = 50
	icon_state = "printer"
	hardware_size = 1
	critical = FALSE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	/// A program type that the scanner interfaces with and attempts to install on insertion.
	var/datum/computer_file/program/scanner/driver_type = /datum/computer_file/program/scanner
	/// A driver program which has been set up to interface with the scanner.
	var/datum/computer_file/program/scanner/driver
	/// Whether scans can be run from the program directly.
	var/can_run_scan = FALSE
	/// Whether the scan output can be viewed in the program.
	var/can_view_scan = TRUE
	/// Whether the scan output can be saved to disk.
	var/can_save_scan = TRUE

/obj/item/stock_parts/computer/scanner/Destroy()
	do_before_uninstall()
	. = ..()

/obj/item/stock_parts/computer/scanner/proc/do_after_install(user, atom/device)
	var/datum/extension/interactive/ntos/os = get_extension(device, /datum/extension/interactive/ntos)
	if(!driver_type || !device || !os)
		return FALSE
	if(!os.has_component(PART_HDD))
		to_chat(user, "Driver installation for \the [src] failed: \the [device] lacks a hard drive.")
		return FALSE
	var/datum/computer_file/program/scanner/old_driver = os.get_file(initial(driver_type.filename))
	if(istype(old_driver))
		to_chat(user, "Drivers found on \the [device]; \the [src] has been installed.")
		old_driver.connect_scanner()
		return TRUE
	var/datum/computer_file/program/scanner/driver_file = new driver_type
	if(!os.save_file(driver_file))
		to_chat(user, "Driver installation for \the [src] failed: file could not be written to the hard drive.")
		return FALSE
	to_chat(user, "Driver software for \the [src] has been installed on \the [device].")
	driver_file.computer = os
	driver_file.connect_scanner()
	return TRUE

/obj/item/stock_parts/computer/scanner/proc/do_before_uninstall()
	if(driver)
		driver.disconnect_scanner()
	if(driver)	//In case the driver doesn't find it.
		driver = null

/obj/item/stock_parts/computer/scanner/proc/run_scan(mob/user, datum/computer_file/program/scanner/program) //For scans done from the software.

/obj/item/stock_parts/computer/scanner/proc/do_on_afterattack(mob/user, atom/target, proximity)


/obj/item/stock_parts/computer/scanner/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_CABLE] = "<p>Repairs the component. 1 length of coil repairs 10 points of damage.</p>"
	.["Nanopaste"] = "<p>Fully repairs the component. This costs 1 unit of nanopaste.</p>"


/obj/item/stock_parts/computer/scanner/use_tool(obj/item/tool, mob/user, list/click_params)
	do_on_attackby(user, tool)

	// Cable Coil - Repair some damage
	if (isCoil(tool))
		if (!health_damaged())
			to_chat(user, SPAN_WARNING("\The [src] doesn't require repairs."))
			return TRUE
		var/obj/item/stack/cable_coil/cable = tool
		if (!cable.use(1))
			to_chat(user, SPAN_WARNING("There isn't enough of \the [tool] left to repair \the [src]."))
			return TRUE
		restore_health(10)
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs some of \the [src]'s damage with some [cable.plural_name] of [cable.name]."),
			SPAN_NOTICE("You repair some of \the [src]'s damage with some [cable.plural_name] of [cable.name].")
		)
		return TRUE

	// Nanopaste - Repair all damage
	if (istype(tool, /obj/item/stack/nanopaste))
		if (!health_damaged())
			to_chat(user, SPAN_WARNING("\The [src] doesn't require repairs."))
			return TRUE
		var/obj/item/stack/nanopaste/nanopaste = tool
		if (!nanopaste.use(1))
			to_chat(user, SPAN_WARNING("There isn't enough of \the [tool] left to repair \the [src]."))
			return TRUE
		revive_health()
		user.visible_message(
			SPAN_NOTICE("\The [user] fully repairs \the [src] with some [nanopaste.plural_name]."),
			SPAN_NOTICE("You fully repair \the [src] with some [nanopaste.plural_name].")
		)
		return TRUE

	return ..()


/obj/item/stock_parts/computer/scanner/proc/do_on_attackby(mob/user, atom/target)

/obj/item/stock_parts/computer/scanner/proc/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!check_functionality())
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!user.IsAdvancedToolUser())
		return FALSE
	if(!proximity)
		return FALSE
	return TRUE
