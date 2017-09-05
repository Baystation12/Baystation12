// Attempts to install the hardware into apropriate slot.
/obj/item/modular_computer/proc/try_install_component(var/mob/living/user, var/obj/item/weapon/computer_hardware/H, var/found = 0)
	// "USB" flash drive.
	if(istype(H, /obj/item/weapon/computer_hardware/hard_drive/portable))
		if(portable_drive)
			to_chat(user, "This computer's portable drive slot is already occupied by \the [portable_drive].")
			return
		found = 1
		portable_drive = H
	else if(istype(H, /obj/item/weapon/computer_hardware/hard_drive))
		if(hard_drive)
			to_chat(user, "This computer's hard drive slot is already occupied by \the [hard_drive].")
			return
		found = 1
		hard_drive = H
	else if(istype(H, /obj/item/weapon/computer_hardware/network_card))
		if(network_card)
			to_chat(user, "This computer's network card slot is already occupied by \the [network_card].")
			return
		found = 1
		network_card = H
	else if(istype(H, /obj/item/weapon/computer_hardware/nano_printer))
		if(nano_printer)
			to_chat(user, "This computer's nano printer slot is already occupied by \the [nano_printer].")
			return
		found = 1
		nano_printer = H
	else if(istype(H, /obj/item/weapon/computer_hardware/card_slot))
		if(card_slot)
			to_chat(user, "This computer's card slot is already occupied by \the [card_slot].")
			return
		found = 1
		card_slot = H
	else if(istype(H, /obj/item/weapon/computer_hardware/battery_module))
		if(battery_module)
			to_chat(user, "This computer's battery slot is already occupied by \the [battery_module].")
			return
		found = 1
		battery_module = H
	else if(istype(H, /obj/item/weapon/computer_hardware/processor_unit))
		if(processor_unit)
			to_chat(user, "This computer's processor slot is already occupied by \the [processor_unit].")
			return
		found = 1
		processor_unit = H
	else if(istype(H, /obj/item/weapon/computer_hardware/ai_slot))
		if(ai_slot)
			to_chat(user, "This computer's intellicard slot is already occupied by \the [ai_slot].")
			return
		found = 1
		ai_slot = H
	else if(istype(H, /obj/item/weapon/computer_hardware/tesla_link))
		if(tesla_link)
			to_chat(user, "This computer's tesla link slot is already occupied by \the [tesla_link].")
			return
		found = 1
		tesla_link = H
	if(found)
		to_chat(user, "You install \the [H] into \the [src]")
		H.holder2 = src
		user.drop_from_inventory(H)
		H.forceMove(src)
		update_verbs()

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
	if(processor_unit == H)
		processor_unit = null
		found = 1
		critical = 1
	if(ai_slot == H)
		ai_slot = null
		found = 1
	if(tesla_link == H)
		tesla_link = null
		found = 1
	if(found)
		if(user)
			to_chat(user, "You remove \the [H] from \the [src].")
		H.forceMove(get_turf(src))
		H.holder2 = null
		update_verbs()
	if(critical && enabled)
		if(user)
			to_chat(user, "<span class='danger'>\The [src]'s screen freezes for few seconds and then displays an \"HARDWARE ERROR: Critical component disconnected. Please verify component connection and reboot the device. If the problem persists contact technical support for assistance.\" warning.</span>")
		shutdown_computer()
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
	if(processor_unit && (processor_unit.name == name))
		return processor_unit
	if(ai_slot && (ai_slot.name == name))
		return ai_slot
	if(tesla_link && (tesla_link.name == name))
		return tesla_link
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
	if(processor_unit)
		all_components.Add(processor_unit)
	if(ai_slot)
		all_components.Add(ai_slot)
	if(tesla_link)
		all_components.Add(tesla_link)
	return all_components