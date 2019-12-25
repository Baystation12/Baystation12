// Identical to default behavior, but does not require circuit boards.

/decl/machine_construction/default/panel_closed/item_chassis
	needs_board = null
	down_state = /decl/machine_construction/default/panel_open/item_chassis

/decl/machine_construction/default/panel_open/item_chassis
	needs_board = null
	up_state = /decl/machine_construction/default/panel_closed/item_chassis