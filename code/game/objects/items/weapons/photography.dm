/* Photography!
 * Contains:
 *		Camera
 *		Photos
 *		Photo Albums
 */

/*
 * Camera
 */
/obj/item/weapon/camera_test
	name = "camera"
	icon = 'icons/obj/items.dmi'
	desc = "A one use - polaroid camera. 10 photos left."
	icon_state = "camera"
	item_state = "electropack"
	w_class = 2.0
	flags = FPRINT | CONDUCT | USEDELAY | TABLEPASS
	slot_flags = SLOT_BELT
	m_amt = 2000
	throwforce = 5
	throw_speed = 4
	throw_range = 10
	var/pictures_left = 10
	var/can_use = 1

/obj/item/weapon/photo
	name = "photo"
	icon = 'icons/obj/items.dmi'
	icon_state = "photo"
	item_state = "clipboard"
	w_class = 1.0


//////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/camera_test/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/camera_test/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (!can_use || !pictures_left || ismob(target.loc)) return

	var/turf/the_turf = get_turf(target)

	var/icon/photo = icon('icons/obj/items.dmi',"photo")

	var/icon/turficon = build_composite_icon(the_turf)
	turficon.Scale(22,20)

	photo.Blend(turficon,ICON_OVERLAY,6,8)

	var/mob_title = null
	var/mob_detail = null

	var/item_title = null
	var/item_detail = null

	var/itemnumber = 0
	for(var/atom/A in the_turf)
		if(istype(A, /obj/item/weapon/photo))	continue
		if(A.invisibility) continue
		if(ismob(A))
			var/icon/X = build_composite_icon(A)
			X.Scale(22,20)
			photo.Blend(X,ICON_OVERLAY,6,8)
			del(X)

			if(!mob_title)
				mob_title = "[A]"
			else
				mob_title += " and [A]"

			if(!mob_detail)

				var/holding = null
				if(istype(A, /mob/living/carbon))
					var/mob/living/carbon/temp = A
					if(temp.l_hand || temp.r_hand)
						if(temp.l_hand) holding = "They are holding \a [temp.l_hand]"
						if(temp.r_hand)
							if(holding)
								holding += " and \a [temp.r_hand]."
							else
								holding = "They are holding \a [temp.r_hand]."

				if(isliving(A))
					var/mob/living/L = A

					if(!mob_detail)
						mob_detail = "You can see [L] on the photo[L.health < 75 ? " - [L] looks hurt":""].[holding ? " [holding]":"."]"
					else
						mob_detail += "You can also see [L] on the photo[L.health < 75 ? " - [L] looks hurt":""].[holding ? " [holding]":"."]"

		else
			if(itemnumber < 5)
				var/icon/X = build_composite_icon(A)
				X.Scale(22,20)
				photo.Blend(X,ICON_OVERLAY,6,8)
				del(X)
				itemnumber++

				if(!item_title)
					item_title = " \a [A]"
				else
					item_title = " some objects"

				if(!item_detail)
					item_detail = "\a [A]"
				else
					item_detail += " and \a [A]"

	var/finished_title = null
	var/finished_detail = null

	if(!item_title && !mob_title)
		finished_title = "boring photo"
		finished_detail = "This is a pretty boring photo of \a [the_turf]."
	else
		if(mob_title)
			finished_title = "photo of [mob_title][item_title ? " and[item_title]":""]"
			finished_detail = "[mob_detail][item_detail ? " Theres also [item_detail].":"."]"
		else if(item_title)
			finished_title = "photo of[item_title]"
			finished_detail = "You can see [item_detail]."

	var/obj/item/weapon/photo/P = new/obj/item/weapon/photo( get_turf(src) )

	P.icon = photo
	P.name = finished_title
	P.desc = finished_detail

	playsound(src.loc, pick('sound/items/polaroid1.ogg','sound/items/polaroid2.ogg'), 75, 1, -3)

	pictures_left--
	src.desc = "A one use - polaroid camera. [pictures_left] photos left."
	user << "\blue [pictures_left] photos left."
	can_use = 0
	spawn(50) can_use = 1

/*
 * Photos
 */
/obj/item/weapon/paper/photograph/New()

	..()
	src.pixel_y = 0
	src.pixel_x = 0
	return

/obj/item/weapon/paper/photograph/attack_self(mob/user as mob)

	var/n_name = copytext(sanitize(input(user, "What would you like to label the photo?", "Paper Labelling", null)  as text),1,32)
	if ((src.loc == user && user.stat == 0))
		src.name = text("photo[]", (n_name ? text("- '[]'", n_name) : null))
	src.add_fingerprint(user)
	return



/*
 * Photo Albums
 */
/obj/item/weapon/storage/photo_album
	name = "Photo album"
	icon = 'icons/obj/items.dmi'
	icon_state = "album"
	item_state = "briefcase"
	can_hold = list("/obj/item/weapon/photo",)

/obj/item/weapon/storage/photo_album/MouseDrop(obj/over_object as obj)

	if ((istype(usr, /mob/living/carbon/human) || (ticker && ticker.mode.name == "monkey")))
		var/mob/M = usr
		if (!( istype(over_object, /obj/screen) ))
			return ..()
		playsound(src.loc, "rustle", 50, 1, -5)
		if ((!( M.restrained() ) && !( M.stat ) && M.back == src))
			switch(over_object.name)
				if("r_hand")
					M.u_equip(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.u_equip(src)
					M.put_in_l_hand(src)
			src.add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if (usr.s_active)
				usr.s_active.close(usr)
			src.show_to(usr)
			return
	return

/obj/item/weapon/storage/photo_album/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()