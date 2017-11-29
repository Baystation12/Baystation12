/obj/machinery/self_destruct
	name = "\improper Nuclear Cylinder Inserter"
	desc = "A hollow space used to instert nuclear cylinders for arming the self destruct."
	icon = 'icons/obj/machines/self_destruct.dmi'
	icon_state = "empty"
	density = 0
	anchored = 1
	var/obj/item/weapon/nuclear_cylinder/cylinder
	var/armed = 0

/obj/machinery/self_destruct/attackby(obj/item/W as obj, mob/usr as mob)
	if(istype(W, /obj/item/weapon/nuclear_cylinder))
		if(cylinder)
			to_chat(usr, "There is already a cylinder here.")
			return
		usr.visible_message("[usr] begins to carefully place [W] onto the Inserter.", "You begin to carefully place [W] onto the Inserter.")
		if(do_after(usr, 80, src))
			usr.drop_from_inventory(W, src)
			cylinder = W
			density = 1
			usr.visible_message("[usr] places [W] onto the Inserter.", "You place [W] onto the Inserter.")
			update_icon()
			return
	..()

/obj/machinery/self_destruct/attack_hand(mob/usr as mob)
	if(cylinder)
		if(armed)
			var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in get_area(src)
			if(!nuke)
				to_chat(usr, "<span class='warning'>Unable to interface with the self destruct terminal, unable to disarm.</span>")
				return
			if(nuke.timing)
				to_chat(usr, "<span class='warning'>The self destruct sequence is in progress, unable to disarm.</span>")
				return
			usr.visible_message("[usr] begins extracting [cylinder].", "You begin extracting [cylinder].")
			if(do_after(usr, 40, src))
				usr.visible_message("[usr] extracts [cylinder].", "You extract [cylinder].")
				armed = 0
				density = 1
				flick("unloading", src)
		else
			usr.visible_message("[usr] begins to arm [cylinder].", "You begin to arm [cylinder].")
			if(do_after(usr, 40, src))
				armed = 1
				density = 0
				usr.visible_message("[usr] arms [cylinder].", "You arm [cylinder].")
				flick("loading", src)
				playsound(src.loc,'sound/effects/caution.ogg',50,1,5)
		update_icon()
		src.add_fingerprint(usr)
	else
		..()



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

/obj/machinery/self_destruct/update_icon()
	if(armed)
		icon_state = "armed"
	else if(cylinder)
		icon_state = "loaded"
	else
		icon_state = "empty"