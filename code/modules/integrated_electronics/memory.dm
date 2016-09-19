/obj/item/integrated_circuit/memory
	name = "memory chip"
	desc = "This tiny chip can store one piece of data."
	icon_state = "memory"
	complexity = 1
	number_of_inputs = 1
	number_of_outputs = 1
	number_of_activators = 1
	activator_names = list(
		"set"
	)

/obj/item/integrated_circuit/memory/examine(mob/user)
	..()
	var/i
	for(i = 1, i <= outputs.len, i++)
		var/datum/integrated_io/O = outputs[i]
		user << "\The [src] has [O.data ? "'O.data'" : "nothing"] saved to address [i]."

/obj/item/integrated_circuit/memory/work()
	if(..())
		var/i
		for(i = 1, i <= inputs.len, i++)
			var/datum/integrated_io/I = inputs[i]
			var/datum/integrated_io/O = outputs[i]
			O.data = I.data

/obj/item/integrated_circuit/memory/medium
	name = "memory circuit"
	desc = "This circuit can store four pieces of data."
	icon_state = "memory4"
	complexity = 4
	number_of_inputs = 4
	number_of_outputs = 4

/obj/item/integrated_circuit/memory/large
	name = "large memory circuit"
	desc = "This big circuit can hold eight pieces of data."
	icon_state = "memory8"
	complexity = 8
	number_of_inputs = 8
	number_of_outputs = 8

/obj/item/integrated_circuit/memory/huge
	name = "large memory stick"
	desc = "This stick of memory can hold up up to sixteen pieces of data."
	icon_state = "memory16"
	complexity = 16
	number_of_inputs = 16
	number_of_outputs = 16

/obj/item/integrated_circuit/memory/constant
	name = "constant chip"
	desc = "This tiny chip can store one piece of data, which cannot be overwritten without disassembly."
	icon_state = "memory"
	complexity = 1
	number_of_inputs = 0
	number_of_outputs = 1
	number_of_activators = 1
	activator_names = list(
		"push data"
	)
	var/accepting_refs = 0

/obj/item/integrated_circuit/memory/constant/work()
	var/datum/integrated_io/O = outputs[1]
	O.push_data()

/obj/item/integrated_circuit/memory/constant/attack_self(mob/user)
	var/datum/integrated_io/O = outputs[1]
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in list("string","number","ref", "null")
	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = input("Now type in a string.","[src] string writing") as null|text
			if(istext(new_data))
				O.data = new_data
				user << "<span class='notice'>You set \the [src]'s memory to [O.display_data()].</span>"
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data))
				O.data = new_data
				user << "<span class='notice'>You set \the [src]'s memory to [O.display_data()].</span>"
		if("ref")
			accepting_refs = 1
			user << "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>"
		if("null")
			O.data = null
			user << "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>"

/obj/item/integrated_circuit/memory/constant/afterattack(atom/target, mob/living/user, proximity)
	if(accepting_refs && proximity)
		var/datum/integrated_io/O = outputs[1]
		O.data = target
		visible_message("<span class='notice'>[user] slides \a [src]'s over \the [target].</span>")
		user << "<span class='notice'>You set \the [src]'s memory to a reference to [O.display_data()].  The ref scanner is \
		now off.</span>"
		accepting_refs = 0