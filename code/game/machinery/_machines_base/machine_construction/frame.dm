// Construction frames

/singleton/machine_construction/frame/unwrenched/state_is_valid(obj/machinery/machine)
	return !machine.anchored


/singleton/machine_construction/frame/unwrenched/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/wrenched)


/singleton/machine_construction/frame/unwrenched/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, (I.toolspeed * 2) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			TRANSFER_STATE(/singleton/machine_construction/frame/wrenched)
			to_chat(user, SPAN_NOTICE("You wrench \the [machine] into place."))
			machine.anchored = TRUE
	if(isWelder(I))
		var/obj/item/weldingtool/WT = I
		if(!WT.remove_fuel(0, user))
			to_chat(user, "The welding tool must be on to complete this task.")
			return TRUE
		playsound(machine.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, (I.toolspeed * 2) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			if(!WT.isOn())
				return TRUE
			TRANSFER_STATE(/singleton/machine_construction/default/deconstructed)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [machine]."))
			machine.dismantle()
	if(istype(I, /obj/item/stack/material/titanium))
		var/obj/item/stack/M = I
		if(!(do_after(user, 2 SECONDS, machine, DO_REPAIR_CONSTRUCT) && M.use(5)))
			to_chat(user, SPAN_WARNING("You need five sheets of titanium to continue construction."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You reinforce the frame's support structure."))
		TRANSFER_STATE(/singleton/machine_construction/frame/reinforced)


/singleton/machine_construction/frame/unwrenched/mechanics_info()
	. = list()
	. += "Use a welder to break apart the frame."
	. += "Use a wrench to secure the frame in place."
	. += "Use titanium sheets to reinforce the frame."


/singleton/machine_construction/frame/wrenched/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && !machine.circuit


/singleton/machine_construction/frame/wrenched/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/wrenched/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, (I.toolspeed * 2) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			TRANSFER_STATE(/singleton/machine_construction/frame/unwrenched)
			to_chat(user, SPAN_NOTICE("You unfasten \the [machine]."))
			machine.anchored = FALSE
			return
	if(isCoil(I))
		var/obj/item/stack/cable_coil/C = I
		if(C.get_amount() < 5)
			to_chat(user, SPAN_WARNING("You need five lengths of cable to add them to \the [machine]."))
			return TRUE
		playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
		if(do_after(user, 2 SECONDS, machine, DO_REPAIR_CONSTRUCT) && C.use(5))
			TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_circuit)
			to_chat(user, SPAN_NOTICE("You add cables to the frame."))
		return TRUE


/singleton/machine_construction/frame/wrenched/mechanics_info()
	. = list()
	. += "Use a wrench to unfasten the frame from the floor and prepare it for deconstruction."
	. += "Add cables to make it ready for a circuit."


/singleton/machine_construction/frame/awaiting_circuit/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && !machine.circuit


/singleton/machine_construction/frame/awaiting_circuit/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/awaiting_circuit/attackby(obj/item/I, mob/user, obj/machinery/constructable_frame/machine)
	if(istype(I, /obj/item/stock_parts/circuitboard))
		var/obj/item/stock_parts/circuitboard/circuit = I
		if(circuit.board_type == machine.expected_machine_type)
			if(!user.canUnEquip(I))
				return FALSE
			TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_parts)
			user.unEquip(I, machine)
			playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You add the circuit board to \the [machine]."))
			machine.circuit = I
			return
		else
			to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
			return TRUE
	if(isWirecutter(I))
		TRANSFER_STATE(/singleton/machine_construction/frame/wrenched)
		playsound(machine.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You remove the cables."))
		new /obj/item/stack/cable_coil(machine.loc, 5)


/singleton/machine_construction/frame/awaiting_circuit/mechanics_info()
	. = list()
	. += "Insert a circuit board to progress with constructing the machine."
	. += "Use a wirecutter to remove the cables."


/singleton/machine_construction/frame/awaiting_parts/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && machine.circuit


/singleton/machine_construction/frame/awaiting_parts/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.anchored)
			try_change_state(machine, /singleton/machine_construction/frame/wrenched)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/awaiting_parts/attackby(obj/item/I, mob/user, obj/machinery/constructable_frame/machine)
	if(isCrowbar(I))
		if (!istype(machine.circuit, /obj/item/stock_parts/circuitboard/wmd))
			TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_apc)
			machine.circuit = machine.stored_circuit
			new /obj/item/stack/cable_coil(machine.loc, 5)
		TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_circuit)
		playsound(machine.loc, 'sound/items/Crowbar.ogg', 50, 1)
		machine.circuit.dropInto(machine.loc)
		machine.circuit = null
		if (machine.stored_circuit)
			machine.stored_circuit = null
		to_chat(user, SPAN_NOTICE("You remove the circuit board."))
		return
	if(isScrewdriver(I))
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		var/obj/machinery/new_machine = new machine.circuit.build_path(machine.loc, machine.dir, FALSE)
		machine.circuit.construct(new_machine)
		new_machine.install_component(machine.circuit, refresh_parts = FALSE)
		new_machine.apply_component_presets()
		new_machine.RefreshParts()
		if(new_machine.construct_state)
			new_machine.construct_state.post_construct(new_machine)
		else
			crash_with("Machine of type [new_machine.type] was built from a circuit and frame, but had no construct state set.")
		qdel(machine)
		return TRUE


/singleton/machine_construction/frame/awaiting_parts/mechanics_info()
	. = list()
	. += "Use a crowbar to remove the circuitboard and any parts installed."
	. += "Use a screwdriver to build the machine."


// WMD Construction
/singleton/machine_construction/frame/reinforced/state_is_valid(obj/machinery/constructable_frame/machine)
	return !machine.anchored


/singleton/machine_construction/frame/reinforced/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/reinforced/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if (isWelder(I))
		var/obj/item/weldingtool/WT = I
		if(!WT.remove_fuel(0, user))
			to_chat(user, "The welding tool must be on to complete this task.")
			return TRUE
		playsound(machine.loc, 'sound/items/Welder.ogg', 50, 1)
		if (do_after(user, (I.toolspeed * 2) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			if (!WT.isOn())
				return TRUE
			TRANSFER_STATE(/singleton/machine_construction/default/deconstructed)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [machine]."))

	if(isWrench(I))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, (I.toolspeed * 2) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			TRANSFER_STATE(/singleton/machine_construction/frame/framed)
			to_chat(user, SPAN_NOTICE("You bend and fit the titanium into the frame."))
			machine.anchored = FALSE
			return


/singleton/machine_construction/frame/reinforced/mechanics_info()
	. = list()
	. += "Use a wrench to bend the added titanium to the frame."
	. += "Use a welder to deconstruct the titanium reinforcements."


/singleton/machine_construction/frame/framed/state_is_valid(obj/machinery/constructable_frame/machine)
	return !machine.anchored


/singleton/machine_construction/frame/framed/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/framed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, (I.toolspeed * 2.5) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			TRANSFER_STATE(/singleton/machine_construction/frame/reinforced)
			to_chat(user, SPAN_NOTICE("You unanchor the titanium reinforcements."))
			machine.anchored = FALSE
			return

	if (isWelder(I))
		var/obj/item/weldingtool/WT = I
		if(!WT.remove_fuel(0, user))
			to_chat(user, "The welding tool must be on to complete this task.")
			return TRUE
		playsound(machine.loc, 'sound/items/Welder.ogg', 50, 1)
		if (do_after(user, (I.toolspeed * 2.5) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			if (!WT.isOn())
				return TRUE
			TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_board)
			to_chat(user, SPAN_NOTICE("You weld the reinforcements and fit the panels, tightly."))


/singleton/machine_construction/frame/framed/mechanics_info()
	. = list()
	. += "Use a welder to deconstruct the titanium reinforcements."
	. += "Use a wrench to bend the added titanium to the frame."


/singleton/machine_construction/frame/awaiting_board/state_is_valid(obj/machinery/constructable_frame/machine)
	return !machine.anchored


/singleton/machine_construction/frame/awaiting_board/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/awaiting_board/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, (I.toolspeed * 2.5) SECONDS, machine, DO_REPAIR_CONSTRUCT))
			TRANSFER_STATE(/singleton/machine_construction/frame/reinforced)
			to_chat(user, SPAN_NOTICE("You unanchor the titanium reinforcements."))
			machine.anchored = FALSE
			return

	if(istype(I, /obj/item/stock_parts/circuitboard/microwave))
		var/obj/item/stock_parts/circuitboard/microwave/mw = I
			TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_cable)
			user.unEquip(I, machine)
			playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You add the circuit board to \the [machine]."))
			machine.stored_circuit = I
			machine.circuit = /obj/item/stock_parts/circuitboard/wmd


/singleton/machine_construction/frame/awaiting_board/mechanics_info()
	. = list()
	. += "Add a microwave oven PCB to continue construction."
	. += "Use a wrench to unanchor the reinforcements."


/singleton/machine_construction/frame/awaiting_cable/state_is_valid(obj/machinery/constructable_frame/machine)
	return !machine.anchored


/singleton/machine_construction/frame/awaiting_cable/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/awaiting_cable/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isCrowbar(I))
		TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_board)
		playsound(machine.loc, 'sound/items/Crowbar.ogg', 50, 1)
		machine.circuit.dropInto(machine.loc)
		machine.circuit = null
		to_chat(user, SPAN_NOTICE("You remove the circuit board."))
		return

	if(isCoil(I))
		var/obj/item/stack/cable_coil/C = I
		if(C.get_amount() < 5)
			to_chat(user, SPAN_WARNING("You need five lengths of cable to add them to \the [machine]."))
			return TRUE
		playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
		if(do_after(user, 2 SECONDS, machine, DO_REPAIR_CONSTRUCT) && C.use(5))
			TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_connection)
			to_chat(user, SPAN_NOTICE("You add cables to the bomb frame."))
		return TRUE


/singleton/machine_construction/frame/awaiting_cable/mechanics_info()
	. = list()
	. += "Add cables to connect the internals."
	. += "Use a crowbar to pry out the PCB."


/singleton/machine_construction/frame/awaiting_connection/state_is_valid(obj/machinery/constructable_frame/machine)
	return !machine.anchored


/singleton/machine_construction/frame/awaiting_connection/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/awaiting_connection/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isWirecutter(I))
		TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_cable)
		playsound(machine.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You remove the cables."))
		new /obj/item/stack/cable_coil(machine.loc, 5)
		return

	if(isScrewdriver(I))
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You start to secure the connections in the frame."))
		if(do_after(user, 4 SECONDS, machine, DO_REPAIR_CONSTRUCT))
			TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_parts)
			to_chat(user, SPAN_NOTICE("You screw the cable-ends to the connection points."))
		return TRUE


/singleton/machine_construction/frame/awaiting_connection/mechanics_info()
	. = list()
	. += "Use a screwdriver to finalise the connections."
	. += "Use a pair of wirecutters to cut out the cable."
