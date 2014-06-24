//--------------------------------------------
// Gas filter - omni variant
//--------------------------------------------
obj/machinery/atmospherics/omni/filter
	name = "Omni gas filter"
	icon = 'icons/obj/atmospherics/omni_devices.dmi'
	icon_state = ""

	tag_north = ATM_OUTPUT
	tag_south = ATM_INPUT
	tag_east = ATM_O2
	tag_west = ATM_N2

	var/list/filters = new()
	var/datum/omni_port/input
	var/datum/omni_port/output
