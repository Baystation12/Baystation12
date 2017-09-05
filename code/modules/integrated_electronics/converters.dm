//These circuits convert one variable to another.
/obj/item/integrated_circuit/converter
	complexity = 2
	inputs = list("input")
	outputs = list("output")
	activators = list("convert")
	category = /obj/item/integrated_circuit/converter

/obj/item/integrated_circuit/converter/num2text
	name = "number to string"
	desc = "This circuit can convert a number variable into a string."
	icon_state = "num-string"

/obj/item/integrated_circuit/converter/num2text/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	if(incoming.data && isnum(incoming.data))
		result = num2text(incoming.data)
	set_pin_data(IC_OUTPUT, 1, result)

/obj/item/integrated_circuit/converter/text2num
	name = "string to number"
	desc = "This circuit can convert a string variable into a number."
	icon_state = "string-num"

/obj/item/integrated_circuit/converter/text2num/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	if(istext(incoming.data))
		result = text2num(incoming.data)

	set_pin_data(IC_OUTPUT, 1, result)

/obj/item/integrated_circuit/converter/text2ascii
	name = "char to ascii"
	desc = "This circuit can convert a single string character into the corresponding ASCII number"
	icon_state = "string-ascii"
	extended_desc = "In the case of multi-character string input only the first character will be converted."

/obj/item/integrated_circuit/converter/text2ascii/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	if(istext(incoming.data))
		result = text2ascii(incoming.data)

	set_pin_data(IC_OUTPUT, 1, result)

/obj/item/integrated_circuit/converter/ascii2text
	name = "ascii to char"
	desc = "This circuit can convert a given ASCII number to the corresponding string"
	icon_state = "ascii-string"

/obj/item/integrated_circuit/converter/ascii2text/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	if(isnum(incoming.data))
		result = ascii2text(incoming.data)

	set_pin_data(IC_OUTPUT, 1, result)

/obj/item/integrated_circuit/converter/ref2text
	name = "reference to string"
	desc = "This circuit can convert a reference to something else to a string, specifically the name of that reference."
	icon_state = "ref-string"

/obj/item/integrated_circuit/converter/ref2text/do_work()
	var/datum/integrated_io/incoming = inputs[1]
	var/atom/A = incoming.data_as_type(/atom)

	set_pin_data(IC_OUTPUT, 1, A && A.name)

/obj/item/integrated_circuit/converter/lowercase
	name = "lowercase string converter"
	desc = "this will cause a string to come out in all lowercase."
	icon_state = "lowercase"

/obj/item/integrated_circuit/converter/lowercase/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	if(incoming.data && istext(incoming.data))
		result = lowertext(incoming.data)

	set_pin_data(IC_OUTPUT, 1, result)

/obj/item/integrated_circuit/converter/uppercase
	name = "uppercase string converter"
	desc = "THIS WILL CAUSE A STRING TO COME OUT IN ALL UPPERCASE."
	icon_state = "uppercase"

/obj/item/integrated_circuit/converter/uppercase/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	if(incoming.data && istext(incoming.data))
		result = uppertext(incoming.data)

	set_pin_data(IC_OUTPUT, 1, result)

/obj/item/integrated_circuit/converter/concatenatior
	name = "concatenatior"
	desc = "This joins many strings together to get one big string."
	complexity = 4
	inputs = list("A","B","C","D","E","F","G","H")
	outputs = list("result")
	activators = list("concatenate")

/obj/item/integrated_circuit/converter/concatenatior/do_work()
	var/result = list()
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(istext(I.data))
			result = result + I.data

	set_pin_data(IC_OUTPUT, 1, jointext(result,null))
