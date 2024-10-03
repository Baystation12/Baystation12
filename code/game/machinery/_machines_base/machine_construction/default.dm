// Used to be called default_deconstruction_screwdriver -> default_deconstruction_crowbar and default_part_replacement

/singleton/machine_construction/default
	needs_board = "machine"
	var/up_state
	var/down_state


/singleton/machine_construction/default/no_deconstruct/use_tool(obj/item/tool, mob/user, obj/machinery/machine)
	return FALSE


/singleton/machine_construction/default/panel_closed
	down_state = /singleton/machine_construction/default/panel_open

/singleton/machine_construction/default/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/singleton/machine_construction/default/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, down_state)


/singleton/machine_construction/default/panel_closed/use_tool(obj/item/tool, mob/user, obj/machinery/machine)
	. = ..()
	if (!.)
		return TRUE

	if (!machine.can_use_tools)
		USE_FEEDBACK_FAILURE("\The [src] cannot be modified.")
		return TRUE

	// Screwdriver - Open maintenance panel
	if (isScrewdriver(tool))
		TRANSFER_STATE(down_state)
		playsound(machine, 'sound/items/Screwdriver.ogg', 50, TRUE)
		machine.panel_open = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] opens \a [machine]'s maintenance panel with \a [tool]."),
			SPAN_NOTICE("You open \the [machine]'s maintenance panel with \the [tool].")
		)
		machine.update_icon()
		return TRUE

	// Part Replacer - List parts.
	if (istype(tool, /obj/item/storage/part_replacer))
		user.visible_message(
			SPAN_NOTICE("\The [user] scans \a [machine] with \a [tool]."),
			SPAN_NOTICE("You scan \the [machine] with \the [tool].")
		)
		machine.display_parts(user)
		return TRUE


/singleton/machine_construction/default/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, down_state)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/singleton/machine_construction/default/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel."
	. += "Use a parts replacer to view installed parts."

/singleton/machine_construction/default/panel_closed/cannot_print
	cannot_print = TRUE

/singleton/machine_construction/default/panel_open
	up_state = /singleton/machine_construction/default/panel_closed
	down_state = /singleton/machine_construction/default/deconstructed

/singleton/machine_construction/default/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/singleton/machine_construction/default/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, up_state)


/singleton/machine_construction/default/panel_open/use_tool(obj/item/tool, mob/user, obj/machinery/machine)
	. = ..()
	if (.)
		return

	// Crowbar - Dismantle machine.
	if (isCrowbar(tool))
		TRANSFER_STATE(down_state)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \a [machine] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [machine] with \the [tool].")
		)
		machine.dismantle()
		return TRUE

	// Screwdriver - Close panel.
	if (isScrewdriver(tool))
		TRANSFER_STATE(up_state)
		playsound(machine, 'sound/items/Screwdriver.ogg', 50, TRUE)
		machine.panel_open = FALSE
		user.visible_message(
			SPAN_NOTICE("\The [user] closes \a [machine]'s maintenance hatch with \a [tool]."),
			SPAN_NOTICE("You close \the [machine]'s maintenance panel with \the [tool].")
		)
		machine.update_icon()
		return TRUE

	// Part replacer - Replace parts.
	if (istype(tool, /obj/item/storage/part_replacer))
		return machine.part_replacement(user, tool)

	// Wrench - Remove individual part.
	if (isWrench(tool))
		return machine.part_removal(user)

	// Items - Attempt part insertion.
	if (istype(tool))
		return machine.part_insertion(user, tool)


/singleton/machine_construction/default/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."

// Not implemented fully as the machine will qdel on transition to this. Path needed for checks.
/singleton/machine_construction/default/deconstructed
