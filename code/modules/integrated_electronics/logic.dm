/obj/item/integrated_circuit/logic
	name = "logic gate"
	desc = "This tiny chip will decide for you!"
	extended_desc = "Logic circuits will treat a null, 0, and a \"\" string value as FALSE and anything else as TRUE."
	complexity = 3
	outputs = list("result")
	activators = list("compare", "on true result")
	category = /obj/item/integrated_circuit/logic

/obj/item/integrated_circuit/logic/do_work(var/activator_pin)
	if(activator_pin != activators[1])
		return

	var/datum/integrated_io/O = outputs[1]
	var/datum/integrated_io/P = activators[2]
	O.push_data()
	if(O.data)
		P.push_data()

/obj/item/integrated_circuit/logic/binary
	inputs = list("A","B")
	category = /obj/item/integrated_circuit/logic/binary

/obj/item/integrated_circuit/logic/binary/do_work()
	var/datum/integrated_io/A = inputs[1]
	var/datum/integrated_io/B = inputs[2]
	var/datum/integrated_io/O = outputs[1]
	O.data = do_compare(A, B) ? TRUE : FALSE
	..()

/obj/item/integrated_circuit/logic/binary/proc/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return FALSE

/obj/item/integrated_circuit/logic/unary
	inputs = list("A")
	category = /obj/item/integrated_circuit/logic/unary

/obj/item/integrated_circuit/logic/unary/do_work()
	var/datum/integrated_io/A = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = do_check(A) ? TRUE : FALSE
	..()

/obj/item/integrated_circuit/logic/unary/proc/do_check(var/datum/integrated_io/A)
	return FALSE

/obj/item/integrated_circuit/logic/binary/equals
	name = "equal gate"
	desc = "This gate compares two values, and outputs the number one if both are the same."
	icon_state = "equal"

/obj/item/integrated_circuit/logic/binary/equals/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() == B.get_data()

/obj/item/integrated_circuit/logic/binary/and
	name = "and gate"
	desc = "This gate will output 'one' if both inputs evaluate to true."
	icon_state = "and"

/obj/item/integrated_circuit/logic/binary/and/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() && B.get_data()

/obj/item/integrated_circuit/logic/binary/or
	name = "or gate"
	desc = "This gate will output 'one' if one of the inputs evaluate to true."
	icon_state = "or"

/obj/item/integrated_circuit/logic/binary/or/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() || B.get_data()

/obj/item/integrated_circuit/logic/binary/less_than
	name = "less than gate"
	desc = "This will output 'one' if the first input is less than the second input."
	icon_state = "less_than"

/obj/item/integrated_circuit/logic/binary/less_than/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() < B.get_data()

/obj/item/integrated_circuit/logic/binary/less_than_or_equal
	name = "less than or equal gate"
	desc = "This will output 'one' if the first input is less than, or equal to the second input."
	icon_state = "less_than_or_equal"

/obj/item/integrated_circuit/logic/binary/less_than_or_equal/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() <= B.get_data()

/obj/item/integrated_circuit/logic/binary/greater_than
	name = "greater than gate"
	desc = "This will output 'one' if the first input is greater than the second input."
	icon_state = "greater_than"

/obj/item/integrated_circuit/logic/binary/greater_than/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() > B.get_data()

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	name = "greater_than or equal gate"
	desc = "This will output 'one' if the first input is greater than, or equal to the second input."
	icon_state = "greater_than_or_equal"

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() >= B.get_data()

/obj/item/integrated_circuit/logic/unary/not
	name = "not gate"
	desc = "This gate inverts what's fed into it."
	icon_state = "not"

/obj/item/integrated_circuit/logic/unary/not/do_check(var/datum/integrated_io/A)
	return !A.get_data()

/obj/item/integrated_circuit/logic/multiplexer
	name = "multiplexer"
	desc = "This is what those in the business tend to refer to as a 'mux' or data selector. It moves data from one of the selected inputs to the output."
	extended_desc = "The first input pin is used to select which of the other input pins which has its data moved to the output. If the input selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "mux2"
	inputs = list("input selection")
	activators = list("select")
	category = /obj/item/integrated_circuit/logic
	var/number_of_inputs = 2

/obj/item/integrated_circuit/logic/multiplexer/New()
	for(var/i = 1 to number_of_inputs)
		inputs += "input [i]"
	complexity = number_of_inputs
	..()
	extended_desc += " This multiplexer has a range from 1 to [inputs.len - 1]."

/obj/item/integrated_circuit/logic/multiplexer/do_work()
	var/datum/integrated_io/input_selection = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null

	if(isnum(input_selection.data) && (input_selection.data >= 1 && input_selection.data < inputs.len))
		var/datum/integrated_io/selected_input = inputs[input_selection.data + 1]
		O.data = selected_input.data

	O.push_data()

/obj/item/integrated_circuit/logic/multiplexer/medium
	number_of_inputs = 4
	icon_state = "mux4"

/obj/item/integrated_circuit/logic/multiplexer/large
	number_of_inputs = 8
	icon_state = "mux8"

/obj/item/integrated_circuit/logic/multiplexer/huge
	icon_state = "mux16"
	number_of_inputs = 16

/obj/item/integrated_circuit/logic/demultiplexer
	name = "demultiplexer"
	desc = "This is what those in the business tend to refer to as a 'demux'. It moves data from the input to one of the selected outputs."
	extended_desc = "The first input pin is used to select which of the output pins is given the data from the second input pin. If the output selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "dmux2"
	inputs = list("output selection","input")
	outputs = list()
	activators = list("select")
	category = /obj/item/integrated_circuit/logic
	var/number_of_outputs = 2

/obj/item/integrated_circuit/logic/demultiplexer/New()
	for(var/i = 1 to number_of_outputs)
		outputs += "output [i]"
	complexity = number_of_outputs

	..()
	extended_desc += " This demultiplexer has a range from 1 to [outputs.len]."

/obj/item/integrated_circuit/logic/demultiplexer/do_work()
	var/datum/integrated_io/output_selection = inputs[1]
	var/datum/integrated_io/input = inputs[2]

	for(var/datum/integrated_io/O in outputs)
		O.data = null

	if(isnum(output_selection.data) && (output_selection.data >= 1 && output_selection.data <= outputs.len))
		var/datum/integrated_io/selected_output = outputs[output_selection.data]
		selected_output.data = input.data

	push_data()

/obj/item/integrated_circuit/logic/demultiplexer/medium
	icon_state = "dmux4"
	number_of_outputs = 4

/obj/item/integrated_circuit/logic/demultiplexer/large
	icon_state = "dmux8"
	number_of_outputs = 8

/obj/item/integrated_circuit/logic/demultiplexer/huge
	icon_state = "dmux16"
	number_of_outputs = 16