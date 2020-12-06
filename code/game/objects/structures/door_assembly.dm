/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "construction"
	anchored = 0
	density = 1
	w_class = ITEM_SIZE_NO_CONTAINER
	var/state = 0
	var/base_icon_state = ""
	var/base_name = "Airlock"
	var/obj/item/weapon/airlock_electronics/electronics = null
	var/airlock_type = /obj/machinery/door/airlock //the type path of the airlock once completed
	var/glass_type = /obj/machinery/door/airlock/glass
	var/glass = 0 // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed. Text = mineral plating is installed instead.
	var/created_name = null
	var/panel_icon = 'icons/obj/doors/station/panel.dmi'
	var/fill_icon = 'icons/obj/doors/station/fill_steel.dmi'
	var/glass_icon = 'icons/obj/doors/station/fill_glass.dmi'
	var/paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE
	var/door_color = "none"
	var/stripe_color = "none"
	var/symbol_color = "none"

	New()
		update_state()

/obj/structure/door_assembly/door_assembly_hatch
	icon = 'icons/obj/doors/hatch/door.dmi'
	panel_icon = 'icons/obj/doors/hatch/panel.dmi'
	fill_icon = 'icons/obj/doors/hatch/fill_steel.dmi'
	base_name = "Airtight Hatch"
	airlock_type = /obj/machinery/door/airlock/hatch
	glass = -1

/obj/structure/door_assembly/door_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_icon = 'icons/obj/doors/secure/fill_steel.dmi'
	base_name = "High Security Airlock"
	airlock_type = /obj/machinery/door/airlock/highsecurity
	glass = -1
	paintable = 0

/obj/structure/door_assembly/door_assembly_ext
	icon = 'icons/obj/doors/external/door.dmi'
	fill_icon = 'icons/obj/doors/external/fill_steel.dmi'
	glass_icon = 'icons/obj/doors/external/fill_glass.dmi'
	base_name = "External Airlock"
	airlock_type = /obj/machinery/door/airlock/external
	glass_type = /obj/machinery/door/airlock/external/glass
	paintable = 0

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/double/door.dmi'
	fill_icon = 'icons/obj/doors/double/fill_steel.dmi'
	glass_icon = 'icons/obj/doors/double/fill_glass.dmi'
	panel_icon = 'icons/obj/doors/double/panel.dmi'
	dir = EAST
	var/width = 1
	airlock_type = /obj/machinery/door/airlock/multi_tile
	glass_type = /obj/machinery/door/airlock/multi_tile/glass

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



/obj/structure/door_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter the name for the door.", src.name, src.created_name), MAX_NAME_LEN)
		if(!t)	return
		if(!in_range(src, usr) && src.loc != usr)	return
		created_name = t
		return

	if(isWelder(W) && ( (istext(glass)) || (glass == 1) || (!anchored) ))
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			if(istext(glass))
				user.visible_message("[user] welds the [glass] plating off the airlock assembly.", "You start to weld the [glass] plating off the airlock assembly.")
				if(do_after(user, 40,src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You welded the [glass] plating off!</span>")
					var/M = text2path("/obj/item/stack/material/[glass]")
					new M(src.loc, 2)
					glass = 0
			else if(glass == 1)
				user.visible_message("[user] welds the glass panel out of the airlock assembly.", "You start to weld the glass panel out of the airlock assembly.")
				if(do_after(user, 40,src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You welded the glass panel out!</span>")
					new /obj/item/stack/material/glass/reinforced(src.loc)
					glass = 0
			else if(!anchored)
				user.visible_message("[user] dissassembles the airlock assembly.", "You start to dissassemble the airlock assembly.")
				if(do_after(user, 40,src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You dissasembled the airlock assembly!</span>")
					new /obj/item/stack/material/steel(src.loc, 4)
					qdel (src)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel.</span>")
			return

	else if(isWrench(W) && state == 0)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring the airlock assembly from the floor.", "You begin unsecuring the airlock assembly from the floor.")
		else
			user.visible_message("[user] begins securing the airlock assembly to the floor.", "You begin securing the airlock assembly to the floor.")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured the airlock assembly!</span>")
			anchored = !anchored

	else if(isCoil(W) && state == 0 && anchored)
		var/obj/item/stack/cable_coil/C = W
		if (C.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of coil to wire the airlock assembly.</span>")
			return
		user.visible_message("[user] wires the airlock assembly.", "You start to wire the airlock assembly.")
		if(do_after(user, 40,src) && state == 0 && anchored)
			if (C.use(1))
				src.state = 1
				to_chat(user, "<span class='notice'>You wire the airlock.</span>")

	else if(isWirecutter(W) && state == 1 )
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("[user] cuts the wires from the airlock assembly.", "You start to cut the wires from airlock assembly.")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You cut the airlock wires.!</span>")
			new/obj/item/stack/cable_coil(src.loc, 1)
			src.state = 0

	else if(istype(W, /obj/item/weapon/airlock_electronics) && state == 1)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user.visible_message("[user] installs the electronics into the airlock assembly.", "You start to install electronics into the airlock assembly.")

		if(do_after(user, 40,src))
			if(!src) return
			if(!user.unEquip(W, src))
				return
			to_chat(user, "<span class='notice'>You installed the airlock electronics!</span>")
			src.state = 2
			src.SetName("Near finished Airlock Assembly")
			src.electronics = W

	else if(isCrowbar(W) && state == 2 )
		//This should never happen, but just in case I guess
		if (!electronics)
			to_chat(user, "<span class='notice'>There was nothing to remove.</span>")
			src.state = 1
			return

		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_message("\The [user] starts removing the electronics from the airlock assembly.", "You start removing the electronics from the airlock assembly.")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You removed the airlock electronics!</span>")
			src.state = 1
			src.SetName("Wired Airlock Assembly")
			electronics.dropInto(loc)
			electronics = null

	else if(istype(W, /obj/item/stack/material) && !glass)
		var/obj/item/stack/material/S = W
		var/material_name = S.get_material_name()		
		if (S)
			if (S.get_amount() >= 1)
				if(material_name == MATERIAL_GLASS && S.reinf_material)
					playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
					user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
					if(do_after(user, 40,src) && !glass)
						if (S.use(1))
							to_chat(user, "<span class='notice'>You installed reinforced glass windows into the airlock assembly.</span>")
							glass = 1
				else if(!(material_name in list(MATERIAL_GOLD, MATERIAL_SILVER, MATERIAL_DIAMOND, MATERIAL_URANIUM, MATERIAL_PHORON, MATERIAL_SANDSTONE)))
					to_chat(user, "You cannot make an airlock out of that material.")
					return
				else
					if(S.get_amount() >= 2)
						playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
						user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
						if(do_after(user, 40,src) && !glass)
							if (S.use(2))
								to_chat(user, "<span class='notice'>You installed [S.get_material_name()] plating into the airlock assembly.</span>")
								glass = S.get_material_name()

	else if(isScrewdriver(W) && state == 2 )
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now finishing the airlock.</span>")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You finish the airlock!</span>")
			var/path
			if(istext(glass))
				path = text2path("/obj/machinery/door/airlock/[glass]")
			else if (glass == 1)
				path = glass_type
			else
				path = airlock_type

			new path(src.loc, src)
			qdel(src)
	else
		..()
	update_state()

/obj/structure/door_assembly/proc/update_state()
	overlays.Cut()
	var/image/filling_overlay
	var/image/panel_overlay
	var/final_name = ""
	if(glass == 1)
		filling_overlay = image(glass_icon, "construction")
	else
		filling_overlay = image(fill_icon, "construction")
	switch (state)
		if(0)
			if (anchored)
				final_name = "Secured "
		if(1)
			final_name = "Wired "
			panel_overlay = image(panel_icon, "construction0")
		if(2)
			final_name = "Near Finished "
			panel_overlay = image(panel_icon, "construction1")
	final_name += "[glass == 1 ? "Window " : ""][istext(glass) ? "[glass] Airlock" : base_name] Assembly"
	SetName(final_name)
	overlays += filling_overlay
	overlays += panel_overlay
