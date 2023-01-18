/obj/machinery/nuke_cylinder_dispenser
	name = "nuclear cylinder storage"
	desc = "It's a secure, armored storage unit embeded into the floor for storing the nuclear cylinders."
	icon = 'icons/obj/machines/self_destruct.dmi'
	icon_state = "base"
	anchored = TRUE
	density = FALSE
	req_access = list(access_heads_vault)

	var/locked = TRUE
	var/open = FALSE
	var/list/cylinders = list() //Should only hold 6

/obj/machinery/nuke_cylinder_dispenser/Initialize()
	. = ..()
	for(var/i in 1 to 6)
		cylinders += new /obj/item/nuclear_cylinder()
	update_icon()

/obj/machinery/nuke_cylinder_dispenser/emag_act(remaining_charges, mob/user, emag_source)
	to_chat(user, SPAN_NOTICE("The card fails to do anything. It seems this device has an advanced encryption system."))
	return NO_EMAG_ACT

/obj/machinery/nuke_cylinder_dispenser/physical_attack_hand(mob/user)
	if(is_powered() && locked && check_access(user))
		locked = FALSE
		user.visible_message("[user] unlocks \the [src].", "You unlock \the [src].")
		update_icon()
		add_fingerprint(user)
		return TRUE
	if(!locked)
		open = !open
		user.visible_message("[user] [open ? "opens" : "closes"] \the [src].", "You [open ? "open" : "close"] \the [src].")
		update_icon()
		add_fingerprint(user)
	return TRUE


/obj/machinery/nuke_cylinder_dispenser/use_tool(obj/item/tool, mob/user, list/click_params)
	// ID Card - Toggle lock
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		if (open)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can lock it."))
			return TRUE
		var/id_name = GET_ID_CARD_NAME(tool, id)
		if (!is_powered())
			to_chat(user, SPAN_WARNING("\The [src] doesn't respond to [id_name]."))
			return TRUE
		if (!check_access(id))
			to_chat(user, SPAN_WARNING("\The [src] refuses [id_name]."))
			return TRUE
		locked = !locked
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [locked ? "locks" : "unlocks"] \the [src] with \a [tool]."),
			SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src] with [id_name].")
		)
		return TRUE

	// Nuclear Cylinder - Insert cylinder
	if (istype(tool, /obj/item/nuclear_cylinder))
		if (!open)
			to_chat(user, SPAN_WARNING("\The [src] must be open before you can insert \the [tool]."))
			return TRUE
		if (length(cylinders) >= 6)
			to_chat(user, SPAN_WARNING("\The [src] is already filled with cylinders."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] begins inserting \a [tool] into \the [src]."),
			SPAN_NOTICE("You begin inserting \a [tool] into \the [src].")
		)
		if (!do_after(user, 8 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		cylinders |= tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] stores \a [tool] in \the [src]."),
			SPAN_NOTICE("You store \the [tool] in \the [src].")
		)

	return ..()


/obj/machinery/nuke_cylinder_dispenser/MouseDrop(atom/over)
	if(!CanMouseDrop(over, usr))
		return
	if(over == usr && open && length(cylinders))
		usr.visible_message("[usr] begins to extract \the [cylinders[1]].", "You begin to extract \the [cylinders[1]].")
		if(do_after(usr, 7 SECONDS, src, DO_PUBLIC_UNIQUE) && open && length(cylinders))
			usr.visible_message("[usr] picks up \the [cylinders[1]].", "You pick up \the [cylinders[1]].")
			usr.put_in_hands(cylinders[length(cylinders)])
			cylinders.Cut(length(cylinders))
			update_icon()
		add_fingerprint(usr)

/obj/machinery/nuke_cylinder_dispenser/on_update_icon()
	overlays.Cut()
	if(length(cylinders))
		overlays += "rods_[length(cylinders)]"
	if(!open)
		overlays += "hatch"
	if(is_powered())
		if(locked)
			overlays += "red_light"
		else
			overlays += "green_light"
