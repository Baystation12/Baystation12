/obj/item/weapon/stock_parts/radio
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
		set_extension(src, /datum/extension/interactive/multitool, multitool_extension)
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
		if(!is_valid_event(events[thing]))
			LAZYREMOVE(events, thing)

/obj/item/weapon/stock_parts/radio/proc/is_valid_event(obj/machinery/machine, decl/public_access/variable)
	return istype(variable) && LAZYACCESS(machine.public_variables, variable)

/obj/item/weapon/stock_parts/radio/transmitter
	name = "radio transmitter"
	desc = "A radio transmitter designed for use with machines."
	icon_state = "subspace_transmitter"
	var/range       // If you want range-limited subtypes
	var/latency = 2 // Delay between event and transmission; doesn't apply to transmit on tick
	var/buffer

/obj/item/weapon/stock_parts/radio/transmitter/proc/queue_transmit(list/data)
	if(!length(data))
		return
	if(!buffer)
		buffer = data
		addtimer(CALLBACK(src, .proc/transmit), latency)
	else
		buffer |= data

/obj/item/weapon/stock_parts/radio/transmitter/proc/transmit()
	if(!LAZYLEN(buffer))
		return
	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	signal.encryption = encryption
	signal.data = buffer
	signal.data["tag"] = id_tag
	radio.post_signal(src, signal, filter, range)
	buffer = null

// Standard variant can either transmit on var change or transmit every tick. Latter is not encouraged for premade variants.
/obj/item/weapon/stock_parts/radio/transmitter/basic
	multitool_extension = /datum/extension/interactive/multitool/radio/transmitter
	var/list/transmit_on_change
	var/list/transmit_on_tick

/obj/item/weapon/stock_parts/radio/transmitter/basic/proc/var_changed(decl/public_access/public_variable/variable, obj/machinery/machine, old_value, new_value)
	var/list/L = list()
	for(var/thing in transmit_on_change)
		if(transmit_on_change[thing] == variable)
			L[thing] = new_value
	queue_transmit(L)

/obj/item/weapon/stock_parts/radio/transmitter/basic/on_install(obj/machinery/machine)
	..()
	transmit_on_change = sanitize_events(machine, transmit_on_change)
	transmit_on_tick = sanitize_events(machine, transmit_on_tick)
	if(LAZYLEN(transmit_on_tick))
		start_processing(machine)
	for(var/thing in transmit_on_change)
		var/decl/public_access/public_variable/variable = transmit_on_change[thing]
		variable.register_listener(src, machine, .proc/var_changed)

/obj/item/weapon/stock_parts/radio/transmitter/basic/on_uninstall(obj/machinery/machine)
	for(var/thing in transmit_on_change)
		var/decl/public_access/public_variable/variable = transmit_on_change[thing]
		variable.unregister_listener(src, machine)
	..()

/obj/item/weapon/stock_parts/radio/transmitter/basic/Destroy()
	if(istype(loc, /obj/machinery))
		for(var/thing in transmit_on_change)
			var/decl/public_access/public_variable/variable = transmit_on_change[thing]
			variable.unregister_listener(src, loc)
	. = ..()

/obj/item/weapon/stock_parts/radio/transmitter/basic/machine_process(obj/machinery/machine)
	var/list/L = list()
	for(var/thing in transmit_on_tick)
		var/decl/public_access/public_variable/variable = transmit_on_tick[thing]
		L[thing] = variable.access_var(machine)
	queue_transmit(L)

// This is a variant that waits for an event (a public var set), and then transmits everything in the list.

/obj/item/weapon/stock_parts/radio/transmitter/on_event
	multitool_extension = /datum/extension/interactive/multitool/radio/event_transmitter
	var/decl/public_access/public_variable/event
	var/list/transmit_on_event

/obj/item/weapon/stock_parts/radio/transmitter/on_event/on_install(obj/machinery/machine)
	..()
	transmit_on_event = sanitize_events(machine, transmit_on_event)
	if(!is_valid_event(machine, event))
		event = null
	if(event)
		event.register_listener(src, machine, .proc/trigger_event)

/obj/item/weapon/stock_parts/radio/transmitter/on_event/on_uninstall(obj/machinery/machine)
	if(event)
		event.unregister_listener(src, machine)
	..()

/obj/item/weapon/stock_parts/radio/transmitter/on_event/Destroy()
	if(event && istype(loc, /obj/machinery))
		event.unregister_listener(src, loc)
	. = ..()

/obj/item/weapon/stock_parts/radio/transmitter/on_event/proc/trigger_event(decl/public_access/public_variable/variable, obj/machinery/machine, old_value, new_value)
	var/list/dat = list()
	for(var/thing in transmit_on_event)
		var/decl/public_access/public_variable/check_variable = transmit_on_event[thing]
		dat[thing] = check_variable.access_var(machine)
	queue_transmit(dat)

// The base receiver. Can write vars or trigger procs on signal received.

/obj/item/weapon/stock_parts/radio/receiver
	name = "radio receiver"
	desc = "A radio receiver designed for use with machines."
	icon_state = "subspace_amplifier"
	multitool_extension = /datum/extension/interactive/multitool/radio/receiver
	var/list/receive_and_write
	var/list/receive_and_call

/obj/item/weapon/stock_parts/radio/receiver/on_install(obj/machinery/machine)
	. = ..()
	receive_and_write = sanitize_events(machine, receive_and_write)
	receive_and_call = sanitize_events(machine, receive_and_call)

/obj/item/weapon/stock_parts/radio/receiver/is_valid_event(obj/machinery/machine, decl/public_access/variable)
	if(istype(variable, /decl/public_access/public_method))
		return LAZYACCESS(machine.public_methods, variable.type)
	if(..())
		var/decl/public_access/public_variable/thing = variable
		return thing.can_write

/obj/item/weapon/stock_parts/radio/receiver/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!(status & PART_STAT_INSTALLED))
		return
	if(signal.encryption && signal.encryption != encryption)
		return
	if(id_tag && signal.data["tag"] != id_tag)
		return

	var/obj/machinery/machine = loc
	if(!istype(machine))
		return
	for(var/thing in receive_and_write)
		if(!isnull(signal.data[thing]))
			var/decl/public_access/public_variable/variable = receive_and_write[thing]
			variable.write_var_protected(machine, signal.data[thing])
	for(var/thing in receive_and_call)
		if(!isnull(signal.data[thing]))
			var/decl/public_access/public_method/method = receive_and_call[thing]
			method.perform(machine)