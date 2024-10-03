// Identical to default behavior, but does not require circuit boards.

/singleton/machine_construction/default/item_chassis
	needs_board = null
	down_state = /singleton/machine_construction/default/deconstructed

/singleton/machine_construction/default/item_chassis/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isWrench(I))
		TRANSFER_STATE(down_state)
		machine.dismantle()
		return TRUE

/singleton/machine_construction/default/item_chassis/state_is_valid(obj/machinery/machine)
	return TRUE

/singleton/machine_construction/default/item_chassis/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, down_state)

/singleton/machine_construction/default/panel_closed/mechanics_info()
	. = list()
	. += "Use a wrench to deconstruct the machine"
