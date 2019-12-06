/obj/item/weapon/stock_parts/radio
	part_flags = PART_FLAG_QDEL
	var/datum/radio_frequency/radio
	var/frequency
	var/id_tag
	var/filter
	var/encryption
	var/multitool_extension

/obj/item/weapon/stock_parts/radio/Initialize()
	if(frequency)
		set_frequency(frequency, filter)
	if(multitool_extension)
		set_extension(src, multitool_extension)
	. = ..()

/obj/item/weapon/stock_parts/radio/on_install(obj/machinery/machine)
	..()
	if(!id_tag)
		id_tag = machine.id_tag

/obj/item/weapon/stock_parts/radio/proc/set_frequency(new_frequency, new_filter)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	filter = new_filter
	radio = radio_controller.add_object(src, frequency, filter)

/obj/item/weapon/stock_parts/radio/Destroy()
	radio_controller.remove_object(src, frequency)
	. = ..()

/obj/item/weapon/stock_parts/radio/proc/sanitize_events(obj/machinery/machine, list/events)
	for(var/thing in events)
		if(!is_valid_event(machine, events[thing]))
			LAZYREMOVE(events, thing)

/obj/item/weapon/stock_parts/radio/proc/is_valid_event(obj/machinery/machine, decl/public_access/variable)
	return istype(variable) && LAZYACCESS(machine.public_variables, variable.type)