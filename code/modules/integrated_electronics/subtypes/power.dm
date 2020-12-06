/obj/item/integrated_circuit/power/
	category_text = "Power - Active"

/obj/item/integrated_circuit/power/transmitter
	name = "power transmission circuit"
	desc = "This can wirelessly transmit electricity from an assembly's battery towards a nearby machine."
	icon_state = "power_transmitter"
	extended_desc = "This circuit transmits 5 kJ of electricity every time the activator pin is pulsed. The input pin must be \
	a reference to a machine to send electricity to. This can be a battery, or anything containing a battery. The machine can exist \
	inside the assembly, or adjacent to it. The power is sourced from the assembly's power cell. If the target is outside of the assembly, \
	some power is lost due to inefficiency."
	w_class = ITEM_SIZE_SMALL
	complexity = 16
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"target cell charge" = IC_PINTYPE_NUMBER,
		"target cell max charge" = IC_PINTYPE_NUMBER,
		"target cell percentage" = IC_PINTYPE_NUMBER
		)
	activators = list("transmit" = IC_PINTYPE_PULSE_IN, "on transmit" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 500 // Inefficiency has to come from somewhere.
	var/amount_to_move = 5000

/obj/item/integrated_circuit/power/transmitter/large
	name = "large power transmission circuit"
	desc = "This can wirelessly transmit a lot of electricity from an assembly's battery towards a nearby machine. <b>Warning:</b> Do not operate in flammable environments."
	extended_desc = "This circuit transmits 20 kJ of electricity every time the activator pin is pulsed. The input pin must be \
	a reference to a machine to send electricity to. This can be a battery, or anything containing a battery. The machine can exist \
	inside the assembly, or adjacent to it. The power is sourced from the assembly's power cell. If the target is outside of the assembly, \
	some power is lost due to inefficiency. Warning! Don't stack more than 1 power transmitter, as it becomes less efficient for every other \
	transmission circuit in its own assembly and other nearby ones."
	w_class = ITEM_SIZE_LARGE
	complexity = 32
	power_draw_per_use = 2000
	amount_to_move = 20000

/obj/item/integrated_circuit/power/transmitter/do_work()

	var/obj/O = get_pin_data_as_type(IC_INPUT, 1, /obj)
	if(!O)
		return FALSE
	if(istype(O, /obj/item/weapon/gun/energy))
		return FALSE
	if(!assembly)
		return FALSE // Pointless to do everything else if there's no battery to draw from.
	var/obj/item/weapon/cell/cell = O.get_cell()
	if(cell)
		var/transfer_amount = amount_to_move
		var/turf/A = get_turf(src)
		var/turf/B = get_turf(O)
		if(A.Adjacent(B))
			if(O.loc != assembly)
				transfer_amount *= 0.8 // Losses due to distance.
			var/transmitter_count = 0
			for(var/obj/item/integrated_circuit/power/transmitter in A.GetAllContents())
				transmitter_count++
			if(!transmitter_count)
				return FALSE
			transfer_amount /= transmitter_count
			set_pin_data(IC_OUTPUT, 1, cell.charge)
			set_pin_data(IC_OUTPUT, 2, cell.maxcharge)
			set_pin_data(IC_OUTPUT, 3, cell.percent())
			activate_pin(2)
			push_data()
			if(cell.charge == cell.maxcharge)
				return FALSE
			if(transfer_amount && assembly.draw_power(amount_to_move)) // CELLRATE is already handled in draw_power()
				cell.give(transfer_amount * CELLRATE)
				if(istype(O, /obj/item))
					var/obj/item/I = O
					I.update_icon()
				return TRUE
	else
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, null)
		activate_pin(2)
		push_data()
		return FALSE

/obj/item/integrated_circuit/power/transmitter/large/do_work()
	if(..()) // If the above code succeeds, do this below.
		var/atom/movable/acting_object = get_object()
		if(prob(20))
			var/datum/effect/effect/system/spark_spread/s = new()
			s.set_up(12, 1, src)
			s.start()
			acting_object.visible_message("<span class='warning'>\The [acting_object] makes some sparks!</span>")
		return TRUE
