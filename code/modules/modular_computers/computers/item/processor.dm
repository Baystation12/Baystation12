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

// Process is handled via machinery half of this, due to power interaction.
/obj/item/modular_computer/processor/process()
	return PROCESS_KILL

/obj/item/modular_computer/processor/New(var/comp)
	if(!comp || !istype(comp, /obj/machinery/modular_computer))
		CRASH("Inapropriate type passed to obj/item/modular_computer/processor/New()! Aborting.")
		return
	// Obtain reference to machinery computer
	machinery_computer = comp
	machinery_computer.cpu = src
	// Now steal the computer's components and assume them as our own. The computer will send us commands, we'll do most of the work.
	hard_drive = machinery_computer.hard_drive
	machinery_computer.hard_drive = null
	if(hard_drive)
		hard_drive.holder2 = src
		hard_drive.holder = null
	network_card = machinery_computer.network_card
	machinery_computer.network_card = null
	if(network_card)
		network_card.holder2 = src
		network_card.holder = null
	nano_printer = machinery_computer.nano_printer
	machinery_computer.nano_printer = null
	if(nano_printer)
		nano_printer.holder = src
		nano_printer.holder = null
	card_slot = machinery_computer.card_slot
	machinery_computer.card_slot = null
	if(card_slot)
		card_slot.holder2 = src
		card_slot.holder = null
	battery = machinery_computer.battery
	machinery_computer.battery = null
	hardware_flag = machinery_computer.hardware_flag

/obj/item/modular_computer/processor/find_hardware_by_name(var/N)
	var/datum/computer_hardware/H = machinery_computer.find_hardware_by_name(N)
	if(H)
		return H
	else
		return ..()

/obj/item/modular_computer/processor/get_header_data()
	var/list/L = ..()
	if(machinery_computer.tesla_link && machinery_computer.tesla_link.enabled)
		L["PC_apclinkicon"] = "charging.gif"
	return L

// Checks whether the machinery computer doesn't take power from APC network
/obj/item/modular_computer/processor/check_power_override()
	if(!machinery_computer)
		return 0
	if(!machinery_computer.tesla_link || !machinery_computer.tesla_link.enabled)
		return 0
	return 1

//
/obj/item/modular_computer/processor/CanUseTopic(user, state)
	if(!machinery_computer)
		return 0
	return machinery_computer.CanUseTopic(user, state)

