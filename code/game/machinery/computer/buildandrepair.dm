//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
//	weight = 1.0E8

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob, var/expanded)
	var/list/item_props = list()
	if(expanded)
		for(var/i in P.properties)
			item_props += i
	else if(P.main_property)
		item_props += P.main_property
	var/list/actions = list()
	switch(state)
		if(0)
			if(TOOL_WRENCH in item_props)
				actions += TOOL_WRENCH
			if(TOOL_WELDER in item_props)
				actions += TOOL_WELDER
		if(1)
			if(TOOL_WRENCH in item_props)
				actions += TOOL_WRENCH
			if(istype(P, /obj/item/weapon/circuitboard) && !circuit)
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You place the circuit board inside the frame."
					src.icon_state = "1"
					src.circuit = P
					user.drop_item()
					P.loc = src
				else
					user << "\red This frame does not accept circuit boards of this type!"
			if(circuit && (TOOL_SCREWDRIVER in item_props))
				actions += TOOL_SCREWDRIVER
			if(circuit && (TOOL_CROWBAR in item_props))
				actions += TOOL_CROWBAR
		if(2)
			if(circuit && (TOOL_SCREWDRIVER in item_props))
				actions += TOOL_SCREWDRIVER
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					user << "<span class='warning'>You need five coils of wire to add them to the frame.</span>"
					return
				user << "<span class='notice'>You start to add cables to the frame.</span>"
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && state == 2)
					if (C.use(5))
						user << "<span class='notice'>You add cables to the frame.</span>"
						state = 3
						icon_state = "3"
		if(3)
			if(circuit && (TOOL_WIRECUTTERS in item_props))
				actions += TOOL_WIRECUTTERS
			if(istype(P, /obj/item/stack/sheet/glass))
				var/obj/item/stack/sheet/glass/G = P
				if (G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to put in the glass panel.</span>"
				if(do_after(user, 20) && state == 3)
					if (G.use(2))
						user << "<span class='notice'>You put in the glass panel.</span>"
						src.state = 4
						src.icon_state = "4"
		if(4)
			if(TOOL_CROWBAR in item_props)
				actions += TOOL_CROWBAR
			if(TOOL_SCREWDRIVER in item_props)
				actions += TOOL_SCREWDRIVER
	if(actions.len)
		. = handle_actions(P, user, actions, expanded)

/obj/structure/computerframe/handle_actions(obj/item/W, mob/user, var/list/actions, var/expanded)
	var/action = null
	if(expanded)
		action = input(user, "Choose an action", "Action", null) as null|anything in actions
	else
		action = actions[1]
	if(!action)
		return
	var/efficiency = W.properties[action]
	if(!efficiency)
		return
	switch(action)
		if(TOOL_CROWBAR)
			if((state == 1) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] starts removing the circuit board from \the [src] with \the [W].</span>", "<span class='notice'>You start removing the circuit board from \the [src] with \the [W].</span>")
				if(do_after(user, 20/efficiency))
					if(prob(100 * efficiency))
						user << "<span class='notice'>You remove the circuit board.</span>"
						src.state = 1
						src.icon_state = "0"
						circuit.loc = src.loc
						src.circuit = null
					else
						user << "<span class='notice'>You fail to remove the circuit board.</span>"
					return
				return
			if(state == 4)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] starts to remove the glass panel of \the [src] with \the [W].</span>", "<span class='notice'>You start to remove the glass panel of \the [src] with \the [W].</span>")
				if(do_after(user, 20/efficiency))
					if(prob(100 * efficiency))
						user << "<span class='notice'>You remove the glass panel.</span>"
						src.state = 3
						src.icon_state = "3"
						new /obj/item/stack/sheet/glass(src.loc, 2)
					user << "<span class='notice'>You fail to remove the glass panel.</span>"
				return
		if(TOOL_SCREWDRIVER)
			if((state == 1) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You screw the circuit board into place."
				src.state = 2
				src.icon_state = "2"
				return
			if((state == 2) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You unfasten the circuit board."
				src.state = 1
				src.icon_state = "1"
				return
			if(state == 4)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] starts to connect the monitor of \the [src] with \the [W].</span>", "<span class='notice'>You start to connect the monitor of \the [src] with \the [W].</span>")
				if(do_after(user, 20/efficiency))
					if(prob(100 * efficiency))
						user << "<span class='notice'>You connect the monitor.</span>"
						var/B = new src.circuit.build_path(src.loc)
						src.circuit.construct(B)
						del(src)
					user << "<span class='notice'>You fail to connect the monitor.</span>"
				return
		if(TOOL_WELDER)
			if(state == 0)
				if(W.use_tool(user, 1))
					playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
					if(do_after(user, 20))
						user << "\blue You deconstruct the frame."
						new /obj/item/stack/sheet/metal( src.loc, 5 )
						del(src)
			
		if(TOOL_WIRECUTTERS)
			if(state == 3)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "\blue You remove the cables."
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5
				return
		if(TOOL_WRENCH)
			if(state == 0)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You wrench the frame into place."
					src.anchored = 1
					src.state = 1
					return
			if(state == 1)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You unfasten the frame."
					src.anchored = 0
					src.state = 0
					return
	return