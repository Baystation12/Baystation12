/obj/item/stock_parts/radio/transmitter
	name = "radio transmitter"
	desc = "A radio transmitter designed for use with machines."
	icon_state = "subspace_transmitter"
	var/range = 60  // Limits transmit range
	var/latency = 2 // Delay between event and transmission; doesn't apply to transmit on tick
	var/buffer

/obj/item/stock_parts/radio/transmitter/proc/queue_transmit(list/data)
	if(!length(data))
		return
	if(!buffer)
		buffer = data
		addtimer(CALLBACK(src, .proc/transmit), latency)
	else
		buffer |= data

/obj/item/stock_parts/radio/transmitter/proc/transmit()
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
/obj/item/stock_parts/radio/transmitter/basic
	multitool_extension = /datum/extension/interactive/multitool/radio/transmitter
	var/list/transmit_on_change
	var/list/transmit_on_tick

/obj/item/stock_parts/radio/transmitter/basic/proc/var_changed(decl/public_access/public_variable/variable, obj/machinery/machine, old_value, new_value)
	var/list/L = list()
	for(var/thing in transmit_on_change)
		if(transmit_on_change[thing] == variable)
			L[thing] = new_value
	queue_transmit(L)

/obj/item/stock_parts/radio/transmitter/basic/on_install(obj/machinery/machine)
	..()
	sanitize_events(machine, transmit_on_change)
	sanitize_events(machine, transmit_on_tick)
	if(LAZYLEN(transmit_on_tick))
		start_processing(machine)
	for(var/thing in transmit_on_change)
		var/decl/public_access/public_variable/variable = transmit_on_change[thing]
		variable.register_listener(src, machine, .proc/var_changed)

/obj/item/stock_parts/radio/transmitter/basic/on_uninstall(obj/machinery/machine)
	for(var/thing in transmit_on_change)
		var/decl/public_access/public_variable/variable = transmit_on_change[thing]
		variable.unregister_listener(src, machine)
	..()

/obj/item/stock_parts/radio/transmitter/basic/Destroy()
	if(istype(loc, /obj/machinery))
		for(var/thing in transmit_on_change)
			var/decl/public_access/public_variable/variable = transmit_on_change[thing]
			variable.unregister_listener(src, loc)
	. = ..()

/obj/item/stock_parts/radio/transmitter/basic/machine_process(obj/machinery/machine)
	var/list/L = list()
	for(var/thing in transmit_on_tick)
		var/decl/public_access/public_variable/variable = transmit_on_tick[thing]
		L[thing] = variable.access_var(machine)
	queue_transmit(L)

// This is a variant that waits for an event (a public var set), and then transmits everything in the list.

/obj/item/stock_parts/radio/transmitter/on_event
	multitool_extension = /datum/extension/interactive/multitool/radio/event_transmitter
	var/decl/public_access/public_variable/event
	var/list/transmit_on_event

/obj/item/stock_parts/radio/transmitter/on_event/is_valid_event(obj/machinery/machine, decl/public_access/variable)
	if(istype(variable, /decl/public_access/public_method))
		return LAZYACCESS(machine.public_methods, variable.type)
	return ..()

/obj/item/stock_parts/radio/transmitter/on_event/on_install(obj/machinery/machine)
	..()
	sanitize_events(machine, transmit_on_event)
	if(!is_valid_event(machine, event))
		event = null
	if(event)
		event.register_listener(src, machine, .proc/trigger_event)

/obj/item/stock_parts/radio/transmitter/on_event/on_uninstall(obj/machinery/machine)
	if(event)
		event.unregister_listener(src, machine)
	..()

/obj/item/stock_parts/radio/transmitter/on_event/Destroy()
	if(event && istype(loc, /obj/machinery))
		event.unregister_listener(src, loc)
	. = ..()

/obj/item/stock_parts/radio/transmitter/on_event/proc/trigger_event(decl/public_access/public_variable/variable, obj/machinery/machine, old_value, new_value)
	var/list/dat = list()
	for(var/thing in transmit_on_event)
		var/decl/public_access/public_variable/check_variable = transmit_on_event[thing]
		dat[thing] = check_variable.access_var(machine)
	queue_transmit(dat)

/obj/item/stock_parts/radio/transmitter/basic/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	name = "basic radio transmitter"
	desc = "A stock radio transmitter machine component. Can transmit updates regularly or on change."
	color = COLOR_RED
	matter = list(MATERIAL_STEEL = 400)

/obj/item/stock_parts/radio/transmitter/on_event/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	name = "event radio transmitter"
	desc = "A radio transmitter machine component which transmits when activated by an event."
	color = COLOR_ORANGE
	matter = list(MATERIAL_STEEL = 400)