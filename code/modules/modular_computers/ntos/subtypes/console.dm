/datum/extension/interactive/ntos/console
	expected_type = /obj/machinery
	screen_icon_file = 'icons/obj/modular_console.dmi'
	
/datum/extension/interactive/ntos/console/get_hardware_flag()
	return PROGRAM_CONSOLE

/datum/extension/interactive/ntos/console/get_component(var/part_type)
	var/obj/machinery/M = holder
	return M.get_component_of_type(part_type)

/datum/extension/interactive/ntos/console/get_all_components()
	var/obj/machinery/M = holder
	return M.component_parts.Copy()

/datum/extension/interactive/ntos/console/get_power_usage()
	var/obj/machinery/M = holder
	return M.get_power_usage()

/datum/extension/interactive/ntos/console/recalc_power_usage()
	var/obj/machinery/M = holder
	M.RefreshParts()

/datum/extension/interactive/ntos/console/emagged()
	var/obj/machinery/M = holder
	var/obj/item/weapon/stock_parts/circuitboard/modular_computer/MB = M.get_component_of_type(/obj/item/weapon/stock_parts/circuitboard/modular_computer)
	return MB && MB.emagged

/datum/extension/interactive/ntos/console/system_boot()
	..()
	var/obj/machinery/M = holder
	M.update_use_power(POWER_USE_ACTIVE)

/datum/extension/interactive/ntos/console/system_shutdown()
	..()
	var/obj/machinery/M = holder
	M.update_use_power(POWER_USE_IDLE)