
/obj/structure/weapon_rack
	name = "Covenant weapon rack"
	desc = "A rack for holding Covenant weapons, and recharging plasma weapons"
	icon = 'code/modules/halo/covenant/structures_machines/crate_tall.dmi'
	icon_state = "weapon_rack"
	density = 1
	w_class = ITEM_SIZE_HUGE
	var/list/held_items = list()
	var/list/charging_items = list()
	var/charging = 0
	var/charging_capacity = 8

/obj/structure/weapon_rack/New()
	. = ..()

	//grab our contents
	for(var/obj/item/I in get_turf(src))
		try_hold(I)

/obj/structure/weapon_rack/attackby(var/obj/item/weapon/W, var/mob/user)
	if(isliving(user))
		user.drop_item()
		W.loc = src.loc
		try_hold(W, user)
		user.visible_message("<span class='info'>[user] places \icon[W] [W] onto [src].</span>")

/obj/structure/weapon_rack/proc/try_hold(var/obj/I, var/mob/user)
	for(var/obj/item/O in held_items)
		if(O.loc != src.loc)
			held_items -= O

	if(istype(I) && held_items.len < charging_capacity)
		held_items += I
		reorder_contents()

		if(hascall(I, "cov_plasma_recharge_tick"))
			charging_items.Add(I)
			if(!charging)
				charging = 1
				GLOB.processing_objects.Add(src)
		return 1
	else
		to_chat(user, "<span class='warning'>You can't fit \icon[I] onto [src].</span>")

/obj/structure/weapon_rack/proc/reorder_contents()

	var/curslot = NORTHWEST
	var/pixel_offset = 8
	var/depth = 0
	for(var/obj/item/I in held_items)

		if(I.loc == src.loc)
			switch(curslot)
				if(NORTHWEST)
					I.pixel_x = -pixel_offset + depth * 2
					I.pixel_y = pixel_offset + depth * 2
					curslot = NORTHEAST
				if(NORTHEAST)
					I.pixel_x = pixel_offset + depth * 2
					I.pixel_y = pixel_offset + depth * 2
					curslot = SOUTHWEST
				if(SOUTHWEST)
					I.pixel_x = -pixel_offset + depth * 2
					I.pixel_y = -pixel_offset + depth * 2
					curslot = SOUTHEAST
				if(SOUTHEAST)
					I.pixel_x = pixel_offset + depth * 2
					I.pixel_y = -pixel_offset + depth * 2
					curslot = NORTHWEST

					depth += 1
		else
			held_items -= I

/obj/structure/weapon_rack/process()
	for(var/obj/item/I in charging_items)
		if(I.loc != src.loc)
			charging_items -= I

		else if(!call(I, "cov_plasma_recharge_tick")())
			charging_items -= I

	if(!charging_items.len)
		charging = 0
		GLOB.processing_objects.Remove(src)
