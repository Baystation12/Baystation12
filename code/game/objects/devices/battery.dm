
/obj/item/weapon/battery
	desc = "a small battery"
	name = "battery"
	icon = 'power.dmi'
	icon_state = "battery"
	var/maxcharge = 10000
	var/charge = 10000
	w_class = 1.0

/obj/item/battery_box
	var/amount = 7
	var/open = 0
	icon = 'power.dmi'
	icon_state = "box_close"
	name = "Battery box"

/obj/item/battery_box/proc/update()
	if(open)
		src.icon_state = text("box[]", src.amount)
	else
		src.icon_state = "box_close"
	return

/*
/obj/item/kitchen/donut_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/donut) && (amount < 6))
		user.drop_item()
		W.loc = src
		usr << "You place a donut back into the box."
	src.update()
	return
*/

/obj/item/battery_box/MouseDrop(mob/user as mob)
	if ((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(user, /mob/living/carbon/metroid))
			if (usr.hand)
				if (!( usr.l_hand ))
					spawn( 0 )
						src.attack_hand(usr, 1, 1)
						return
			else
				if (!( usr.r_hand ))
					spawn( 0 )
						src.attack_hand(usr, 0, 1)
						return
	return

/obj/item/battery_box/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/battery_box/attack_hand(mob/user as mob, unused, flag)
	if(!open)
		open = 1
		update()
		usr << "You open a box"
		return
	if (flag)
		return ..()
	src.add_fingerprint(user)
	if (locate(/obj/item/weapon/battery, src))
		for(var/obj/item/weapon/battery/P in src)
			if (!usr.l_hand)
				P.loc = usr
				P.layer = 20
				usr.l_hand = P
				usr.update_clothing()
				usr << "You take a battery out of the box."
				break
			else if (!usr.r_hand)
				P.loc = usr
				P.layer = 20
				usr.r_hand = P
				usr.update_clothing()
				usr << "You take a battery out of the box."
				break
	else
		if (src.amount >= 1)
			src.amount--
			var/obj/item/weapon/battery/D = new /obj/item/weapon/battery
			D.loc = usr.loc
			if(ishuman(usr))
				if(!usr.get_active_hand())
					usr.put_in_hand(D)
					usr << "You take a battery out of the box."
			else
				D.loc = get_turf(src)
				usr << "You take a battery out of the box."

	src.update()
	return

/obj/item/battery_box/examine()
	set src in oview(1)

	src.amount = round(src.amount)
	var/n = src.amount
	for(var/obj/item/weapon/battery/P in src)
		n++
	if (n <= 0)
		n = 0
		usr << "There are no batteries left in the box."
	else
		if (n == 1)
			usr << "There is one battery left in the box."
		else
			usr << text("There are [] batteries in the box.", n)
	return