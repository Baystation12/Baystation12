//These circuits do simple math.
/obj/item/integrated_circuit/arithmetic
	complexity = 1
	inputs = list("A","B","C","D","E","F","G","H")
	outputs = list("result")
	activators = list("compute")
	category = /obj/item/integrated_circuit/arithmetic

// +Adding+ //

/obj/item/integrated_circuit/arithmetic/addition
	name = "addition circuit"
	desc = "This circuit can add numbers together."
	icon_state = "addition"

/obj/item/integrated_circuit/arithmetic/addition/do_work()
	var/result = 0
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			result = result + I.data
	set_pin_data(IC_OUTPUT, 1, result)

// -Subtracting- //

/obj/item/integrated_circuit/arithmetic/subtraction
	name = "subtraction circuit"
	desc = "This circuit can subtract numbers."
	icon_state = "subtraction"

/obj/item/integrated_circuit/arithmetic/subtraction/do_work()
	var/result = 0
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			result = result - I.data
	set_pin_data(IC_OUTPUT, 1, result)

// *Multiply* //

/obj/item/integrated_circuit/arithmetic/multiplication
	name = "multiplication circuit"
	desc = "This circuit can multiply numbers."
	icon_state = "multiplication"

/obj/item/integrated_circuit/arithmetic/subtraction/do_work()
	var/result = 0
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			result = result * I.data
	set_pin_data(IC_OUTPUT, 1, result)

// /Division/  //

/obj/item/integrated_circuit/arithmetic/division
	name = "division circuit"
	desc = "This circuit can divide numbers, just don't think about trying to divide by zero!"
	icon_state = "division"

/obj/item/integrated_circuit/arithmetic/division/do_work()
	var/result = 0
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(isnum(I.data) && I.data != 0) //No runtimes here.
			result = result / I.data
	set_pin_data(IC_OUTPUT, 1, result)

// Absolute //

/obj/item/integrated_circuit/arithmetic/absolute
	name = "absolute circuit"
	desc = "This outputs a non-negative version of the number you put in.  This may also be thought of as its distance from zero."
	icon_state = "absolute"
	inputs = list("A")

/obj/item/integrated_circuit/arithmetic/absolute/do_work()
	var/result = 0
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(isnum(I.data) && I.data != 0)
			result = abs(result)
	set_pin_data(IC_OUTPUT, 1, result)

// Averaging //

/obj/item/integrated_circuit/arithmetic/average
	name = "average circuit"
	desc = "This circuit is of average quality, however it will compute the average for numbers you give it."
	icon_state = "average"

/obj/item/integrated_circuit/arithmetic/average/do_work()
	var/result = 0
	var/inputs_used = 0
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			inputs_used++
			result = result + I.data

	if(inputs_used)
		result = result / inputs_used
	set_pin_data(IC_OUTPUT, 1, result)

// Pi, because why the hell not? //
/obj/item/integrated_circuit/arithmetic/pi
	name = "pi constant circuit"
	desc = "Not recommended for cooking.  Outputs '3.14159' when it receives a pulse."
	icon_state = "pi"
	inputs = list()

/obj/item/integrated_circuit/arithmetic/pi/do_work()
	set_pin_data(IC_OUTPUT, 1, 3.14159)

// Random //
/obj/item/integrated_circuit/arithmetic/random
	name = "random number generator circuit"
	desc = "This gives a random (integer) number between values A and B inclusive."
	icon_state = "random"
	inputs = list("L","H")

/obj/item/integrated_circuit/arithmetic/random/do_work()
	var/result = 0
	var/datum/integrated_io/L = inputs[1]
	var/datum/integrated_io/H = inputs[2]

	if(isnum(L.data) && isnum(H.data))
		result = rand(L.data, H.data)
	set_pin_data(IC_OUTPUT, 1, result)
