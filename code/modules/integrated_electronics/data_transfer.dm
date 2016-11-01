/obj/item/integrated_circuit/transfer/splitter
	name = "splitter"
	desc = "Splits incoming data into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	inputs = list("data to split")
	outputs = list("A","B")

/obj/item/integrated_circuit/transfer/splitter/medium
	name = "four splitter"
	icon_state = "splitter4"
	complexity = 5
	outputs = list("A","B","C","D")

/obj/item/integrated_circuit/transfer/splitter/large
	name = "eight splitter"
	icon_state = "splitter8"
	complexity = 9
	outputs = list("A","B","C","D","E","F","G","H")

/obj/item/integrated_circuit/transfer/splitter/do_work()
	var/datum/integrated_io/I = inputs[1]
	for(var/i = 1 to outputs.len)
		set_pin_data(IC_OUTPUT, i, I.data)

/obj/item/integrated_circuit/transfer/activator_splitter
	name = "activator splitter"
	desc = "Splits incoming activation pulses into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B"
	)

/obj/item/integrated_circuit/transfer/activator_splitter/do_work(var/io)
	if(io != activators[1])
		return

	for(var/datum/integrated_io/activate/A in activators)
		if(A == activators[1])
			continue
		A.activate()

/obj/item/integrated_circuit/transfer/activator_splitter/medium
	name = "four activator splitter"
	icon_state = "splitter4"
	complexity = 5
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B",
		"outgoing pulse C",
		"outgoing pulse D"
	)

/obj/item/integrated_circuit/transfer/activator_splitter/large
	name = "eight activator splitter"
	icon_state = "splitter4"
	complexity = 9
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B",
		"outgoing pulse C",
		"outgoing pulse D",
		"outgoing pulse E",
		"outgoing pulse F",
		"outgoing pulse G",
		"outgoing pulse H"
	)
