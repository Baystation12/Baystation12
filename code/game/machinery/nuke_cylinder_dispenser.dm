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

/obj/machinery/nuke_cylinder_dispenser/attackby(obj/item/O, mob/user)
	if(!open && is_powered() && isid(O))
		var/obj/item/card/id/id = O
		if(check_access(id))
			locked = !locked
			user.visible_message("[user] [locked ? "locks" : "unlocks"] \the [src].", "You [locked ? "lock" : "unlock"] \the [src].")
			update_icon()
		return
	if(open && istype(O, /obj/item/nuclear_cylinder) && (length(cylinders) < 6))
		user.visible_message("[user] begins inserting \the [O] into storage.", "You begin inserting \the [O] into storage.")
		if(do_after(user, 80, src) && open && (length(cylinders) < 6) && user.unEquip(O, src))
			user.visible_message("[user] places \the [O] into storage.", "You place \the [O] into storage.")
			cylinders.Add(O)
			update_icon()
		add_fingerprint(user)

/obj/machinery/nuke_cylinder_dispenser/MouseDrop(atom/over)
	if(!CanMouseDrop(over, usr))
		return
	if(over == usr && open && length(cylinders))
		usr.visible_message("[usr] begins to extract \the [cylinders[1]].", "You begin to extract \the [cylinders[1]].")
		if(do_after(usr, 70, src) && open && length(cylinders))
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