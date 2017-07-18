/* Morgue stuff
 * Contains:
 *		Morgue
 *		Morgue trays
 *		Creamatorium
 *		Creamatorium trays
 */

/*
 * Morgue
 */

/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in until someone fetches them."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = 1
	var/obj/structure/m_tray/connected = null
	anchored = 1.0

/obj/structure/morgue/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/morgue/proc/update()
	if (src.connected)
		src.icon_state = "morgue0"
	else
		if (src.contents.len)
			src.icon_state = "morgue2"
		else
			src.icon_state = "morgue1"
	return

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/morgue/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(src.connected)
		src.connected = null
	else
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/m_tray( src.loc )
		step(src.connected, src.dir)
		src.connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, src.dir)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "morgue0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "morguet"
			src.connected.set_dir(src.dir)
		else
			qdel(src.connected)
			src.connected = null
	src.add_fingerprint(user)
	update()
	return

/obj/structure/morgue/attack_robot(var/mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else return ..()

/obj/structure/morgue/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = text("Morgue- '[]'", t)
		else
			src.name = "Morgue"
	src.add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.connected = new /obj/structure/m_tray( src.loc )
	step(src.connected, EAST)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "morgue0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "morguet"
	else
		qdel(src.connected)
		src.connected = null
	return


/*
 * Morgue tray
 */
/obj/structure/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morguet"
	density = 1
	layer = BELOW_OBJ_LAYER
	var/obj/structure/morgue/connected = null
	anchored = 1
	throwpass = 1

/obj/structure/m_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/m_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
			//Foreach goto(26)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/m_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, "<span class='warning'>\The [user] stuffs [O] into [src]!</span>")
	return


/*
 * Crematorium
 */

/obj/structure/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "crema1"
	density = 1
	var/obj/structure/c_tray/connected = null
	anchored = 1.0
	var/cremating = 0
	var/id = 1
	var/locked = 0
	var/_wifi_id
	var/datum/wifi/receiver/button/crematorium/wifi_receiver

/obj/structure/crematorium/initialize()
	..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/structure/crematorium/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	if(wifi_receiver)
		qdel(wifi_receiver)
		wifi_receiver = null
	return ..()

/obj/structure/crematorium/proc/update()
	if (src.connected)
		src.icon_state = "crema0"
	else
		if (src.contents.len)
			src.icon_state = "crema2"
		else
			src.icon_state = "crema1"
	return

/obj/structure/crematorium/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/crematorium/attack_hand(mob/user as mob)
//	if (cremating) AWW MAN! THIS WOULD BE SO MUCH MORE FUN ... TO WATCH
//		user.show_message("<span class='warning'>Uh-oh, that was a bad idea.</span>", 1)
//		to_chat(usr, "Uh-oh, that was a bad idea.")
//		src:loc:poison += 20000000
//		src:loc:firelevel = src:loc:poison
//		return
	if (cremating)
		to_chat(usr, "<span class='warning'>It's locked.</span>")
		return
	if ((src.connected) && (src.locked == 0))
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		//src.connected = null
		qdel(src.connected)
	else if (src.locked == 0)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/c_tray( src.loc )
		step(src.connected, SOUTH)
		src.connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, SOUTH)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "crema0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "cremat"
		else
			//src.connected = null
			qdel(src.connected)
	src.add_fingerprint(user)
	update()

/obj/structure/crematorium/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, usr) > 1 && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = text("Crematorium- '[]'", t)
		else
			src.name = "Crematorium"
	src.add_fingerprint(user)
	return

/obj/structure/crematorium/relaymove(mob/user as mob)
	if (user.stat || locked)
		return
	src.connected = new /obj/structure/c_tray( src.loc )
	step(src.connected, SOUTH)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, SOUTH)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "crema0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "cremat"
	else
		qdel(src.connected)
		src.connected = null
	return

/obj/structure/crematorium/proc/cremate(atom/A, mob/user as mob)
//	for(var/obj/machinery/crema_switch/O in src) //trying to figure a way to call the switch, too drunk to sort it out atm
//		if(var/on == 1)
//		return
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		for (var/mob/M in viewers(src))
			M.show_message("<span class='warning'>You hear a hollow crackle.</span>", 1)
			return

	else
		if(!isemptylist(src.search_contents_for(/obj/item/weapon/disk/nuclear)))
			to_chat(usr, "You get the feeling that you shouldn't cremate one of the items in the cremator.")
			return

		for (var/mob/M in viewers(src))
			M.show_message("<span class='warning'>You hear a roar as the crematorium activates.</span>", 1)

		cremating = 1
		locked = 1

		for(var/mob/living/M in contents)
			if (M.stat!=2)
				if (!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C = M
					if (C.can_feel_pain())
						C.emote("scream")

			//Logging for this causes runtimes resulting in the cremator locking up. Commenting it out until that's figured out.
			//M.attack_log += "\[[time_stamp()]\] Has been cremated by <b>[user]/[user.ckey]</b>" //No point in this when the mob's about to be deleted
			//user.attack_log +="\[[time_stamp()]\] Cremated <b>[M]/[M.ckey]</b>"
			//log_attack("\[[time_stamp()]\] <b>[user]/[user.ckey]</b> cremated <b>[M]/[M.ckey]</b>")
			M.death(1)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = 0
		locked = 0
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return


/*
 * Crematorium tray
 */
/obj/structure/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "cremat"
	density = 1
	layer = BELOW_OBJ_LAYER
	var/obj/structure/crematorium/connected = null
	anchored = 1
	throwpass = 1

/obj/structure/c_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/c_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
			//Foreach goto(26)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/c_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, text("<span class='warning'>[] stuffs [] into []!</span>", user, O, src))
			//Foreach goto(99)
	return

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	req_access = list(access_crematorium)
	id = 1

/obj/machinery/button/crematorium/update_icon()
	return

/obj/machinery/button/crematorium/attack_hand(mob/user as mob)
	if(..())
		return
	if(src.allowed(user))
		for (var/obj/structure/crematorium/C in world)
			if (C.id == id)
				if (!C.cremating)
					C.cremate(user)
	else
		to_chat(usr, "<span class='warning'>Access denied.</span>")
