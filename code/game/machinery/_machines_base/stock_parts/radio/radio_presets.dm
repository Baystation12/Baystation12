// Base subtypes. Will generally be enough to modify vars on subtypes of these.

/singleton/stock_part_preset/radio
	expected_part_type = /obj/item/stock_parts/radio
	var/frequency
	var/filter
	var/encryption
	var/id_tag_modifier  // Will be appended to the machine's id_tag, if any.

/singleton/stock_part_preset/radio/do_apply(obj/machinery/machine, obj/item/stock_parts/radio/part)
	if(frequency || filter)
		part.set_frequency(frequency || part.frequency, filter || part.filter)
	if(encryption)
		part.encryption = encryption
	if(id_tag_modifier)
		part.id_tag += id_tag_modifier

/singleton/stock_part_preset/radio/basic_transmitter
	expected_part_type = /obj/item/stock_parts/radio/transmitter/basic
	var/transmit_on_change
	var/transmit_on_tick

/singleton/stock_part_preset/radio/basic_transmitter/do_apply(obj/machinery/machine, obj/item/stock_parts/radio/transmitter/basic/part)
	..()
	if(transmit_on_change)
		part.transmit_on_change = list()
		for(var/key in transmit_on_change)
			part.transmit_on_change[key] = GET_SINGLETON(transmit_on_change[key])

	if(transmit_on_tick)
		part.transmit_on_tick = list()
		for(var/key in transmit_on_tick)
			part.transmit_on_tick[key] = GET_SINGLETON(transmit_on_tick[key])

/singleton/stock_part_preset/radio/event_transmitter
	expected_part_type = /obj/item/stock_parts/radio/transmitter/on_event
	var/event
	var/transmit_on_event

/singleton/stock_part_preset/radio/event_transmitter/do_apply(obj/machinery/machine, obj/item/stock_parts/radio/transmitter/on_event/part)
	..()

	if(event)
		part.event = GET_SINGLETON(event)

	if(transmit_on_event)
		part.transmit_on_event = list()
		for(var/key in transmit_on_event)
			part.transmit_on_event[key] = GET_SINGLETON(transmit_on_event[key])

/singleton/stock_part_preset/radio/receiver
	expected_part_type = /obj/item/stock_parts/radio/receiver
	var/receive_and_write
	var/receive_and_call

/singleton/stock_part_preset/radio/receiver/do_apply(obj/machinery/machine, obj/item/stock_parts/radio/receiver/part)
	..()

	if(receive_and_write)
		part.receive_and_write = list()
		for(var/key in receive_and_write)
			part.receive_and_write[key] = GET_SINGLETON(receive_and_write[key])

	if(receive_and_call)
		part.receive_and_call = list()
		for(var/key in receive_and_call)
			part.receive_and_call[key] = GET_SINGLETON(receive_and_call[key])
