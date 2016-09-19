//These circuits do simple math.
/obj/item/integrated_circuit/arithmetic
	complexity = 1
	number_of_inputs = 8
	number_of_outputs = 1
	number_of_activators = 1
	input_names = list(
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H"
		)
	output_names = list(
		"result"
	)
	activator_names = list(
		"compute"
	)

// +Adding+ //

/obj/item/integrated_circuit/arithmetic/addition
	name = "addition circuit"
	desc = "This circuit can add numbers together."
	icon_state = "addition"

/obj/item/integrated_circuit/arithmetic/addition/work()
	if(..())
		var/result = 0
		for(var/datum/integrated_io/input/I in inputs)
			I.pull_data()
			if(isnum(I.data))
				result = result + I.data

		for(var/datum/integrated_io/output/O in outputs)
			O.data = result
			O.push_data()

// -Subtracting- //

/obj/item/integrated_circuit/arithmetic/subtraction
	name = "subtraction circuit"
	desc = "This circuit can subtract numbers."
	icon_state = "subtraction"

/obj/item/integrated_circuit/arithmetic/subtraction/work()
	if(..())
		var/result = 0
		for(var/datum/integrated_io/input/I in inputs)
			I.pull_data()
			if(isnum(I.data))
				result = result - I.data

		for(var/datum/integrated_io/output/O in outputs)
			O.data = result
			O.push_data()

// *Multiply* //

/obj/item/integrated_circuit/arithmetic/multiplication
	name = "multiplication circuit"
	desc = "This circuit can multiply numbers."
	icon_state = "multiplication"

/obj/item/integrated_circuit/arithmetic/subtraction/work()
	if(..())
		var/result = 0
		for(var/datum/integrated_io/input/I in inputs)
			I.pull_data()
			if(isnum(I.data))
				result = result * I.data

		for(var/datum/integrated_io/output/O in outputs)
			O.data = result
			O.push_data()

// /Division/  //

/obj/item/integrated_circuit/arithmetic/division
	name = "division circuit"
	desc = "This circuit can divide numbers, just don't think about trying to divide by zero!"
	icon_state = "division"

/obj/item/integrated_circuit/arithmetic/division/work()
	if(..())
		var/result = 0
		for(var/datum/integrated_io/input/I in inputs)
			I.pull_data()
			if(isnum(I.data) && I.data != 0) //No runtimes here.
				result = result / I.data

		for(var/datum/integrated_io/output/O in outputs)
			O.data = result
			O.push_data()

// Absolute //

/obj/item/integrated_circuit/arithmetic/absolute
	name = "absolute circuit"
	desc = "This outputs a non-negative version of the number you put in.  This may also be thought of as its distance from zero."
	icon_state = "absolute"
	number_of_inputs = 1
	number_of_outputs = 1

/obj/item/integrated_circuit/arithmetic/absolute/work()
	if(..())
		var/result = 0
		for(var/datum/integrated_io/input/I in inputs)
			I.pull_data()
			if(isnum(I.data) && I.data != 0)
				result = abs(result)

		for(var/datum/integrated_io/output/O in outputs)
			O.data = result
			O.push_data()

// Averaging //

/obj/item/integrated_circuit/arithmetic/average
	name = "average circuit"
	desc = "This circuit is of average quality, however it will compute the average for numbers you give it."
	icon_state = "average"

/obj/item/integrated_circuit/arithmetic/average/work()
	if(..())
		var/result = 0
		var/inputs_used = 0
		for(var/datum/integrated_io/input/I in inputs)
			I.pull_data()
			if(isnum(I.data))
				inputs_used++
				result = result + I.data

		if(inputs_used)
			result = result / inputs_used

		for(var/datum/integrated_io/output/O in outputs)
			O.data = result
			O.push_data()

// Pi, because why the hell not? //
/obj/item/integrated_circuit/arithmetic/pi
	name = "pi constant circuit"
	desc = "Not recommended for cooking.  Outputs '3.14159' when it receives a pulse."
	icon_state = "pi"
	number_of_inputs = 0
	number_of_outputs = 1

/obj/item/integrated_circuit/arithmetic/pi/work()
	if(..())
		var/datum/integrated_io/output/O = outputs[1]
		O.data = 3.14159
		O.push_data()

// Random //
/obj/item/integrated_circuit/arithmetic/random
	name = "random number generator circuit"
	desc = "This gives a random (integer) number between values A and B inclusive."
	icon_state = "random"
	number_of_inputs = 2
	number_of_outputs = 1
	number_of_activators = 1
	input_names = list(
		"L",
		"H"
		)

/obj/item/integrated_circuit/arithmetic/random/work()
	if(..())
		var/result = 0
		var/datum/integrated_io/L = inputs[1]
		var/datum/integrated_io/H = inputs[2]

		if(isnum(L.data) && isnum(H.data))
			result = rand(L.data, H.data)

		for(var/datum/integrated_io/output/O in outputs)
			O.data = result
			O.push_data()