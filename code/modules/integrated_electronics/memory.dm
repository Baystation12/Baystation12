/obj/item/integrated_circuit/memory
	name = "memory chip"
	desc = "This tiny chip can store one piece of data."
	icon_state = "memory"
	complexity = 1
	inputs = list()
	outputs = list()
	activators = list("set")
	category = /obj/item/integrated_circuit/memory
	var/memory_pins = 1

/obj/item/integrated_circuit/memory/New()
	for(var/i = 1 to memory_pins)
		inputs += "input [i]"
		outputs += "output [i]"
	complexity = memory_pins
	..()

/obj/item/integrated_circuit/memory/internal_examine(mob/user)
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
		set_pin_data(IC_OUTPUT, i, get_pin_data(IC_INPUT, i))

/obj/item/integrated_circuit/memory/medium
	name = "memory circuit"
	desc = "This circuit can store four pieces of data."
	icon_state = "memory4"
	memory_pins = 4

/obj/item/integrated_circuit/memory/large
	name = "large memory circuit"
	desc = "This big circuit can hold eight pieces of data."
	icon_state = "memory8"
	memory_pins = 8

/obj/item/integrated_circuit/memory/huge
	name = "large memory stick"
	desc = "This stick of memory can hold up up to sixteen pieces of data."
	icon_state = "memory16"
	memory_pins = 16

/obj/item/integrated_circuit/memory/constant
	name = "constant chip"
	desc = "This tiny chip can store one piece of data, which cannot be overwritten without disassembly."
	icon_state = "memory"
	complexity = 1
	inputs = list()
	outputs = list("output pin")
	activators = list("push data")
	memory_pins = 0
	var/accepting_refs = 0

/obj/item/integrated_circuit/memory/constant/do_work()
	push_data()

/obj/item/integrated_circuit/memory/constant/attack_self(mob/user)
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in list("string","number","ref", "null")
	if(!CanInteract(user, physical_state))
		return

	var/datum/integrated_io/O = outputs[1]
	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = input("Now type in a string.","[src] string writing") as null|text
			if(istext(new_data) && CanInteract(user, physical_state))
				O.write_data_to_pin(new_data)
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [O.display_data()].</span>")
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data) && CanInteract(user, physical_state))
				O.write_data_to_pin(new_data)
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [O.display_data()].</span>")
		if("ref")
			accepting_refs = 1
			to_chat(user, "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>")
		if("null")
			O.write_data_to_pin(null)
			to_chat(user, "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>")
/obj/item/integrated_circuit/memory/constant/afterattack(atom/target, mob/living/user, proximity)
	if(accepting_refs && proximity)
		var/datum/integrated_io/O = outputs[1]
		O.write_data_to_pin(weakref(target))
		visible_message("<span class='notice'>[user] slides \a [src]'s over \the [target].</span>")
		to_chat(user, "<span class='notice'>You set \the [src]'s memory to a reference to [O.display_data()].  The ref scanner is \
		now off.</span>")
		accepting_refs = 0
