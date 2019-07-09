// Computers follow similar steps to default, but have different circuit types (which is enforced here)

/decl/machine_construction/default/panel_closed/computer
	down_state = /decl/machine_construction/default/panel_open/computer
	needs_board = "computer"

/decl/machine_construction/default/panel_open/computer
	up_state = /decl/machine_construction/default/panel_closed/computer
	needs_board = "computer"