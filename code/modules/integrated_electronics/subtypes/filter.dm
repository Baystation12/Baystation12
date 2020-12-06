/obj/item/integrated_circuit/filter
	category_text = "Filter"
	power_draw_per_use = 5
	complexity = 2
	activators = list("compare" = IC_PINTYPE_PULSE_IN, "if valid" = IC_PINTYPE_PULSE_OUT, "if not valid" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	icon = 'icons/obj/electronic_assemblies.dmi'

/obj/item/integrated_circuit/filter/proc/may_pass(var/input)
	return FALSE

/obj/item/integrated_circuit/filter/do_work()
	push_data()

/obj/item/integrated_circuit/filter/ref
	extended_desc = "Uses heuristics and complex algoritms to match incoming data against its filtering parameters and occasionally produces both false positives and negatives."
	var/filter_type
	complexity = 4
	inputs = list( "input" = IC_PINTYPE_REF )
	outputs = list("result" = IC_PINTYPE_BOOLEAN)

/obj/item/integrated_circuit/filter/ref/may_pass(var/weakref/data)
	if(!(filter_type && isweakref(data)))
		return FALSE
	var/weakref/wref = data
	return istype(wref.resolve(), filter_type)


/obj/item/integrated_circuit/filter/ref/do_work()
	var/datum/integrated_io/A = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = may_pass(A.data) ? TRUE : FALSE

	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	..()

/obj/item/integrated_circuit/filter/ref/mob
	name = "life filter"
	desc = "Only allow refs belonging to more complex, currently or formerly, living but not necessarily biological entities through"
	icon_state = "filter_mob"
	filter_type = /mob/living

/obj/item/integrated_circuit/filter/ref/mob/humanoid
	name = "humanoid filter"
	desc = "Only allow refs belonging to humanoids (dead or alive) through"
	icon_state = "filter_humanoid"
	filter_type = /mob/living/carbon/human

/obj/item/integrated_circuit/filter/ref/obj
	name = "object filter"
	desc = "Allows most kinds of refs to pass, as long as they are not considered (once) living entities."
	icon_state = "filter_obj"
	filter_type = /obj

/obj/item/integrated_circuit/filter/ref/obj/item
	name = "item filter"
	desc = "Only allow refs belonging to minor items through, typically hand-held such."
	icon_state = "filter_item"
	filter_type = /obj/item

/obj/item/integrated_circuit/filter/ref/obj/machinery
	name = "machinery filter"
	desc = "Only allow refs belonging machinery or complex objects through, such as computers and consoles."
	icon_state = "filter_machinery"
	filter_type = /obj/machinery

/obj/item/integrated_circuit/filter/ref/object/structure
	name = "structure filter"
	desc = "Only allow refs belonging larger objects and structures through, such as closets and beds."
	icon_state = "filter_structure"
	filter_type = /obj/structure

/obj/item/integrated_circuit/filter/ref/custom
	name = "custom filter"
	desc = "Allows custom filtering. It will match type against a stored reference."
	icon_state = "filter_custom"
	inputs = list( "input" = IC_PINTYPE_REF, "expected type" = IC_PINTYPE_REF )

/obj/item/integrated_circuit/filter/ref/custom/may_pass(var/weakref/data, var/weakref/typedata)
	if(!isweakref(data) || !isweakref(typedata))
		return FALSE
	var/weakref/wref = data
	var/weakref/wref2 = typedata
	var/atom/A = wref.resolve()
	var/atom/B = wref2.resolve()
	return (A && B && (istype(A, B.type)))

/obj/item/integrated_circuit/filter/ref/custom/do_work()
	var/datum/integrated_io/A = inputs[1]
	var/datum/integrated_io/T = inputs[2]
	var/datum/integrated_io/O = outputs[1]
	O.data = may_pass(A.data, T.data) ? TRUE : FALSE

	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()