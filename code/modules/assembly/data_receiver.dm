/obj/item/device/assembly/data_receiver
	name = "data receiver"
	desc = "Receivess data. Duh."
	icon_state = "logic"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

	receive_data(var/list/data, var/obj/item/device/assembly/sender)
		receive_direct_pulse() // Does all the wire checking for us. Hooray!
		return 1