/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten phoron tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/oxygentanks = 10
	var/phorontanks = 10
	var/list/oxytanks = list()	//sorry for the similar var names
	var/list/platanks = list()


/obj/structure/dispenser/oxygen
	phorontanks = 0

/obj/structure/dispenser/phoron
	oxygentanks = 0

/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()

/obj/structure/dispenser/on_update_icon()
	overlays.Cut()
	switch(oxygentanks)
		if(1 to 3)	overlays += "oxygen-[oxygentanks]"
		if(4 to INFINITY) overlays += "oxygen-4"
	switch(phorontanks)
		if(1 to 4)	overlays += "phoron-[phorontanks]"
		if(5 to INFINITY) overlays += "phoron-5"

/obj/structure/dispenser/attack_ai(mob/user as mob)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Phoron tanks: [phorontanks] - [phorontanks ? "<A href='?src=\ref[src];phoron=1'>Dispense</A>" : "empty"]"
	show_browser(user, dat, "window=dispenser")
	onclose(user, "dispenser")
	return


/obj/structure/dispenser/use_tool(obj/item/tool, mob/user, list/click_params)
	// Tank - Insert tank
	if (istype(tool, /obj/item/tank))
		// Oxygen Tanks
		if (is_type_in_list(tool, list(/obj/item/tank/oxygen, /obj/item/tank/air, /obj/item/tank/anesthetic)))
			if (oxygentanks >= 10)
				USE_FEEDBACK_FAILURE("\The [src]'s oxygen tank rack is full.")
				return TRUE
			if (!user.unEquip(tool, src))
				FEEDBACK_UNEQUIP_FAILURE(user, tool)
				return TRUE
			oxytanks += tool
			oxygentanks++
			update_icon()
			user.visible_message(
				SPAN_NOTICE("\The [user] adds \a [tool] to \the [src]'s oxygen rack."),
				SPAN_NOTICE("You add \the [tool] to \the [src]'s oxygen rack.")
			)
			return TRUE
		// Phoron Tanks
		if (istype(tool, /obj/item/tank/phoron))
			if (phorontanks >= 10)
				USE_FEEDBACK_FAILURE("\The [src]'s phoron tank rack is full.")
				return TRUE
			if (!user.unEquip(tool, src))
				FEEDBACK_UNEQUIP_FAILURE(user, tool)
				return TRUE
			platanks += tool
			phorontanks++
			update_icon()
			user.visible_message(
				SPAN_NOTICE("\The [user] adds \a [tool] to \the [src]'s phoron rack."),
				SPAN_NOTICE("You add \the [tool] to \the [src]'s phoron rack.")
			)
			return TRUE
		// Other tanks
		USE_FEEDBACK_FAILURE("\The [tool] doesn't fit in any of \the [src]'s racks.")
		return TRUE

	return ..()


/obj/structure/dispenser/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(Adjacent(usr))
		usr.set_machine(src)
		if(href_list["oxygen"])
			if(oxygentanks > 0)
				var/obj/item/tank/oxygen/O
				if(length(oxytanks) == oxygentanks)
					O = oxytanks[1]
					oxytanks.Remove(O)
				else
					O = new /obj/item/tank/oxygen(loc)
				O.dropInto(loc)
				to_chat(usr, SPAN_NOTICE("You take [O] out of [src]."))
				oxygentanks--
				update_icon()
		if(href_list["phoron"])
			if(phorontanks > 0)
				var/obj/item/tank/phoron/P
				if(length(platanks) == phorontanks)
					P = platanks[1]
					platanks.Remove(P)
				else
					P = new /obj/item/tank/phoron(loc)
				P.dropInto(loc)
				to_chat(usr, SPAN_NOTICE("You take [P] out of [src]."))
				phorontanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		close_browser(usr, "window=dispenser")
		return
	return
