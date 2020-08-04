/obj/machinery/self_destruct
	name = "\improper Nuclear Cylinder Inserter"
	desc = "A hollow space used to insert nuclear cylinders for arming the self destruct."
	icon = 'icons/obj/machines/self_destruct.dmi'
	icon_state = "empty"
	density = 0
	anchored = 1
	var/obj/item/weapon/nuclear_cylinder/cylinder
	var/armed = 0
	var/damaged = 0

/obj/machinery/self_destruct/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W))
		if(damaged)
			user.visible_message("[user] begins to repair [src].", "You begin repairing [src].")
			if(do_after(usr, 100, src))
				var/obj/item/weapon/weldingtool/w
				if(w.burn_fuel(10))
					damaged = 0
					user.visible_message("[user] repairs [src].", "You repair [src].")
				else
					to_chat(user, "<span class='warning'>There is not enough fuel to repair [src].</span>")
				return
	if(istype(W, /obj/item/weapon/nuclear_cylinder))
		if(damaged)
			to_chat(user, "<span class='warning'>[src] is damaged, you cannot place the cylinder.</span>")
			return
		if(cylinder)
			to_chat(user, "There is already a cylinder here.")
			return
		user.visible_message("[user] begins to carefully place [W] onto the Inserter.", "You begin to carefully place [W] onto the Inserter.")
		if(do_after(user, 80, src) && user.unEquip(W, src))
			cylinder = W
			density = 1
			user.visible_message("[user] places [W] onto the Inserter.", "You place [W] onto the Inserter.")
			update_icon()
			return
	..()

/obj/machinery/self_destruct/physical_attack_hand(mob/user)
	if(cylinder)
		. = TRUE
		if(armed)
			if(damaged)
				to_chat(user, "<span class='warning'>The inserter has been damaged, unable to disarm.</span>")
				return
			var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in get_area(src)
			if(!nuke)
				to_chat(user, "<span class='warning'>Unable to interface with the self destruct terminal, unable to disarm.</span>")
				return
			if(nuke.timing)
				to_chat(user, "<span class='warning'>The self destruct sequence is in progress, unable to disarm.</span>")
				return
			user.visible_message("[user] begins extracting [cylinder].", "You begin extracting [cylinder].")
			if(do_after(user, 40, src))
				user.visible_message("[user] extracts [cylinder].", "You extract [cylinder].")
				armed = 0
				density = 1
				flick("unloading", src)
		else if(!damaged)
			user.visible_message("[user] begins to arm [cylinder].", "You begin to arm [cylinder].")
			if(do_after(user, 40, src))
				armed = 1
				density = 0
				user.visible_message("[user] arms [cylinder].", "You arm [cylinder].")
				flick("loading", src)
				playsound(src.loc,'sound/effects/caution.ogg',50,1,5)
		update_icon()
		src.add_fingerprint(user)

/obj/machinery/self_destruct/MouseDrop(atom/over)
	if(!CanMouseDrop(over, usr))
		return
	if(over == usr && cylinder)
		if(armed)
			to_chat(usr, "Disarm the cylinder first.")
		else
			usr.visible_message("[usr] beings to carefully pick up [cylinder].", "You begin to carefully pick up [cylinder].")
			if(do_after(usr, 70, src))
				usr.put_in_hands(cylinder)
				usr.visible_message("[usr] picks up [cylinder].", "You pick up [cylinder].")
				density = 0
				cylinder = null
		update_icon()
		src.add_fingerprint(usr)
	..()

/obj/machinery/self_destruct/ex_act(severity)
	switch(severity)
		if(1)
			set_damaged()
		if(2)
			if(prob(50))
				set_damaged()
		if(3)
			if(prob(25))
				set_damaged()

/obj/machinery/self_destruct/proc/set_damaged()
		src.visible_message("<span class='warning'>[src] dents and chars.</span>")
		damaged = 1

/obj/machinery/self_destruct/examine(mob/user)
	. = ..()
	if(damaged)
		to_chat(user, "<span class='warning'>[src] is damaged, it needs repairs.</span>")
		return
	if(armed)
		to_chat(user, "[src] is armed and ready.")
		return
	if(cylinder)
		to_chat(user, "[src] is loaded and ready to be armed.")

/obj/machinery/self_destruct/on_update_icon()
	if(armed)
		icon_state = "armed"
	else if(cylinder)
		icon_state = "loaded"
	else
		icon_state = "empty"