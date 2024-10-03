// Used to be called default_deconstruction_screwdriver -> default_deconstruction_crowbar and default_part_replacement

/singleton/machine_construction/default
	needs_board = "machine"
	var/up_state
	var/down_state

/singleton/machine_construction/default/no_deconstruct/use_tool(obj/item/I, mob/user, obj/machinery/machine)
	. = FALSE

/singleton/machine_construction/default/panel_closed
	down_state = /singleton/machine_construction/default/panel_open

/singleton/machine_construction/default/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/singleton/machine_construction/default/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, down_state)

/singleton/machine_construction/default/panel_closed/use_tool(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if (!machine.can_use_tools)
		to_chat(user, SPAN_WARNING("\The [src] cannot be modified!"))
		return TRUE
	if(isScrewdriver(I))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return TRUE
	if(istype(I, /obj/item/storage/part_replacer))
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

/singleton/machine_construction/default/panel_open/use_tool(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isCrowbar(I))
		TRANSFER_STATE(down_state)
		machine.dismantle()
		return TRUE
	if(isScrewdriver(I))
		TRANSFER_STATE(up_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = FALSE
		to_chat(user, SPAN_NOTICE("You close the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return TRUE

	if(istype(I, /obj/item/storage/part_replacer))
		return machine.part_replacement(user, I)

	if(isWrench(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

/singleton/machine_construction/default/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."

// Not implemented fully as the machine will qdel on transition to this. Path needed for checks.
/singleton/machine_construction/default/deconstructed
