
/obj/item/weapon/paperwork
    name = "paperwork"

/obj/item/weapon/paperwork/proc/render_content(mob/user=null)

/obj/item/weapon/paperwork/proc/show_content(mob/user)

/obj/item/weapon/paperwork/proc/copy(newloc)

/obj/item/weapon/paperwork/proc/create_bundle(obj/item/weapon/paperwork/other, mob/user)
	if (istype(P, /obj/item/weapon/paper/carbon))
		var/obj/item/weapon/paper/carbon/C = P
		if (!C.iscopy && !C.copied)
			user << "<span class='notice'>Take off the carbon copy first.</span>"
			add_fingerprint(user)
			return
	
	var/obj/item/weapon/paper_bundle/B = new(src.loc)
	if (name != initial(name))
		B.name = name
	
	user.drop_from_inventory(P)
	if (istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/h_user = user
		if (h_user.r_hand == src)
			h_user.drop_from_inventory(src)
			h_user.put_in_r_hand(B)
		else if (h_user.l_hand == src)
			h_user.drop_from_inventory(src)
			h_user.put_in_l_hand(B)
		else if (h_user.l_store == src)
			h_user.drop_from_inventory(src)
			B.loc = h_user
			B.layer = 20
			h_user.l_store = B
			h_user.update_inv_pockets()
		else if (h_user.r_store == src)
			h_user.drop_from_inventory(src)
			B.loc = h_user
			B.layer = 20
			h_user.r_store = B
			h_user.update_inv_pockets()
		else if (h_user.head == src)
			h_user.u_equip(src)
			h_user.put_in_hands(B)
		else if (!istype(src.loc, /turf))
			src.loc = get_turf(h_user)
			if(h_user.client)	h_user.client.screen -= src
			h_user.put_in_hands(B)
	user << "<span class='notice'>You clip \the [P] to \the [src].</span>"
	src.loc = B
	P.loc = B
	B.update_icon()

/obj/item/weapon/paperwork/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/flame))
		burnpaper(W, user)
		return
	..()

/obj/item/weapon/paperwork/examine(mob/user)
	if(in_range(user, src))
		show_content(user)
	else
		user << "<span class='notice'>It is too far away.</span>"

/obj/item/weapon/paperwork/proc/burnpaper(obj/item/weapon/flame/P, mob/user)
	var/class = "<span class='warning'>"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/weapon/flame/lighter/zippo))
			class = "<span class='rose'>"

		user.visible_message("[class][user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!", \
		"[class]You hold \the [P] up to \the [src], burning it slowly.")

		if (do_after(user, 20) && P.lit)
			user.visible_message("[class][user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.", \
			"[class]You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.")

			if(user.get_inactive_hand() == src)
				user.drop_from_inventory(src)

			new /obj/effect/decal/cleanable/ash(src.loc)
			del(src)
		else
			user << "\red You must hold \the [P] steady to burn \the [src]."


/obj/item/weapon/paperwork/verb/rename(mob/user)
	set name = "Rename paperwork"
	set category = "Object"
	set src in usr

	var/n_name = copytext(sanitize(input(user, "What would you like to label \the [src]?", "Paper Labelling", null)  as text), 1, MAX_NAME_LEN)
	if((loc == usr && !usr.stat))
		name = "[(n_name ? "[n_name]" : initial(name))]"
	add_fingerprint(usr)
	return
