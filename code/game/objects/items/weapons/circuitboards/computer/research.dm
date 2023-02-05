/obj/item/stock_parts/circuitboard/rdconsole
	name = T_BOARD("R&D control console")
	build_path = /obj/machinery/computer/rdconsole/core


/obj/item/stock_parts/circuitboard/rdconsole/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_SCREWDRIVER] = "<p>Toggles the circuit board between a research and robotics accessible console.</p>"


/obj/item/stock_parts/circuitboard/rdconsole/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Switch RD console type
	if (isScrewdriver(tool))
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts the jumper on \the [src]'s access protocol pins."),
			SPAN_NOTICE("You adjust the jumper on the access protocol pins.")
		)
		if (build_path == /obj/machinery/computer/rdconsole/core)
			SetName(T_BOARD("RD Console - Robotics"))
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE("Access protocols set to robotics."))
		else
			SetName(T_BOARD("RD Console"))
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE("Access protocols set to default."))
		return TRUE

	return ..()
