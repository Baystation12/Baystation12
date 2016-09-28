/obj/item/integrated_circuit/memory
	name = "memory chip"
	desc = "This tiny chip can store one piece of data."
	icon_state = "memory"
	complexity = 1
	inputs = list("input pin 1")
	outputs = list("output pin 1")
	activators = list("set")
	category = /obj/item/integrated_circuit/memory

/obj/item/integrated_circuit/memory/examine(mob/user)
	..()
	var/i
	for(i = 1, i <= outputs.len, i++)
		var/datum/integrated_io/O = outputs[i]
		var/data = "nothing"
		if(isweakref(O.data))
			var/datum/d = O.data_as_type(/datum)
			if(d)
				data = "[d]"
		else if(!isnull(O.data))
			data = O.data
		to_chat(user, "\The [src] has [data] saved to address [i].")

/obj/item/integrated_circuit/memory/do_work()
	for(var/i = 1 to inputs.len)
		var/datum/integrated_io/I = inputs[i]
		var/datum/integrated_io/O = outputs[i]
		O.data = I.data
	push_data()

/obj/item/integrated_circuit/memory/medium
	name = "memory circuit"
	desc = "This circuit can store four pieces of data."
	icon_state = "memory4"
	complexity = 4
	inputs = list("input pin 1","input pin 2","input pin 3","input pin 4")
	outputs = list("output pin 1","output pin 2","output pin 3","output pin 4")

/obj/item/integrated_circuit/memory/large
	name = "large memory circuit"
	desc = "This big circuit can hold eight pieces of data."
	icon_state = "memory8"
	complexity = 8
	inputs = list(
		"input pin 1",
		"input pin 2",
		"input pin 3",
		"input pin 4",
		"input pin 5",
		"input pin 6",
		"input pin 7",
		"input pin 8")
	outputs = list(
		"output pin 1",
		"output pin 2",
		"output pin 3",
		"output pin 4",
		"output pin 5",
		"output pin 6",
		"output pin 7",
		"output pin 8")

/obj/item/integrated_circuit/memory/huge
	name = "large memory stick"
	desc = "This stick of memory can hold up up to sixteen pieces of data."
	icon_state = "memory16"
	complexity = 16
	inputs = list(
		"input pin 1",
		"input pin 2",
		"input pin 3",
		"input pin 4",
		"input pin 5",
		"input pin 6",
		"input pin 7",
		"input pin 8",
		"input pin 9",
		"input pin 10",
		"input pin 11",
		"input pin 12",
		"input pin 13",
		"input pin 14",
		"input pin 15",
		"input pin 16"
	)
	outputs = list(
		"output pin 1",
		"output pin 2",
		"output pin 3",
		"output pin 4",
		"output pin 5",
		"output pin 6",
		"output pin 7",
		"output pin 8",
		"output pin 9",
		"output pin 10",
		"output pin 11",
		"output pin 12",
		"output pin 13",
		"output pin 14",
		"output pin 15",
		"output pin 16")

/obj/item/integrated_circuit/memory/constant
	name = "constant chip"
	desc = "This tiny chip can store one piece of data, which cannot be overwritten without disassembly."
	icon_state = "memory"
	complexity = 1
	inputs = list()
	outputs = list("output pin")
	activators = list("push data")
	var/accepting_refs = 0

/obj/item/integrated_circuit/memory/constant/do_work()
	var/datum/integrated_io/O = outputs[1]
	O.push_data()

/obj/item/integrated_circuit/memory/constant/attack_self(mob/user)
	var/datum/integrated_io/O = outputs[1]
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in list("string","number","ref", "null")
	if(!CanInteract(user, physical_state))
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = input("Now type in a string.","[src] string writing") as null|text
			if(istext(new_data) && CanInteract(user, physical_state))
				O.data = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [O.display_data()].</span>")
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data) && CanInteract(user, physical_state))
				O.data = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [O.display_data()].</span>")
		if("ref")
			accepting_refs = 1
			to_chat(user, "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>")
		if("null")
			O.data = null
			to_chat(user, "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>")

/obj/item/integrated_circuit/memory/constant/afterattack(atom/target, mob/living/user, proximity)
	if(accepting_refs && proximity)
		var/datum/integrated_io/O = outputs[1]
		O.data = weakref(target)
		visible_message("<span class='notice'>[user] slides \a [src]'s over \the [target].</span>")
		to_chat(user, "<span class='notice'>You set \the [src]'s memory to a reference to [O.display_data()].  The ref scanner is \
		now off.</span>")
		accepting_refs = 0
