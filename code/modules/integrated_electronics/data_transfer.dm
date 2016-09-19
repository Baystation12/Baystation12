/obj/item/integrated_circuit/transfer/splitter
	name = "splitter"
	desc = "Splits incoming data into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	number_of_inputs = 1
	number_of_outputs = 2
	input_names = list(
		"data to split"
		)
	output_names = list(
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H"
	)

/obj/item/integrated_circuit/transfer/splitter/medium
	name = "four splitter"
	icon_state = "splitter4"
	complexity = 5
	number_of_inputs = 1
	number_of_outputs = 4

/obj/item/integrated_circuit/transfer/splitter/large
	name = "eight splitter"
	icon_state = "splitter8"
	complexity = 9
	number_of_inputs = 1
	number_of_outputs = 8

/obj/item/integrated_circuit/transfer/splitter/work()
	if(..())
		var/datum/integrated_io/I = inputs[1]
		for(var/datum/integrated_io/output/O in outputs)
			O.data = I.data

/obj/item/integrated_circuit/transfer/activator_splitter
	name = "activator splitter"
	desc = "Splits incoming activation pulses into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	number_of_activators = 3
	activator_names = list(
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

/obj/item/integrated_circuit/transfer/activator_splitter/work()
	if(..())
		for(var/datum/integrated_io/activate/A in outputs)
			if(A == activators[1])
				continue
			if(A.linked.len)
				for(var/datum/integrated_io/activate/target in A.linked)
					target.holder.work()

/obj/item/integrated_circuit/transfer/activator_splitter/medium
	name = "four activator splitter"
	icon_state = "splitter4"
	complexity = 5
	number_of_activators = 5

/obj/item/integrated_circuit/transfer/activator_splitter/large
	name = "eight activator splitter"
	icon_state = "splitter4"
	complexity = 9
	number_of_activators = 9
