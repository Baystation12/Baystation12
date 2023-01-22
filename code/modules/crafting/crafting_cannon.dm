/decl/crafting_stage/pipe/cannon
	item_desc = "It is a half-finished pneumatic cannon with a pipe segment installed."
	progress_message = "You secure the piping inside the frame."
	next_stages = list(/decl/crafting_stage/welding/cannon_pipe)
	item_icon_state = "pneumatic1"
	begins_with_object_type = /obj/item/cannonframe

/decl/crafting_stage/welding/cannon_pipe
	progress_message = "You weld the pipe into place."
	item_desc = "It is a half-finished pneumatic cannon with a pipe segment welded in place."
	next_stages = list(/decl/crafting_stage/material/cannon_chassis)
	item_icon_state = "pneumatic2"

/decl/crafting_stage/material/cannon_chassis
	progress_message = "You assemble a chassis around the cannon frame."
	item_desc = "It is a half-finished pneumatic cannon with an outer chassis installed."
	next_stages = list(/decl/crafting_stage/welding/cannon_chassis)
	item_icon_state = "pneumatic3"

/decl/crafting_stage/welding/cannon_chassis
	progress_message = "You weld the metal chassis together."
	item_desc = "It is a half-finished pneumatic cannon with an outer chassis welded in place."
	next_stages = list(/decl/crafting_stage/cannon_valve)
	item_icon_state = "pneumatic4"

/decl/crafting_stage/cannon_valve
	completion_trigger_type = /obj/item/device/transfer_valve
	progress_message = "You install the transfer valve and connect it to the piping."
	item_desc = "It is a half-finished pneumatic cannon with a transfer valve installed."
	next_stages = list(/decl/crafting_stage/welding/cannon_valve)
	item_icon_state = "pneumatic5"

/decl/crafting_stage/welding/cannon_valve
	progress_message = "You weld the valve into place."
	product = /obj/item/gun/launcher/pneumatic
