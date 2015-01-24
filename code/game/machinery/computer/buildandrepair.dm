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
	var/list/actions = list()
	switch(state)
		if(0)
			if(circuit && (P.main_property == "wrench" || expanded && ("wrench" in P.properties)))
				actions += "wrench"
			if(istype(P, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					user << "The welding tool must be on to complete this task."
					return
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					user << "\blue You deconstruct the frame."
					new /obj/item/stack/sheet/metal( src.loc, 5 )
					del(src)
		if(1)
			if(circuit && (P.main_property == "wrench" || expanded && ("wrench" in P.properties)))
				actions += "wrench"
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
			if(circuit && (P.main_property == "screwdriver" || expanded && ("screwdriver" in P.properties)))
				actions += "screwdriver"
			if(circuit && (P.main_property == "crowbar" || expanded && ("crowbar" in P.properties)))
				actions += "crowbar"
		if(2)
			if(circuit && (P.main_property == "screwdriver" || expanded && ("screwdriver" in P.properties)))
				actions += "screwdriver"
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
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "\blue You remove the cables."
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5

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
			if(P.main_property == "crowbar" || expanded && ("crowbar" in P.properties))
				actions += "crowbar"
			if(P.main_property == "screwdriver" || expanded && ("screwdriver" in P.properties))
				actions += "screwdriver"
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
		if("crowbar")
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
						return
					user << "<span class='notice'>You fail to remove the circuit board.</span>"
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
		if("screwdriver")
			if((state == 1) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You screw the circuit board into place."
				src.state = 2
				src.icon_state = "2"
			if((state == 2) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You unfasten the circuit board."
				src.state = 1
				src.icon_state = "1"
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
		if("welder")
			
		if("wrench")
			if(state == 0)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You wrench the frame into place."
					src.anchored = 1
					src.state = 1
			if(state == 1)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You unfasten the frame."
					src.anchored = 0
					src.state = 0
	return