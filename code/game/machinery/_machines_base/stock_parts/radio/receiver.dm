// The base receiver. Can write vars or trigger procs on signal received.

/obj/item/stock_parts/radio/receiver
	name = "radio receiver"
	desc = "A radio receiver designed for use with machines."
	icon_state = "subspace_amplifier"
	multitool_extension = /datum/extension/interactive/multitool/radio/receiver
	var/list/receive_and_write
	var/list/receive_and_call

/obj/item/stock_parts/radio/receiver/on_install(obj/machinery/machine)
	. = ..()
	sanitize_events(machine, receive_and_write)
	sanitize_events(machine, receive_and_call)

/obj/item/stock_parts/radio/receiver/is_valid_event(obj/machinery/machine, decl/public_access/variable)
	if(istype(variable, /decl/public_access/public_method))
		return LAZYACCESS(machine.public_methods, variable.type)
	if(..())
		var/decl/public_access/public_variable/thing = variable
		return thing.can_write

/obj/item/stock_parts/radio/receiver/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!id_tag)
		return
	if(!(status & PART_STAT_INSTALLED))
		return
	if(signal.encryption && (signal.encryption != encryption))
		return
	if(signal.data["tag"] != id_tag)
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
			method.perform(machine, signal.data[thing])

/obj/item/stock_parts/radio/receiver/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	matter = list(MATERIAL_STEEL = 400)