// Held by /obj/machinery/modular_computer to reduce amount of copy-pasted code.
/obj/item/modular_computer/processor
	name = "processing unit"
	desc = "You shouldn't see this. If you do, report it."
	icon = null
	icon_state = null
	icon_state_unpowered = null
	icon_state_menu = null
	hardware_flag = 0

	var/obj/machinery/modular_computer/machinery_computer = null

// Due to how processes work, we'd receive two process calls - one from machinery type and one from our own type.
// Since we want this to be in-sync with machinery (as it's hidden type for machinery-based computers) we'll ignore
// non-relayed process calls.
/obj/item/modular_computer/processor/process(var/relayed = 0)
	if(relayed)
		..()
	else
		return

// Power interaction is handled by our machinery part, due to machinery having APC connection.
/obj/item/modular_computer/processor/handle_power()
	if(machinery_computer)
		machinery_computer.handle_power()

/obj/item/modular_computer/processor/New(var/comp)
	if(!comp || !istype(comp, /obj/machinery/modular_computer))
		CRASH("Inapropriate type passed to obj/item/modular_computer/processor/New()! Aborting.")
		return
	// Obtain reference to machinery computer
	machinery_computer = comp
	machinery_computer.cpu = src
	hardware_flag = machinery_computer.hardware_flag

/obj/item/modular_computer/processor/find_hardware_by_name(var/N)
	var/datum/computer_hardware/H = machinery_computer.find_hardware_by_name(N)
	if(H)
		return H
	else
		return ..()

/obj/item/modular_computer/processor/update_icon()
	if(machinery_computer)
		return machinery_computer.update_icon()

/obj/item/modular_computer/processor/get_header_data()
	var/list/L = ..()
	if(machinery_computer.tesla_link && machinery_computer.tesla_link.enabled && machinery_computer.powered())
		L["PC_apclinkicon"] = "charging.gif"
	return L

// Checks whether the machinery computer doesn't take power from APC network
/obj/item/modular_computer/processor/check_power_override()
	if(!machinery_computer)
		return 0
	if(!machinery_computer.tesla_link || !machinery_computer.tesla_link.enabled)
		return 0
	return machinery_computer.powered()

// This thing is not meant to be used on it's own, get topic data from our machinery owner.
/obj/item/modular_computer/processor/CanUseTopic(user, state)
	if(!machinery_computer)
		return 0
	return machinery_computer.CanUseTopic(user, state)

/obj/item/modular_computer/processor/shutdown_computer()
	if(!machinery_computer)
		return
	kill_program(1)
	visible_message("\The [machinery_computer] shuts down.")
	enabled = 0
	machinery_computer.update_icon()
	return