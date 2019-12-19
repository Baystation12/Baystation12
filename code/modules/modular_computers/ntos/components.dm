/datum/extension/interactive/ntos/proc/get_component(var/part_type)
	return locate(part_type) in holder

/datum/extension/interactive/ntos/proc/get_all_components()
	. = list()
	for(var/obj/item/weapon/stock_parts/P in holder)
		. += P

/datum/extension/interactive/ntos/proc/find_hardware_by_name(var/partname)
	for(var/obj/item/weapon/stock_parts/P in holder)
		if(findtext(P.name, partname))
			return P

/datum/extension/interactive/ntos/proc/has_component(var/part_type)
	return !!get_component(part_type)

/datum/extension/interactive/ntos/proc/print_paper(content, title)
	var/obj/item/weapon/stock_parts/computer/nano_printer/printer = get_component(PART_PRINTER)
	if(printer)
		return printer.print_text(content, title)
		
/datum/extension/interactive/ntos/proc/get_network_tag()
	var/obj/item/weapon/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		return network_card.get_network_tag()
	else
		return "N/A"
		
/datum/extension/interactive/ntos/proc/get_ntnet_status(var/specific_action = 0)
	var/obj/item/weapon/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		return network_card.get_signal(specific_action)
	else
		return 0

/datum/extension/interactive/ntos/proc/get_inserted_id()
	var/obj/item/weapon/stock_parts/computer/card_slot/card_slot = get_component(PART_CARD)
	if(card_slot)
		return card_slot.stored_card

/datum/extension/interactive/ntos/proc/max_disk_capacity()
	var/obj/item/weapon/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		return hard_drive.max_capacity

/datum/extension/interactive/ntos/proc/used_disk_capacity()
	var/obj/item/weapon/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		return hard_drive.used_capacity

/datum/extension/interactive/ntos/proc/get_hardware_flag()
	return PROGRAM_ALL

//Used to display in configurator program
/datum/extension/interactive/ntos/proc/get_power_usage()
	return 0

/datum/extension/interactive/ntos/proc/recalc_power_usage()

/datum/extension/interactive/ntos/proc/voltage_overload()
	var/atom/A = holder
	if(istype(A))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(10, 1, A.loc)
		s.start()

	var/obj/item/weapon/stock_parts/computer/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		qdel(hard_drive)

	var/obj/item/weapon/stock_parts/computer/battery_module = get_component(PART_BATTERY)
	if(battery_module && prob(25))
		qdel(battery_module)

	var/obj/item/weapon/stock_parts/computer/tesla_link = get_component(PART_TESLA)
	if(tesla_link && prob(50))
		qdel(tesla_link)