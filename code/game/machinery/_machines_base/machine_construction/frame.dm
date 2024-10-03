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


/singleton/machine_construction/frame/unwrenched/use_tool(obj/item/tool, mob/user, obj/machinery/machine)
	// Wrench - Anchor machine.
	if (isWrench(tool))
		user.visible_message(
			SPAN_NOTICE("\The [user] begins securing \the [machine] to the floor with \a [tool]."),
			SPAN_NOTICE("You begin securing \the [machine] to the floor with \the [tool].")
		)
		playsound(machine, 'sound/items/Ratchet.ogg', 50, TRUE)
		if (!user.do_skilled((tool.toolspeed * 2 SECONDS), SKILL_CONSTRUCTION, machine, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(machine, tool))
			return TRUE
		TRANSFER_STATE(/singleton/machine_construction/frame/unwrenched)
		user.visible_message(
			SPAN_NOTICE("\The [user] secures \a [machine] to the floor with \a [tool]."),
			SPAN_NOTICE("You secure \the [machine] to the floor with \the [tool].")
		)
		machine.anchored = FALSE
		machine.post_anchor_change()
		return TRUE

	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(3, user))
			return TRUE
		playsound(machine, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts dismantling \a [machine] with \a [tool]."),
			SPAN_NOTICE("You start dismantling \the [machine] with \the [tool].")
		)
		if (!user.do_skilled(tool.toolspeed * 2 SECONDS, SKILL_CONSTRUCTION, machine, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(machine, tool))
			return TRUE
		if (!welder.remove_fuel(3, user))
			return TRUE
		TRANSFER_STATE(/singleton/machine_construction/default/deconstructed)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \a [machine] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [machine] with \the [tool].")
		)
		machine.dismantle()
		return TRUE


/singleton/machine_construction/frame/unwrenched/mechanics_info()
	. = list()
	. += "Use a welder to break apart the frame."
	. += "Use a wrench to secure the frame in place."

/singleton/machine_construction/frame/wrenched/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && !machine.circuit

/singleton/machine_construction/frame/wrenched/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /singleton/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /singleton/machine_construction/frame/unwrenched)


/singleton/machine_construction/frame/wrenched/use_tool(obj/item/tool, mob/user, obj/machinery/machine)
	// Wrench. Anchor machine.
	if (isWrench(tool))
		user.visible_message(
			SPAN_NOTICE("\The [user] begins unsecuring \the [machine] from the floor with \a [tool]."),
			SPAN_NOTICE("You begin unsecuring \the [machine] from the floor with \the [tool].")
		)
		playsound(machine, 'sound/items/Ratchet.ogg', 50, TRUE)
		if (!user.do_skilled((tool.toolspeed * 2 SECONDS), SKILL_CONSTRUCTION, machine, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(machine, tool))
			return TRUE
		TRANSFER_STATE(/singleton/machine_construction/frame/unwrenched)
		user.visible_message(
			SPAN_NOTICE("\The [user] unsecures \a [machine] from the floor with \a [tool]."),
			SPAN_NOTICE("You unsecure \the [machine] from the floor with \the [tool].")
		)
		machine.anchored = FALSE
		machine.post_anchor_change()
		return TRUE

	// Cable coil. Wire machine.
	if (isCoil(tool))
		var/obj/item/stack/cable_coil/cable_coil = tool
		if (!cable_coil.can_use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable_coil, 5, "to wire \the [machine].")
			return TRUE
		playsound(machine, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts wiring \a [machine] with [cable_coil.get_vague_name(TRUE)]."),
			SPAN_NOTICE("You start wiring \the [machine] with [cable_coil.get_exact_name(5)].")
		)
		if (!user.do_skilled(2 SECONDS, SKILL_ELECTRICAL, machine, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(machine, tool))
			return TRUE
		if (!cable_coil.use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable_coil, 5, "to wire \the [machine].")
			return TRUE
		TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_circuit)
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \a [machine] with [cable_coil.get_vague_name(TRUE)]."),
			SPAN_NOTICE("You wire \the [machine] with [cable_coil.get_exact_name(5)].")
		)
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


/singleton/machine_construction/frame/awaiting_circuit/use_tool(obj/item/tool, mob/user, obj/machinery/constructable_frame/machine)
	// Circuitboard - Install circuits.
	if (istype(tool, /obj/item/stock_parts/circuitboard))
		var/obj/item/stock_parts/circuitboard/circuit = tool
		if (circuit.board_type != machine.expected_machine_type)
			USE_FEEDBACK_FAILURE("\The [machine] does not accept \the [circuit]'s board type.")
			return TRUE
		if (!user.canUnEquip(tool))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_parts)
		user.unEquip(tool, machine)
		playsound(machine, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] adds \a [tool] to \a [machine]."),
			SPAN_NOTICE("You add \the [tool] to \the [machine].")
		)
		machine.circuit = tool
		return TRUE

	// Wirecutter - Remove wiring.
	if (isWirecutter(tool))
		TRANSFER_STATE(/singleton/machine_construction/frame/wrenched)
		playsound(machine, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [machine]'s wiring with \a [tool]."),
			SPAN_NOTICE("You remove \the [machine]'s wiring with \the [tool].")
		)
		new /obj/item/stack/cable_coil(machine.loc, 5)
		return TRUE


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

/singleton/machine_construction/frame/awaiting_parts/use_tool(obj/item/tool, mob/user, obj/machinery/constructable_frame/machine)
	// Crowbar. Remove circuit board.
	if (isCrowbar(tool))
		TRANSFER_STATE(/singleton/machine_construction/frame/awaiting_circuit)
		playsound(machine, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [machine]'s circuit board with \a [tool]."),
			SPAN_NOTICE("You remove \the [machine]'s [machine.circuit.name] with \the [tool].")
		)
		machine.circuit.dropInto(machine.loc)
		machine.circuit = null
		return TRUE

	// Screwdriver. Finish construction.
	if (isScrewdriver(tool))
		playsound(machine, 'sound/items/Screwdriver.ogg', 50, TRUE)
		var/obj/machinery/new_machine = new machine.circuit.build_path(machine.loc, machine.dir, FALSE)
		machine.circuit.construct(new_machine)
		new_machine.install_component(machine.circuit, refresh_parts = FALSE)
		new_machine.apply_component_presets()
		new_machine.RefreshParts()
		if(new_machine.construct_state)
			new_machine.construct_state.post_construct(new_machine)
		else
			crash_with("Machine of type [new_machine.type] was built from a circuit and frame, but had no construct state set.")
		user.visible_message(
			SPAN_NOTICE("\The [user] finishes \a [new_machine] with \a [tool]."),
			SPAN_NOTICE("You finish \the [new_machine] with \the [tool].")
		)
		qdel(machine)
		return TRUE

/singleton/machine_construction/frame/awaiting_parts/mechanics_info()
	. = list()
	. += "Use a crowbar to remove the circuitboard and any parts installed."
	. += "Use a screwdriver to build the machine."
