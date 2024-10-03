// Telecomms have lots of states.

/singleton/machine_construction/tcomms
	needs_board = "machine"

/singleton/machine_construction/tcomms/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/singleton/machine_construction/tcomms/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /singleton/machine_construction/tcomms/panel_open)


/singleton/machine_construction/tcomms/panel_closed/use_tool(obj/item/tool, mob/user, obj/machinery/machine)
	. = ..()
	if (.)
		return

	// Screwdriver - Open panel
	if (isScrewdriver(tool))
		TRANSFER_STATE(/singleton/machine_construction/tcomms/panel_open)
		machine.panel_open = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] opens \the [machine]'s panel with \a [tool]."),
			SPAN_NOTICE("You open \the [machine]'s panel with \the [tool].")
		)
		playsound(machine, 'sound/items/Screwdriver.ogg', 50, TRUE)
		return TRUE


/singleton/machine_construction/tcomms/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, /singleton/machine_construction/tcomms/panel_open/no_cable)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/singleton/machine_construction/tcomms/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel."

/singleton/machine_construction/tcomms/panel_closed/cannot_print
	cannot_print = TRUE

/singleton/machine_construction/tcomms/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/singleton/machine_construction/tcomms/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /singleton/machine_construction/tcomms/panel_closed)


/singleton/machine_construction/tcomms/panel_open/use_tool(obj/item/tool, mob/user, obj/machinery/machine)
	. = ..()
	if (.)
		return

	return state_interactions(tool, user, machine)


/**
 * Tool interactions specifically for tcomms sub-states. Called by `/singleton/machine_construction/tcomms/panel_open/use_tool()`.
 *
 * **Parameters**:
 * - `tool` - The item being used.
 * - `user` - The mob performing the interaction.
 * - `machine` - The parent machine being interacted with.
 *
 * Returns boolean. Indicates whether the interaction was handled or not. If `TRUE`, no other interactions will occur.
 */
/singleton/machine_construction/tcomms/panel_open/proc/state_interactions(obj/item/tool, mob/user, obj/machinery/machine)
	// Screwdriver - Close panel
	if (isScrewdriver(tool))
		TRANSFER_STATE(/singleton/machine_construction/tcomms/panel_closed)
		machine.panel_open = FALSE
		user.visible_message(
			SPAN_NOTICE("\The [user] closes \a [machine]'s maintenance panel with \a [tool]."),
			SPAN_NOTICE("You close \the [machine]'s maintenance panel with \the [tool].")
		)
		to_chat(user, "You fasten the bolts.")
		playsound(machine, 'sound/items/Screwdriver.ogg', 50, TRUE)
		return TRUE

	// Wrench - Unwrench external plating
	if (isWrench(tool))
		TRANSFER_STATE(/singleton/machine_construction/tcomms/panel_open/unwrenched)
		user.visible_message(
			SPAN_NOTICE("\The [user] dislodges \a [machine]'s external plating with \a [tool]."),
			SPAN_NOTICE("You dislodge \the [machine]'s external plating with \the [tool].")
		)
		playsound(machine, 'sound/items/Ratchet.ogg', 75, TRUE)
		return TRUE


/singleton/machine_construction/tcomms/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a wrench to remove the external plating."

/singleton/machine_construction/tcomms/panel_open/unwrenched/state_interactions(obj/item/tool, mob/user, obj/machinery/machine)
	// Wrench - Secure external plating.
	if (isWrench(tool))
		TRANSFER_STATE(/singleton/machine_construction/tcomms/panel_open)
		user.visible_message(
			SPAN_NOTICE("\The [user] secures \a [machine]'s external plating with \a [tool]."),
			SPAN_NOTICE("You secure \the [machine]'s external plating with \the [tool].")
		)
		playsound(machine, 'sound/items/Ratchet.ogg', 75, TRUE)
		return TRUE

	// Wirecutter - Remove wiring.
	if (isWirecutter(tool))
		TRANSFER_STATE(/singleton/machine_construction/tcomms/panel_open/no_cable)
		playsound(machine.loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [machine]'s wiring with \a [tool]."),
			SPAN_NOTICE("You remove \the [machine]'s wiring with \the [tool].")
		)
		new /obj/item/stack/cable_coil(get_turf(machine), 5)
		machine.set_broken(TRUE, TRUE) // the machine's been borked!
		return TRUE

/singleton/machine_construction/tcomms/panel_open/unwrenched/mechanics_info()
	. = list()
	. += "Use a wrench to secure the external plating."
	. += "Use wirecutters to remove the cabling."


/singleton/machine_construction/tcomms/panel_open/no_cable/state_interactions(obj/item/tool, mob/user, obj/machinery/machine)
	// Cable Coil - Add wiring.
	if (isCoil(tool))
		var/obj/item/stack/cable_coil/cable_coil = tool
		if (!cable_coil.use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable_coil, 5, "to wire \the [machine].")
			return TRUE
		TRANSFER_STATE(/singleton/machine_construction/tcomms/panel_open/unwrenched)
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \a [machine] with [cable_coil.get_vague_name(TRUE)]."),
			SPAN_NOTICE("You wire \the [machine] with [cable_coil.get_exact_name(5)].")
		)
		machine.set_broken(FALSE, TRUE)
		return TRUE

	// Crowbar - Dismantle frame.
	if (isCrowbar(tool))
		TRANSFER_STATE(/singleton/machine_construction/default/deconstructed)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismanles \a [machine] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [machine] with \the [tool].")
		)
		machine.dismantle()
		return TRUE

	// Part Replacer - Replace parts.
	if (istype(tool, /obj/item/storage/part_replacer))
		return machine.part_replacement(tool, user)

	// Wrench - Remove individual part.
	if (isWrench(tool))
		return machine.part_removal(user)

	// Item - Attempt part insertion.
	if (istype(tool))
		return machine.part_insertion(user, tool)


/singleton/machine_construction/tcomms/panel_open/no_cable/mechanics_info()
	. = list()
	. += "Attach cables to make the machine functional."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."
