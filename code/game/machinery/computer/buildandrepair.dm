//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/constructable_frame/computerframe
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "unwired"
	obj_flags = OBJ_FLAG_ROTATABLE
	expected_machine_type = "computer"

/obj/machinery/constructable_frame/computerframe/on_update_icon()
	overlays.Cut()
	switch(construct_state && construct_state.type)
		if(/decl/machine_construction/frame/awaiting_circuit)
			icon_state = "wired"
		if(/decl/machine_construction/frame/awaiting_parts)
			icon_state = "wired"
			var/screen = locate(/obj/item/weapon/stock_parts/console_screen) in components
			var/keyboard = locate(/obj/item/weapon/stock_parts/keyboard) in components
			if(screen)
				overlays += "comp_screen"
			if(keyboard)
				overlays += "keyboard"
			else
				overlays += "circuit"
		else
			icon_state = "unwired"

/obj/machinery/constructable_frame/computerframe/deconstruct
	anchored = TRUE
	construct_state = /decl/machine_construction/frame/awaiting_circuit