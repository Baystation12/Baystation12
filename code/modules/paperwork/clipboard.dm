/obj/item/weapon/clipboard
	name = "clipboard"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throwforce = 0
	w_class = 2.0
	throw_speed = 3
	throw_range = 10
	var/obj/item/weapon/pen/haspen		//The stored pen.
	var/obj/item/weapon/paperwork/toppaper //The topmost piece of paper. Used when attacking the clipboard with a pen or stamp
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT

/obj/item/weapon/clipboard/New()
	update_icon()

/obj/item/weapon/clipboard/MouseDrop(obj/over_object as obj) //Quick clipboard fix. -Agouri
	if(ishuman(usr))
		var/mob/M = usr
		if(!(istype(over_object, /obj/screen) ))
			return ..()

		if(!M.restrained() && !M.stat)
			switch(over_object.name)
				if("r_hand")
					M.u_equip(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.u_equip(src)
					M.put_in_l_hand(src)

			add_fingerprint(usr)
			return

/obj/item/weapon/clipboard/update_icon()
	overlays.Cut()
	if(toppaper)
		overlays += toppaper.icon_state
		overlays += toppaper.overlays
	if(haspen)
		overlays += "clipboard_pen"
	overlays += "clipboard_over"
	return

/obj/item/weapon/clipboard/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W, /obj/item/weapon/paperwork))
		user.drop_item()
		W.loc = src
		//if(istype(W, /obj/item/weapon/paperwork/paper))
		toppaper = W
		user << "<span class='notice'>You clip the [W] onto \the [src].</span>"
		update_icon()

	else if(istype(toppaper) && (istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/toy/crayon) || istype(W, /obj/item/weapon/stamp)) )
		toppaper.attackby(W, user)
		update_icon()

	return

/obj/item/weapon/clipboard/attack_self(mob/user as mob)
	var/dat = "<title>Clipboard</title>"
	if(haspen)
		dat += "<A href='?src=\ref[src];pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='?src=\ref[src];addpen=1'>Add Pen</A><BR><HR>"

	for(var/obj/item/weapon/paperwork/P in src)
		dat += "<A href='?src=\ref[src];write=\ref[P]'>Write</A> <A href='?src=\ref[src];remove=\ref[P]'>Remove</A> [(P == toppaper)? "* Top Item " : "<A href='?src=\ref[src];top=\ref[P]'>Move to Top</A>"] - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"

	user << browse(dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)
	return

/obj/item/weapon/clipboard/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(src.loc == usr)

		if(href_list["pen"])
			if(istype(haspen) && (haspen.loc == src))
				haspen.loc = usr.loc
				usr.put_in_hands(haspen)
				haspen = null

		else if(href_list["addpen"])
			if(!haspen)
				var/obj/item/weapon/pen/W = usr.get_active_hand()
				if(istype(W, /obj/item/weapon/pen))
					usr.drop_item()
					W.loc = src
					haspen = W
					usr << "<span class='notice'>You slot the pen into \the [src].</span>"

		else if(href_list["write"])
			var/obj/item/weapon/paperwork/P = locate(href_list["write"])

			if(P && (P.loc == src) && istype(P, /obj/item/weapon/paperwork) )
				var/obj/item/I = usr.get_active_hand()
				if(istype(I, /obj/item/weapon/pen) || istype(I, /obj/item/toy/crayon))
					if (P != toppaper)
						playsound(src.loc, "pageturn", 50, 1)
					P.attackby(I, usr)

		else if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])

			if(P && (P.loc == src) )
				playsound(src.loc, "pageturn", 50, 1)
				P.loc = usr.loc
				usr.put_in_hands(P)
				if(P == toppaper)
					toppaper = null
					var/obj/item/weapon/paperwork/newtop = locate(/obj/item/weapon/paperwork) in src
					if(newtop && (newtop != P))
						toppaper = newtop
					else
						toppaper = null

		else if(href_list["read"])
			var/obj/item/weapon/paperwork/P = locate(href_list["read"])
			if(P && (P.loc == src) && istype(P) )
				if (P != toppaper)
					playsound(src.loc, "pageturn", 50, 1)
				P.show_content(usr)

		else if(href_list["top"])
			var/obj/item/weapon/paperwork/P = locate(href_list["top"])
			if(P && (P.loc == src) && istype(P) && P != toppaper)
				toppaper = P
				playsound(src.loc, "pageturn", 50, 1)
				usr << "<span class='notice'>You move [P.name] to the top.</span>"

		//Update everything
		attack_self(usr)
		update_icon()
	return
