/obj/item/integrated_circuit/logic
	name = "logic gate"
	desc = "This tiny chip will decide for you!"
	complexity = 3
	number_of_inputs = 2
	number_of_outputs = 1
	number_of_activators = 2
	input_names = list(
		"A",
		"B"
		)
	output_names = list(
		"result"
	)
	activator_names = list(
		"compare",
		"on true result"
	)

/obj/item/integrated_circuit/logic/equals
	name = "equal gate"
	desc = "This gate compares two values, and outputs the number one if both are the same."
	icon_state = "equal"

/obj/item/integrated_circuit/logic/equals/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/B = inputs[2]
		var/datum/integrated_io/O = outputs[1]
		var/datum/integrated_io/P = activators[2]
		if(A.data == B.data)
			O.data = 1
			O.push_data()
			P.push_data()
		else
			O.data = 0

/obj/item/integrated_circuit/logic/not
	name = "not gate"
	desc = "This gate inverts what's fed into it."
	icon_state = "not"
	number_of_inputs = 1
	number_of_outputs = 1
	number_of_activators = 1
	output_names = list(
		"invert"
	)


/obj/item/integrated_circuit/logic/not/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/O = outputs[1]
		if(A.data)
			O.data = !A.data
			O.push_data()
		else
			O.data = 0

/obj/item/integrated_circuit/logic/and
	name = "and gate"
	desc = "This gate will output 'one' if both inputs evaluate to true."
	icon_state = "and"

/obj/item/integrated_circuit/logic/and/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/B = inputs[2]
		var/datum/integrated_io/O = outputs[1]
		var/datum/integrated_io/P = activators[2]
		if(A.data && B.data)
			O.data = 1
			O.push_data()
			A.push_data()
			P.push_data()
		else
			O.data = 0

/obj/item/integrated_circuit/logic/or
	name = "or gate"
	desc = "This gate will output 'one' if one of the inputs evaluate to true."
	icon_state = "or"

/obj/item/integrated_circuit/logic/or/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/B = inputs[2]
		var/datum/integrated_io/O = outputs[1]
		var/datum/integrated_io/P = activators[2]
		if(A.data || B.data)
			O.data = 1
			O.push_data()
			A.push_data()
			P.push_data()
		else
			O.data = 0

/obj/item/integrated_circuit/logic/less_than
	name = "less than gate"
	desc = "This will output 'one' if the first input is less than the second input."
	icon_state = "less_than"

/obj/item/integrated_circuit/logic/less_than/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/B = inputs[2]
		var/datum/integrated_io/O = outputs[1]
		var/datum/integrated_io/P = activators[2]
		if(A.data < B.data)
			O.data = 1
			O.push_data()
			A.push_data()
			P.push_data()
		else
			O.data = 0

/obj/item/integrated_circuit/logic/less_than_or_equal
	name = "less than or equal gate"
	desc = "This will output 'one' if the first input is less than, or equal to the second input."
	icon_state = "less_than_or_equal"

/obj/item/integrated_circuit/logic/less_than_or_equal/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/B = inputs[2]
		var/datum/integrated_io/O = outputs[1]
		var/datum/integrated_io/P = activators[2]
		if(A.data <= B.data)
			O.data = 1
			O.push_data()
			A.push_data()
			P.push_data()
		else
			O.data = 0

/obj/item/integrated_circuit/logic/greater_than
	name = "greater than gate"
	desc = "This will output 'one' if the first input is greater than the second input."
	icon_state = "greater_than"

/obj/item/integrated_circuit/logic/greater_than/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/B = inputs[2]
		var/datum/integrated_io/O = outputs[1]
		var/datum/integrated_io/P = activators[2]
		if(A.data > B.data)
			O.data = 1
			O.push_data()
			A.push_data()
			P.push_data()
		else
			O.data = 0

/obj/item/integrated_circuit/logic/greater_than_or_equal
	name = "greater_than or equal gate"
	desc = "This will output 'one' if the first input is greater than, or equal to the second input."
	icon_state = "greater_than_or_equal"

/obj/item/integrated_circuit/logic/greater_than_or_equal/work()
	if(..())
		var/datum/integrated_io/A = inputs[1]
		var/datum/integrated_io/B = inputs[2]
		var/datum/integrated_io/O = outputs[1]
		var/datum/integrated_io/P = activators[2]
		if(A.data >= B.data)
			O.data = 1
			O.push_data()
			A.push_data()
			P.push_data()
		else
			O.data = 0