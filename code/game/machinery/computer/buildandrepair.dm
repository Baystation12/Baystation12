//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/constructable_frame/computerframe
	name = "computer frame"
	icon = 'icons/obj/machines/frames.dmi'
	icon_state = "unwired"
	obj_flags = OBJ_FLAG_ROTATABLE
	expected_machine_type = "computer"

/obj/machinery/constructable_frame/computerframe/on_update_icon()
	ClearOverlays()
	switch(construct_state && construct_state.type)
		if(/singleton/machine_construction/frame/awaiting_circuit)
			icon_state = "wired"
		if(/singleton/machine_construction/frame/awaiting_parts)
			icon_state = "wired"
			AddOverlays("circuit")
		else
			icon_state = "unwired"

/obj/machinery/constructable_frame/computerframe/deconstruct
	anchored = TRUE
	construct_state = /singleton/machine_construction/frame/awaiting_circuit
