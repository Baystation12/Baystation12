// Identical to default behavior, but does not require circuit boards.

/decl/machine_construction/default/item_chassis
	needs_board = null
	down_state = /decl/machine_construction/default/deconstructed

/decl/machine_construction/default/item_chassis/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isWrench(I))
		TRANSFER_STATE(down_state)
		machine.dismantle()
		return

/decl/machine_construction/default/item_chassis/state_is_valid(obj/machinery/machine)
	return TRUE

/decl/machine_construction/default/item_chassis/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, down_state)

/decl/machine_construction/default/panel_closed/mechanics_info()
	. = list()
	. += "Use a wrench to deconstruct the machine"