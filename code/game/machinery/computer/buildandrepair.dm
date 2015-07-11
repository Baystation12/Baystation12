/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null

/obj/structure/computerframe/attackby(var/obj/item/I, var/mob/user, var/expand_tool)
	add_fingerprint(user)

	if(handle_tool(I, user, expand_tool))
		return

	if(!circuit && state == 1 && istype(I, /obj/item/weapon/circuitboard))
		var/obj/item/weapon/circuitboard/B = I
		if(B.board_type == "computer")
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user << "<span class='notice'>You place the circuit board inside the frame.</span>"
			icon_state = "1"
			circuit = I
			user.drop_item()
			I.loc = src
		else
			user << "<span class='warning'>This frame does not accept circuit boards of this type!</span>"
		return
	else if(state == 2 && istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.get_amount() < 5)
			user << "<span class='warning'>You need five coils of wire to add them to the frame.</span>"
			return
		user << "<span class='notice'>You start to add cables to the frame...</span>"
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20) && state == 2)
			if(C.use(5))
				user << "<span class='notice'>You add cables to the frame.</span>"
				state = 3
				icon_state = "3"
		return
	else if(state == 3 && istype(I, /obj/item/stack/material/glass))
		var/obj/item/stack/material/glass/G = I
		if(G.get_amount() < 2)
			user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
			return
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		user << "<span class='notice'>You start to put in the glass panel...</span>"
		if(do_after(user, 20) && state == 3)
			if(G.use(2))
				user << "<span class='notice'>You put in the glass panel.</span>"
				state = 4
				icon_state = "4"
		return

/obj/structure/computerframe/gather_actions()
	var/list/actions = list()
	switch(state)
		if(0)
			actions += TOOL_WRENCH
			actions += TOOL_WELDER
		if(1)
			actions += TOOL_WRENCH
			if(circuit)
				actions += TOOL_SCREWDRIVER
				actions += TOOL_CROWBAR
		if(2)
			if(circuit)
				actions += TOOL_SCREWDRIVER
		if(3)
			actions += TOOL_WIRECUTTERS
		if(4)
			actions += TOOL_CROWBAR
			actions += TOOL_SCREWDRIVER
	return actions

/obj/structure/computerframe/tool_act(var/action, var/efficiency, var/obj/item/I, var/mob/user)
	switch(action)
		if(TOOL_WRENCH)
			if(state == 0)
				user << "<span class='notice'>You start wrenching \the [src] into place...</span>"
				if(do_after(user, 20 / efficiency) && state == 0)
					user << "<span class='notice'>You wrench \the [src] into place.</span>"
					anchored = 1
					state = 1
				return 1
			if(state == 1)
				user << "<span class='notice'>You start unfastening \the [src]...</span>"
				if(do_after(user, 20 / efficiency) && state == 1)
					user << "<span class='notice'>You unfasten the frame.</span>"
					anchored = 0
					state = 0
				return 1
		if(TOOL_SCREWDRIVER)
			if(state == 1 && circuit)
				user << "<span class='notice'>You start screwing the circuit board into place...</span>"
				if(do_after(user, 10 / efficiency) && state == 1 && circuit)
					user << "<span class='notice'>You screw the circuit board into place.</span>"
					state = 2
					icon_state = "2"
				return 1
			if(state == 2 && circuit)
				user << "<span class='notice'>You start unfastening the circuit board...</span>"
				if(do_after(user, 10 / efficiency) && state == 2 && circuit)
					user << "<span class='notice'>You unfasten the circuit board.</span>"
					state = 1
					icon_state = "1"
				return 1
			if(state == 4)
				user << "<span class='notice'>You start connecting the monitor...</span>"
				if(do_after(user, 10 / efficiency) && state == 4)
					user << "<span class='notice'>You connect the monitor.</span>"
					var/B = new circuit.build_path(loc)
					circuit.construct(B)
					qdel(src)
		if(TOOL_WIRECUTTERS)
			if(state == 3)
				user << "<span class='notice'>You start to remove the cables...</span>"
				if(do_after(user, 10 / efficiency) && state == 3)
					user << "<span class='notice'>You remove the cables.</span>"
					state = 2
					icon_state = "2"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(loc)
					A.amount = 5
		if(TOOL_WELDER)
			if(state == 0)
				user << "<span class='notice'>You start deconstructing the frame...</span>"
				I.use_tool(TOOL_WELDER, user, 1)
				if(do_after(user, 20 / efficiency) && state == 0)
					user << "<span class='notice'>You deconstruct the frame.</span>"
					new /obj/item/stack/material/steel(loc, 5)
					qdel(src)
		if(TOOL_CROWBAR)
			if(state == 1 && circuit)
				user << "<span class='notice'>You start removing the circuit board...</span>"
				if(do_after(user, 10 / efficiency) && state == 1 && circuit)
					user << "<span class='notice'>You remove the circuit board.</span>"
					state = 1
					icon_state = "0"
					circuit.loc = loc
					circuit = null
				return 1
			if(state == 4)
				user << "<span class='notice'>You start removing the glass panel...</span>"
				if(do_after(user, 10 / efficiency) && state == 4)
					user << "<span class='notice'>You remove the glass panel.</span>"
					state = 3
					icon_state = "3"
					new /obj/item/stack/material/glass(loc, 2)
