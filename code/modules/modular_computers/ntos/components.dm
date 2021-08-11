/datum/extension/interactive/ntos/proc/get_component(part_type)
	return locate(part_type) in holder

/datum/extension/interactive/ntos/proc/get_all_components()
	. = list()
	for(var/obj/item/stock_parts/P in holder)
		. += P

/datum/extension/interactive/ntos/proc/find_hardware_by_name(partname)
	for(var/obj/item/stock_parts/P in holder)
		if(findtext(P.name, partname))
			return P

/datum/extension/interactive/ntos/proc/has_component(part_type)
	return !!get_component(part_type)

/datum/extension/interactive/ntos/proc/print_paper(content, title)
	var/obj/item/stock_parts/computer/nano_printer/printer = get_component(PART_PRINTER)
	if(printer)
		return printer.print_text(content, title)

/// Returns the network tag that other computers trying to reach it would see.
/datum/extension/interactive/ntos/proc/get_network_tag_incoming()
	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		return network_card.get_network_tag_direct()
	return "N/A"

/// Returns the network tag visible for the outgoing connections this computer makes. Value is cached until computer next runs Process() or is shut down.
/datum/extension/interactive/ntos/proc/get_network_tag()
	if(isnull(network_tag))
		var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
		if(network_card)
			network_tag = network_card.get_network_tag()
		else
			network_tag = "N/A"
	return network_tag

/// Returns the connection quality to NTNet for this computer for others trying to reach it.
/datum/extension/interactive/ntos/proc/get_ntnet_status_incoming()
	if(!on) // No signal if the computer isn't on.
		return 0
	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		return network_card.get_signal_direct()
	return 0

/// Returns the connection quality to NTNet for this computer when making outgoing connections. Value is cached until computer next runs Process() or is shut down.
/datum/extension/interactive/ntos/proc/get_ntnet_status()
	if(!on) // No signal if the computer isn't on.
		return 0
	if(isnull(ntnet_status))
		var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
		if(network_card)
			ntnet_status = network_card.get_signal()
		else
			ntnet_status = 0
	return ntnet_status

/// Returns TRUE if the connection supports a specific capability, otherwise FALSE
/datum/extension/interactive/ntos/proc/get_ntnet_capability(specific_action)
	if(ntnet_global)
		return TRUE
	return FALSE

/// Returns the current network speed in GQ/s for the specified connection quality
/datum/extension/interactive/ntos/proc/get_ntnet_speed(status)
	. = 0
	switch(status)
		if(1)
			. = NTNETSPEED_LOWSIGNAL
		if(2)
			. = NTNETSPEED_HIGHSIGNAL
		if(3)
			. = NTNETSPEED_ETHERNET

/datum/extension/interactive/ntos/proc/get_inserted_id()
	var/obj/item/stock_parts/computer/card_slot/card_slot = get_component(PART_CARD)
	if(card_slot)
		return card_slot.stored_card

/datum/extension/interactive/ntos/proc/max_disk_capacity(obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(istype(disk))
		return disk.max_capacity
	return 0

/datum/extension/interactive/ntos/proc/used_disk_capacity(obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(istype(disk))
		return disk.used_capacity
	return 0

/datum/extension/interactive/ntos/proc/get_hardware_flag()
	return PROGRAM_ALL

/// Overriden in device subtypes and used to display in configurator program.
/datum/extension/interactive/ntos/proc/get_power_usage()
	return 0

/datum/extension/interactive/ntos/proc/recalc_power_usage()

/datum/extension/interactive/ntos/proc/voltage_overload()
	var/atom/A = holder
	if(istype(A))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(10, 1, A.loc)
		s.start()

	var/obj/item/stock_parts/computer/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		qdel(hard_drive)

	var/obj/item/stock_parts/computer/battery_module = get_component(PART_BATTERY)
	if(battery_module && prob(25))
		qdel(battery_module)

	var/obj/item/stock_parts/computer/tesla_link = get_component(PART_TESLA)
	if(tesla_link && prob(50))
		qdel(tesla_link)
