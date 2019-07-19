// Computers follow similar steps to default, but have different circuit types (which is enforced here)

/decl/machine_construction/default/panel_closed/computer
	down_state = /decl/machine_construction/default/panel_open/computer
	needs_board = "computer"

/decl/machine_construction/default/panel_closed/computer/no_deconstruct/attackby(obj/item/I, mob/user, obj/machinery/machine)
	return FALSE

/decl/machine_construction/default/panel_open/computer
	up_state = /decl/machine_construction/default/panel_closed/computer
	needs_board = "computer"