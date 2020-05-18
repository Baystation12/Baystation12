/obj/item/weapon/stock_parts/circuitboard/rdconsole
	name = T_BOARD("R&D control console")
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/weapon/stock_parts/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(isScrewdriver(I))
		user.visible_message("<span class='notice'>\The [user] adjusts the jumper on \the [src]'s access protocol pins.</span>", "<span class='notice'>You adjust the jumper on the access protocol pins.</span>")
		if(src.build_path == /obj/machinery/computer/rdconsole/core)
			src.SetName(T_BOARD("RD Console - Robotics"))
			src.build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, "<span class='notice'>Access protocols set to robotics.</span>")
		else
			src.SetName(T_BOARD("RD Console"))
			src.build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, "<span class='notice'>Access protocols set to default.</span>")
	return
