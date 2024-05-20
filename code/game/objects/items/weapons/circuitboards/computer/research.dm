/obj/item/stock_parts/circuitboard/rdconsole
	name = "circuit board (R&D control console)"
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/stock_parts/circuitboard/rdconsole/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(isScrewdriver(I))
		user.visible_message(SPAN_NOTICE("\The [user] adjusts the jumper on \the [src]'s access protocol pins."), SPAN_NOTICE("You adjust the jumper on the access protocol pins."))
		if(src.build_path == /obj/machinery/computer/rdconsole/core)
			src.SetName("circuit board (RD Console - Robotics)")
			src.build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE("Access protocols set to robotics."))
		else
			src.SetName("circuit board (RD Console)")
			src.build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE("Access protocols set to default."))
		return TRUE
	return ..()
