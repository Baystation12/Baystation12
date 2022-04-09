/obj/item/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/emagged = FALSE
	var/open = 0
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE


/obj/item/storage/secure/attackby(obj/item/W, mob/user)
	if (!locked)
		return ..()
	if (istype(W, /obj/item/melee/energy/blade) && emag_act(INFINITY, user, "You slice through the lock of \the [src]"))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, loc)
		spark_system.start()
		playsound(loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(loc, "sparks", 50, 1)
		return
	if (isScrewdriver(W))
		if (do_after(user, 20, src))
			open = ! open
			user.show_message(text("<span class='notice'>You [] the service panel.</span>", (src.open ? "open" : "close")))
		return
	if (isMultitool(W) && (open == 1)&& (!l_hacking))
		user.show_message("<span class='notice'>Now attempting to reset internal memory, please hold.</span>", 1)
		l_hacking = 1
		if (do_after(usr, 100, src))
			if (prob(40))
				l_setshort = 1
				l_set = 0
				user.show_message("<span class='notice'>Internal memory reset. Please give it a few seconds to reinitialize.</span>", 1)
				sleep(80)
				l_setshort = 0
				l_hacking = 0
			else
				user.show_message("<span class='warning'>Unable to reset internal memory.</span>", 1)
				l_hacking = 0
		else
			l_hacking = 0


/obj/item/storage/secure/MouseDrop(over_object, src_location, over_location)
	if (locked)
		add_fingerprint(usr)
		return
	..()


/obj/item/storage/secure/attack_self(mob/user)
	user.set_machine(src)
	var/dat = text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (locked ? "LOCKED" : "UNLOCKED"))
	var/message = "Code"
	if ((l_set == 0) && (!emagged) && (!l_setshort))
		dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>")
	if (emagged)
		dat += text("<p>\n<font color=red><b>LOCKING SYSTEM ERROR - 1701</b></font>")
	if (l_setshort)
		dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
	message = text("[]", src.code)
	if (!locked)
		message = "*****"
	dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
	show_browser(user, dat, "window=caselock;size=300x280")


/obj/item/storage/secure/Topic(href, href_list)
	..()
	if ((usr.stat || usr.restrained()) || (get_dist(src, usr) > 1))
		return
	if (href_list["type"])
		if (href_list["type"] == "E")
			if ((l_set == 0) && (length(code) == 5) && (!l_setshort) && (code != "ERROR"))
				l_code = code
				l_set = 1
			else if ((code == l_code) && (!emagged) && (l_set == 1))
				locked = 0
				overlays.Cut()
				overlays += image('icons/obj/storage.dmi', icon_opened)
				code = null
			else
				code = "ERROR"
		else
			if ((href_list["type"] == "R") && (!emagged) && (!l_setshort))
				locked = 1
				overlays.Cut()
				code = null
				close(usr)
			else
				src.code += text("[]", href_list["type"])
				if (length(src.code) > 5)
					src.code = "ERROR"
		for (var/mob/M in viewers(1, loc))
			if ((M.client && M.machine == src))
				attack_self(M)
			return


/obj/item/storage/secure/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, text("The service panel is [src.open ? "open" : "closed"]."))


/obj/item/storage/secure/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	if (emagged)
		return
	emagged = TRUE
	src.overlays += image('icons/obj/storage.dmi', icon_sparking)
	sleep(6)
	overlays.Cut()
	overlays += image('icons/obj/storage.dmi', icon_locking)
	locked = 0
	to_chat(user, (feedback ? feedback : "You short out the lock of \the [src]."))
	return TRUE


/obj/item/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	force = 8.0
	base_parry_chance = 15
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	use_sound = 'sound/effects/storage/briefcase.ogg'


/obj/item/storage/secure/briefcase/attack_hand(mob/user)
	if ((loc == user) && (locked == 1))
		to_chat(usr, "<span class='warning'>[src] is locked and cannot be opened!</span>")
	else if ((loc == user) && (!locked))
		open(usr)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				close(M)
	add_fingerprint(user)


/obj/item/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	force = 8.0
	w_class = ITEM_SIZE_NO_CONTAINER
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = 56
	anchored = TRUE
	density = FALSE
	cant_hold = list(/obj/item/storage/secure/briefcase)
	startswith = list(
		/obj/item/paper = 1,
		/obj/item/pen = 1
	)


/obj/item/storage/secure/safe/attack_hand(mob/user)
	return attack_self(user)


/obj/item/storage/secure/AltClick(/mob/user)
	if (locked)
		return
	..()
