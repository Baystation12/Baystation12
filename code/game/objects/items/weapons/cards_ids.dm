/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("Data Disk- '[]'", t)
	else
		src.name = "Data Disk"
	src.add_fingerprint(usr)
	return


/*
 * ID CARDS
 */
/obj/item/weapon/card/id/attack_self(mob/user as mob)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment), 1)

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/attack_hand(mob/user as mob)
	var/obj/item/weapon/storage/wallet/WL
	if( istype(loc, /obj/item/weapon/storage/wallet) )
		WL = loc
	..()
	if(WL)
		WL.update_icon()

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	return

/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var t = copytext(sanitize(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name)),1,26)
		if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		src.registered_name = t

		var u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Assistant")),1,MAX_MESSAGE_LEN)
		if(!u)
			alert("Invalid assignment.")
			src.registered_name = ""
			return
		src.assignment = u
		src.name = "[src.registered_name]'s ID Card ([src.assignment])"
		user << "\blue You successfully forge the ID card."
	else
		..()


/*
 * FINGERPRINT HOLDER
 */
/obj/item/weapon/fcardholder/attack_self(mob/user as mob)
	var/dat = "<B>Clipboard</B><BR>"
	for(var/obj/item/weapon/f_card/P in src)
		dat += text("<A href='?src=\ref[];read=\ref[]'>[]</A> <A href='?src=\ref[];remove=\ref[]'>Remove</A><BR>", src, P, P.name, src, P)
	user << browse(dat, "window=fcardholder")
	onclose(user, "fcardholder")
	return

/obj/item/weapon/fcardholder/Topic(href, href_list)
	..()
	if ((usr.stat || usr.restrained()))
		return
	if (usr.contents.Find(src))
		usr.machine = src
		if (href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if ((P && P.loc == src))
				usr.put_in_hands(P)
				src.add_fingerprint(usr)
				P.add_fingerprint(usr)
			src.update()
		if (href_list["read"])
			var/obj/item/weapon/f_card/P = locate(href_list["read"])
			if ((P && P.loc == src))
				if (!( istype(usr, /mob/living/carbon/human) ))
					usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", P.name, P.display()), text("window=[]", P.name))
					onclose(usr, "[P.name]")
				else
					usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", P.name, P.display()), text("window=[]", P.name))
					onclose(usr, "[P.name]")
			src.add_fingerprint(usr)
		if (ismob(src.loc))
			var/mob/M = src.loc
			if (M.machine == src)
				spawn( 0 )
					src.attack_self(M)
					return
	return

/obj/item/weapon/fcardholder/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/fcardholder/attack_hand(mob/user as mob)
	if (user.contents.Find(src))
		spawn( 0 )
			src.attack_self(user)
			return
		src.add_fingerprint(user)
	else
		return ..()
	return

/obj/item/weapon/fcardholder/attackby(obj/item/weapon/P as obj, mob/user as mob)
	..()
	if (istype(P, /obj/item/weapon/f_card))
		if (src.contents.len < 30)
			user.drop_item()
			P.loc = src
			add_fingerprint(user)
			src.add_fingerprint(user)
		else
			user << "\blue Not enough space!!!"
	else
		if (istype(P, /obj/item/weapon/pen))
			var/t = input(user, "Holder Label:", text("[]", src.name), null)  as text
			if (user.get_active_hand() != P)
				return
			if ((!in_range(src, usr) && src.loc != user))
				return
			t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)
			if (t)
				src.name = text("FPCase- '[]'", t)
			else
				src.name = "Finger Print Case"
		else
			return
	src.update()
	spawn( 0 )
		attack_self(user)
		return
	return

/obj/item/weapon/fcardholder/proc/update()
	var/i = 0
	for(var/obj/item/weapon/f_card/F in src)
		i = 1
		break
	src.icon_state = text("fcardholder[]", (i ? "1" : "0"))
	return




/*
 * FINGERPRINT CARD
 */
/obj/item/weapon/f_card/examine()
	set src in view(2)

	..()
	usr << text("\blue There are [] on the stack!", src.amount)
	usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, display()), text("window=[]", src.name))
	onclose(usr, "[src.name]")
	return

/obj/item/weapon/f_card/proc/display()
	if(!fingerprints || !fingerprints.len)
		return "<B>There are no fingerprints on this card.</B>"
	else
		var/dat = "<B>Fingerprints on Card</B><HR>"
		for(var/name in fingerprints)
			dat += "[name]<BR>"
		return dat
	return

/obj/item/weapon/f_card/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/f_card))
		if ((src.fingerprints || W.fingerprints))
			return
		if (src.amount == 10)
			return
		if (W:amount + src.amount > 10)
			src.amount = 10
			W:amount = W:amount + src.amount - 10
		else
			src.amount += W:amount
			//W = null
			del(W)
		src.add_fingerprint(user)
		if (W)
			W.add_fingerprint(user)
	else
		if (istype(W, /obj/item/weapon/pen))
			var/t = input(user, "Card Label:", text("[]", src.name), null)  as text
			if (user.get_active_hand() != W)
				return
			if ((!in_range(src, usr) && src.loc != user))
				return
			t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)
			if (t)
				src.name = text("FPrintC- '[]'", t)
			else
				src.name = "Finger Print Card"
			W.add_fingerprint(user)
			src.add_fingerprint(user)
	return

/obj/item/weapon/f_card/add_fingerprint()

	..()
	if (!istype(usr, /mob/living/silicon))
		if (fingerprints)
			if (src.amount > 1)
				var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card(get_turf(src))
				F.amount = --src.amount
				amount = 1
			icon_state = "fingerprint1"
	return