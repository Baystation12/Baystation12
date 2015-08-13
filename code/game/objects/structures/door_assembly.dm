/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_as_0"
	anchored = 0
	density = 1
	var/state = 0
	var/base_icon_state = ""
	var/base_name = "Airlock"
	var/obj/item/weapon/airlock_electronics/electronics = null
	var/airlock_type = "" //the type path of the airlock once completed
	var/glass_type = "/glass"
	var/glass = 0 // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed. Text = mineral plating is installed instead.
	var/created_name = null

	New()
		update_state()

/obj/structure/door_assembly/door_assembly_com
	base_icon_state = "com"
	base_name = "Command Airlock"
	glass_type = "/glass_command"
	airlock_type = "/command"

/obj/structure/door_assembly/door_assembly_sec
	base_icon_state = "sec"
	base_name = "Security Airlock"
	glass_type = "/glass_security"
	airlock_type = "/security"

/obj/structure/door_assembly/door_assembly_eng
	base_icon_state = "eng"
	base_name = "Engineering Airlock"
	glass_type = "/glass_engineering"
	airlock_type = "/engineering"

/obj/structure/door_assembly/door_assembly_min
	base_icon_state = "min"
	base_name = "Mining Airlock"
	glass_type = "/glass_mining"
	airlock_type = "/mining"

/obj/structure/door_assembly/door_assembly_atmo
	base_icon_state = "atmo"
	base_name = "Atmospherics Airlock"
	glass_type = "/glass_atmos"
	airlock_type = "/atmos"

/obj/structure/door_assembly/door_assembly_research
	base_icon_state = "res"
	base_name = "Research Airlock"
	glass_type = "/glass_research"
	airlock_type = "/research"

/obj/structure/door_assembly/door_assembly_science
	base_icon_state = "sci"
	base_name = "Science Airlock"
	glass_type = "/glass_science"
	airlock_type = "/science"

/obj/structure/door_assembly/door_assembly_med
	base_icon_state = "med"
	base_name = "Medical Airlock"
	glass_type = "/glass_medical"
	airlock_type = "/medical"

/obj/structure/door_assembly/door_assembly_mai
	base_icon_state = "mai"
	base_name = "Maintenance Airlock"
	airlock_type = "/maintenance"
	glass = -1

/obj/structure/door_assembly/door_assembly_ext
	base_icon_state = "ext"
	base_name = "External Airlock"
	airlock_type = "/external"
	glass = -1

/obj/structure/door_assembly/door_assembly_fre
	base_icon_state = "fre"
	base_name = "Freezer Airlock"
	airlock_type = "/freezer"
	glass = -1

/obj/structure/door_assembly/door_assembly_hatch
	base_icon_state = "hatch"
	base_name = "Airtight Hatch"
	airlock_type = "/hatch"
	glass = -1

/obj/structure/door_assembly/door_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_hatch"
	glass = -1

/obj/structure/door_assembly/door_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	base_icon_state = "highsec"
	base_name = "High Security Airlock"
	airlock_type = "/highsecurity"
	glass = -1

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/door_assembly2x1.dmi'
	dir = EAST
	var/width = 1

/*Temporary until we get sprites.
	glass_type = "/multi_tile/glass"
	airlock_type = "/multi_tile/maint"
	glass = 1*/
	base_icon_state = "g" //Remember to delete this line when reverting "glass" var to 1.
	airlock_type = "/multi_tile/glass"
	glass = -1 //To prevent bugs in deconstruction process.

	New()
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size
		update_state()

	Move()
		. = ..()
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

/obj/structure/door_assembly/attackby(var/obj/item/I, var/mob/user, var/expand_tool)
	add_fingerprint(user)

	if(handle_tool(I, user, expand_tool))
		update_state()
		return

	if(istype(I, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter the name for the door.", src.name, src.created_name), MAX_NAME_LEN)
		if(!t)	return
		if(!in_range(src, usr) && src.loc != usr)	return
		created_name = t
		return

	else if(istype(I, /obj/item/stack/cable_coil) && state == 0 && anchored)
		var/obj/item/stack/cable_coil/C = I
		if (C.get_amount() < 1)
			user << "<span class='warning'>You need one length of coil to wire the airlock assembly.</span>"
			return
		user.visible_message("[user] wires the airlock assembly.", "You start to wire the airlock assembly.")
		if(do_after(user, 40) && state == 0 && anchored)
			if (C.use(1))
				src.state = 1
				user << "<span class='notice'>You wire the airlock.</span>"

	else if(istype(I, /obj/item/weapon/airlock_electronics) && state == 1)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user.visible_message("[user] installs the electronics into the airlock assembly.", "You start to install electronics into the airlock assembly.")

		if(do_after(user, 40))
			if(!src) return
			user.drop_item()
			I.loc = src
			user << "<span class='notice'>You installed the airlock electronics!</span>"
			src.state = 2
			src.name = "Near finished Airlock Assembly"
			src.electronics = I

	else if(istype(I, /obj/item/stack/material) && !glass)
		var/obj/item/stack/S = I
		var/material_name = S.get_material_name()
		if (S)
			if (S.get_amount() >= 1)
				if(material_name == "rglass")
					playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
					user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
					if(do_after(user, 40) && !glass)
						if (S.use(1))
							user << "<span class='notice'>You installed reinforced glass windows into the airlock assembly.</span>"
							glass = 1
				else if(material_name)
					// Ugly hack, will suffice for now. Need to fix it upstream as well, may rewrite mineral walls. ~Z
					if(!(material_name in list("gold", "silver", "diamond", "uranium", "phoron", "sandstone")))
						user << "You cannot make an airlock out of that material."
						return
					if(S.get_amount() >= 2)
						playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
						user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
						if(do_after(user, 40) && !glass)
							if (S.use(2))
								user << "<span class='notice'>You installed [material_display_name(material_name)] plating into the airlock assembly.</span>"
								glass = material_name
	else
		..()
	update_state()

/obj/structure/door_assembly/gather_actions()
	. = list()
	switch(state)
		if(2)
			. += TOOL_SCREWDRIVER
			. += TOOL_CROWBAR
		if(1)
			. += TOOL_WIRECUTTERS
		if(0)
			. += TOOL_WRENCH
	if(glass || !anchored)
		. += TOOL_WELDER

/obj/structure/door_assembly/tool_act(var/action, var/efficiency, var/obj/item/I, var/mob/user)
	switch(action)
		if(TOOL_SCREWDRIVER)
			if(state == 2)
				user << "Now finishing the airlock..."
				if(do_after(user, 40 / efficiency) && state == 2)
					user.visible_message("<span class='notice'>[user] finishes the airlock.</span>", "<span class='notice'>You finish the airlock.</span>")
					var/path
					if(istext(glass))
						path = text2path("/obj/machinery/door/airlock/[glass]")
					else if(glass == 1)
						path = text2path("/obj/machinery/door/airlock[glass_type]")
					else
						path = text2path("/obj/machinery/door/airlock[airlock_type]")
					var/obj/machinery/door/new_airlock = new path(loc, src)
					new_airlock.dir = dir
					qdel(src)
				return 1
		if(TOOL_CROWBAR)
			if(state == 2 && electronics)
				user << "You start removing the electronics from \the [src]..."
				if(do_after(user, 40 / efficiency) && state == 2 && electronics)
					user.visible_message("<span class='notice'>[user] removes the airlock electronics.</span>", "<span class='notice'>You remove the airlock electronics.</span>")
					state = 1
					name = "Wired Airlock Assembly"
					electronics.loc = loc
					electronics = null
				return 1
		if(TOOL_WIRECUTTERS)
			if(state == 1)
				user << "You start cutting the wires from \the [src]..."
				if(do_after(user, 40 / efficiency) && state == 1)
					user.visible_message("<span class='notice'>[user] cuts the airlock wires.</span>", "<span class='notice'>You cut the airlock wires.</span>")
					new /obj/item/stack/cable_coil(loc, 1)
					state = 0
				return 1
		if(TOOL_WRENCH)
			if(state == 0)
				user << "You start [anchored ? "unsecuring" : "securing"] \the [src] [anchored ? "from" : "to"] the floor..."
				if(do_after(user, 40 / efficiency) && state == 0)
					user.visible_message("<span class='notice'>[user] [anchored ? "unsecured" : "secured"] \the [src].</span>", "<span class='notice'>You [anchored ? "unsecured" : "secured"] \the [src].</span>")
					anchored = !anchored
				return 1
		if(TOOL_WELDER)
			if(istext(glass))
				user << "You start welding the [glass] plating off \the [src]..."
				I.use_tool(TOOL_WELDER, user, 1)
				if(do_after(user, 40 / efficiency) && istext(glass))
					user.visible_message("<span class='notice'>[user] welds the [glass] plating off \the [src].</span>", "<span class='notice'>You weld the [glass] plating off \the [src].</span>")
					var/M = text2path("/obj/item/stack/material/[glass]")
					new M(loc, 2)
					glass = 0
				return 1
			else if(glass == 1)
				user << "You start welding the glass panel off \the [src]..."
				I.use_tool(TOOL_WELDER, user, 1)
				if(do_after(user, 40 / efficiency) && glass == 1)
					user.visible_message("<span class='notice'>[user] welds the glass panel off \the [src].</span>", "<span class='notice'>You weld the glass panel off \the [src].</span>")
					new /obj/item/stack/material/glass/reinforced(loc)
					glass = 0
				return 1
			else if(!anchored)
				user << "You start disassembling \the [src]..."
				if(do_after(user, 40 / efficiency) && !anchored)
					user.visible_message("<span class='notice'>[user] dissasembled the airlock assembly.</span>", "<span class='notice'>You dissasembled the airlock assembly.</span>")
					new /obj/item/stack/material/steel(loc, 4)
					qdel(src)
				return 1

/obj/structure/door_assembly/proc/update_state()
	icon_state = "door_as_[glass == 1 ? "g" : ""][istext(glass) ? glass : base_icon_state][state]"
	name = ""
	switch (state)
		if(0)
			if (anchored)
				name = "Secured "
		if(1)
			name = "Wired "
		if(2)
			name = "Near Finished "
	name += "[glass == 1 ? "Window " : ""][istext(glass) ? "[glass] Airlock" : base_name] Assembly"
