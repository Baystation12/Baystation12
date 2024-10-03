// Computers follow similar steps to default, but have different circuit types (which is enforced here)

/singleton/machine_construction/default/panel_closed/computer
	down_state = /singleton/machine_construction/default/panel_open/computer
	needs_board = "computer"

/singleton/machine_construction/default/panel_closed/computer/no_deconstruct/use_tool(obj/item/I, mob/user, obj/machinery/machine)
	return FALSE

/singleton/machine_construction/default/panel_open/computer
	up_state = /singleton/machine_construction/default/panel_closed/computer
	needs_board = "computer"

/singleton/machine_construction/default/panel_closed/computer/cannot_print
	cannot_print = TRUE
